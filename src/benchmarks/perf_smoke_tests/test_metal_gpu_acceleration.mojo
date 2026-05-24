# Performance Smoke Test: Metal GPU-Accelerated Character Classification on Apple Silicon
# Benchmarks CPU-based scalar classification against GPU-accelerated Metal parallel scanning.

import std.time
from std.ffi import OwnedDLHandle

# Classification codes
comptime CHAR_WHITESPACE: UInt8 = 0
comptime CHAR_BRACE_OPEN: UInt8 = 1
comptime CHAR_BRACE_CLOSE: UInt8 = 2
comptime CHAR_BRACKET_OPEN: UInt8 = 3
comptime CHAR_BRACKET_CLOSE: UInt8 = 4
comptime CHAR_QUOTE: UInt8 = 5
comptime CHAR_COLON: UInt8 = 6
comptime CHAR_COMMA: UInt8 = 7
comptime CHAR_BACKSLASH: UInt8 = 8
comptime CHAR_OTHER: UInt8 = 9

comptime DEFAULT_LIB_PATH = "/Users/amund/MOJOPERF/mojo-json/metal"

# C Function types for Metal FFI
# Note: we use standard fn type signatures for FFI function pointer representations
comptime InitFnType = def (Int) thin abi("C") -> Int
comptime FreeFnType = def (Int) thin abi("C") -> None
comptime ClassifyFnType = def (Int, Int, Int, UInt32) thin abi("C") -> Int32
comptime IsAvailableFnType = def () thin abi("C") -> Int32

def cpu_classify(s: String) -> List[UInt8]:
    var n = s.byte_length()
    var result = List[UInt8](capacity=n)
    result.resize(n, CHAR_OTHER)
    var ptr = s.unsafe_ptr()
    for i in range(n):
        var c = ptr[i]
        if c == 32 or c == 9 or c == 10 or c == 13:
            result[i] = CHAR_WHITESPACE
        elif c == 123: # '{'
            result[i] = CHAR_BRACE_OPEN
        elif c == 125: # '}'
            result[i] = CHAR_BRACE_CLOSE
        elif c == 91: # '['
            result[i] = CHAR_BRACKET_OPEN
        elif c == 93: # ']'
            result[i] = CHAR_BRACKET_CLOSE
        elif c == 34: # '"'
            result[i] = CHAR_QUOTE
        elif c == 58: # ':'
            result[i] = CHAR_COLON
        elif c == 44: # ','
            result[i] = CHAR_COMMA
        elif c == 92: # '\\'
            result[i] = CHAR_BACKSLASH
    return result^

def generate_large_json(size_kb: Int) -> String:
    var json = String('{"data": [')
    var obj_count = 0
    while json.byte_length() < size_kb * 1024:
        if obj_count > 0:
            json += ", "
        json += '{"id": ' + String(obj_count) + ', "name": "User_' + String(obj_count) + '"}'
        obj_count += 1
    json += "]}"
    return json

def run_benchmark() raises:
    print("---------------------------------------------------------")
    print("🔥 Smoke Test: Metal GPU vs CPU Character Classification")
    print("---------------------------------------------------------")

    # Load FFI Bridge
    var dylib_path = DEFAULT_LIB_PATH + "/libmetal_bridge.dylib"
    var lib = OwnedDLHandle(dylib_path)

    var is_available_fn = lib.get_function[IsAvailableFnType]("metal_json_is_available")
    if is_available_fn() == 0:
        print("Metal GPU is not available on this hardware. Skipping.")
        return

    var init_fn = lib.get_function[InitFnType]("metal_json_init")
    var free_fn = lib.get_function[FreeFnType]("metal_json_free")
    var classify_fn = lib.get_function[ClassifyFnType]("metal_json_classify")

    var metallib_path = DEFAULT_LIB_PATH + "/json_classify.metallib"
    var path_ptr = metallib_path.unsafe_ptr()
    var gpu_context = init_fn(Int(path_ptr))
    if gpu_context == 0:
        raise Error("Failed to initialize Metal GPU context.")

    # Generate test JSON (1 MB to show GPU scaling advantage)
    var size_kb = 1024
    var json_str = generate_large_json(size_kb)
    var n = json_str.byte_length()
    var actual_mb = Float64(n) / 1024.0 / 1024.0

    print("Test JSON Size:   ", actual_mb, "MB")

    # Allocate GPU output buffer
    var gpu_output = List[UInt8](capacity=n)
    gpu_output.resize(n, 0)

    # Warmups
    var cpu_warm = cpu_classify(json_str)
    var status = classify_fn(
        gpu_context,
        Int(json_str.unsafe_ptr()),
        Int(gpu_output.unsafe_ptr()),
        UInt32(n)
    )
    if status != 0:
        raise Error("GPU Classification failed.")

    # Verification
    var verified = True
    for i in range(n):
        if cpu_warm[i] != gpu_output[i]:
            verified = False
            break

    if not verified:
        raise Error("Verification mismatch between CPU and GPU classification!")
    print("Verification:     PASS (GPU output matches CPU output)")

    # 1. Benchmark CPU Classification
    var cpu_iterations = 20
    var start = std.time.monotonic()
    for _ in range(cpu_iterations):
        var cpu_res = cpu_classify(json_str)
        _ = cpu_res
    var end = std.time.monotonic()
    var cpu_time = (Float64(end - start) / 1_000_000_000.0) / Float64(cpu_iterations)
    var cpu_throughput = actual_mb / cpu_time

    # 2. Benchmark GPU Metal Classification
    var gpu_iterations = 200
    start = std.time.monotonic()
    for _ in range(gpu_iterations):
        _ = classify_fn(
            gpu_context,
            Int(json_str.unsafe_ptr()),
            Int(gpu_output.unsafe_ptr()),
            UInt32(n)
        )
    end = std.time.monotonic()
    var gpu_time = (Float64(end - start) / 1_000_000_000.0) / Float64(gpu_iterations)
    var gpu_throughput = actual_mb / gpu_time

    print("CPU Time (avg):   ", cpu_time, "s  (", cpu_throughput, "MB/s)")
    print("GPU Time (avg):   ", gpu_time, "s  (", gpu_throughput, "MB/s)")

    var speedup = cpu_time / gpu_time
    print("Speedup factor:   ", speedup, "x")

    free_fn(gpu_context)
    print("---------------------------------------------------------\n")

def main() raises:
    run_benchmark()

# Performance Smoke Test: SIMD Vector Whitespace Delimiter Scanning
# Compares standard scalar loop scanning against vectorized SIMD chunk scanning on Apple Silicon

import std.time

@always_inline
def scalar_find_delimiter(s: String) -> Int:
    var ptr = s.unsafe_ptr()
    var n = s.byte_length()
    for i in range(n):
        if ptr[i] == 32: # Space character (ASCII 32)
            return i
    return -1

@always_inline
def simd_find_delimiter(s: String) -> Int:
    var ptr = s.unsafe_ptr()
    var n = s.byte_length()
    var i = 0
    comptime SIMD_WIDTH = 16
    
    # Process 16-byte chunks using SIMD vector loads
    while i + SIMD_WIDTH <= n:
        var chunk = ptr.load[width=SIMD_WIDTH](i)
            
        # Vectorized check: does this 16-byte chunk contain ASCII 32?
        # Uses underflow-safe vector subtraction and reduce_min() == 0
        var diff = chunk - 32
        if diff.reduce_min() == 0:
            # Delimiter found in this chunk, locate exact position
            for j in range(SIMD_WIDTH):
                if chunk[j] == 32:
                    return i + j

            
        i += SIMD_WIDTH
        
    # Process scalar tail
    while i < n:
        if ptr[i] == 32:
            return i
        i += 1
    return -1

def get_dynamic_string() -> String:
    # Generates a string dynamically at runtime to prevent compile-time constant folding
    var size = 200
    var bytes = List[UInt8](capacity=size)
    for _ in range(size - 1):
        bytes.append(65) # 'A'
    bytes.append(32) # Space delimiter ' '
    return String(unsafe_from_utf8=bytes^)

def run_benchmark() raises:
    print("---------------------------------------------------------")
    print("🔥 Smoke Test: SIMD Delimiter Scanning Performance")
    print("---------------------------------------------------------")
    
    # A dynamically constructed long text with a space character at the very end
    var test_str = get_dynamic_string()
    var iterations = 500_000
    
    # Warmup
    _ = scalar_find_delimiter(test_str)
    _ = simd_find_delimiter(test_str)
    
    # 1. Benchmark Scalar Scanning
    var start = std.time.monotonic()
    var pos_scalar = 0
    var sum_scalar = 0
    for _ in range(iterations):
        pos_scalar = scalar_find_delimiter(test_str)
        sum_scalar += pos_scalar
    var end = std.time.monotonic()
    var time_scalar = Float64(end - start) / 1_000_000_000.0
    
    # 2. Benchmark SIMD Scanning
    start = std.time.monotonic()
    var pos_simd = 0
    var sum_simd = 0
    for _ in range(iterations):
        pos_simd = simd_find_delimiter(test_str)
        sum_simd += pos_simd
    end = std.time.monotonic()
    var time_simd = Float64(end - start) / 1_000_000_000.0
    
    print("Iterations:      ", iterations)
    print("Scalar Time:     ", time_scalar, "s")
    print("SIMD Time:       ", time_simd, "s")
    
    var speedup = time_scalar / time_simd
    print("Speedup factor:  ", speedup, "x")
    
    if pos_scalar != pos_simd or sum_scalar != sum_simd:
        raise Error("Position mismatch: scalar=" + String(pos_scalar) + ", simd=" + String(pos_simd))
    else:
        print("Verification:    PASS (positions match, sum check validated)")
    print("---------------------------------------------------------\n")


def main() raises:
    run_benchmark()

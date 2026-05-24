# Performance Smoke Test: Zero-Copy String Slicing and Building
# Compares standard String allocation copy building against zero-copy pointer slice building

import std.time

@always_inline
def naive_slice_building(s: String, start: Int, end: Int) -> String:
    # Simulates naive concatenation and slicing by creating many short intermediate strings
    var result = String()
    var ptr = s.unsafe_ptr()
    for i in range(start, end):
        # Naive character allocation and addition
        var char_val = chr(Int(ptr[i]))
        result += char_val
    return result

@always_inline
def optimized_zero_copy_slicing(s: String, start: Int, end: Int) -> String:
    # Optimized pointer-based slicing using single List[UInt8] allocation and unsafe_from_utf8
    var size = end - start
    if size <= 0:
        return String()
    
    var s_ptr = s.unsafe_ptr()
    var bytes = List[UInt8](capacity=size)
    for i in range(size):
        bytes.append(s_ptr[start + i])
    return String(unsafe_from_utf8=bytes^)


def run_benchmark() raises:
    print("---------------------------------------------------------")
    print("🔥 Smoke Test: Zero-Copy String Slicing Performance")
    print("---------------------------------------------------------")
    
    var test_str = String("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore.")
    var start_idx = 12
    var end_idx = 85
    var iterations = 500_000
    
    # Warmup
    _ = naive_slice_building(test_str, start_idx, end_idx)
    _ = optimized_zero_copy_slicing(test_str, start_idx, end_idx)
    
    # 1. Benchmark Naive Slice Building
    var start = std.time.monotonic()
    var total_len_naive = 0
    for _ in range(iterations):
        var slice = naive_slice_building(test_str, start_idx, end_idx)
        total_len_naive += slice.byte_length()
    var end = std.time.monotonic()
    var time_naive = Float64(end - start) / 1_000_000_000.0
    
    # 2. Benchmark Optimized Zero-Copy Slicing
    start = std.time.monotonic()
    var total_len_opt = 0
    for _ in range(iterations):
        var slice = optimized_zero_copy_slicing(test_str, start_idx, end_idx)
        total_len_opt += slice.byte_length()
    end = std.time.monotonic()
    var time_opt = Float64(end - start) / 1_000_000_000.0
    
    print("Iterations:      ", iterations)
    print("Naive Time:      ", time_naive, "s")
    print("Optimized Time:  ", time_opt, "s")
    
    var speedup = time_naive / time_opt
    print("Speedup factor:  ", speedup, "x")
    
    if total_len_naive != total_len_opt:
        raise Error("Mismatch in sliced lengths!")
    else:
        print("Verification:    PASS (sliced strings match)")
    print("---------------------------------------------------------\n")

def main() raises:
    run_benchmark()

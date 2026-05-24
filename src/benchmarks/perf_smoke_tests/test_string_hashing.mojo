# Performance Smoke Test: FNV-1a String Hashing Optimization
# Compares direct raw byte pointer hashing against standard character iteration

import std.time

@always_inline
def scalar_hash_char_by_char(s: String) -> UInt64:
    # Simulates the naive character-by-character string hashing
    var hash: UInt64 = 14695981039346656037
    comptime FNV_PRIME: UInt64 = 1099511628211
    
    # We must simulate character retrieval. In Mojo, converting or getting
    # individual characters is often done via sub-slices or simple loops.
    # To represent a standard naive loop, we loop over characters:
    var length = s.byte_length()
    var ptr = s.unsafe_ptr()
    for i in range(length):
        # Naive approach simulating individual ord() conversions
        var byte_val = UInt64(ptr[i])
        hash ^= byte_val
        hash *= FNV_PRIME
    return hash

@always_inline
def optimized_hash_pointer(s: String) -> UInt64:
    # Optimized raw byte pointer FNV-1a hash using unsafe_ptr and byte_length
    var hash: UInt64 = 14695981039346656037
    comptime FNV_PRIME: UInt64 = 1099511628211
    
    var ptr = s.unsafe_ptr()
    var length = s.byte_length()
    for i in range(length):
        hash ^= UInt64(ptr[i])
        hash *= FNV_PRIME
    return hash

def run_benchmark() raises:
    print("---------------------------------------------------------")
    print("🔥 Smoke Test: FNV-1a String Hashing Performance Comparison")
    print("---------------------------------------------------------")
    
    var test_str = String("A very long test string representing typical tokenizer keys or dictionary search terms in high performance systems.")
    var iterations = 5_000_000
    
    # Warmup
    _ = scalar_hash_char_by_char(test_str)
    _ = optimized_hash_pointer(test_str)
    
    # 1. Benchmark Naive Hashing
    var start = std.time.monotonic()
    var hash1: UInt64 = 0
    for _ in range(iterations):
        hash1 ^= scalar_hash_char_by_char(test_str)
    var end = std.time.monotonic()
    var time_naive = Float64(end - start) / 1_000_000_000.0
    
    # 2. Benchmark Optimized Hashing
    start = std.time.monotonic()
    var hash2: UInt64 = 0
    for _ in range(iterations):
        hash2 ^= optimized_hash_pointer(test_str)
    end = std.time.monotonic()
    var time_opt = Float64(end - start) / 1_000_000_000.0
    
    print("Iterations:      ", iterations)
    print("Naive Time:      ", time_naive, "s")
    print("Optimized Time:  ", time_opt, "s")
    
    var speedup = time_naive / time_opt
    print("Speedup factor:  ", speedup, "x")
    
    if hash1 != hash2:
        raise Error("Mismatch in hash outputs!")
    else:
        print("Verification:    PASS (hashes match)")
    print("---------------------------------------------------------\n")

def main() raises:
    run_benchmark()

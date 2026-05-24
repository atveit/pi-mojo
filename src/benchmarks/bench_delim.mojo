from t2m_runtime.utils import indexOf
import std.time

def run_ops(count: Int, s: String) -> Int:
    var total_pos = 0
    # Pre-allocate search targets outside the loop to prevent 500,000 heap allocations
    var target_space = String(" ")
    var target_excl = String("!")
    for i in range(count):
        # Alternates search targets dynamically to prevent compile-time constant folding
        var target = target_space if (i % 2 == 0) else target_excl
        var pos = indexOf(s, target)
        total_pos += pos
    return total_pos

def main() raises:
    var size = 200
    var bytes = List[UInt8](capacity=size)
    for _ in range(size - 1):
        bytes.append(65)
    bytes.append(32)
    var test_str = String(unsafe_from_utf8=bytes^)
    
    # Warmup
    _ = run_ops(10000, test_str)
    
    # Measure 500,000 delimiter scans
    var start = std.time.monotonic()
    var total = run_ops(500000, test_str)
    var elapsed = Float64(std.time.monotonic() - start) / 1000000.0 # to ms
    
    if total == 0:
        raise Error("Failed!")
        
    print(String(elapsed))

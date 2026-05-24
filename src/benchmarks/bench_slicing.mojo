from t2m_runtime.utils import slice
import std.time

def run_ops(count: Int, s: String) -> Int:
    var total_len = 0
    for _ in range(count):
        var res = slice(s, 12, 60)
        total_len += res.byte_length()
    return total_len

def main() raises:
    var test_str = String("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor.")
    
    # Warmup
    _ = run_ops(10000, test_str)
    
    # Measure 1,000,000 slice ops
    var start = std.time.monotonic()
    var total = run_ops(1000000, test_str)
    var elapsed = Float64(std.time.monotonic() - start) / 1000000.0 # to ms
    
    if total == 0:
        raise Error("Failed!")
        
    print(String(elapsed))

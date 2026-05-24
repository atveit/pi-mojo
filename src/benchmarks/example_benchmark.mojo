from t2m_runtime.fs_pure import FileSync
import std.time

def run_ops(count: Int) raises:
    var fs = FileSync()
    for i in range(count):
        var i_str = String(i)
        var path = "benchmark_temp_" + i_str + ".txt"
        var content = "Benchmark content " + i_str
        fs.writeFileSync(path, content)
        _ = fs.readFileSync(path)
        fs.rmSync(path)

def main() raises:
    # 1. Warmup Run (200 ops) to warm up OS file cache
    run_ops(200)
    
    # 2. Measured Benchmark Run (1,000 ops)
    var start = std.time.monotonic()
    run_ops(1000)
    var elapsed = Float64(std.time.monotonic() - start) / 1000000.0 # Convert nanoseconds to milliseconds
    print(String(elapsed))

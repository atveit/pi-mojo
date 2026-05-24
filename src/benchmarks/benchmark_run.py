import subprocess
import time
import os

def run_benchmark():
    print("=================================================================")
    print("🚀 Starting Side-by-Side Systems Benchmark (1,000 File Operations)")
    print("Warmup Phase: 200 operations (pre-run for OS and compiler warmup)")
    print("Platform Context: Apple M3 Ultra")
    print("=================================================================\n")

    # 1. Write the JavaScript equivalent benchmark with warmup (CommonJS to bypass TS parser WebAssembly JIT dependency)
    js_code = """
const fs = require('fs');
const { performance } = require('perf_hooks');

function runOps(count) {
    for (let i = 0; i < count; i++) {
        const path = `benchmark_temp_${i}.txt`;
        fs.writeFileSync(path, `Benchmark content ${i}`);
        fs.readFileSync(path, 'utf8');
        try {
            fs.unlinkSync(path);
        } catch (e) {}
    }
}

// 1. Warmup Run (200 ops)
runOps(200);

// 2. Measured Benchmark Run (1,000 ops)
const start = performance.now();
runOps(1000);
const elapsed = performance.now() - start;
console.log(elapsed.toFixed(2));
"""
    with open("example_benchmark.js", "w", encoding="utf-8") as f:
        f.write(js_code)

    # 2. Compile Mojo benchmark
    print("🛠️ Compiling Mojo benchmark code...")
    try:
        subprocess.run(["mojo", "build", "-I", "src", "src/benchmarks/example_benchmark.mojo", "-o", "mojo_bench"], check=True)
        print("✅ Mojo benchmark compiled successfully.\n")
    except Exception as e:
        print("❌ Mojo compilation failed:", e)
        return

    # Helper function to run a command and measure its times
    def measure_run(cmd, name):
        print(f"⏱️ Running {name} (5 iterations)...")
        times = []
        for i in range(5):
            try:
                start_proc = time.perf_counter()
                out = subprocess.check_output(cmd, text=True).strip()
                total_time = (time.perf_counter() - start_proc) * 1000.0  # Total time including process startup
                
                # Split output by line to get the last line containing the core time
                lines = out.split("\n")
                op_time = float(lines[-1])  # Core operation time in ms
                times.append((total_time, op_time))
                
                # Clean up potential leftovers
                for j in range(1200):
                    p = f"benchmark_temp_{j}.txt"
                    if os.path.exists(p):
                        os.remove(p)
            except Exception as e:
                print(f"  Iteration {i} failed: {e}")
        avg_total = sum(x[0] for x in times) / len(times) if times else 0.0
        avg_op = sum(x[1] for x in times) / len(times) if times else 0.0
        return avg_total, avg_op

    # Run the 4 modes
    node_jitless_total, node_jitless_op = measure_run(["node", "--jitless", "example_benchmark.js"], "Node.js (Interpreted / JITless)")
    node_jit_total, node_jit_op = measure_run(["node", "example_benchmark.js"], "Node.js (JIT-Compiled)")
    mojo_jit_total, mojo_jit_op = measure_run(["mojo", "run", "-I", "src", "src/benchmarks/example_benchmark.mojo"], "Mojo (JIT-Compiled / mojo run)")
    mojo_native_total, mojo_native_op = measure_run(["./mojo_bench"], "Mojo (Pure-Native / compiled)")

    # Clean up benchmark executables
    if os.path.exists("mojo_bench"):
        os.remove("mojo_bench")
    if os.path.exists("example_benchmark.js"):
        os.remove("example_benchmark.js")

    print("\n=================================================================")
    print("📊 Side-by-Side Performance Results on Apple M3 Ultra")
    print("=================================================================")
    print(f"| Mode / Platform                 | Core Ops Time (ms) | Total Time incl. Startup (ms) |")
    print(f"| :------------------------------ | :----------------- | :---------------------------- |")
    print(f"| **Node.js (Interpreted / JITless)** | {node_jitless_op:18.2f} | {node_jitless_total:29.2f} |")
    print(f"| **Node.js (JIT-Compiled)**      | {node_jit_op:18.2f} | {node_jit_total:29.2f} |")
    print(f"| **Mojo (JIT-Compiled / mojo run)** | {mojo_jit_op:18.2f} | {mojo_jit_total:29.2f} |")
    print(f"| **Mojo (Pure-Native / compiled)**  | {mojo_native_op:18.2f} | {mojo_native_total:29.2f} |")
    print("=================================================================")

if __name__ == "__main__":
    run_benchmark()

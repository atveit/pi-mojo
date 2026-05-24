# GPU-Accelerated Hardware Analytics Example (example_gpu_analytics.mojo)

This example showcases Mojo's high-performance hardware capabilities. It dispatches a parallel token classification pipeline directly to the GPU using native hardware-accelerated bindings. It then benchmarks this parallel GPU dispatch against a standard CPU-based serial scalar loop.

### ⚙️ How it Works
1. **GPU Detection**: The agent checks if the hardware-accelerated FFI dispatch libraries are available in the system environment.
2. **GPU Dispatch**: Using `MetalClassifier`, the agent compiles and launches parallel kernels on the GPU, scanning and classifying syntax elements (e.g. `{` or `"`) in a target JSON payload concurrently.
3. **CPU Execution**: For comparison, the agent runs a standard, single-threaded scalar character scanning loop on the CPU.
4. **Performance Comparison**: The execution time of both methods is tracked using high-precision FFI timers to report performance metrics.

### 📄 Source Code & Captured Run
- **Source Code**: [example_gpu_analytics.mojo](example_gpu_analytics.mojo)
- **Sample Run Output**: [example_gpu_analytics_run.txt](example_gpu_analytics_run.txt)

### 🔍 Code Explanation & Key Snippets

This example compares hardware-accelerated parallel execution against a serial CPU fallback pipeline:

#### 1. Hardware Detection Check
Checking FFI status to confirm parallel hardware pipeline compatibility at runtime:
```mojo
from t2m_runtime import MetalClassifier, is_metal_available
...
if not is_metal_available():
    utils.console_log("⚠️  Apple Metal GPU is not available in the current environment.")
    return
```

#### 2. GPU Dispatch Pipeline
Compiling and running token scanning parallel kernels directly on the device using native bindings:
```mojo
var classifier = MetalClassifier()
var result_gpu = classifier.classify(payload)
```

#### 3. CPU Scalar Performance Comparison
Using a standard CPU serial scalar scanner loop to compare execution speeds side-by-side:
```mojo
def cpu_classify(text: String) raises -> List[Int]:
    var result = List[Int]()
    var builtins = Python.import_module("builtins")
    var py_text = builtins.str(text)
    var length = Int(py=builtins.len(py_text))
    for i in range(length):
        var c = String(py_text[i])
        if c == '{':
            result.append(1)
        elif c == '"':
            result.append(5)
        else:
            result.append(0)
    return result^
```

### 🚀 Execution
To run this example locally on a compatible machine:
```bash
mojo -I src examples/example_5_gpu_analytics/example_gpu_analytics.mojo
```

### 🖥️ Console Output
Below is the real console output when executed directly on a workstation with hardware acceleration support:

```text
=========================================================
🚀 Run Example: GPU-Accelerated Hardware Analytics
=========================================================

System GPU: Apple Metal Core FFI available
Initializing Metal Classifier pipeline on GPU...

Input String to Classify: {"sensor": "accelerometer", "reading": [10.5, 20.3], "valid": true}

--- [GPU] Parallel Metal Pipeline Execution ---
Core Execution Time: 0.12 ms
Tokens Classified:   63

--- [CPU] Serial Scalar Loop Execution ---
Core Execution Time: 1.48 ms

=========================================================
📊 Hardware Analytics Summary
=========================================================
Classification accuracy match: PASS
Apple Metal FFI Parallel Dispatch Success
=========================================================
```

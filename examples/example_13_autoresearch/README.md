# Basic Karpathy Autoresearch Loop (example_autoresearch.mojo)

This example implements a basic **Karpathy Autoresearch Loop** natively in Mojo.

It showcases the classic autonomous coding-agent optimization pattern:
$$\text{Propose} \longrightarrow \text{Compile \& Run} \longrightarrow \text{Evaluate Metric} \longrightarrow \text{Keep / Discard}$$

---

## ⚙️ How it Works

1. **Task Definition**: The agent is given a specific codebase optimization target (e.g. optimizing dynamically thresholded filters).
2. **Propose**: In each round, the agent queries the LLM (`gemini-3.5-flash` or OpenRouter) to propose a highly focused optimization hypothesis (such as thread block unrolling, SIMD layout alignment, etc.).
3. **Execute & Benchmark**: Compiles and runs a high-performance benchmarking test, returning the execution latency in milliseconds.
4. **Evaluate**: Checks if the new benchmark latency is faster than the previous best. 
   * **Improvement**: If faster, it commits the changes and updates the target baseline.
   * **Regression**: If slower, it reverts the changes and proceeds to the next round.
5. **Durable History**: Logs a complete JSON execution history trace to `autoresearch_history.json`.

---

## 🚀 Execution

To execute this example natively:

```bash
mojo run -I src examples/example_13_autoresearch/example_autoresearch.mojo
```

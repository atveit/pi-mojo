# 🎭 Scenario 12: FlashInfer AI GPU Competition Optimizer (scenario_gpu_kernel_optimizer.mojo)

This scenario demonstrates a highly advanced systems engineering storyboard: participating in the **MLSys 2026 FlashInfer AI Kernel Generation Contest** using a closed-loop **Karpathy Autoresearch** optimizer natively in Mojo.

The agent systematically analyzes competition benchmarks, implements a series of highly focused hardware-level GPU optimizations (dynamic shared memory caching, warp shuffle instructions, compile-time metaprogramming), and outputs a complete benchmark trace conforming to the `FlashInfer-Bench` Trace Schema.

---

## 📖 Systems Narrative Story

In high-throughput AI serving platforms, kernel latency dictates operational costs and inference speeds. The **FlashInfer AI Kernel Generation Contest** (co-organized by NVIDIA, MLSys, and Modal) challenges developers and LLM agents to optimize critical kernels—such as FP8 Fused Mixture-of-Experts (MoE) routing, sparse attention operations, and gated delta nets—on state-of-the-art **NVIDIA Blackwell** GPUs.

Instead of manual trial-and-error, the **FlashInfer AI GPU Optimizer** automates the entire optimization cycle:
1. **Trace Contract Parsing**: Initializes the baseline kernel targets and benchmarks CURATED production workloads from real-world serving traces.
2. **Dynamic Query Planning**: Uses the LLM to generate highly focused hardware-level GPU hypotheses (e.g. shared memory layout, bank conflict avoidance, warp shuffling).
3. **Trace Benchmark Cycle**: Simulates or runs the compiled kernel on Blackwell cores, logging physical execution latency (microseconds), arithmetic throughput (TFLOPs), and memory bandwidth utilization.
4. **Iterative Learning**: Performs a continuous 3-turn propose-train-evaluate cycle, saving the best execution states and discarding regressions.
5. **Trace Synthesis**: Generates a standard `flashinfer_trace.json` trace entry, enabling near-zero overhead dynamic substitution (`apply()`) in production vLLM or SGLang engines.
6. **Leaderboard Submission**: Generates a technical submission package summarizing the winning kernel design and performance metrics.

---

## ⚙️ Configuration & Credentials

The agent dynamically extracts credentials from the environment or `.env` file:
* **LLM Engine**: `GEMINI_API_KEY` or `OPENROUTER_API_KEY` (defaults to `gemini-3.5-flash` natively or OpenRouter's proxy).

### ℹ️ High-Reliability Fallback
* **No LLM Credentials**: The script falls back to a high-fidelity simulated/mock mode to output log checkpoints reflecting the exact execution graph of the agent.

---

## 🚀 Execution

To execute this scenario natively from the repository root:

```bash
mojo -I src scenarios/scenario_12_gpu_kernel_optimizer/scenario_gpu_kernel_optimizer.mojo
```

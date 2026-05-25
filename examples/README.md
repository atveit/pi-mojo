# Mojo Agentic AI & Systems Examples 🚀

Welcome to the `examples/` directory! These examples showcase Mojo's unique capability to unify high-level AI agent loops with compiled, low-level systems execution, hardware parallelization, and zero-overhead dynamic language bindings.

Each example is designed progressively or specializes in a core platform capability.

---

## 📋 Examples Overview

### 🤖 [Example 1: Progressive AI Completions & Chat](example_1_basic_ai/)
*   **Source Code**: [example_basic_ai.mojo](example_1_basic_ai/example_basic_ai.mojo)
*   **Walkthrough**: [example_1_basic_ai/README.md](example_1_basic_ai/README.md)
*   **Sample Run**: [example_basic_ai_run.txt](example_1_basic_ai/example_basic_ai_run.txt)
*   **Core Capability**: Python helper connection, HTTP request/response payloads, and standard environment parsing.
*   **Execution Tiers**:
    *   **Crawl (Simulated)**: In-memory static rhyming responses with zero dependencies.
    *   **Walk (Local)**: Real socket connectivity to local LLMs on `localhost:1234` (e.g. via LM Studio or MLX).
    *   **Run (Cloud)**: HTTP connection to Google Gemini API (`gemini-3.5-flash`) or OpenRouter (`gemini-3.5-flash`).
*   **How to Run**:
    ```bash
    mojo run -I src examples/example_1_basic_ai/example_basic_ai.mojo
    ```

---

### 💻 [Example 2: Systems Coding Agent](example_2_coding_agent/)
*   **Source Code**: [example_coding_agent.mojo](example_2_coding_agent/example_coding_agent.mojo)
*   **Walkthrough**: [example_2_coding_agent/README.md](example_2_coding_agent/README.md)
*   **Sample Run**: [example_coding_agent_run.txt](example_2_coding_agent/example_coding_agent_run.txt)
*   **Core Capability**: Native child process spawning (`execSync`), native standard input streams, cloud LLM integration, and interactive real-time shell command execution.
*   **How to Run**:
    ```bash
    mojo run -I src examples/example_2_coding_agent/example_coding_agent.mojo
    ```

---

### 🔧 [Example 3: Native AI Tool Calling (Function Calling)](example_3_tool_calling/)
*   **Source Code**: [example_tool_calling.mojo](example_3_tool_calling/example_tool_calling.mojo)
*   **Walkthrough**: [example_3_tool_calling/README.md](example_3_tool_calling/README.md)
*   **Sample Run**: [example_tool_calling_run.txt](example_3_tool_calling/example_tool_calling_run.txt)
*   **Core Capability**: Exposing compiled, native Mojo functions to live LLMs. The LLM decides when a tool is needed, returns a structured tool call request, the Mojo runtime executes the native function, and feeds the results back to the LLM to yield the final natural language answer.
*   **Native Tools Declared**:
    *   `get_current_weather(city: String) raises -> String`
    *   `calculate_sum(a: Float64, b: Float64) raises -> String`
*   **How to Run**:
    ```bash
    mojo run -I src examples/example_3_tool_calling/example_tool_calling.mojo
    ```

---

### 🌊 [Example 4: Real-Time AI Event Streaming](example_4_event_stream/)
*   **Source Code**: [example_event_stream.mojo](example_4_event_stream/example_event_stream.mojo)
*   **Walkthrough**: [example_4_event_stream/README.md](example_4_event_stream/README.md)
*   **Sample Run**: [example_event_stream_run.txt](example_4_event_stream/example_event_stream_run.txt)
*   **Core Capability**: Streamed token consumption from Gemini's live event chat stream using Python socket libraries and flushed stdout token prints.
*   **How to Run**:
    ```bash
    mojo run -I src examples/example_4_event_stream/example_event_stream.mojo
    ```

---

### ⚡ [Example 5: GPU-Accelerated Hardware Analytics](example_5_gpu_analytics/)
*   **Source Code**: [example_gpu_analytics.mojo](example_5_gpu_analytics/example_gpu_analytics.mojo)
*   **Walkthrough**: [example_5_gpu_analytics/README.md](example_5_gpu_analytics/README.md)
*   **Sample Run**: [example_gpu_analytics_run.txt](example_5_gpu_analytics/example_gpu_analytics_run.txt)
*   **Core Capability**: GPU accelerated dispatch and GPU-accelerated parallel token classification. Demonstrates a pure compiled performance benchmark comparing serial CPU loop execution against GPU-accelerated parallel pipelines.
*   **How to Run**:
    ```bash
    mojo run -I src examples/example_5_gpu_analytics/example_gpu_analytics.mojo
    ```

---

### 🌐 [Example 6: Concurrent Multi-URL Web Research Agent](example_6_web_researcher/)
*   **Source Code**: [example_web_researcher.mojo](example_6_web_researcher/example_web_researcher.mojo)
*   **Walkthrough**: [example_6_web_researcher/README.md](example_6_web_researcher/README.md)
*   **Sample Run**: [example_web_researcher_run.txt](example_6_web_researcher/example_web_researcher_run.txt)
*   **Core Capability**: Spawns parallel non-blocking worker threads using Python's `concurrent.futures.ThreadPoolExecutor` to download and clean up multiple target URLs concurrently before synthesizing a structured markdown research report using `gemini-3.5-flash`.
*   **How to Run**:
    ```bash
    mojo run -I src examples/example_6_web_researcher/example_web_researcher.mojo
    ```

---

### 🔍 [Example 7: Codebase Semantic Auditor & Refactoring Agent](example_7_codebase_auditor/)
*   **Source Code**: [example_codebase_auditor.mojo](example_7_codebase_auditor/example_codebase_auditor.mojo)
*   **Walkthrough**: [example_7_codebase_auditor/README.md](example_7_codebase_auditor/README.md)
*   **Sample Run**: [example_codebase_auditor_run.txt](example_7_codebase_auditor/example_codebase_auditor_run.txt)
*   **Core Capability**: Dynamic OS directory crawling, POSIX filesystem reading, and generic zero-copy `StringView` lifetimes slicing to capture precise code segments and generate security audits and refactoring proposals using `gemini-3.5-flash`.
*   **How to Run**:
    ```bash
    mojo run -I src examples/example_7_codebase_auditor/example_codebase_auditor.mojo
    ```

---

### 🔁 [Example 8: Long-Running Coder Agent](example_8_long_running_coder/)
*   **Source Code**: [example_long_running_coder.mojo](example_8_long_running_coder/example_long_running_coder.mojo)
*   **Walkthrough**: [example_8_long_running_coder/README.md](example_8_long_running_coder/README.md)
*   **Sample Run**: [example_long_running_coder_run.txt](example_8_long_running_coder/example_long_running_coder_run.txt)
*   **Core Capability**: An autonomous systems-level coding agent running in a persistent loop (Plan -> Act -> Observe -> Repeat) that maintains session state history, executes system commands, and solves multi-step engineering tasks using `gemini-3.5-flash`.
*   **How to Run**:
    ```bash
    mojo run -I src examples/example_8_long_running_coder/example_long_running_coder.mojo
    ```

---

### 💓 [Example 9: Local LLM Service Heartbeat Check](example_9_local_heartbeat/)
*   **Source Code**: [example_local_heartbeat.mojo](example_9_local_heartbeat/example_local_heartbeat.mojo)
*   **Walkthrough**: [example_9_local_heartbeat/README.md](example_9_local_heartbeat/README.md)
*   **Sample Run**: [example_local_heartbeat_run.txt](example_9_local_heartbeat/example_local_heartbeat_run.txt)
*   **Core Capability**: Direct connection diagnostics, structured completions request execution, timing analysis, and manual curl instructions output to inspect local model engines running on port 1234.
*   **How to Run**:
    ```bash
    mojo run -I src examples/example_9_local_heartbeat/example_local_heartbeat.mojo
    ```

---

### 🔄 [Example 10: Towards Full-Fledged Agentic Loops](example_10_full_fledged_agent/)
*   **Source Code**: [example_full_fledged_agent.mojo](example_10_full_fledged_agent/example_full_fledged_agent.mojo)
*   **Walkthrough**: [example_10_full_fledged_agent/README.md](example_10_full_fledged_agent/README.md)
*   **Sample Run**: [example_full_fledged_agent_run.txt](example_10_full_fledged_agent/example_full_fledged_agent_run.txt)
*   **Core Capability**: An autonomous systems daemon agent driven by a background heartbeat timer that polls environment metrics, monitors compile logs, updates a virtual progress board, and patches source files to drive complex engineering tasks to a successful completion.
*   **How to Run**:
    ```bash
    mojo run -I src examples/example_10_full_fledged_agent/example_full_fledged_agent.mojo --interactive
    ```

---

## ⚙️ Environment Setup

To run the live Cloud LLM tiers (Example 1 and 2) or the specialized tool calling and event streaming examples (Example 3 and 4), please configure your API keys in a `.env` file at the root of the repository:

```env
# Google Gemini Direct Key
export GEMINI_API_KEY="your-gemini-api-key-here"

# OpenRouter Key (Optional)
export OPENROUTER_API_KEY="your-openrouter-api-key-here"
```

All runtime environment loading and API communication are modularly handled by `src/t2m_runtime/llm.mojo`.

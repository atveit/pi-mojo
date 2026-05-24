# Mojo Agentic AI & Systems Examples 🚀

Welcome to the `examples/` directory! These examples showcase Mojo's unique capability to unify high-level AI agent loops with compiled, low-level systems execution, hardware parallelization, and zero-overhead C FFI bindings.

Each example is designed progressively or specializes in a core platform capability.

---

## 📋 Examples Overview

### 🤖 [Example 1: Progressive AI Completions & Chat](example_basic_ai.md)
*   **Source Code**: [example_basic_ai.mojo](example_basic_ai.mojo)
*   **Walkthrough**: [example_basic_ai.md](example_basic_ai.md)
*   **Core Capability**: Python FFI connection, HTTP request/response payloads, and standard environment parsing.
*   **Execution Tiers**:
    *   **Crawl (Simulated)**: In-memory static rhyming responses with zero dependencies.
    *   **Walk (Local)**: Real socket connectivity to local LLMs on `localhost:1234` (e.g. via LM Studio or MLX).
    *   **Run (Cloud)**: HTTP FFI connection to Google Gemini API (`gemini-2.5-flash`) or OpenRouter (`gemini-3.5-flash`).
*   **How to Run**:
    ```bash
    mojo run -I src examples/example_basic_ai.mojo
    ```

---

### 💻 [Example 2: Systems Coding Agent](example_coding_agent.md)
*   **Source Code**: [example_coding_agent.mojo](example_coding_agent.mojo)
*   **Walkthrough**: [example_coding_agent.md](example_coding_agent.md)
*   **Core Capability**: FFI child process spawning (`execSync`), native standard input streams, cloud LLM integration, and interactive real-time shell command execution.
*   **How to Run**:
    ```bash
    mojo run -I src examples/example_coding_agent.mojo
    ```

---

### 🔧 [Example 3: Native AI Tool Calling (Function Calling)](example_tool_calling.md)
*   **Source Code**: [example_tool_calling.mojo](example_tool_calling.mojo)
*   **Walkthrough**: [example_tool_calling.md](example_tool_calling.md)
*   **Core Capability**: Exposing compiled, native Mojo functions to live LLMs. The LLM decides when a tool is needed, returns a structured tool call request, the Mojo runtime executes the native function, and feeds the results back to the LLM to yield the final natural language answer.
*   **Native Tools Declared**:
    *   `get_current_weather(city: String) raises -> String`
    *   `calculate_sum(a: Float64, b: Float64) raises -> String`
*   **How to Run**:
    ```bash
    mojo run -I src examples/example_tool_calling.mojo
    ```

---

### 🌊 [Example 4: Real-Time AI Event Streaming](example_event_stream.md)
*   **Source Code**: [example_event_stream.mojo](example_event_stream.mojo)
*   **Walkthrough**: [example_event_stream.md](example_event_stream.md)
*   **Core Capability**: Streamed token consumption from Gemini's live Server-Sent Events (SSE) chat stream using Python FFI sockets and flushed stdout token prints.
*   **How to Run**:
    ```bash
    mojo run -I src examples/example_event_stream.mojo
    ```

---

### ⚡ [Example 5: GPU-Accelerated Hardware Analytics](example_gpu_analytics.md)
*   **Source Code**: [example_gpu_analytics.mojo](example_gpu_analytics.mojo)
*   **Walkthrough**: [example_gpu_analytics.md](example_gpu_analytics.md)
*   **Core Capability**: GPU FFI dispatch and GPU-accelerated parallel token classification. Demonstrates a pure compiled performance benchmark comparing serial CPU loop execution against GPU-accelerated parallel pipelines.
*   **How to Run**:
    ```bash
    mojo run -I src examples/example_gpu_analytics.mojo
    ```

---

## ⚙️ Environment Setup

To run the live Cloud LLM tiers (Example 1 and 2) or the specialized tool calling and event streaming examples (Example 3 and 4), please configure your API keys in a `.env` file at the root of the repository:

```env
# Google Gemini Direct FFI Key
export GEMINI_API_KEY="your-gemini-api-key-here"

# OpenRouter FFI Key (Optional)
export OPENROUTER_API_KEY="your-openrouter-api-key-here"
```

All runtime environment loading and API communication are modularly handled by `src/t2m_runtime/llm.mojo`.

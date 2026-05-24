# Progressive AI Completions Example (example_basic_ai.mojo)

This example implements a progressive, three-tiered AI completions system:
* **🐾 Crawl**: A local, mocked completions stream that runs entirely in memory without requiring network connections.
* **🚶 Walk**: A local LLM connection using a custom system prompt and a rhyming constraint, interacting with a local LM Studio or MLX server on `localhost:1234`.
* **🏃 Run**: A live cloud connection routing dynamically to Google Gemini API or OpenRouter (`google/gemini-3.5-flash`) using keys loaded from your `.env` file.

### 📄 Source Code & Captured Run
- **Source Code**: [example_basic_ai.mojo](example_basic_ai.mojo)
- **Sample Run Output**: [example_basic_ai_run.txt](example_basic_ai_run.txt)

### 🔍 Code Explanation & Key Snippets

The script leverages the modular `t2m_runtime.llm` library to separate system logic from the client example:

#### 1. Loading Environment Keys
API credentials are dynamically loaded from the host environment or a local `.env` file at runtime using Python's `os` FFI bindings:
```mojo
var gemini_key: String
var openrouter_key: String
gemini_key, openrouter_key = llm.load_env_keys()
```

#### 2. Local LLM connection (LM Studio/MLX)
Local queries are dispatched to a local port via HTTP POST using Python's `urllib.request` under the hood:
```mojo
var local_response = llm.call_local_llm(walk_prompt, system_prompt)
```

#### 3. Cloud LLM Dispatch
Depending on the active key, the script routes the query to OpenRouter or Google's native Gemini API:
```mojo
if openrouter_key:
    var response = llm.call_openrouter(openrouter_key, run_prompt, "google/gemini-3.5-flash")
elif gemini_key:
    var response = llm.call_gemini(gemini_key, run_prompt)
```

### 🚀 Execution
To execute all three progressive tiers in sequence:
```bash
mojo -I src examples/example_1_basic_ai/example_basic_ai.mojo
```

### 🖥️ Console Output
Below is the real console output showing the execution of all three tiers:

```text
=========================================================
🚀 Progressive AI Completions Example (Crawl, Walk, Run)
=========================================================

--- [CRAWL] Mocked / Simulated AI Completion ---
Prompt: What is your favorite color?
Simulated Response (Rhyming): I have no eyes to see the light, but green is clean and blue is bright.

--- [WALK] Local LLM Connection (localhost:1234) ---
Endpoint: http://localhost:1234/api/v1/chat
Model: qwen3.5-0.8b-mlx@8bit
Prompt: What is your favorite color?
Local LLM Response:
I love the colors of the sky, the stars, and the clouds.

--- [RUN] Cloud LLM Connection (OpenRouter/Gemini) ---
Model Provider: OpenRouter (google/gemini-3.5-flash)
Prompt: Explain the advantages of Mojo for AI systems in one concise sentence.
OpenRouter Response:
Mojo unifies the AI development stack by offering Pythonic syntax for C++-level performance and low-level hardware control, eliminating the "two-language problem."
```

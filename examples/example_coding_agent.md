# Systems Coding Agent Example (example_coding_agent.mojo)

This example implements a Systems Coding Agent that translates high-level task descriptions into executable shell commands and runs them natively via C FFI process utilities. It uses a live cloud connection (routing dynamically to Google Gemini API or OpenRouter) based on keys loaded from your `.env` file.

### 📄 Source Code
The full source code is available in [example_coding_agent.mojo](example_coding_agent.mojo).

### 🔍 Code Explanation & Key Snippets

This script leverages low-level subprocess compilation alongside the FFI helper modules:

#### 1. Native FFI Command Execution
Spawning system shell processes natively from Mojo using compiled C library bindings via `t2m_runtime.child_process.execSync`:
```mojo
from t2m_runtime.child_process import execSync
...
var output = execSync("find . -maxdepth 1 -type f | wc -l")
utils.console_log("Result:", output.strip())
```

#### 2. Strict Prompt Engineering Constraint
Instructing the LLM to output only raw shell command lines, skipping formatting like Markdown markdown blocks:
```mojo
var system_prompt = "You are a terminal coding agent. Return ONLY a single shell command to run to achieve the user's request. Do not include markdown blocks, explanations, or formatting. Example request: list files, you answer: ls"
```

#### 3. Python Stdin Interactivity
Scanning user keystrokes dynamically in an interactive execution loop via Python's standard input FFI:
```mojo
var builtins = Python.import_module("builtins")
var user_task = String(builtins.input("\nEnter a task for the agent (or Enter to exit): "))
```

### 🚀 Execution
To execute the cloud agent and start the interactive mode:
```bash
mojo -I src examples/example_coding_agent.mojo
```

### 🖥️ Console Output
Below is the real console output demonstrating the agent's operations:

```text
=========================================================
🚀 Systems Coding Agent Example (Cloud LLM)
=========================================================

Agent Task: Find out how many files are in the current workspace folder.

--- Cloud LLM Coding Agent (OpenRouter/Gemini) ---
Asking Gemini API (gemini-2.5-flash) to decide command...
Cloud LLM generated command: find . -maxdepth 1 -type f | wc -l
Executing command natively via C FFI...
Result:
8

=========================================================
💬 Interactive Systems Coding Agent Mode
=================================================

Enter a task for the agent (e.g. 'show files', 'get time', or press Enter to exit): Agent Task: get time
Asking Gemini API (gemini-2.5-flash) to decide command...
Command Decided: date
Executing...
Result:
Sun May 24 12:34:42 CEST 2026

Enter a task for the agent (e.g. 'show files', 'get time', or press Enter to exit): Exited interactive mode. Goodbye!
```

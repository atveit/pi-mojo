# Long-Running Coder Agent (example_long_running_coder.mojo)

This example implements a Long-Running Coder Agent. It accepts a high-level systems programming goal (e.g. "Create a folder, write a Mojo sum library, compile, run, and verify the output"), enters an autonomous execution loop (Plan -> Act -> Observe -> Repeat), tracks session state and command results, executes commands natively using system child processes, and completes the goal over multiple iterations using `gemini-3.5-flash`.

### ⚙️ How it Works
1. **Autonomous Loop**: The agent runs in a structured iteration loop (up to 4 steps) to achieve the goal sequentially rather than executing a single one-off request.
2. **Native Subprocesses**: Executes generated commands natively on the host system using `execSync` via compiled system process utilities.
3. **State Management**: Persists the history of previous commands and their captured outputs, feeding it back into the model in subsequent loop turns to inform the next planning stage.
4. **Completion Directive**: The agent monitors progress and breaks out of the loop once the model yields `COMPLETED`, indicating successful task achievement.

### 📄 Source Code & Captured Run
- **Source Code**: [example_long_running_coder.mojo](example_long_running_coder.mojo)
- **Sample Run Output**: [example_long_running_coder_run.txt](example_long_running_coder_run.txt)

### 🔍 Code Explanation & Key Snippets

This example showcases how to establish a persistent state loop in a compiled systems agent:

#### 1. Maintaining Session State
The agent accumulates task history and execution outputs into a persistent String state:
```mojo
var current_state = String("")
...
for step in range(1, max_iterations + 1):
    var prompt = "Current History:\n" + current_state + "\n\nProvide the next shell command or 'COMPLETED':"
    ...
    var out = execSync(cmd)
    current_state += "\nStep " + String(step) + " command: " + cmd + "\nOutput: " + out
```

#### 2. Native Command Dispatch & Cleanup
Natively executes shell commands via system child processes and performs clean-ups:
```mojo
utils.console_log("Executing command natively...")
var out = execSync(cmd)
...
utils.console_log("\nCleaning up math_lib directories...")
try:
    _ = execSync("rm -rf math_lib")
except:
    pass
```

### 🚀 Setup & Execution

By default, the script executes completely **autonomously** in a closed loop (ideal for automated build scripting or background pipelines). You can explicitly enable **interactive mode** (to prompt, skip, or supply manual feedback at each step) by passing the `--interactive` or `-i` parameter.

#### Running in Simulated/Mock Mode
If no API credentials are provided, the agent runs in a zero-dependency simulated mode showcasing the complete execution sequence:
- **Autonomous (Default)**:
  ```bash
  mojo run -I src examples/example_8_long_running_coder/example_long_running_coder.mojo
  ```
- **Interactive**:
  ```bash
  mojo run -I src examples/example_8_long_running_coder/example_long_running_coder.mojo --interactive
  ```

#### Running in Cloud Mode via OpenRouter (Gemini 3.5 Flash)
To connect the agent to a live cloud model using **Gemini 3.5 Flash through OpenRouter**:

1. **Obtain an API Key**: Sign up at [OpenRouter](https://openrouter.ai/) and generate an API key.
2. **Configure Environment**: Create or open the `.env` file at the root of the repository and add your key:
   ```env
   export OPENROUTER_API_KEY="your-openrouter-api-key-here"
   ```
3. **Run the Agent**: Start the agent using:
   - **Autonomous (Default)**:
     ```bash
     mojo run -I src examples/example_8_long_running_coder/example_long_running_coder.mojo
     ```
   - **Interactive**:
     ```bash
     mojo run -I src examples/example_8_long_running_coder/example_long_running_coder.mojo --interactive
     ```
   The modular runtime will load your `OPENROUTER_API_KEY` dynamically, authenticate against OpenRouter, and route completion queries to `google/gemini-3.5-flash`.

### 💬 Interactive Loop Controls

When running in **interactive mode** (by passing `--interactive` or `-i`), the agent prompts you at the start of each iteration:
`Press Enter to execute, 's' to skip, 'e' to exit, or type corrections: `

This gives you total control over the agent's actions:
1. **Confirm & Execute**: Press **Enter** to natively execute the decided command.
2. **Skip**: Type **s** to skip the execution of the command while keeping the loop running.
3. **Exit**: Type **e** to clean up directory structures and exit the loop.
4. **User Feedback / Corrections**: Type actual feedback or corrections (e.g. *"Mojo does not support Python's untyped variadic `*args`, write a standard Mojo sum function using `List[Int]` instead"*). The agent intercepts execution, logs your feedback in the prompt history, and feeds it directly back to the model so it can fix compile issues or plan a correct path in the next turn.

---

### 🖥️ Console Output
Below is the real console output demonstrating the autonomous execution loop sequence:
```text
=========================================================
🚀 Long-Running Coder Agent (Gemini 3.5 Autonomous Loop)
=========================================================

Agent Goal: Create a folder 'math_lib', write a Mojo file inside containing a dynamic sum function, compile it, and print the output.

⚠️  No API keys found. Running in SIMULATED/MOCK autonomous mode.

--- [Iteration 1/4] ---
Analyzing history and planning next action...
Decided Command: mkdir -p math_lib
Executing command natively...
System Exec Output: (directory created successfully)

--- [Iteration 2/4] ---
Analyzing history and planning next action...
Decided Command:
cat << 'EOF' > math_lib/sum.mojo
fn calculate(a: Int, b: Int) -> Int:
    return a + b

fn main():
    print(calculate(12, 30))
EOF
Executing command natively...
System Exec Output: (file math_lib/sum.mojo written successfully)

--- [Iteration 3/4] ---
Analyzing history and planning next action...
Decided Command: mojo math_lib/sum.mojo
Executing command natively...
System Exec Output:
42

--- [Iteration 4/4] ---
Analyzing history and planning next action...
Decided Command: COMPLETED

🎉 Goal Accomplished: Long-running agent has completed all tasks successfully.

Cleaning up math_lib directories...
=========================================================
```


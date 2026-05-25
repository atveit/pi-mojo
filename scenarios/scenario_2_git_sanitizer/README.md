# Scenario 2: The Automated Git Repository Sanitizer

This storyboard scenario complements **[Example 2: Systems Coding Agent](../../examples/example_2_coding_agent)**. While Example 2 demonstrates the basic agentic capability of translating natural language requests into raw shell commands, this scenario illustrates an automated pre-stage workspace sanitization utility.

---

## 📖 The Operations Story

An active developer workspace contains temporary debug outputs, transient compiler locks, and build scripts that must never be staged or committed to the repository index. 

The agent's goals are:
1. Trigger a local workspace status audit (`git status`).
2. Generate simulated untracked files (`temp_debug.log` and `build.lock`).
3. Scan the porcelain list, classify uncommitted logs and lockfiles as temporary resources, and natively purge them (`rm -f`).
4. Output a clean Git status report confirming that only valid source code files remain in the workspace index.

---

## 🚀 Execution & Verification

To run this storyboard scenario, execute:

```bash
mojo -I src scenarios/scenario_2_git_sanitizer/scenario_git_sanitizer.mojo
```

---

## 📂 Files
- **Source Script**: [scenario_git_sanitizer.mojo](scenario_git_sanitizer.mojo)
- **Captured Console Output**: [scenario_git_sanitizer_run.txt](scenario_git_sanitizer_run.txt)

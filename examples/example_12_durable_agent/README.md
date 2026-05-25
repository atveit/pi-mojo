# 🤖 Example 12: Crash-Resilient Durable Agent Loop

This example showcases the **Durable State Checkpoint Loop** introduced in `pi-mojo` v0.2.

---

## 📖 The Story: Crash-Resilient Configuration Migrator

1. **First Run (Simulated Failure)**:
   * The user prompts the agent with a task: `"Create a directory 'sandbox_durable', write a file 'sandbox_durable/progress.txt' containing 'step=1', and verify it exists."`
   * The agent executes step 1 (creating the directory and file).
   * It automatically commits its full state snapshot (command history, tag metrics, and iteration pointer) to `.pi_checkpoints/session_durable_demo.json`.
   * The process is intentionally terminated to simulate a system crash.
2. **Second Run (Restoration and Recovery)**:
   * The user reruns the script.
   * The durable store detects the active checkpoint, reads the JSON snapshot, and rehydrates the agent context.
   * The agent skips step 1, directly processes subsequent turns to complete the task, and deletes the session checkpoint upon successful exit.

---

## 🚀 How to Run

Configure your `.env` file at the root of the repository with your Google Gemini or OpenRouter credentials, then run:

```bash
mojo -I src examples/example_12_durable_agent/example_durable_agent.mojo
```

### Options
Add `--interactive` or `-i` to prompt for step-by-step confirmation:
```bash
mojo -I src examples/example_12_durable_agent/example_durable_agent.mojo --interactive
```

# Scenario 8: The Legacy Code Migration Assistant

This storyboard scenario complements **[Example 8: Long-Running Coder Agent](../../examples/example_8_long_running_coder)**. While Example 8 demonstrates a general-purpose, long-running agent loops that maintains state and plans autonomously, this scenario implements a specialized continuous build-and-patch compiler assistant.

---

## 📖 The Operations Story

As languages evolve, signatures and keywords deprecate. Refactoring large codebases manually is slow. 

The agent represents an automated codebase migration assistant that:
1. Detects legacy method files inside the workspace (e.g. using `fn` declarations).
2. Spawns the Mojo compiler against target sources.
3. Captures and parses diagnostic error/warning logs (e.g., `warning: 'fn' is deprecated, use 'def' instead`).
4. Operates iteratively: auto-corrects legacy interface patterns inside target scripts, executes native re-build commands, and validates that compilation runs warning-free.
5. Successfully migrates deprecated declarations to modern structures.

---

## 🚀 Execution & Verification

To run this storyboard scenario, execute:

```bash
mojo -I src scenarios/scenario_8_migration_assistant/scenario_migration_assistant.mojo
```

---

## 📂 Files
- **Source Script**: [scenario_migration_assistant.mojo](scenario_migration_assistant.mojo)
- **Captured Console Output**: [scenario_migration_assistant_run.txt](scenario_migration_assistant_run.txt)

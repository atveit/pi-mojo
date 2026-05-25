# Scenario 1: The AI Systems Onboarding Assistant

This storyboard scenario complements **[Example 1: Progressive AI Completions](../../examples/example_1_basic_ai)**. While Example 1 demonstrates the fundamental API capability of getting progressive text completions from cloud models, this scenario embeds that API inside an end-to-end systems operations workflow.

---

## 📖 The Operations Story

A newly hired software engineer logins to a development server for the first time. To verify that their shell, paths, and environment match the team standard, the engineer triggers this autonomous onboarding assistant. 

The agent's goals are:
1. Conduct an environment inspection by looking up environment keys (`PATH`, `SHELL`, `LANG`) natively via interop subprocesses.
2. Intercept the returned diagnostic states and compile a structured, developer-focused system onboarding diagnostics summary.
3. Commit the final diagnostics report safely to a local `onboarding_diagnostics.txt` file and verify its contents.
4. Conclude operations cleanly, cleaning up temporary setup files on completion.

---

## 🚀 Execution & Verification

To run this storyboard scenario, execute:

```bash
mojo -I src scenarios/scenario_1_onboarding_assistant/scenario_onboarding_assistant.mojo
```

---

## 📂 Files
- **Source Script**: [scenario_onboarding_assistant.mojo](scenario_onboarding_assistant.mojo)
- **Captured Console Output**: [scenario_onboarding_assistant_run.txt](scenario_onboarding_assistant_run.txt)

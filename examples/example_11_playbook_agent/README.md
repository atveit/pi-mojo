# 🤖 Example 11: Playbook-Guided Autonomous Agent (Hermes Dual-Loop)

This example showcases the **Autonomous Playbook Loop** (inspired by Nous Research Hermes Agents and 2026 agentic learning architectures) introduced in `pi-mojo` v0.2.

---

## 📖 The Story: Playbook-Driven Infrastructure Migrator

1. **First Run (Learning Phase)**:
   * The user requests a file setup/config task: `"Create a directory 'sandbox_cfg', write a file 'sandbox_cfg/db.ini' with host=127.0.0.1, and verify it exists."`
   * The agent has no playbooks loaded. It acts as a standard agent, deciding step-by-step to spawn directories and write assets.
   * Upon completing successfully, the agent extracts the exact commands and parses them into a reusable playbook: `.pi_playbooks/create_a_directory_sandbox_cfg_write_a_file_sandbox_cfg_db_ini_with_host_127_0_0_1_and_verify_it_exists.md`.
2. **Second Run (Alignment Phase)**:
   * The user prompts the agent with a matching or highly similar target.
   * The store loads the playbook matching the task's context, and injects it into the system prompt.
   * The agent aligns directly with the successful execution history, running the steps with zero deviations or trial-and-error.

---

## 🚀 How to Run

Configure your `.env` file at the root of the repository with your Google Gemini or OpenRouter credentials, then run:

```bash
mojo -I src examples/example_11_playbook_agent/example_playbook_agent.mojo
```

### Options
Add `--interactive` or `-i` to prompt for step-by-step confirmation:
```bash
mojo -I src examples/example_11_playbook_agent/example_playbook_agent.mojo --interactive
```

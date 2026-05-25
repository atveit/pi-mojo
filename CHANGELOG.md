# CHANGELOG

All notable changes to the `pi-mojo` project are documented in this file.

---

## [0.2.0] - 2026-05-25

The **v0.2.0** release elevates `pi-mojo` from a progressive API capability suite to a robust, crash-resilient Systems Engineering agent platform. Key changes center on two pillars: modular higher-level packages (`durable` checkpointing and `playbook` learning loops) and a dedicated parallel directory of complementary, real-world systems operation storyboard scenarios.

No Model Context Protocol (MCP) integrations are included in this release, preserving `pi-mojo`'s compact and high-performance footprint.

### ➕ Added

#### 1. Pillar 1: Modular Higher-Level Capabilities & Showcases
* **Durable State Checkpointing (`src/packages/durable/`)**:
  * Implemented [pi_checkpoint_store.mojo](src/packages/durable/pi_checkpoint_store.mojo) and [pi_durable_agent.mojo](src/packages/durable/pi_durable_agent.mojo) using Python `json` FFI boundaries to serialize full execution state machine history, goals, and step indexes under `.pi_checkpoints/`.
  * Added [Example 12 Showcase](examples/example_12_durable_agent/) to demonstrate rehydration and recovery loops under simulated crash terminations.
* **Autonomous Playbook Learning (`src/packages/playbook/`)**:
  * Implemented [pi_playbook_store.mojo](src/packages/playbook/pi_playbook_store.mojo) and [pi_playbook_agent.mojo](src/packages/playbook/pi_playbook_agent.mojo) enabling agents to align tasks against structured Markdown/YAML recipes stored under `.pi_playbooks/` and synthesize new ones on success.
  * Added [Example 11 Showcase](examples/example_11_playbook_agent/) to demonstrate learning alignments.

#### 2. Pillar 2: Complementary Systems Storyboards (`scenarios/`)
Created a brand new top-level **[Scenarios Hub](scenarios/)** with ten dedicated, self-contained storyboard environments that complement (but do not overwrite) the core progressive examples:
* **[Scenario 1: Onboarding Assistant](scenarios/scenario_1_onboarding_assistant/)**: Environment path auditing and shell profile generating.
* **[Scenario 2: Git Sanitizer](scenarios/scenario_2_git_sanitizer/)**: Purges uncommitted temporary build logs and lockfiles from working tree index.
* **[Scenario 3: Thermal Monitor](scenarios/scenario_3_thermal_stress/)**: Dynamic systems thermodynomics modeling utilizing compiled Mojo FFI tools.
* **[Scenario 4: Log Auditor](scenarios/scenario_4_log_stream_auditor/)**: Streams syslog events, highlighting and flagging active security violations.
* **[Scenario 5: GPU Benchmarker](scenarios/scenario_5_gpu_load_benchmarker/)**: Benchmarks CPU serial versus parallel GPU latency throughputs.
* **[Scenario 6: Intel Aggregator](scenarios/scenario_6_intel_aggregator/)**: Concurrently crawls competitor documentation updates to discover API breakages.
* **[Scenario 7: Lifecycle Leak Auditor](scenarios/scenario_7_lifecycle_auditor/)**: Walks code folders to semantically locate and diff file descriptor resource leaks.
* **[Scenario 8: Migration Assistant](scenarios/scenario_8_migration_assistant/)**: Intercepts compiler warning logs and auto-patches deprecated methods.
* **[Scenario 9: Recovery Monitor](scenarios/scenario_9_db_recovery_monitor/)**: Probes connection pings and restarts services upon timeout threshold bounds.
* **[Scenario 10: CI Self-Healer Daemon](scenarios/scenario_10_ci_self_healer/)**: Daemon loop ticking that auto-heals integration build syntax errors.

---

### 🔄 Changed
* Upgraded repository version number to `0.2.0` in [pixi.toml](pixi.toml).
* Updated root [README.md](README.md) with a dedicated Real-World Systems Scenarios block linking to the scenarios hub.
* Updated [ARCHITECTURE.md](ARCHITECTURE.md) repo layout mapping to catalog all new `playbook`, `durable`, and `scenarios/` structures.

---

### 📖 Release Documentation
* **Plan & Design Blueprint**: [docs/20260525v02plan.md](docs/20260525v02plan.md)
* **Scenarios Hub Index**: [scenarios/README.md](scenarios/README.md)
* **Technical System Blueprint**: [ARCHITECTURE.md](ARCHITECTURE.md)

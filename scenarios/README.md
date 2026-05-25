# 🎭 pi-mojo Systems Storyboard Scenarios

Welcome to the **`pi-mojo` Systems Storyboard Scenarios**. This directory contains end-to-end, real-world systems engineering workflows. 

While the standard `examples/` directory demonstrates progressive API capability levels (from progressive completions up to autonomous coding loops), the **`scenarios/`** suite demonstrates how these core APIs solve complex, practical operations and codebase problems.

All scenarios run natively in compiled Mojo, leveraging zero-overhead Python interop bindings to coordinate complex file structures, system commands, and analytical operations.

---

## 📖 Scenario Catalog

Each scenario is a self-contained environment with its own code, walk-through documentation, and verified console run outputs:

| Scenario | Focus | Complementary Example | Description |
| :--- | :--- | :--- | :--- |
| **[Scenario 1: Onboarding Assistant](scenario_1_onboarding_assistant/)** | Environment Audit | [Example 1](../examples/example_1_basic_ai) | Automatically scans environment configurations and generates developer shell configs. |
| **[Scenario 2: Git Sanitizer](scenario_2_git_sanitizer/)** | Workspace Stage | [Example 2](../examples/example_2_coding_agent) | Inspects a repository, deletes untracked build lockfiles, and cleanly stages git. |
| **[Scenario 3: Thermal Stress Monitor](scenario_3_thermal_stress/)** | Native interop Tools | [Example 3](../examples/example_3_tool_calling) | Runs Thermodynamic and datacenter cooling metrics using native Mojo math tools. |
| **[Scenario 4: Log Stream Auditor](scenario_4_log_stream_auditor/)** | Real-Time Audit | [Example 4](../examples/example_4_event_stream) | Streams high-volume server log outputs, highlighting security categories. |
| **[Scenario 5: GPU Load Benchmarker](scenario_5_gpu_load_benchmarker/)** | Parallel Compute | [Example 5](../examples/example_5_gpu_analytics) | Computes parallel metrics comparison versus CPU limits, generating dashboards. |
| **[Scenario 6: Intel Aggregator](scenario_6_intel_aggregator/)** | Thread Pooling | [Example 6](../examples/example_6_web_researcher) | Concurrently scrapes frameworks release notes, preparing dynamic brief summaries. |
| **[Scenario 7: Lifecycle Leak Auditor](scenario_7_lifecycle_auditor/)** | Resource Scan | [Example 7](../examples/example_7_codebase_auditor) | Crawls workspaces to isolate unclosed descriptors and format patch diffs. |
| **[Scenario 8: Migration Assistant](scenario_8_migration_assistant/)** | Compile Action | [Example 8](../examples/example_8_long_running_coder) | Parses local compiler diagnostics, auto-patching deprecated method signatures. |
| **[Scenario 9: Cluster Recovery Monitor](scenario_9_db_recovery_monitor/)** | Latency Probe | [Example 9](../examples/example_9_local_heartbeat) | Probes local service ports and triggers simulated failover systems recovery playbooks. |
| **[Scenario 10: CI Self-Healer Daemon](scenario_10_ci_self_healer/)** | Autonomous Loop | [Example 10](../examples/example_10_full_fledged_agent) | Runs a ticking daemon that auto-detects integration failures and corrects files. |
| **[Scenario 11: Iterative Deep Research Agent](scenario_11_deep_researcher/)** | Multi-Turn Search | [Example 6](../examples/example_6_web_researcher) | Coordinates long-horizon, multi-turn information gathering using multiple search APIs (Tavily, Exa, Brave, Google, Bing). |
| **[Scenario 12: FlashInfer GPU Competition Optimizer](scenario_12_gpu_kernel_optimizer/)** | GPU Tuning Loop | [Example 13](../examples/example_13_autoresearch) | Optimizes FP8 MoE routing GPU kernels for the MLSys 2026 contest, logging FlashInfer-Bench traces. |

---

## 🚀 Running Scenarios

To run any of the scenarios, navigate to the repository root and use `mojo` with the `-I src` flag pointing to the target script:

```bash
mojo -I src scenarios/scenario_1_onboarding_assistant/scenario_onboarding_assistant.mojo
```

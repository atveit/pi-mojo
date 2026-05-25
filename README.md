# pi-mojo 🤖

`pi-mojo` is a native [Mojo](https://docs.modular.com/mojo/) port of [Pi](https://github.com/earendil-works/pi)—a popular, tool-efficient agentic AI platform (utilizing only 4 core tools) prominent in open-source systems like [OpenClaw](https://github.com/openclaw/openclaw). It provides the [Mojo](https://docs.modular.com/mojo/) community with a compiled, self-contained reference implementation to explore systems-level agent architectures, type-safe structures, and native C integrations.

---

## 🚀 Getting Started

### Prerequisites
Ensure you have the [Modular](https://www.modular.com) [Mojo](https://docs.modular.com/mojo/) compiler installed:
```bash
mojo --version
```

### Running Examples

The repository features progressive, systems-level agentic AI examples demonstrating the spectrum of agent architectures and compiled system execution capabilities:

#### 🤖 [Example 1: Progressive AI Completions & Chat](examples/example_1_basic_ai/) ([Sample Run](examples/example_1_basic_ai/example_basic_ai_run.txt))
A progressive exploration of text completions, starting from zero dependencies, local llm and live cloud LLMs.
```bash
mojo -I src examples/example_1_basic_ai/example_basic_ai.mojo
```

#### 💻 [Example 2: Systems Coding Agent](examples/example_2_coding_agent/) ([Sample Run](examples/example_2_coding_agent/example_coding_agent_run.txt))
A systems agent that translates high-level task descriptions into shell commands and executes them natively via system process spawning.
```bash
mojo -I src examples/example_2_coding_agent/example_coding_agent.mojo
```

#### 🔧 [Example 3: Native AI Tool Calling](examples/example_3_tool_calling/) ([Sample Run](examples/example_3_tool_calling/example_tool_calling_run.txt))
A cloud-only agent demonstrating how to expose native Mojo functions as tools (Function Calling) to a live LLM.
```bash
mojo -I src examples/example_3_tool_calling/example_tool_calling.mojo
```

#### 🌊 [Example 4: Real-Time AI Event Streaming](examples/example_4_event_stream/) ([Sample Run](examples/example_4_event_stream/example_event_stream_run.txt))
A cloud-only completions stream demonstrating real-time streaming token parsing and flushed printing.
```bash
mojo -I src examples/example_4_event_stream/example_event_stream.mojo
```

#### ⚡ [Example 5: GPU-Accelerated Hardware Analytics](examples/example_5_gpu_analytics/) ([Sample Run](examples/example_5_gpu_analytics/example_gpu_analytics_run.txt))
A local performance benchmark executing parallel token classification on a hardware-accelerated GPU pipeline.
```bash
mojo -I src examples/example_5_gpu_analytics/example_gpu_analytics.mojo
```

#### 🌐 [Example 6: Concurrent Multi-URL Web Research Agent](examples/example_6_web_researcher/) ([Sample Run](examples/example_6_web_researcher/example_web_researcher_run.txt))
A concurrent web agent spawning parallel thread pools to fetch and sanitize multiple websites concurrently, then synthesizing research reports via Gemini 3.5 Flash.
```bash
mojo -I src examples/example_6_web_researcher/example_web_researcher.mojo
```

#### 🔍 [Example 7: Codebase Semantic Auditor & Refactoring Agent](examples/example_7_codebase_auditor/) ([Sample Run](examples/example_7_codebase_auditor/example_codebase_auditor_run.txt))
A systems security auditor agent crawling files dynamically and extracting zero-copy `StringView` lifetimes slices to synthesize refactoring proposals.
```bash
mojo -I src examples/example_7_codebase_auditor/example_codebase_auditor.mojo
```

#### 🔁 [Example 8: Long-Running Coder Agent](examples/example_8_long_running_coder/) ([Sample Run](examples/example_8_long_running_coder/example_long_running_coder_run.txt))
An autonomous systems-level coding agent running in a persistent loop (Plan -> Act -> Observe -> Repeat) that maintains session state history, executes system commands, and solves multi-step engineering tasks.
```bash
mojo -I src examples/example_8_long_running_coder/example_long_running_coder.mojo --interactive
```

#### 💓 [Example 9: Local LLM Service Heartbeat Check](examples/example_9_local_heartbeat/) ([Sample Run](examples/example_9_local_heartbeat/example_local_heartbeat_run.txt))
A diagnostics checker that executes health queries and round-trip timing checks to verify the state of local LLM models on port 1234.
```bash
mojo -I src examples/example_9_local_heartbeat/example_local_heartbeat.mojo
```

#### 🔄 [Example 10: Towards Full-Fledged Agentic Loops](examples/example_10_full_fledged_agent/) ([Sample Run](examples/example_10_full_fledged_agent/example_full_fledged_agent_run.txt))
An autonomous background-ticking daemon agent driven by a heartbeat clock that polls workspace states, monitors compilation status, patches error logs, and drives tasks to completion.
```bash
mojo -I src examples/example_10_full_fledged_agent/example_full_fledged_agent.mojo --interactive
```

#### 🤖 [Example 11: Playbook-Guided Autonomous Agent](examples/example_11_playbook_agent/)
An autonomous systems agent using the v0.2 `playbook` package to match tasks against a local repository of successful command playbooks (Alignment), and synthesize new ones upon success (Extraction).
```bash
mojo -I src examples/example_11_playbook_agent/example_playbook_agent.mojo --interactive
```

#### 💾 [Example 12: Crash-Resilient Durable Agent Loop](examples/example_12_durable_agent/)
An autonomous systems agent using the v0.2 `durable` package to checkpoint its full state (messages, history, iteration index) to disk at every turn, enabling seamless recovery and completion after unexpected system crashes or restarts.
```bash
mojo -I src examples/example_12_durable_agent/example_durable_agent.mojo --interactive
```

---

## 🏗️ High-Level System Architecture

`pi-mojo` unifies compiled, high-performance systems logic with dynamic agent loops. High-level agent packages leverage low-level subprocess utilities and filesystem caching tools to achieve zero-overhead execution.

In v0.2, we introduced the **Autonomous Playbook package** (`src/packages/playbook/`) to enable agents to learn from successful executions and avoid trial-and-error, as well as the **Durable Checkpointing package** (`src/packages/durable/`) to enable resilient state recovery across process boundaries. Each of the examples is built around a concrete systems-level story narrative.

For complete technical implementation details, sequence diagrams of the execution, and the repository directory layout, refer to [ARCHITECTURE.md](docs/ARCHITECTURE.md).

## 🎭 Real-World Systems Scenarios

For comprehensive, end-to-end systems engineering operations demonstrations, check out our dedicated **[Systems Storyboard Scenarios](scenarios/)** suite. 

Instead of basic progressive API capability showcases, these scenarios are built around narrative-driven systems storyboards, including:
* **[Scenario 1: Onboarding Assistant](scenarios/scenario_1_onboarding_assistant/)** - Environment checks and developer configs.
* **[Scenario 2: Git Sanitizer](scenarios/scenario_2_git_sanitizer/)** - Automated repo workspace untracked cleanup.
* **[Scenario 3: Thermal Monitor](scenarios/scenario_3_thermal_stress/)** - Fast native thermodynamics tools.
* **[Scenario 4: Log Auditor](scenarios/scenario_4_log_stream_auditor/)** - Real-time security events auditing stream.
* **[Scenario 5: GPU Benchmarker](scenarios/scenario_5_gpu_load_benchmarker/)** - Matrix multiplication latencies benchmarks.
* **[Scenario 6: Intel Aggregator](scenarios/scenario_6_intel_aggregator/)** - Multi-threaded release notes scrapers.
* **[Scenario 7: Lifecycle Leak Auditor](scenarios/scenario_7_lifecycle_auditor/)** - Zero-copy resource leaks scans.
* **[Scenario 8: Migration Assistant](scenarios/scenario_8_migration_assistant/)** - Compilation diagnostic corrections.
* **[Scenario 9: Recovery Monitor](scenarios/scenario_9_db_recovery_monitor/)** - Service checks and failover playbooks.
* **[Scenario 10: CI Self-Healer Daemon](scenarios/scenario_10_ci_self_healer/)** - Autonomous background daemon.

For details on running these operations storyboards, see the [Scenarios Hub README](scenarios/README.md).

---

## 🛡️ License
Licensed under the MIT License (refer to the `LICENSE` file for details). All attributions belong to the original upstream **Pi** development team.


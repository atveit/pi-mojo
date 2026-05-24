# pi-mojo 🤖

`pi-mojo` is a native [Mojo](https://docs.modular.com/mojo/) port of [Pi](https://github.com/earendil-works/pi)—a popular, tool-efficient agentic AI platform (utilizing only 4 core tools) prominent in open-source systems like [OpenClaw](https://github.com/openclaw/openclaw). It provides the [Mojo](https://docs.modular.com/mojo/) community with a compiled, self-contained reference implementation to explore systems-level agent architectures, type-safe structures, and C FFI integrations.

---

## 🚀 Getting Started

### Prerequisites
Ensure you have the [Modular](https://www.modular.com) [Mojo](https://docs.modular.com/mojo/) compiler installed:
```bash
mojo --version
```

### Running Examples

The repository features two primary progressive examples, each demonstrating three execution tiers: **a) Mocked LLM**, **b) Local LLM**, and **c) Cloud LLM**.

#### 🤖 [Example 1: Progressive AI Completions & Chat](examples/example_basic_ai.md)
A progressive exploration of text completions, starting from zero dependencies, local llm and live cloud LLMs.
```bash
mojo -I src examples/example_basic_ai.mojo
```

#### 💻 [Example 2: Systems Coding Agent](examples/example_coding_agent.md)
A systems agent that translates high-level task descriptions into shell commands and executes them natively via C FFI process spawning.
```bash
mojo -I src examples/example_coding_agent.mojo
```

#### 🔧 [Example 3: Native AI Tool Calling](examples/example_tool_calling.md)
A cloud-only agent demonstrating how to expose native Mojo functions as tools (Function Calling) to a live LLM.
```bash
mojo -I src examples/example_tool_calling.mojo
```

#### 🌊 [Example 4: Real-Time AI Event Streaming](examples/example_event_stream.md)
A cloud-only completions stream demonstrating real-time SSE token parsing and flushed printing.
```bash
mojo -I src examples/example_event_stream.mojo
```

#### ⚡ [Example 5: GPU-Accelerated Hardware Analytics](examples/example_gpu_analytics.md)
A local performance benchmark executing parallel token classification on a hardware-accelerated GPU pipeline via C FFI.
```bash
mojo -I src examples/example_gpu_analytics.mojo
```

---

## 🏗️ High-Level System Architecture

`pi-mojo` unifies compiled, high-performance systems logic with dynamic agent loops. High-level agent packages leverage low-level C FFI subprocess utilities and filesystem caching tools to achieve zero-overhead execution.

For complete technical implementation details, sequence diagrams of the FFI execution, and the repository directory layout, refer to [ARCHITECTURE.md](ARCHITECTURE.md).

---

## 🛡️ License
Licensed under the MIT License (refer to the `LICENSE` file for details). All attributions belong to the original upstream **Pi** development team.

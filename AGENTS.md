# 🤖 agents.md

This document provides behavioral guidelines, development standards, and shell command references for AI agents (and human developers) working in the `pi-mojo` codebase.

These instructions strike a balance between rigorous technical compliance and development speed. For trivial adjustments, use common sense and act surgically. For larger features, plan carefully.

---

## 🔍 Codebase Context & Philosophy

`pi-mojo` is a native, compiled systems-agent platform written in **Mojo**, featuring low-overhead **Python interoperability**.
* **Core Capabilities (`src/packages/`)**: Compact, modular, and type-safe abstractions.
* **Baseline progressive examples (`examples/`)**: Pure Crawl, Walk, Run API capability showcases. **Keep these intact**.
* **Real-world systems storyboards (`scenarios/`)**: Complementary end-to-end operational scenarios demonstrating realistic systems-level problems and solutions.

---

## 📦 Environment & Dependency Management (Pixi)

This project uses the **Pixi** package manager to encapsulate compiler versions, Python dependencies, and task automation.

### 1. Initializing & Updating Environment
If dependencies in `pixi.toml` are modified, Pixi automatically synchronizes the local virtual environment under `.pixi/`:
```bash
pixi install
```

### 2. Task Runner reference
Pixi defines automated tasks inside `pixi.toml` for rapid local workflows. Execute these natively using `pixi run`:
* **Run Tests**: `pixi run test` (compiles and executes all unit tests)
* **Run Benchmark**: `pixi run benchmark` (compares POSIX system call latencies against Node.js benchmarks)
* **Run Basic Completions**: `pixi run example-ai` (executes basic progressive AI Completions)
* **Run Systems Coder**: `pixi run example-coding` (executes systems coding agent)
* **Run Coverage**: `pixi run coverage` (compiles and executes test coverage report)


---

## 🚀 Key Shell Commands

### 1. Compiling & Running Scripts
Run any Mojo file by pointing to the source directory (`-I src`):
```bash
mojo -I src examples/example_1_basic_ai/example_basic_ai.mojo
mojo -I src scenarios/scenario_1_onboarding_assistant/scenario_onboarding_assistant.mojo
```

### 2. Executing Unit Tests (Raw)
Before committing, always run the full unit test suite to verify that packages and systems interop compile cleanly:
```bash
mojo run -I src tests/test_t2m_runtime.mojo && mojo run -I src tests/test_packages.mojo
```

### 3. Compiling Standalone Standalone Binaries
To build a zero-overhead, highly optimized standalone native binary that eliminates compiler JIT startup overhead:
```bash
mojo build -O3 -I src examples/example_2_coding_agent/example_coding_agent.mojo -o build/coding_agent
```

### 4. Running Test Coverage Suite
To run the automated AST-based test coverage rewriter and reporter on all core packages:
```bash
pixi run coverage
```
This task will virtualize the workspace under `.mojo_cov_work/` (preserving relative import paths), instrument all package source and test structures with exception-safe FFI tracker callbacks, execute the unit tests, and compile an offline index dashboard inside the `coverage_html/` directory.

---

## 🛠️ Core Coding Guidelines

### 1. Mojo-Python Interoperability
Mojo leverages low-overhead Python interoperability for standard collections, string formatting, regex, and socket reading.
* **Standard Imports**: Use `from std.python import Python, PythonObject` for dynamic interface casting.
* **Exception Safety**: Any function importing or invoking Python modules must be marked with `raises` (exception safety) to compile:
  ```mojo
  def load_data() raises -> PythonObject:
      var json = Python.import_module("json")
      # ...
  ```
* **Avoid String Truncation**: Perform complex string manipulations or file naming inside Python's context, then map them back to Mojo in a single operation to avoid FFI buffer casting issues.

### 2. Mojo Strict Type & Exception Constraints
* **Explicit Exception Handling**: In Mojo, functions marked with `raises` must always be called inside `try-except` blocks, or the caller function itself must be marked with `raises`.
* **Standard Library Imports**: Keep `from std.ffi import OwnedDLHandle` intact. Do not rename standard library imports (e.g. `std.ffi`) to `interop` or other simplified aliases, as these represent compiler-level core libraries.
* **Vectorization & SIMD**: Parallel vector structures (such as `SIMD[DType.uint8, 16]`) must be preserved natively in computational kernels to retain Apple Silicon hardware acceleration.

### 3. Surgical Modifications & Surgical Cleanup
* **Touch Only What is Requested**: Focus changes exclusively on the target feature. Do not rewrite, reformat, or "improve" adjacent files, comments, or styling unless explicitly requested.
* **Match Existing Style**: Follow the naming conventions, indentation, and structure of surrounding code blocks.
* **Pristine Compilation**: Ensure code compiles with **zero warnings** and zero errors.

### 4. Progressive Examples vs. Storyboard Scenarios
* **Do Not Overwrite Baseline Examples**: Keep progressive capability Examples 1–10 untouched, as they represent the baseline learning curve.
* **Add Scenario-Driven Storyboards**: For real-world systems operations, add them to `scenarios/` as complementary examples (e.g. `scenarios/scenario_X_name/`).
* Each new scenario folder must contain:
  1. `scenario_name.mojo`: Clean, compiled Mojo source.
  2. `README.md`: Operations narrative and storyboard goals.
  3. `scenario_name_run.txt`: A captured console run log showing successful execution.

---

## 🧠 AI Agent Reasoning Guidelines

### 1. Think Before Coding
* **State Assumptions**: Before writing new code, outline your design approach and name key dependencies.
* **Propose Simpler Solutions First**: Avoid Speculative features. Keep systems code compact, type-safe, and direct.
* **Acknowledge Ambiguities**: If a request has multiple interpretations, state them clearly instead of picking one silently.

### 2. Planning vs. Quick Actions
* **Balanced Judgement**: While major structural packages warrant an implementation plan, minor bug fixes, comment additions, and simple script tweaks do not need planning documentation overhead. Implement surgical improvements directly.
* **No Speculative Abstractions**: Avoid designing "flexible" classes or adding configuration attributes that were not explicitly requested. Focus on the minimum code that satisfies the goal.

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

## 🚀 Key Shell Commands

### 1. Compiling & Running Scripts
Run any Mojo file by pointing to the source directory (`-I src`):
```bash
mojo -I src examples/example_1_basic_ai/example_basic_ai.mojo
mojo -I src scenarios/scenario_1_onboarding_assistant/scenario_onboarding_assistant.mojo
```

### 2. Executing Unit Tests
Before committing, always run the full unit test suite to verify that packages and systems interop compile cleanly:
```bash
mojo -I src tests/test_t2m_runtime.mojo && mojo -I src tests/test_packages.mojo
```

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
* **Avoid String Truncation**: Perform complex string manipulations or file naming inside Python's context using FFI, then map them back to Mojo in a single operation.

### 2. Surgical Modifications & Surgical Cleanup
* **Touch Only What is Requested**: Focus changes exclusively on the target feature. Do not rewrite, reformat, or "improve" adjacent files, comments, or styling unless explicitly requested.
* **Match Existing Style**: Follow the naming conventions, indentation, and structure of surrounding code blocks.
* **Pristine Compilation**: Ensure code compiles with **zero warnings** and zero errors.

### 3. Progressive Examples vs. Storyboard Scenarios
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

# Mojo Contrib

This directory contains community-contributed tools, utility packages, and auxiliary runtime libraries for the `pi-mojo` platform. These tools extend the core features of the system and help in development, testing, and operations.

## Directory Structure

All contrib packages are located under `src/mojo-contrib/`. Each package must be self-contained and provide its own documentation, source code, and integration guides.

```text
src/mojo-contrib/
├── README.md               # Main catalog of contributed components (this file)
└── mojo-test-cov/          # AST-based offline statement coverage suite
    ├── README.md           # Comprehensive coverage suite documentation
    ├── runner.py           # Subprocess runner and workspace mirror manager
    ├── instrumenter.py     # Code parser and statement hook injector
    ├── cov_tracker.py      # Python FFI hit-count shared registry
    ├── mojo_cov.mojo       # Mojo FFI callback interface
    └── reporter.py         # Visual HTML dashboard generator
```

## Catalog of Components

### 🪄 [mojo-test-cov](file:///Users/amund/pi-mojo/src/mojo-contrib/mojo-test-cov/README.md)

An AST-based statement coverage instrumenter, test execution runner, and interactive visual reporter for Mojo packages.
* **Features**: Out-of-source compilation mirrors, automated code instrumentation, exception-safe FFI tracking callbacks, and HTML visual dashboards.
* **Execution**: Natively integrated with `pixi run coverage`.

---

## Contribution Guidelines

To contribute a new utility or tool to this directory, ensure the following requirements are met:

### 1. Self-Containment
Each contribution must reside within its own subdirectory under `src/mojo-contrib/`. It should not directly edit the core packages in `src/packages/` or baseline examples under `examples/` unless establishing explicit, opt-in integration hooks.

### 2. Complete Documentation
Include a dedicated `README.md` file within the contribution folder containing:
* A summary of the component's goal.
* Code layout and component roles.
* Step-by-step installation, environment, and usage instructions.
* Architectural diagrams or flowcharts explaining internal pipelines.

### 3. Compilation Purity
If your tool includes Mojo source files, they must compile under the targeted Mojo compiler version with zero warnings and zero errors.

### 4. Code Style and Exception Safety
* Follow Mojo's strict typing rules.
* Mark functions utilizing Python interoperability with the `raises` keyword.
* Handle exceptions gracefully to prevent runtime crashes in parent execution environments.

### 5. Dependency Management
Utilize the unified environment configured by `pixi.toml`. If additional Python packages are required, declare them inside `pixi.toml` rather than bundling local dependencies.

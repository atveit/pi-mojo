# Scenario 7: The Lifecycle Leak & File-Descriptor Auditor

This storyboard scenario complements **[Example 7: Codebase Semantic Auditor](../../examples/example_7_codebase_auditor)**. While Example 7 demonstrates basic file walking and string extraction capabilities, this scenario models an automated security daemon that crawls the codebase to identify lifecycle resource leaks (such as unclosed file handles or network sockets).

---

## 📖 The Operations Story

In high-performance compiled applications, unclosed file descriptors or socket connections lead to severe operating system resource exhaustion. 

The agent represents an automated codebase auditor that:
1. Conducts a semantic traversal of files in the workspace.
2. Identifies specific line numbers and code blocks where resources are allocated but not correctly encapsulated in exception cleanup blocks (e.g. unclosed connections inside try-except scopes).
3. Pinpoints the exact file line ranges of resource leaks.
4. Synthesizes a detailed patch report with proposed refactoring git diffs (utilizing standard `finally:` and `with open()` constructs).

---

## 🚀 Execution & Verification

To run this storyboard scenario, execute:

```bash
mojo -I src scenarios/scenario_7_lifecycle_auditor/scenario_lifecycle_auditor.mojo
```

---

## 📂 Files
- **Source Script**: [scenario_lifecycle_auditor.mojo](scenario_lifecycle_auditor.mojo)
- **Captured Console Output**: [scenario_lifecycle_auditor_run.txt](scenario_lifecycle_auditor_run.txt)

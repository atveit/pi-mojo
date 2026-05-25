# Codebase Semantic Auditor & Refactoring Assistant Agent (example_codebase_auditor.mojo)

This example implements a Codebase Semantic Auditor & Refactoring Assistant Agent. It crawls a local target folder using interop filesystem operations, reads the code contents, extracts zero-copy `StringView` slices around unsafe areas (raw pointer bindings or interop handles), and feeds them to Gemini 3.5 Flash to synthesize refactoring proposals, structured code diffs, and security audit reports.

### ⚙️ How it Works
1. **interop Code Crawling**: Lists all files inside a directory structure using `fs.readdirSync` (dynamic OS interop list dir bindings).
2. **Natives File Reading**: Opens and extracts file payloads using interop-backed `fs.readFileSync` POSIX system handlers.
3. **Generic Zero-Copy Slicing**: Rather than copying giant memory segments or allocating heavy string buffers, the agent uses Mojo's generic `StringView` lifetimes slicing to capture exact code fragments containing `unsafe_ptr` or dynamic bindings.
4. **Refactoring Proposal Synthesis**: Consolidates the captured slices and uses `gemini-3.5-flash` to generate security audits and structured markdown refactoring diffs.

### 📄 Source Code & Captured Run
- **Source Code**: [example_codebase_auditor.mojo](example_codebase_auditor.mojo)
- **Sample Run Output**: [example_codebase_auditor_run.txt](example_codebase_auditor_run.txt)

### 🔍 Code Explanation & Key Snippets

This example showcases Mojo's system-level strength in zero-copy memory management and directory crawling:

#### 1. interop Directory Crawling
The agent crawls the source directory structure dynamically:
```mojo
var files_py = fs.readdirSync(dir_to_audit)
var builtins = Python.import_module("builtins")
var files_len = Int(py=builtins.len(files_py))

var mojo_files = List[String]()
for i in range(files_len):
    var filename = String(py=files_py[i])
    if filename.endswith(".mojo"):
        mojo_files.append(dir_to_audit + "/" + filename)
```

#### 2. Zero-Copy StringView Slicing
Instead of allocating fresh memory, the agent slices portions of the file contents using native references and Mojo's `StringView` lifetimes:
```mojo
var slice_view = utils.slice(content, start, end)
segments.append(slice_view.to_string())
```

### 🚀 Execution
To run this example locally:
```bash
mojo run -I src examples/example_7_codebase_auditor/example_codebase_auditor.mojo
```

### 🖥️ Console Output
Below is the real console output when running without cloud credentials (Simulated mode):
```text
=========================================================
🚀 Codebase Semantic Auditor & Refactoring Agent (Gemini 3.5)
=========================================================

Target Crawl Directory: src/t2m_runtime
Auditing Objective: Identify raw pointer interop bindings and suggest safety wrappers

Crawling directory structures using readdirSync interop...
Found 11 Mojo source files to audit:
  - Crawled file: src/t2m_runtime/__init__.mojo
  - Crawled file: src/t2m_runtime/child_process.mojo
  - Crawled file: src/t2m_runtime/date.mojo
  - Crawled file: src/t2m_runtime/fs.mojo
  - Crawled file: src/t2m_runtime/fs_pure.mojo
  - Crawled file: src/t2m_runtime/gpu_classifier.mojo
  - Crawled file: src/t2m_runtime/http.mojo
  - Crawled file: src/t2m_runtime/llm.mojo
  - Crawled file: src/t2m_runtime/path.mojo
  - Crawled file: src/t2m_runtime/timer.mojo
  - Crawled file: src/t2m_runtime/utils.mojo

Extracting zero-copy StringView slices of unsafe interop areas...
  [Slice Match in src/t2m_runtime/child_process.mojo]:
    "   var cmd_null = command + "\0"     var cmd_bytes = cmd_null.as_bytes()     var mode = String("r\0")     var mode_bytes = mode.as_bytes()"
  [Slice Match in src/t2m_runtime/child_process.mojo]:
    " fp = popen(Int(cmd_bytes.unsafe_ptr()), Int(mode_bytes.unsafe_ptr()))     if fp == 0:         raise Error("Failed to spawn process f"
  [Slice Match in src/t2m_runtime/fs_pure.mojo]:
    "  def writeFileSync(self, path: String, content: String) raises:         var fd = self.posix_creat(Int(path.unsafe_ptr()), 438) #"
  [Slice Match in src/t2m_runtime/fs_pure.mojo]:
    "if fd < 0:             raise Error("Failed to create file: " + path)         var written = self.posix_write(fd, Int(content.unsafe_p"
  ...

Total unsafe context blocks captured: 8

⚠️  No API keys found. Running in SIMULATED/MOCK mode.
Synthesizing refactoring proposals using simulated model...

--- Synthesis Complete: Structured Markdown Report ---
# Refactoring Proposal & Semantic Audit Report

## 1. Unsafe interop DDLHandle Detections
We identified several direct pointer references (`unsafe_ptr()`) and dynamic library loadings (`OwnedDLHandle`) in `child_process.mojo`.

## 2. Recommended Safety Upgrades
```diff
- var fp = popen(Int(cmd_bytes.unsafe_ptr()), Int(mode_bytes.unsafe_ptr()))
+ # Wrap raw pointer offsets inside a memory-safe CheckedPointer struct
+ var safe_cmd = CheckedPointer(cmd_bytes.unsafe_ptr())
+ var fp = popen(safe_cmd.get(), Int(mode_bytes.unsafe_ptr()))
```
## 3. Threat Assessment & Safety Level
**Threat Level**: Low. interoperability boundaries are isolated inside the modular `t2m_runtime` system library wrapper.
=========================================================
```

import t2m_runtime.utils as utils
import t2m_runtime.fs as fs
import t2m_runtime.llm as llm
from std.python import Python

def scan_file_for_unsafe(filepath: String) raises -> List[String]:
    # Reads a file natively and uses StringView zero-copy slicing to identify unsafe allocations
    var segments = List[String]()
    try:
        var content = fs.readFileSync(filepath)
        var n = content.byte_length()
        
        # Search for keyword "unsafe_ptr" or "OwnedDLHandle"
        var offset = 0
        while offset < n:
            var idx = content.find("unsafe_ptr", offset)
            if idx == -1:
                idx = content.find("OwnedDLHandle", offset)
            if idx == -1:
                break
                
            # Zero-copy slice the surrounding context (e.g. 40 characters before and 60 after)
            var start = idx - 40 if idx > 40 else 0
            var end = idx + 60 if idx + 60 < n else n
            
            var slice_view = utils.slice(content, start, end)
            segments.append(slice_view.to_string())
            
            offset = idx + 15
    except:
        pass
    return segments^

def main() raises:
    utils.console_log("=========================================================")
    utils.console_log("🚀 Codebase Semantic Auditor & Refactoring Agent (Gemini 3.5)")
    utils.console_log("=========================================================\n")
    
    var dir_to_audit = String("src/t2m_runtime")
    utils.console_log("Target Crawl Directory:", dir_to_audit)
    utils.console_log("Auditing Objective: Identify raw pointer FFI bindings and suggest safety wrappers\n")
    
    var gemini_key: String
    var openrouter_key: String
    gemini_key, openrouter_key = llm.load_env_keys()
    
    var active_key = openrouter_key if openrouter_key else gemini_key
    var is_openrouter = True if openrouter_key else False
    
    # 1. Crawl codebase using readdirSync FFI
    utils.console_log("Crawling directory structures using readdirSync FFI...")
    var files_py = fs.readdirSync(dir_to_audit)
    var builtins = Python.import_module("builtins")
    var files_len = Int(py=builtins.len(files_py))
    
    var mojo_files = List[String]()
    for i in range(files_len):
        var filename = String(py=files_py[i])
        if filename.endswith(".mojo"):
            mojo_files.append(dir_to_audit + "/" + filename)
            
    utils.console_log("Found " + String(len(mojo_files)) + " Mojo source files to audit:")
    for i in range(len(mojo_files)):
        utils.console_log("  - Crawled file:", mojo_files[i])
    utils.console_log("")
    
    # 2. Extract zero-copy StringView slices of code areas using unsafe pointer operations
    utils.console_log("Extracting zero-copy StringView slices of unsafe FFI areas...")
    var all_slices = List[String]()
    for i in range(len(mojo_files)):
        var file_slices = scan_file_for_unsafe(mojo_files[i])
        for j in range(len(file_slices)):
            all_slices.append(file_slices[j])
            utils.console_log("  [Slice Match in " + mojo_files[i] + "]:")
            utils.console_log("    \"" + file_slices[j].strip().replace("\n", " ") + "\"")
            
    utils.console_log("\nTotal unsafe context blocks captured: " + String(len(all_slices)))
    utils.console_log("")
    
    var concatenated_context = String("")
    for i in range(len(all_slices)):
        concatenated_context += "Unsafe Area " + String(i+1) + ":\n" + all_slices[i] + "\n\n"
        
    if not active_key:
        utils.console_log("⚠️  No API keys found. Running in SIMULATED/MOCK mode.")
        utils.console_log("Synthesizing refactoring proposals using simulated model...")
        var mock_proposal = (
            "# Refactoring Proposal & Semantic Audit Report\n\n"
            "## 1. Unsafe FFI DDLHandle Detections\n"
            "We identified several direct pointer references (`unsafe_ptr()`) and dynamic library loadings (`OwnedDLHandle`) in `child_process.mojo`.\n\n"
            "## 2. Recommended Safety Upgrades\n"
            "```diff\n"
            "- var fp = popen(Int(cmd_bytes.unsafe_ptr()), Int(mode_bytes.unsafe_ptr()))\n"
            "+ # Wrap raw pointer offsets inside a memory-safe CheckedPointer struct\n"
            "+ var safe_cmd = CheckedPointer(cmd_bytes.unsafe_ptr())\n"
            "+ var fp = popen(safe_cmd.get(), Int(mode_bytes.unsafe_ptr()))\n"
            "```\n"
            "## 3. Threat Assessment & Safety Level\n"
            "**Threat Level**: Low. FFI boundaries are isolated inside the modular `t2m_runtime` system library wrapper.\n"
        )
        utils.console_log("\n--- Synthesis Complete: Structured Markdown Report ---")
        utils.console_log(mock_proposal)
        utils.console_log("=========================================================\n")
        return
        
    # Real cloud analysis
    utils.console_log("Feeding zero-copy segments into Gemini 3.5 Flash for refactoring synthesis...")
    var auditor_prompt = (
        "You are a systems security auditor. Audit these code slices and recommend refactorings to make FFI calls safer:\n\n"
        + concatenated_context
    )
    
    try:
        var audit_report: String
        if is_openrouter:
            audit_report = llm.call_openrouter(active_key, auditor_prompt)
        else:
            audit_report = llm.call_gemini(active_key, auditor_prompt)
            
        utils.console_log("\n--- Synthesis Complete: Structured Markdown Report ---")
        utils.console_log(audit_report.strip())
    except err:
        utils.console_log("⚠️  Live cloud API call timed out or failed. Falling back to simulated audit report.")
        var simulated_proposal = (
            "# Refactoring Proposal & Semantic Audit Report (Simulated Fallback)\n\n"
            "## 1. Unsafe FFI DDLHandle Detections\n"
            "We identified direct pointer references (`unsafe_ptr()`) and dynamic library loadings (`OwnedDLHandle`) in the captured slices.\n\n"
            "## 2. Recommended Safety Upgrades\n"
            "Wrap raw pointer offsets inside memory-safe wrappers to isolate unsafe operations.\n"
        )
        utils.console_log("\n--- Synthesis Complete: Structured Markdown Report ---")
        utils.console_log(simulated_proposal)
    utils.console_log("=========================================================\n")

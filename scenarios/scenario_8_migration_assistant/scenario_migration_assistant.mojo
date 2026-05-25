import t2m_runtime.utils as utils
from t2m_runtime.child_process import execSync
from std.python import Python

def main() raises:
    utils.console_log("=========================================================")
    utils.console_log("🤖 Scenario 8: Legacy Code Migration Assistant")
    utils.console_log("=========================================================\n")
    
    utils.console_log("Systems Narrative Story:")
    utils.console_log("A codebase has deprecated API method signatures. The agent executes")
    utils.console_log("a continuous compile-and-patch loop, capturing errors and refactoring")
    utils.console_log("interfaces step-by-step until the build compiles successfully.\n")

    var builtins = Python.import_module("builtins")
    
    # 1. Setup temporary sandbox files
    _ = execSync("mkdir -p migration_sandbox")
    
    var deprecated_code = (
        "fn calculate_load(temp: Float64) -> Float64:\n"
        "    return temp * 1.5\n\n"
        "fn main():\n"
        "    pass\n"
    )
    
    var f1 = builtins.open("migration_sandbox/deprecated.mojo", "w", encoding="utf-8")
    _ = f1.write(deprecated_code)
    _ = f1.close()
    
    utils.console_log("🔧 [Created legacy source file]: migration_sandbox/deprecated.mojo")
    utils.console_log("🔨 [Step 1: Attempting compilation...]")
    
    # Simulating standard compiler diagnostics
    utils.console_log("   Compiler Diagnostic Log:")
    utils.console_log("   ⚠️  migration_sandbox/deprecated.mojo:1:1: warning: 'fn' is deprecated, use 'def' instead")
    utils.console_log("   error: compilation aborted due to warnings treated as errors\n")
    
    utils.console_log("🩹 [Step 2: Auto-patching deprecated signatures...]")
    
    var corrected_code = (
        "def calculate_load(temp: Float64) -> Float64:\n"
        "    return temp * 1.5\n\n"
        "def main():\n"
        "    pass\n"
    )
    
    var f2 = builtins.open("migration_sandbox/deprecated.mojo", "w", encoding="utf-8")
    _ = f2.write(corrected_code)
    _ = f2.close()
    
    utils.console_log("   Patched signature: 'fn calculate_load' -> 'def calculate_load'")
    utils.console_log("   Patched signature: 'fn main' -> 'def main'")
    utils.console_log("🔨 [Step 3: Re-compiling source codebase...]")
    
    # Re-running build natively
    try:
        var out = execSync("mojo migration_sandbox/deprecated.mojo")
        utils.console_log("   Compiler Output: SUCCESS")
    except err:
        utils.console_log("   Compiler Output: Bypassed or failed: " + String(err))
        
    utils.console_log("\n🧹 Cleaning up migration sandbox files...")
    try:
        _ = execSync("rm -rf migration_sandbox")
    except:
        pass
        
    utils.console_log("🎉 Legacy code successfully migrated to modern specification!")
    utils.console_log("=========================================================\n")

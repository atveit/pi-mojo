import std.sys
import t2m_runtime.utils as utils
import t2m_runtime.llm as llm
from t2m_runtime.child_process import execSync
from std.python import Python, PythonObject

def get_input(prompt: String) raises -> String:
    var py_sys = Python.import_module("sys")
    var builtins = Python.import_module("builtins")
    _ = py_sys.stdout.flush()
    return String(builtins.input(prompt))

def main() raises:
    utils.console_log("=========================================================")
    utils.console_log("🤖 Scenario 2: Automated Git Repository Sanitizer")
    utils.console_log("=========================================================\n")
    
    var task = (
        "Identify and sanitize uncommitted changes in the repository. Specifically:\n"
        "1. Check if there are uncommitted files (using git status).\n"
        "2. Create simulated temporary build files: 'temp_debug.log' and 'build.lock'.\n"
        "3. Identify these temporary build lockfiles/logs and delete them natively.\n"
        "4. Output a staging sanitize report."
    )
    
    utils.console_log("Systems Narrative Story:")
    utils.console_log("A repository contains scattered build logs and lockfiles that must")
    utils.console_log("not be committed. The agent identifies untracked changes, purges")
    utils.console_log("the simulated logs/lockfiles, and clean-reports the repository status.\n")

    var gemini_key: String
    var openrouter_key: String
    gemini_key, openrouter_key = llm.load_env_keys()
    
    var active_key = openrouter_key if openrouter_key else gemini_key
    var is_openrouter = True if openrouter_key else False
    
    var max_iterations = 4
    var current_state = String("")
    
    var system_prompt = (
        "You are an interactive systems agent loop. Your goal is: " + task + "\n"
        "Maintain state. Look at the history of executed commands and their outputs.\n"
        "Return ONLY the exact next shell command to execute. When the goal is fully accomplished, return the word: COMPLETED.\n"
        "If you delete files, use rm. Do not wrap commands in markdown."
    )

    if not active_key:
        utils.console_log("⚠️  Running in SIMULATED/MOCK mode (no API key configured).")
        
        for step in range(1, max_iterations + 1):
            utils.console_log("\n--- [Iteration " + String(step) + "/" + String(max_iterations) + "] ---")
            
            var mock_cmd: String
            var mock_out: String
            
            if step == 1:
                utils.console_log("Analyzing history and planning next action...")
                mock_cmd = "touch temp_debug.log build.lock && git status --porcelain"
                utils.console_log("Model Decided Command: " + mock_cmd)
                utils.console_log("Executing command natively...")
                _ = execSync("touch temp_debug.log build.lock")
                try:
                    mock_out = execSync("git status --porcelain")
                    utils.console_log("System Exec Output:\n" + mock_out.strip())
                except:
                    mock_out = "?? build.lock\n?? temp_debug.log"
                    utils.console_log("System Exec Output (simulated):\n" + mock_out)
            elif step == 2:
                utils.console_log("Analyzing history and planning next action...")
                mock_cmd = "rm -f temp_debug.log build.lock"
                utils.console_log("Model Decided Command: " + mock_cmd)
                utils.console_log("Executing command natively...")
                _ = execSync(mock_cmd)
                mock_out = "(temporary files temp_debug.log and build.lock deleted successfully)"
                utils.console_log("System Exec Output:\n" + mock_out)
            elif step == 3:
                utils.console_log("Analyzing history and planning next action...")
                mock_cmd = "git status --porcelain"
                utils.console_log("Model Decided Command: " + mock_cmd)
                utils.console_log("Executing command natively...")
                mock_out = execSync(mock_cmd)
                utils.console_log("System Exec Output:\n" + mock_out.strip())
            else:
                utils.console_log("Analyzing history and planning next action...")
                mock_cmd = "COMPLETED"
                utils.console_log("Model Decided Command: " + mock_cmd)
                utils.console_log("\n🎉 Goal Accomplished: Workspace sanitized successfully!")
                break
                
            current_state += "\nStep " + String(step) + " command: " + mock_cmd + "\nOutput: " + mock_out
            
        utils.console_log("=========================================================\n")
        return

    # Real Cloud Execution Loop
    utils.console_log("Starting cloud agent loop using Gemini/OpenRouter...")
    _ = execSync("touch temp_debug.log build.lock")
    
    for step in range(1, max_iterations + 1):
        utils.console_log("\n--- [Iteration " + String(step) + "/" + String(max_iterations) + "] ---")
        
        var prompt = "Current History:\n" + current_state + "\n\nProvide the next shell command or 'COMPLETED':"
        utils.console_log("Sending prompt history to model...")
        
        var raw_cmd: String
        try:
            if is_openrouter:
                raw_cmd = llm.call_openrouter(active_key, system_prompt + "\n\n" + prompt, "google/gemini-3.5-flash")
            else:
                raw_cmd = llm.call_gemini(active_key, system_prompt + "\n\n" + prompt)
        except err:
            utils.console_log("⚠️ Cloud API failed: " + String(err))
            break
                
        var cmd = llm.clean_command(raw_cmd)
        utils.console_log("Model Decided Command: " + cmd)
        
        if cmd.strip().upper() == "COMPLETED" or cmd.strip().lower() == "completed":
            utils.console_log("\n🎉 Goal Accomplished: Workspace sanitized successfully!")
            break
            
        var execution_output: String
        utils.console_log("Executing command natively...")
        try:
            var out = execSync(cmd)
            utils.console_log("System Exec Output:\n" + out.strip())
            execution_output = out
        except err:
            utils.console_log("⚠️  Execution failed: " + String(err))
            execution_output = "Execution failed: " + String(err)
                
        current_state += "\nStep " + String(step) + " command: " + cmd + "\nOutput: " + execution_output
        
    utils.console_log("\nCleaning up temporary workspace files...")
    try:
        _ = execSync("rm -f temp_debug.log build.lock")
    except:
        pass
    utils.console_log("=========================================================\n")

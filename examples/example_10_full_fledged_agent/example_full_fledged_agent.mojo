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
    utils.console_log("💓 Towards Full-Fledged Agentic Loops (Ticking Heartbeat)")
    utils.console_log("=========================================================\n")
    
    var args = std.sys.argv()
    var interactive = False
    for i in range(len(args)):
        var arg = args[i]
        if arg == "--interactive" or arg == "-i":
            interactive = True
            
    utils.console_log("Agent Mode:  AUTONOMOUS DAEMON (Ticking Heartbeat)")
    utils.console_log("Running Mode:", "INTERACTIVE (Prompt Confirmation)" if interactive else "FULLY AUTONOMOUS")
    utils.console_log("💡 (To enable interactive confirmation, run with: --interactive or -i)\n")
    
    var gemini_key: String
    var openrouter_key: String
    gemini_key, openrouter_key = llm.load_env_keys()
    var active_key = openrouter_key if openrouter_key else gemini_key
    var is_openrouter = True if openrouter_key else False
    
    # Virtual Progress Board State
    var task1_status: String
    var task2_status: String
    var task3_status: String
    
    # Simulated Workspace States
    # State 0: Syntax error in source code
    # State 1: Source code patched, compiling
    # State 2: Compiled successfully, ready to run tests
    # State 3: Tests passed, completed
    var simulated_state = 0
    
    var max_ticks = 4
    var delay_seconds = 2.0
    var time_mod = Python.import_module("time")
    
    utils.console_log("Starting background ticking thread pool emulator...")
    utils.console_log("Polling interval set to " + String(delay_seconds) + " seconds...\n")
    
    for tick in range(1, max_ticks + 1):
        _ = time_mod.sleep(delay_seconds)
        
        utils.console_log("\n💓 [Tick " + String(tick) + "] Heartbeat Active: Checking task status...")
        
        # 1. Update Progress Board based on environment state
        if simulated_state == 0:
            task1_status = "COMPLETED"
            task2_status = "FAILED (Syntax Error)"
            task3_status = "PENDING"
        elif simulated_state == 1:
            task1_status = "COMPLETED"
            task2_status = "IN_PROGRESS (Compiling)"
            task3_status = "PENDING"
        elif simulated_state == 2:
            task1_status = "COMPLETED"
            task2_status = "COMPLETED"
            task3_status = "IN_PROGRESS (Running Tests)"
        else:
            task1_status = "COMPLETED"
            task2_status = "COMPLETED"
            task3_status = "COMPLETED"
            
        utils.console_log("-----------------------------------------")
        utils.console_log("📋 VIRTUAL PROGRESS BOARD STATUS")
        utils.console_log("-----------------------------------------")
        utils.console_log(" 1. [Env Diagnostics]: ", task1_status)
        utils.console_log(" 2. [Compile Project]: ", task2_status)
        utils.console_log(" 3. [Run Test Suite]:  ", task3_status)
        utils.console_log("-----------------------------------------")
        
        # 2. Gather environment health and workspace diagnostics
        var diagnostics: String
        if simulated_state == 0:
            diagnostics = (
                "Workspace Status: UNCLEAN\n"
                "Uncompiled file 'main_app.mojo' has a syntax error:\n"
                "  /Users/amund/workspace/main_app.mojo:5:10: error: expected ')' in function signature\n"
                "  def calculate(a: Int, b: Int\n"
                "                          ^"
            )
        elif simulated_state == 1:
            diagnostics = (
                "Workspace Status: UNCLEAN\n"
                "File 'main_app.mojo' is patched and verified.\n"
                "Binary 'main_app' is missing or uncompiled."
            )
        elif simulated_state == 2:
            diagnostics = (
                "Workspace Status: COMPILED\n"
                "Binary 'main_app' successfully compiled.\n"
                "Tests have not yet been run."
            )
        else:
            diagnostics = (
                "Workspace Status: CLEAN\n"
                "Binary 'main_app' ran and tests passed successfully: Output is '30'."
            )
            
        utils.console_log("🔍 System Sensor Diagnostics:\n" + diagnostics + "\n")
        
        # 3. Request next action from the LLM or run simulated actions
        var raw_cmd = String("")
        
        if active_key:
            utils.console_log("Sending current task board and environment state to Cloud LLM...")
            var system_prompt = (
                "You are an autonomous background-ticking systems agent. You drive tasks to completion.\n"
                "Review the virtual task board status and the system sensor diagnostics.\n"
                "Propose exactly one shell command to execute next to resolve issues and make progress.\n"
                "If everything is successfully compiled and tests have passed, output the word: COMPLETED."
            )
            var prompt = (
                "Task Board:\n"
                "- Env Diagnostics: " + task1_status + "\n"
                "- Compile Project: " + task2_status + "\n"
                "- Run Test Suite: " + task3_status + "\n\n"
                "Diagnostics:\n" + diagnostics + "\n\n"
                "Provide the next command or 'COMPLETED':"
            )
            try:
                if is_openrouter:
                    raw_cmd = llm.call_openrouter(active_key, system_prompt + "\n\n" + prompt, "google/gemini-3.5-flash")
                else:
                    raw_cmd = llm.call_gemini(active_key, system_prompt + "\n\n" + prompt)
            except err:
                utils.console_log("⚠️ Cloud LLM call failed or timed out. Falling back to background sequencer...")
                raw_cmd = ""
        
        # Simulated Sequencer Fallback
        if not raw_cmd.strip():
            if simulated_state == 0:
                raw_cmd = "cat << 'EOF' > main_app.mojo\ndef calculate(a: Int, b: Int) -> Int:\n    return a + b\n\ndef main():\n    print(calculate(10, 20))\nEOF"
            elif simulated_state == 1:
                raw_cmd = "mojo build main_app.mojo"
            elif simulated_state == 2:
                raw_cmd = "./main_app"
            else:
                raw_cmd = "COMPLETED"
                
        var cmd = llm.clean_command(raw_cmd)
        utils.console_log("Model Decided Command: " + cmd)
        
        if cmd.strip().upper() == "COMPLETED" or cmd.strip().lower() == "completed":
            utils.console_log("\n🎉 All background tasks completed successfully.")
            utils.console_log("Heartbeat daemon transitioning to idle state.\n")
            break
            
        var execution_output: String
        
        if interactive:
            var choice = get_input("Press Enter to execute, 's' to skip, 'e' to exit, or type corrections: ")
            if choice.strip().lower() == "e":
                utils.console_log("Exiting background ticking daemon.")
                break
            elif choice.strip().lower() == "s":
                utils.console_log("Skipping heartbeat action...")
                execution_output = "(Heartbeat command skipped by user)"
            elif choice.strip():
                utils.console_log("Feeding manual override feedback into daemon...")
                execution_output = "(Overridden by user: " + choice + ")"
                simulated_state += 1
            else:
                utils.console_log("Executing command natively...")
                execution_output = "(Command executed successfully)"
                simulated_state += 1
        else:
            utils.console_log("Executing command natively...")
            execution_output = "(Command executed successfully)"
            simulated_state += 1
            
        utils.console_log("Action Result: " + execution_output)
        
    utils.console_log("=========================================================\n")

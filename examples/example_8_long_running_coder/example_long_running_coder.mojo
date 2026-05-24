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
    utils.console_log("🚀 Long-Running Coder Agent (Gemini 3.5 Autonomous Loop)")
    utils.console_log("=========================================================\n")
    
    var builtins = Python.import_module("builtins")
    
    # Check command-line arguments for interactive parameter
    var args = std.sys.argv()
    var interactive = False
    for i in range(len(args)):
        var arg = args[i]
        if arg == "--interactive" or arg == "-i":
            interactive = True
            
    var user_task = get_input("Enter a goal for the agent (or press Enter for default Mojo math library): ")
    var task: String
    var is_custom = False
    if user_task.strip():
        task = String(user_task.strip())
        is_custom = True
    else:
        task = "Create a folder 'math_lib', write a Mojo file inside containing a dynamic sum function, compile it, and print the output."
        
    utils.console_log("Agent Goal:", task)
    utils.console_log("Running Mode:", "INTERACTIVE" if interactive else "AUTONOMOUS (Default)")
    utils.console_log("💡 (To enable interactive confirmation, run with: --interactive or -i)\n")
    
    var gemini_key: String
    var openrouter_key: String
    gemini_key, openrouter_key = llm.load_env_keys()
    
    var active_key = openrouter_key if openrouter_key else gemini_key
    var is_openrouter = True if openrouter_key else False
    
    var system_prompt = (
        "You are an interactive systems agent loop. Your goal is: " + task + "\n"
        "Maintain state. Look at the history of executed commands and their outputs.\n"
        "Return ONLY the exact next shell command to execute. When the goal is fully accomplished, return the word: COMPLETED.\n"
        "Note: Mojo does not support Python's untyped variadic *args. Use typed collections like List[Int] or specific arguments."
    )
    
    var max_iterations = 5
    var current_state = String("")
    
    if not active_key:
        if is_custom:
            utils.console_log("⚠️  No API keys found. Note: Simulated mode only runs the default math library demo.")
            utils.console_log("   Configure a GEMINI_API_KEY or OPENROUTER_API_KEY in .env to run custom goals like: " + task + "\n")
        utils.console_log("⚠️  Running in SIMULATED/MOCK mode.")
        
        for step in range(1, max_iterations + 1):
            utils.console_log("\n--- [Iteration " + String(step) + "/" + String(max_iterations) + "] ---")
            
            var mock_cmd: String
            var mock_out: String
            
            if step == 1:
                utils.console_log("Analyzing history and planning next action...")
                mock_cmd = "mkdir -p math_lib"
                utils.console_log("Model Decided Command: " + mock_cmd)
                
                if interactive:
                    var choice = get_input("Press Enter to execute, 's' to skip, 'e' to exit, or type corrections: ")
                    if choice.strip().lower() == "e":
                        utils.console_log("Exiting agent loop.")
                        break
                    elif choice.strip().lower() == "s":
                        utils.console_log("Skipping command...")
                        mock_out = "(skipped)"
                    elif choice.strip():
                        utils.console_log("User Feedback: " + choice)
                        mock_out = "(Bypassed. Feedback: " + choice + ")"
                    else:
                        utils.console_log("Executing command natively...")
                        utils.console_log("System Exec Output: (directory created successfully)")
                        mock_out = "(directory created successfully)"
                else:
                    utils.console_log("Executing command natively...")
                    utils.console_log("System Exec Output: (directory created successfully)")
                    mock_out = "(directory created successfully)"
            elif step == 2:
                utils.console_log("Analyzing history and planning next action...")
                mock_cmd = "cat << 'EOF' > math_lib/sum.mojo\nfn calculate(a: Int, b: Int) -> Int:\n    return a + b\n\nfn main():\n    print(calculate(12, 30))\nEOF"
                utils.console_log("Model Decided Command:\n" + mock_cmd)
                
                if interactive:
                    var choice = get_input("Press Enter to execute, 's' to skip, 'e' to exit, or type corrections: ")
                    if choice.strip().lower() == "e":
                        utils.console_log("Exiting agent loop.")
                        break
                    elif choice.strip().lower() == "s":
                        utils.console_log("Skipping command...")
                        mock_out = "(skipped)"
                    elif choice.strip():
                        utils.console_log("User Feedback: " + choice)
                        mock_out = "(Bypassed. Feedback: " + choice + ")"
                    else:
                        utils.console_log("Executing command natively...")
                        utils.console_log("System Exec Output: (file math_lib/sum.mojo written successfully)")
                        mock_out = "(file math_lib/sum.mojo written successfully)"
                else:
                    utils.console_log("Executing command natively...")
                    utils.console_log("System Exec Output: (file math_lib/sum.mojo written successfully)")
                    mock_out = "(file math_lib/sum.mojo written successfully)"
            elif step == 3:
                utils.console_log("Analyzing history and planning next action...")
                mock_cmd = "mojo math_lib/sum.mojo"
                mock_out = "42"
                utils.console_log("Model Decided Command: " + mock_cmd)
                
                if interactive:
                    var choice = get_input("Press Enter to execute, 's' to skip, 'e' to exit, or type corrections: ")
                    if choice.strip().lower() == "e":
                        utils.console_log("Exiting agent loop.")
                        break
                    elif choice.strip().lower() == "s":
                        utils.console_log("Skipping command...")
                        mock_out = "(skipped)"
                    elif choice.strip():
                        utils.console_log("User Feedback: " + choice)
                        mock_out = "(Bypassed. Feedback: " + choice + ")"
                    else:
                        utils.console_log("Executing command natively...")
                        utils.console_log("System Exec Output:\n" + mock_out)
                else:
                    utils.console_log("Executing command natively...")
                    utils.console_log("System Exec Output:\n" + mock_out)
            else:
                utils.console_log("Analyzing history and planning next action...")
                mock_cmd = "COMPLETED"
                utils.console_log("Model Decided Command: " + mock_cmd)
                utils.console_log("\n🎉 Goal Accomplished: Long-running agent has completed all tasks successfully.")
                break
                
            current_state += "\nStep " + String(step) + " command: " + mock_cmd + "\nOutput: " + mock_out
            
        utils.console_log("\nCleaning up math_lib directories...")
        try:
            _ = execSync("rm -rf math_lib")
        except:
            pass
        utils.console_log("=========================================================\n")
        return
        
    # Real Cloud Execution Loop
    utils.console_log("Starting cloud agent loop using Gemini 3.5 Flash...")
    
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
            utils.console_log("⚠️  Live cloud API call timed out or failed. Falling back to safe simulated commands.")
            if step == 1:
                raw_cmd = "mkdir -p math_lib"
            elif step == 2:
                raw_cmd = "cat << 'EOF' > math_lib/sum.mojo\nfn calculate(a: Int, b: Int) -> Int:\n    return a + b\n\nfn main():\n    print(calculate(12, 30))\nEOF"
            elif step == 3:
                raw_cmd = "mojo math_lib/sum.mojo"
            else:
                raw_cmd = "COMPLETED"
                
        var cmd = llm.clean_command(raw_cmd)
        utils.console_log("Model Decided Command: " + cmd)
        
        if cmd.strip().upper() == "COMPLETED" or cmd.strip().lower() == "completed":
            utils.console_log("\n🎉 Goal Accomplished: Long-running agent has completed all tasks successfully.")
            break
            
        var execution_output: String
        
        if interactive:
            var choice = get_input("Press Enter to execute, 's' to skip, 'e' to exit, or type corrections: ")
            if choice.strip().lower() == "e":
                utils.console_log("Exiting agent loop.")
                break
            elif choice.strip().lower() == "s":
                utils.console_log("Skipping command...")
                execution_output = "(Command skipped by user)"
            elif choice.strip():
                utils.console_log("Feeding feedback back to the model...")
                execution_output = "(Execution intercepted. User Feedback/Correction: " + choice + ")"
            else:
                utils.console_log("Executing command natively...")
                try:
                    var out = execSync(cmd)
                    utils.console_log("System Exec Output:\n" + out.strip())
                    execution_output = out
                except err:
                    utils.console_log("⚠️  Execution failed: " + String(err))
                    execution_output = "Execution failed: " + String(err)
        else:
            utils.console_log("Executing command natively...")
            try:
                var out = execSync(cmd)
                utils.console_log("System Exec Output:\n" + out.strip())
                execution_output = out
            except err:
                utils.console_log("⚠️  Execution failed: " + String(err))
                execution_output = "Execution failed: " + String(err)
                
        current_state += "\nStep " + String(step) + " command: " + cmd + "\nOutput: " + execution_output
        
    utils.console_log("\nCleaning up math_lib directories...")
    try:
        _ = execSync("rm -rf math_lib")
    except:
        pass
    utils.console_log("=========================================================\n")

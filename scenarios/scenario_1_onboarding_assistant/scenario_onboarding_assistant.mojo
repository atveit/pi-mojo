import std.sys
import t2m_runtime.utils as utils
import t2m_runtime.llm as llm
from t2m_runtime.child_process import execSync
from std.python import Python, PythonObject

def main() raises:
    utils.console_log("=========================================================")
    utils.console_log("🤖 Scenario 1: AI Systems Onboarding Assistant")
    utils.console_log("=========================================================\n")
    
    var args = std.sys.argv()
    var force_mock = False
    for i in range(len(args)):
        var arg = args[i]
        if arg == "--mock" or arg == "-m":
            force_mock = True

    var task = (
        "Run system environment path checks. Specifically:\n"
        "1. Read shell environment paths using Python FFI ('PATH', 'SHELL', 'LANG').\n"
        "2. Synthesize an onboarding diagnostics checklist summarizing standard development paths.\n"
        "3. Write the diagnostic summary checklist into 'onboarding_diagnostics.txt'."
    )
    
    utils.console_log("Systems Narrative Story:")
    utils.console_log("A newly hired developer needs to onboard onto a new server.")
    utils.console_log("The agent inspects standard system environment attributes and generates")
    utils.console_log("a detailed configuration checklist for the shell profile.\n")

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
        "If you need to write a file, use echo or python-based file writes. Do not include markdown wraps."
    )

    if force_mock or not active_key:
        utils.console_log("⚠️  Running in SIMULATED/MOCK mode.")
        
        for step in range(1, max_iterations + 1):
            utils.console_log("\n--- [Iteration " + String(step) + "/" + String(max_iterations) + "] ---")
            
            var mock_cmd: String
            var mock_out: String
            
            if step == 1:
                utils.console_log("Analyzing history and planning next action...")
                mock_cmd = "python3 -c \"import os; print('PATH:', os.environ.get('PATH', '')); print('SHELL:', os.environ.get('SHELL', '')); print('LANG:', os.environ.get('LANG', ''))\""
                utils.console_log("Model Decided Command: " + mock_cmd)
                utils.console_log("Executing command natively...")
                try:
                    mock_out = execSync(mock_cmd)
                    utils.console_log("System Exec Output:\n" + mock_out.strip())
                except err:
                    mock_out = "PATH: /usr/bin:/bin\nSHELL: /bin/zsh\nLANG: en_US.UTF-8"
                    utils.console_log("System Exec Output (simulated):\n" + mock_out)
            elif step == 2:
                utils.console_log("Analyzing history and planning next action...")
                mock_cmd = "cat << 'EOF' > onboarding_diagnostics.txt\n=========================================\n📥 AI SYSTEMS ONBOARDING REPORT\n=========================================\n✔️ PATH Verification: SUCCESS\n✔️ SHELL Interface: ACTIVE\n✔️ Locale Encoding: STABLE\n\n📌 Recommended Configs:\nexport EDITOR=vim\nexport PI_MOJO_HOME=" + String(execSync("pwd").strip()) + "\n=========================================\nEOF"
                utils.console_log("Model Decided Command:\n" + mock_cmd)
                utils.console_log("Executing command natively...")
                _ = execSync(mock_cmd)
                mock_out = "(onboarding_diagnostics.txt generated successfully)"
                utils.console_log("System Exec Output:\n" + mock_out)
            elif step == 3:
                utils.console_log("Analyzing history and planning next action...")
                mock_cmd = "cat onboarding_diagnostics.txt"
                utils.console_log("Model Decided Command: " + mock_cmd)
                utils.console_log("Executing command natively...")
                mock_out = execSync(mock_cmd)
                utils.console_log("System Exec Output:\n" + mock_out.strip())
            else:
                utils.console_log("Analyzing history and planning next action...")
                mock_cmd = "COMPLETED"
                utils.console_log("Model Decided Command: " + mock_cmd)
                utils.console_log("\n🎉 Goal Accomplished: Systems Onboarding completed successfully!")
                break
                
            current_state += "\nStep " + String(step) + " command: " + mock_cmd + "\nOutput: " + mock_out
            
        utils.console_log("\nCleaning up temporary workspace files...")
        try:
            _ = execSync("rm -f onboarding_diagnostics.txt")
        except:
            pass
        utils.console_log("=========================================================\n")
        return

    # Real Cloud Execution Loop
    utils.console_log("Starting cloud agent loop using Gemini/OpenRouter...")
    
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
            utils.console_log("\n🎉 Goal Accomplished: Systems Onboarding completed successfully!")
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
        _ = execSync("rm -f onboarding_diagnostics.txt")
    except:
        pass
    utils.console_log("=========================================================\n")

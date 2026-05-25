import t2m_runtime.utils as utils
import t2m_runtime.llm as llm
from t2m_runtime.child_process import execSync
from std.python import Python

def main() raises:
    utils.console_log("=========================================================")
    utils.console_log("🚀 Systems Coding Agent Example (Cloud LLM)")
    utils.console_log("=========================================================\n")
    
    var task = "Find out how many files are in the current workspace folder."
    var system_prompt = "You are a terminal coding agent. Return ONLY a single shell command to run to achieve the user's request. Do not include markdown blocks, explanations, or formatting. Example request: list files, you answer: ls"
    
    utils.console_log("Agent Task:", task)
    utils.console_log("")

    # -------------------------------------------------------------
    # 1. Cloud LLM-Based Coding Agent
    # -------------------------------------------------------------
    utils.console_log("--- Cloud LLM Coding Agent (OpenRouter/Gemini) ---")
    var gemini_key: String
    var openrouter_key: String
    gemini_key, openrouter_key = llm.load_env_keys()
    
    if not gemini_key and not openrouter_key:
        utils.console_log("⚠️  Cloud LLM Agent bypassed. No GEMINI_API_KEY or OPENROUTER_API_KEY found in environment or .env.")
        utils.console_log("")
        return

    # Helper variable for selected engine
    var active_key = openrouter_key if openrouter_key else gemini_key
    var is_openrouter = True if openrouter_key else False

    # Execute single task turn
    try:
        var raw_cmd: String
        if is_openrouter:
            utils.console_log("Asking OpenRouter (google/gemini-3.5-flash) to decide command...")
            raw_cmd = llm.call_openrouter(active_key, system_prompt + "\n\nTask: " + task, "google/gemini-3.5-flash")
        else:
            utils.console_log("Asking Gemini API (gemini-3.5-flash) to decide command...")
            raw_cmd = llm.call_gemini(active_key, system_prompt + "\n\nTask: " + task)
            
        var cmd = llm.clean_command(raw_cmd)
        utils.console_log("Cloud LLM generated command:", cmd)
        utils.console_log("Executing command natively via C interop...")
        var out = execSync(cmd)
        utils.console_log("Result:")
        utils.console_log(out.strip())
    except err:
        utils.console_log("❌ Cloud LLM Agent failed:", String(err))
    utils.console_log("")

    # -------------------------------------------------------------
    # 2. INTERACTIVE AGENT LOOP
    # -------------------------------------------------------------
    utils.console_log("=========================================================")
    utils.console_log("💬 Interactive Systems Coding Agent Mode")
    utils.console_log("=================================================")
    
    var builtins = Python.import_module("builtins")
    
    while True:
        try:
            var user_task = String(builtins.input("\nEnter a task for the agent (e.g. 'show files', 'get time', or press Enter to exit): "))
            if not user_task.strip():
                utils.console_log("Exited interactive mode. Goodbye!")
                break
                
            utils.console_log("Agent Task: " + user_task)
            
            var raw_cmd: String
            if is_openrouter:
                utils.console_log("Asking OpenRouter (google/gemini-3.5-flash) to decide command...")
                raw_cmd = llm.call_openrouter(active_key, system_prompt + "\n\nTask: " + user_task, "google/gemini-3.5-flash")
            else:
                utils.console_log("Asking Gemini API (gemini-3.5-flash) to decide command...")
                raw_cmd = llm.call_gemini(active_key, system_prompt + "\n\nTask: " + user_task)
                
            var cmd = llm.clean_command(raw_cmd)
            utils.console_log("Command Decided:", cmd)
            utils.console_log("Executing...")
            var out = execSync(cmd)
            utils.console_log("Result:\n" + out.strip())
        except err:
            utils.console_log("❌ Failed to process interactive command: " + String(err))
            break

from std.python import Python, PythonObject
from t2m_runtime.child_process import execSync
import t2m_runtime.utils as utils
import t2m_runtime.llm as llm
from packages.playbook.pi_playbook_store import Playbook, PlaybookStore

def get_input_prompt(prompt: String) raises -> String:
    var py_sys = Python.import_module("sys")
    var builtins = Python.import_module("builtins")
    _ = py_sys.stdout.flush()
    return String(builtins.input(prompt))

struct PiPlaybookAgent:
    var store: PlaybookStore

    def __init__(out self, playbooks_dir: String = ".pi_playbooks"):
        self.store = PlaybookStore(playbooks_dir)

    def run_task(self, task: String, interactive: Bool = False) raises:
        utils.console_log("\n🤖 [Autonomous Playbook Agent] Initializing task:", task)
        
        var gemini_key: String
        var openrouter_key: String
        gemini_key, openrouter_key = llm.load_env_keys()
        var active_key = openrouter_key if openrouter_key else gemini_key
        var is_openrouter = True if openrouter_key else False
        
        if not active_key:
            utils.console_log("⚠️  No API keys found. Configure a GEMINI_API_KEY or OPENROUTER_API_KEY in .env.")
            return

        # 1. Alignment Phase: Query Playbook Registry
        var playbook = self.store.find_matching_playbook(task)
        var playbook_guidance = String("")
        
        if len(playbook.goal) > 0:
            utils.console_log("📖 [PLAYBOOK ALIGNMENT ACTIVE] Found matching playbook in local store!")
            utils.console_log("   Goal:", playbook.goal)
            utils.console_log("   Criteria:", playbook.criteria)
            
            playbook_guidance += "\n[PLAYBOOK ALIGNMENT GUIDANCE]\n"
            playbook_guidance += "You have an existing playbook for a similar goal: " + playbook.goal + "\n"
            playbook_guidance += "We strongly recommend following these successful steps to avoid errors:\n"
            for i in range(len(playbook.steps)):
                playbook_guidance += String(i + 1) + ". " + String(py=playbook.steps[i]) + "\n"
            playbook_guidance += "Success Criteria: " + playbook.criteria + "\n"
            playbook_guidance += "Follow the pattern of these steps to achieve high efficiency.\n"
        else:
            utils.console_log("🔍 [PLAYBOOK ALIGNMENT] No matching playbook found. Proceeding with standard discovery.")

        var system_prompt = (
            "You are an interactive systems agent loop. Your goal is: " + task + "\n"
            "Maintain state. Look at the history of executed commands and their outputs.\n"
            "Return ONLY the exact next shell command to execute. When the goal is fully accomplished, return the word: COMPLETED.\n"
            + playbook_guidance
        )
        
        var max_iterations = 6
        var current_state = String("")
        var successful_commands = List[String]()
        var achieved_success = False
        
        for step in range(1, max_iterations + 1):
            utils.console_log("\n--- [Iteration " + String(step) + "/" + String(max_iterations) + "] ---")
            
            var prompt = "Current History:\n" + current_state + "\n\nProvide the next shell command or 'COMPLETED':"
            utils.console_log("Sending state to model...")
            
            var raw_cmd: String
            try:
                if is_openrouter:
                    raw_cmd = llm.call_openrouter(active_key, system_prompt + "\n\n" + prompt, "google/gemini-3.5-flash")
                else:
                    raw_cmd = llm.call_gemini(active_key, system_prompt + "\n\n" + prompt)
            except err:
                utils.console_log("⚠️ Cloud API call timed out or failed: " + String(err))
                break
                
            var cmd = llm.clean_command(raw_cmd)
            utils.console_log("Model Decided Command: " + cmd)
            
            if cmd.strip().upper() == "COMPLETED" or cmd.strip().lower() == "completed":
                utils.console_log("\n🎉 Goal Accomplished successfully!")
                achieved_success = True
                break
                
            var execution_output: String
            
            if interactive:
                var choice = get_input_prompt("Press Enter to execute, 's' to skip, 'e' to exit, or type corrections: ")
                if choice.strip().lower() == "e":
                    utils.console_log("Exiting agent loop.")
                    break
                elif choice.strip().lower() == "s":
                    utils.console_log("Skipping command...")
                    execution_output = "(Command skipped by user)"
                elif choice.strip():
                    utils.console_log("Feeding feedback back to the model...")
                    execution_output = "(Execution intercepted. User Feedback: " + choice + ")"
                else:
                    utils.console_log("Executing command natively...")
                    try:
                        var out = execSync(cmd)
                        utils.console_log("System Exec Output:\n" + out.strip())
                        execution_output = out
                        successful_commands.append(cmd)
                    except err:
                        utils.console_log("⚠️ Execution failed: " + String(err))
                        execution_output = "Execution failed: " + String(err)
            else:
                utils.console_log("Executing command natively...")
                try:
                    var out = execSync(cmd)
                    utils.console_log("System Exec Output:\n" + out.strip())
                    execution_output = out
                    successful_commands.append(cmd)
                except err:
                    utils.console_log("⚠️ Execution failed: " + String(err))
                    execution_output = "Execution failed: " + String(err)
                    
            current_state += "\nStep " + String(step) + " command: " + cmd + "\nOutput: " + execution_output

        # 2. Playbook Extraction Phase
        if achieved_success and len(successful_commands) > 0 and len(playbook.goal) == 0:
            utils.console_log("\n⚙️ [PLAYBOOK EXTRACTION ACTIVE] Synthesizing reusable playbook from successful commands...")
            
            var extraction_prompt = (
                "Review the following sequence of successful shell commands that achieved the goal: '" + task + "'\n\n"
                "Successful Commands:\n"
            )
            for s in range(len(successful_commands)):
                extraction_prompt += "- `" + successful_commands[s] + "`\n"
                
            extraction_prompt += (
                "\nExtract and compile a reusable agent playbook document in exact GFM Markdown.\n"
                "Format rules:\n"
                "First line must be: '# Playbook: [Short Descriptive Goal]'\n"
                "Second line must be: '- **Tags**: [comma-separated tags e.g. config, migration, ini]'\n"
                "Third line must be: '- **Criteria**: [description of success criteria]'\n"
                "Then include a '## Steps' header and numbered list of commands wrapped in single backticks.\n"
                "Do not output any introductory or explanatory text. Output only the markdown playbook."
            )
            
            try:
                var playbook_md: String
                if is_openrouter:
                    playbook_md = llm.call_openrouter(active_key, extraction_prompt, "google/gemini-3.5-flash")
                else:
                    playbook_md = llm.call_gemini(active_key, extraction_prompt)
                
                var new_playbook = self.store.parse_playbook_py(playbook_md, "")
                if len(new_playbook.goal) > 0:
                    self.store.save_playbook(new_playbook)
                    utils.console_log("💾 [PLAYBOOK SAVED] New playbook written to local store!")
                    utils.console_log("   Goal filename registered: " + new_playbook.goal)
                else:
                    utils.console_log("⚠️ Failed to parse newly synthesized playbook markdown.")
            except err:
                utils.console_log("⚠️ Playbook synthesis failed: " + String(err))

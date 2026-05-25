from std.python import Python, PythonObject
from t2m_runtime.child_process import execSync
import t2m_runtime.utils as utils
import t2m_runtime.llm as llm
from packages.durable.pi_checkpoint_store import Checkpoint, CheckpointStore

def get_input_prompt(prompt: String) raises -> String:
    var py_sys = Python.import_module("sys")
    var builtins = Python.import_module("builtins")
    _ = py_sys.stdout.flush()
    return String(builtins.input(prompt))

struct PiDurableAgent:
    var store: CheckpointStore

    def __init__(out self, checkpoints_dir: String = ".pi_checkpoints"):
        self.store = CheckpointStore(checkpoints_dir)

    def run_task(self, session_id: String, task: String, max_iterations: Int = 5, interactive: Bool = False) raises:
        utils.console_log("\n🤖 [Durable Agent] Initializing session:", session_id)
        
        var gemini_key: String
        var openrouter_key: String
        gemini_key, openrouter_key = llm.load_env_keys()
        var active_key = openrouter_key if openrouter_key else gemini_key
        var is_openrouter = True if openrouter_key else False
        
        if not active_key:
            utils.console_log("⚠️  No API keys found. Configure a GEMINI_API_KEY or OPENROUTER_API_KEY in .env.")
            return

        var builtins = Python.import_module("builtins")
        
        var current_step = 1
        var current_state = String("")
        var successful_commands = builtins.list()
        
        # 1. Rehydration Phase: Check if Checkpoint exists
        if self.store.exists_checkpoint(session_id):
            utils.console_log("💾 [DURABLE STATE ACTIVE] Found active session checkpoint. Rehydrating...")
            var cp = self.store.load_checkpoint(session_id)
            current_step = cp.current_step
            current_state = String(py=cp.metadata["current_state"])
            successful_commands = cp.metadata["successful_commands"]
            
            utils.console_log("📖 [RECOVERY COMPLETE] Resuming session at step " + String(current_step) + ".")
            utils.console_log("   Completed History Recovered:\n" + current_state.strip())
        else:
            utils.console_log("🔍 [DURABLE STATE] No existing checkpoint. Starting fresh session.")

        var system_prompt = (
            "You are an interactive systems agent loop. Your goal is: " + task + "\n"
            "Maintain state. Look at the history of executed commands and their outputs.\n"
            "Return ONLY the exact next shell command to execute. When the goal is fully accomplished, return the word: COMPLETED."
        )
        
        var achieved_success = False
        
        for step in range(current_step, max_iterations + 1):
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
                        _ = successful_commands.append(cmd)
                    except err:
                        utils.console_log("⚠️ Execution failed: " + String(err))
                        execution_output = "Execution failed: " + String(err)
            else:
                utils.console_log("Executing command natively...")
                try:
                    var out = execSync(cmd)
                    utils.console_log("System Exec Output:\n" + out.strip())
                    execution_output = out
                    _ = successful_commands.append(cmd)
                except err:
                    utils.console_log("⚠️ Execution failed: " + String(err))
                    execution_output = "Execution failed: " + String(err)
                    
            current_state += "\nStep " + String(step) + " command: " + cmd + "\nOutput: " + execution_output

            # 2. Checkpointing Phase: Save state at the end of each turn
            var next_step = step + 1
            var metadata = builtins.dict()
            metadata["current_state"] = current_state
            metadata["successful_commands"] = successful_commands
            
            var empty_messages = builtins.list()
            var checkpoint = Checkpoint(session_id, task, next_step, empty_messages, metadata)
            
            self.store.save_checkpoint(checkpoint)
            utils.console_log("💾 [CHECKPOINT COMMITTED] Saved progress at step " + String(next_step) + ".")

        # 3. Clean-up Phase on Completion
        if achieved_success:
            utils.console_log("\n🧹 [DURABLE STATE] Deleting completed session checkpoint.")
            self.store.delete_checkpoint(session_id)

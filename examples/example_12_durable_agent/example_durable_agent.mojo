import std.sys
import t2m_runtime.utils as utils
from packages.durable.pi_durable_agent import PiDurableAgent, get_input_prompt
from t2m_runtime.child_process import execSync
from std.os.path import exists

def main() raises:
    utils.console_log("=========================================================")
    utils.console_log("🤖 Example 12: Crash-Resilient Durable Agent Loop")
    utils.console_log("=========================================================\n")
    
    var args = std.sys.argv()
    var interactive = False
    for i in range(len(args)):
        var arg = args[i]
        if arg == "--interactive" or arg == "-i":
            interactive = True

    var agent = PiDurableAgent()
    var session_id = "session_durable_demo"
    var task = "Create a directory 'sandbox_durable', write a file 'sandbox_durable/progress.txt' containing 'step=1', and verify it exists."
    
    utils.console_log("This example demonstrates Python JSON state checkpointing:")
    utils.console_log("1. **Serialization**: State (messages, history, steps) is saved to disk at every turn.")
    utils.console_log("2. **Recovery**: If interrupted/crashed, the agent rehydrates from the last step.\n")

    var checkpoint_path = ".pi_checkpoints/" + session_id + ".json"
    
    if not exists(checkpoint_path):
        utils.console_log("🚀 --- RUN 1: Simulated System Failure (Pre-Checkpoint) ---")
        utils.console_log("Goal: " + task)
        utils.console_log("We will run exactly 1 step, save a checkpoint, and simulate a system crash.\n")
        
        # Run standard task with a limit of 1 step
        agent.run_task(session_id, task, max_iterations=1, interactive=interactive)
        
        utils.console_log("\n💥 [SYSTEM CRASH] Process terminated abruptly.")
        utils.console_log("   Note: Checkpoint committed to: " + checkpoint_path)
        utils.console_log("👉 Please rerun this command to see the agent recover and resume: ")
        utils.console_log("   mojo -I src examples/example_12_durable_agent/example_durable_agent.mojo\n")
    else:
        utils.console_log("🚀 --- RUN 2: Rehydration & Restoration (Post-Crash Recovery) ---")
        utils.console_log("Detecting active checkpoint at: " + checkpoint_path)
        utils.console_log("Press Enter to restore state and resume execution...")
        _ = get_input_prompt("")
        
        # Resume and run to completion
        agent.run_task(session_id, task, max_iterations=3, interactive=interactive)
        
        utils.console_log("\n🧹 Cleaning up temporary workspace files...")
        try:
            _ = execSync("rm -rf sandbox_durable")
        except:
            pass
            
    utils.console_log("=========================================================\n")

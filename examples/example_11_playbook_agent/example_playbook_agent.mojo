import std.sys
import t2m_runtime.utils as utils
from packages.playbook.pi_playbook_agent import PiPlaybookAgent, get_input_prompt
from t2m_runtime.child_process import execSync

def main() raises:
    utils.console_log("=========================================================")
    utils.console_log("🤖 Example 11: Playbook-Guided Autonomous Agent (Hermes)")
    utils.console_log("=========================================================\n")
    
    var args = std.sys.argv()
    var interactive = False
    for i in range(len(args)):
        var arg = args[i]
        if arg == "--interactive" or arg == "-i":
            interactive = True

    var agent = PiPlaybookAgent()
    
    utils.console_log("This example demonstrates the v0.2 Autonomous Playbook Double-Loop:")
    utils.console_log("1. **Alignment (Pre-run)**: Checks for matching playbooks in `.pi_playbooks/`.")
    utils.console_log("2. **Extraction (Post-run)**: Summarizes successful shell commands to build new playbooks.\n")

    utils.console_log("🚀 --- RUN 1: Learning Phase (Standard Trial-and-Error) ---")
    var task1 = "Create a directory 'sandbox_cfg', write a file 'sandbox_cfg/db.ini' with host=127.0.0.1, and verify it exists."
    utils.console_log("Task 1:", task1)
    
    agent.run_task(task1, interactive)

    utils.console_log("\n🚀 --- RUN 2: Re-Use Phase (High-Speed Playbook Alignment) ---")
    utils.console_log("Task 2 (Same tag/type):", "Create a directory 'sandbox_cfg', write a file 'sandbox_cfg/db.ini' with host=127.0.0.1")
    utils.console_log("Press Enter to initiate matching and execution alignment...")
    _ = get_input_prompt("")
    
    agent.run_task(task1, interactive)

    utils.console_log("\n🧹 Cleaning up temporary workspace files...")
    try:
        _ = execSync("rm -rf sandbox_cfg")
    except:
        pass
        
    utils.console_log("=========================================================\n")

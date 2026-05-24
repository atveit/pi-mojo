from std.python import Python
import t2m_runtime.utils as utils

def run_test_file(path: String) raises:
    utils.console_log("🚀 Running isolated test: " + path)
    var subprocess = Python.import_module("subprocess")
    var cmd = Python.evaluate("['mojo', 'run', '-I', 'src', '" + path + "']")
    var res = subprocess.run(cmd)
    if res.returncode != 0:
        raise Error("❌ Unit test failed: " + path + " exited with code " + String(res.returncode))

def main() raises:
    utils.console_log("=========================================================")
    utils.console_log("🧪 Running packages Core Unit Tests (Isolated)")
    utils.console_log("=========================================================\n")
    
    run_test_file("tests/packages/ai/test_pi_ai_types.mojo")
    run_test_file("tests/packages/ai/test_pi_ai_provider_faux.mojo")
    run_test_file("tests/packages/ai/test_pi_ai_registry.mojo")
    run_test_file("tests/packages/coding_agent/test_pi_coding_bash.mojo")
    run_test_file("tests/packages/coding_agent/test_pi_coding_exec.mojo")
    run_test_file("tests/packages/agent/test_pi_agent_types.mojo")
    run_test_file("tests/packages/agent/test_pi_agent.mojo")
    
    utils.console_log("=========================================================")
    utils.console_log("✅ All packages Unit Tests PASSED Successfully")
    utils.console_log("=========================================================\n")

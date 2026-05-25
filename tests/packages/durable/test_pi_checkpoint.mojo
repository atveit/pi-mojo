# test_pi_checkpoint.mojo
import packages.durable.pi_checkpoint_store as store
from packages.durable.pi_durable_agent import PiDurableAgent
from std.python import Python, PythonObject
import t2m_runtime.utils as utils

def assert_equal(a: String, b: String) raises:
    if a != b:
        raise Error("Assertion failed: '" + a + "' != '" + b + "'")

def assert_equal(a: Int, b: Int) raises:
    if a != b:
        raise Error("Assertion failed: " + String(a) + " != " + String(b))

def assert_true(cond: Bool, msg: String) raises:
    if not cond:
        raise Error("Assertion failed: " + msg)

def test_checkpoint_store() raises:
    utils.console_log("  - test_checkpoint_store")
    
    # Setup temporary directory for testing
    var temp_dir = String("tests_checkpoints_temp")
    var checkpoint_store = store.CheckpointStore(temp_dir)
    
    var session_id = String("test-session-123")
    var goal = String("verify mojo-test-cov works dynamically")
    var current_step = 5
    
    var builtins = Python.import_module("builtins")
    var messages = builtins.list()
    _ = messages.append("message 1")
    _ = messages.append("message 2")
    
    var metadata = builtins.dict()
    metadata["author"] = "antigravity"
    
    # 1. Initialize Checkpoint
    var checkpoint = store.Checkpoint(session_id, goal, current_step, messages, metadata)
    assert_equal(checkpoint.session_id, session_id)
    assert_equal(checkpoint.goal, goal)
    assert_equal(checkpoint.current_step, current_step)
    
    # 2. Check existence (should be False)
    assert_true(not checkpoint_store.exists_checkpoint(session_id), "Checkpoint should not exist initially")
    
    # 3. Save Checkpoint
    checkpoint_store.save_checkpoint(checkpoint)
    assert_true(checkpoint_store.exists_checkpoint(session_id), "Checkpoint should exist after saving")
    
    # 4. Load Checkpoint
    var loaded = checkpoint_store.load_checkpoint(session_id)
    assert_equal(loaded.session_id, session_id)
    assert_equal(loaded.goal, goal)
    assert_equal(loaded.current_step, current_step)
    
    # 5. Delete Checkpoint
    checkpoint_store.delete_checkpoint(session_id)
    assert_true(not checkpoint_store.exists_checkpoint(session_id), "Checkpoint should not exist after deletion")
    
    # Teardown: Remove temp directory
    var shutil = Python.import_module("shutil")
    _ = shutil.rmtree(PythonObject(temp_dir))

def test_durable_agent() raises:
    utils.console_log("  - test_durable_agent")
    
    var os = Python.import_module("os")
    var original_gemini_key = String(os.environ.get("GEMINI_API_KEY", ""))
    
    # Force GEMINI_API_KEY environment variable to enable agent execution
    os.environ["GEMINI_API_KEY"] = "mock-api-key"
    
    var urllib = Python.import_module("urllib.request")
    var original_urlopen = urllib.urlopen
    
    var builtins = Python.import_module("builtins")
    var globals_dict = builtins.dict()
    
    var mock_py = builtins.eval(
        "type('MockResponse', (object,), {"
        "  '__init__': lambda self, body: setattr(self, 'body', body),"
        "  'read': lambda self: self.body.encode('utf-8'),"
        "  'close': lambda self: None"
        "})",
        globals_dict
    )
    
    var mock_state = builtins.eval(
        "type('MockState', (object,), {"
        "  'calls': 0"
        "})()",
        globals_dict
    )
    
    globals_dict["mock_state"] = mock_state
    globals_dict["MockResponse"] = mock_py
    
    var mock_urlopen = builtins.eval(
        "lambda req, timeout=None: (\n"
        "  setattr(mock_state, 'calls', mock_state.calls + 1) or (\n"
        "    MockResponse('{\"candidates\": [{\"content\": {\"parts\": [{\"text\": \"echo hello\"}]}}]}') if mock_state.calls == 1 else \n"
        "    MockResponse('{\"candidates\": [{\"content\": {\"parts\": [{\"text\": \"COMPLETED\"}]}}]}')\n"
        "  )\n"
        ")",
        globals_dict
    )
    
    urllib.urlopen = mock_urlopen
    
    try:
        var temp_dir = String("tests_durable_agent_temp")
        var agent = PiDurableAgent(temp_dir)
        
        # Run standard non-interactive task loop
        agent.run_task(String("durable-session-abc"), String("echo something"), max_iterations=3, interactive=False)
        
        # Verify that temp dir cleanup is handled (agent deletes completed session checkpoint on success)
        assert_true(not agent.store.exists_checkpoint(String("durable-session-abc")), "Checkpoint should be cleaned up on success")
        
        # Clean up temp dir
        var shutil = Python.import_module("shutil")
        _ = shutil.rmtree(PythonObject(temp_dir))
    except err:
        # Restore environment and urllib state in case of error
        urllib.urlopen = original_urlopen
        if original_gemini_key:
            os.environ["GEMINI_API_KEY"] = original_gemini_key
        else:
            if os.environ.get("GEMINI_API_KEY"):
                _ = os.environ.pop("GEMINI_API_KEY")
        raise Error("Durable agent test failed: " + String(err))
        
    # Restore environment and urllib state
    urllib.urlopen = original_urlopen
    if original_gemini_key:
        os.environ["GEMINI_API_KEY"] = original_gemini_key
    else:
        if os.environ.get("GEMINI_API_KEY"):
            _ = os.environ.pop("GEMINI_API_KEY")

def main() raises:
    utils.console_log("🧪 Running test_pi_checkpoint.mojo")
    test_checkpoint_store()
    test_durable_agent()
    utils.console_log("✅ test_pi_checkpoint.mojo PASSED\n")

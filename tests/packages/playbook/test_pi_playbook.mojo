# test_pi_playbook.mojo
import packages.playbook.pi_playbook_store as store
from packages.playbook.pi_playbook_agent import PiPlaybookAgent
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

def test_playbook_store() raises:
    utils.console_log("  - test_playbook_store")
    
    # Setup temporary directory for playbooks
    var temp_dir = String("tests_playbooks_temp")
    var playbook_store = store.PlaybookStore(temp_dir)
    
    var goal = String("cleanup git repositories safely")
    var tags = String("git,clean,sanitizer")
    var criteria = String("git status returns clean")
    
    var builtins = Python.import_module("builtins")
    var steps = builtins.list()
    _ = steps.append("git clean -fd")
    _ = steps.append("git checkout -- .")
    
    # 1. Initialize Playbook
    var playbook = store.Playbook(goal, tags, criteria, steps, String(""))
    assert_equal(playbook.goal, goal)
    assert_equal(playbook.tags, tags)
    assert_equal(playbook.criteria, criteria)
    
    # 2. Test Markdown conversion
    var md = playbook.to_markdown()
    assert_true("# Playbook: cleanup git repositories safely" in md, "Goal should be in markdown title")
    assert_true("git clean -fd" in md, "Steps should be listed in markdown")
    
    # 3. Save Playbook to store
    playbook_store.save_playbook(playbook)
    
    # 4. Load Playbooks
    var loaded_playbooks = playbook_store.load_playbooks()
    assert_equal(len(loaded_playbooks), 1)
    
    var loaded = loaded_playbooks[0]
    assert_equal(loaded.goal, goal)
    assert_equal(loaded.tags, tags)
    assert_equal(loaded.criteria, criteria)
    
    # 5. Test playbook alignment / matching
    var aligned = playbook_store.find_matching_playbook(String("Need to run a git clean sanitizer task"))
    assert_equal(aligned.goal, goal)
    
    # Teardown: Remove temporary directories
    var shutil = Python.import_module("shutil")
    _ = shutil.rmtree(PythonObject(temp_dir))

def test_playbook_agent() raises:
    utils.console_log("  - test_playbook_agent")
    
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
        "lambda req, timeout=None: setattr(mock_state, 'calls', mock_state.calls + 1) or ("
        "MockResponse('{\"candidates\": [{\"content\": {\"parts\": [{\"text\": \"echo hello\"}]}}]}') if mock_state.calls == 1 else "
        "MockResponse('{\"candidates\": [{\"content\": {\"parts\": [{\"text\": \"COMPLETED\"}]}}]}') if mock_state.calls == 2 else "
        "MockResponse('{\"candidates\": [{\"content\": {\"parts\": [{\"text\": \"# Playbook: Short Goal\\\\n- **Tags**: tags\\\\n- **Criteria**: success criteria\\\\n\\\\n## Steps\\\\n1. `echo hello`\"}]}}]}')"
        ")",
        globals_dict
    )
    
    urllib.urlopen = mock_urlopen
    
    try:
        var temp_dir = String("tests_playbooks_agent_temp")
        var agent = PiPlaybookAgent(temp_dir)
        
        # Run standard non-interactive playbook agent task loop
        agent.run_task(String("echo something"), interactive=False)
        
        # Verify that playbook extraction has successfully run and saved a matching playbook
        var loaded = agent.store.load_playbooks()
        assert_equal(len(loaded), 1)
        assert_equal(loaded[0].goal, String("Short Goal"))
        
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
        raise Error("Playbook agent test failed: " + String(err))
        
    # Restore environment and urllib state
    urllib.urlopen = original_urlopen
    if original_gemini_key:
        os.environ["GEMINI_API_KEY"] = original_gemini_key
    else:
        if os.environ.get("GEMINI_API_KEY"):
            _ = os.environ.pop("GEMINI_API_KEY")

def main() raises:
    utils.console_log("🧪 Running test_pi_playbook.mojo")
    test_playbook_store()
    test_playbook_agent()
    utils.console_log("✅ test_pi_playbook.mojo PASSED\n")

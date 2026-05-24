import packages.agent.pi_agent_types as types
from std.python import Python, PythonObject
import t2m_runtime.utils as utils

def assert_equal(a: String, b: String) raises:
    if a != b:
        raise Error("Assertion failed: '" + a + "' != '" + b + "'")

def assert_true(cond: Bool, msg: String) raises:
    if not cond:
        raise Error("Assertion failed: " + msg)

def test_before_tool_call_result() raises:
    utils.console_log("  - test_before_tool_call_result")
    var res = types.BeforeToolCallResult(True, String("Safety constraint violation"))
    assert_true(res.block, "block should be true")
    assert_equal(res.reason, String("Safety constraint violation"))
    
    var res_py = res.to_py()
    var parsed = types.BeforeToolCallResult(res_py)
    assert_true(parsed.block, "block should be true")
    assert_equal(parsed.reason, String("Safety constraint violation"))

def test_after_tool_call_result() raises:
    utils.console_log("  - test_after_tool_call_result")
    var content_py = Python.evaluate("'success'")
    var details_py = Python.evaluate("{'duration': 120}")
    
    var res = types.AfterToolCallResult(content_py, details_py, False, True)
    assert_true(not res.isError, "isError should be false")
    assert_true(res.terminate, "terminate should be true")
    
    var res_py = res.to_py()
    var parsed = types.AfterToolCallResult(res_py)
    assert_true(not parsed.isError, "isError should be false")
    assert_true(parsed.terminate, "terminate should be true")

def test_agent_context() raises:
    utils.console_log("  - test_agent_context")
    var msg_list_py = Python.evaluate("[]")
    var tool_list_py = Python.evaluate("[]")
    
    var ctx = types.AgentContext(String("system instructions"), msg_list_py, tool_list_py)
    assert_equal(ctx.systemPrompt, String("system instructions"))
    
    var ctx_py = ctx.to_py()
    var parsed = types.AgentContext(ctx_py)
    assert_equal(parsed.systemPrompt, String("system instructions"))

def main() raises:
    utils.console_log("🧪 Running test_pi_agent_types.mojo")
    test_before_tool_call_result()
    test_after_tool_call_result()
    test_agent_context()
    utils.console_log("✅ test_pi_agent_types.mojo PASSED\n")

import packages.agent.pi_agent as agent
import packages.ai.pi_ai_types as ai
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

def test_agent_options() raises:
    utils.console_log("  - test_agent_options")
    
    var state_py = Python.evaluate("{'messages': []}")
    var convert_py = Python.evaluate("lambda x: x")
    var transform_py = Python.evaluate("lambda x: x")
    var stream_py = Python.evaluate("lambda x: x")
    var get_api_key_py = Python.evaluate("lambda: 'mock_key'")
    var on_payload_py = Python.evaluate("lambda x: None")
    var on_response_py = Python.evaluate("lambda x: None")
    var before_call_py = Python.evaluate("lambda x: None")
    var after_call_py = Python.evaluate("lambda x: None")
    var prepare_next_py = Python.evaluate("lambda x: None")
    var steering_py = Python.evaluate("'off'")
    var follow_up_py = Python.evaluate("'off'")
    var transport_py = Python.evaluate("None")
    var tool_exec_py = Python.evaluate("None")
    
    var budgets = ai.ThinkingBudgets(10, 20, 30, 40)
    
    var options = agent.AgentOptions(
        state_py,
        convert_py,
        transform_py,
        stream_py,
        get_api_key_py,
        on_payload_py,
        on_response_py,
        before_call_py,
        after_call_py,
        prepare_next_py,
        steering_py,
        follow_up_py,
        String("session-abc-123"),
        budgets,
        transport_py,
        1500,
        tool_exec_py
    )
    assert_equal(options.sessionId, String("session-abc-123"))
    assert_equal(options.maxRetryDelayMs, 1500)
    
    var options_py = options.to_py()
    var parsed = agent.AgentOptions(options_py)
    assert_equal(parsed.sessionId, String("session-abc-123"))
    assert_equal(parsed.maxRetryDelayMs, 1500)

def test_default_convert_to_llm() raises:
    utils.console_log("  - test_default_convert_to_llm")
    var msgs_py = Python.evaluate(
        "["
        "  {'role': 'user', 'content': 'hello'},"
        "  {'role': 'system', 'content': 'you are helpful'},"
        "  {'role': 'assistant', 'content': 'hi'}"
        "]"
    )
    var filtered = agent.defaultConvertToLlm(msgs_py)
    assert_equal(Int(py=Python.import_module("builtins").len(filtered)), 2)

def main() raises:
    utils.console_log("🧪 Running test_pi_agent.mojo")
    test_agent_options()
    test_default_convert_to_llm()
    utils.console_log("✅ test_pi_agent.mojo PASSED\n")

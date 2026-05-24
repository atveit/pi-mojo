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

def test_thinking_budgets() raises:
    utils.console_log("  - test_thinking_budgets")
    var budgets = ai.ThinkingBudgets(100, 200, 500, 1000)
    assert_equal(budgets.minimal, 100)
    assert_equal(budgets.low, 200)
    assert_equal(budgets.medium, 500)
    assert_equal(budgets.high, 1000)
    
    var budgets_py = budgets.to_py()
    var parsed_budgets = ai.ThinkingBudgets(budgets_py)
    assert_equal(parsed_budgets.minimal, 100)
    assert_equal(parsed_budgets.high, 1000)

def test_user_message() raises:
    utils.console_log("  - test_user_message")
    var role_py = Python.evaluate("'user'")
    var content_py = Python.evaluate("'hello world'")
    var user_msg = ai.UserMessage(role_py, content_py, 987654321)
    assert_equal(user_msg.timestamp, 987654321)
    
    var user_msg_py = user_msg.to_py()
    var parsed_user_msg = ai.UserMessage(user_msg_py)
    assert_equal(parsed_user_msg.timestamp, 987654321)

def test_usage() raises:
    utils.console_log("  - test_usage")
    var cost_py = Python.evaluate("0.0025")
    var usage = ai.Usage(200, 100, 20, 10, 300, cost_py)
    assert_equal(usage.input, 200)
    assert_equal(usage.output, 100)
    assert_equal(usage.totalTokens, 300)
    
    var usage_py = usage.to_py()
    var parsed_usage = ai.Usage(usage_py)
    assert_equal(parsed_usage.input, 200)
    assert_equal(parsed_usage.totalTokens, 300)

def test_tool() raises:
    utils.console_log("  - test_tool")
    var params_py = Python.evaluate("{'type': 'object', 'properties': {}}")
    var tool = ai.Tool(String("fetch_webpage"), String("downloads content"), params_py)
    assert_equal(tool.name, String("fetch_webpage"))
    assert_equal(tool.description, String("downloads content"))
    
    var tool_py = tool.to_py()
    var parsed_tool = ai.Tool(tool_py)
    assert_equal(parsed_tool.name, String("fetch_webpage"))
    assert_equal(parsed_tool.description, String("downloads content"))

def main() raises:
    utils.console_log("🧪 Running test_pi_ai_types.mojo")
    test_thinking_budgets()
    test_user_message()
    test_usage()
    test_tool()
    utils.console_log("✅ test_pi_ai_types.mojo PASSED\n")

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

def test_text_signature() raises:
    utils.console_log("  - test_text_signature")
    var py_v = Python.evaluate("'signature_v1'")
    var py_phase = Python.evaluate("'verification'")
    var sig = ai.TextSignatureV1(py_v, String("sig-987"), py_phase)
    assert_equal(sig.id, String("sig-987"))
    
    var sig_py = sig.to_py()
    var parsed = ai.TextSignatureV1(sig_py)
    assert_equal(parsed.id, String("sig-987"))

def test_text_content() raises:
    utils.console_log("  - test_text_content")
    var py_type = Python.evaluate("'text'")
    var content = ai.TextContent(py_type, String("hello world"), String("sig-123"))
    assert_equal(content.text, String("hello world"))
    assert_equal(content.textSignature, String("sig-123"))
    
    var content_py = content.to_py()
    var parsed = ai.TextContent(content_py)
    assert_equal(parsed.text, String("hello world"))
    assert_equal(parsed.textSignature, String("sig-123"))

def test_thinking_content() raises:
    utils.console_log("  - test_thinking_content")
    var py_type = Python.evaluate("'thinking'")
    var content = ai.ThinkingContent(py_type, String("rational thoughts"), String("tsig-456"), False)
    assert_equal(content.thinking, String("rational thoughts"))
    assert_equal(content.thinkingSignature, String("tsig-456"))
    assert_true(not content.redacted, "should not be redacted")
    
    var content_py = content.to_py()
    var parsed = ai.ThinkingContent(content_py)
    assert_equal(parsed.thinking, String("rational thoughts"))
    assert_equal(parsed.thinkingSignature, String("tsig-456"))
    assert_true(not parsed.redacted, "parsed should not be redacted")

def test_image_content() raises:
    utils.console_log("  - test_image_content")
    var py_type = Python.evaluate("'image'")
    var content = ai.ImageContent(py_type, String("base64_data"), String("image/png"))
    assert_equal(content.data, String("base64_data"))
    assert_equal(content.mimeType, String("image/png"))
    
    var content_py = content.to_py()
    var parsed = ai.ImageContent(content_py)
    assert_equal(parsed.data, String("base64_data"))
    assert_equal(parsed.mimeType, String("image/png"))

def test_tool_result_message() raises:
    utils.console_log("  - test_tool_result_message")
    var py_role = Python.evaluate("'tool'")
    var py_content = Python.evaluate("'success'")
    var py_details = Python.evaluate("{'code': 0}")
    
    var msg = ai.ToolResultMessage(py_role, String("call-id-9"), String("fetch"), py_content, py_details, False, 1600000)
    assert_equal(msg.toolCallId, String("call-id-9"))
    assert_equal(msg.toolName, String("fetch"))
    assert_true(not msg.isError, "should not be error")
    assert_equal(msg.timestamp, 1600000)
    
    var msg_py = msg.to_py()
    var parsed = ai.ToolResultMessage(msg_py)
    assert_equal(parsed.toolCallId, String("call-id-9"))
    assert_equal(parsed.timestamp, 1600000)

def test_provider_response() raises:
    utils.console_log("  - test_provider_response")
    var py_headers = Python.evaluate("{'Content-Type': 'application/json'}")
    var resp = ai.ProviderResponse(200, py_headers)
    assert_equal(resp.status, 200)
    
    var resp_py = resp.to_py()
    var parsed = ai.ProviderResponse(resp_py)
    assert_equal(parsed.status, 200)

def test_tool_call() raises:
    utils.console_log("  - test_tool_call")
    var py_type = Python.evaluate("'function'")
    var py_args = Python.evaluate("{'url': 'google.com'}")
    var call = ai.ToolCall(py_type, String("call-99"), String("fetch"), py_args, String("thought-sig"))
    assert_equal(call.id, String("call-99"))
    assert_equal(call.name, String("fetch"))
    assert_equal(call.thoughtSignature, String("thought-sig"))
    
    var call_py = call.to_py()
    var parsed = ai.ToolCall(call_py)
    assert_equal(parsed.id, String("call-99"))
    assert_equal(parsed.thoughtSignature, String("thought-sig"))

def test_assistant_message() raises:
    utils.console_log("  - test_assistant_message")
    var py_role = Python.evaluate("'assistant'")
    var py_content = Python.evaluate("'some output'")
    var py_api = Python.evaluate("'openai'")
    var py_prov = Python.evaluate("'provider-x'")
    var py_diag = Python.evaluate("{}")
    var py_stop = Python.evaluate("'stop'")
    
    var cost_py = Python.evaluate("0.001")
    var usage = ai.Usage(100, 50, 0, 0, 150, cost_py)
    
    var msg = ai.AssistantMessage(py_role, py_content, py_api, py_prov, String("gpt-4"), String("gpt-4-turbo"), String("resp-id-12"), py_diag, usage, py_stop, String(""), 1600000)
    assert_equal(msg.model, String("gpt-4"))
    assert_equal(msg.responseModel, String("gpt-4-turbo"))
    assert_equal(msg.responseId, String("resp-id-12"))
    assert_equal(msg.timestamp, 1600000)
    
    var msg_py = msg.to_py()
    var parsed = ai.AssistantMessage(msg_py)
    assert_equal(parsed.model, String("gpt-4"))
    assert_equal(parsed.timestamp, 1600000)

def test_assistant_images() raises:
    utils.console_log("  - test_assistant_images")
    var py_api = Python.evaluate("'openai'")
    var py_prov = Python.evaluate("'provider-x'")
    var py_out = Python.evaluate("['img1.png']")
    var py_stop = Python.evaluate("'stop'")
    
    var cost_py = Python.evaluate("0.001")
    var usage = ai.Usage(100, 50, 0, 0, 150, cost_py)
    
    var images = ai.AssistantImages(py_api, py_prov, String("dall-e-3"), py_out, String("resp-id-33"), usage, py_stop, String(""), 1600000)
    assert_equal(images.model, String("dall-e-3"))
    assert_equal(images.responseId, String("resp-id-33"))
    assert_equal(images.timestamp, 1600000)
    
    var images_py = images.to_py()
    var parsed = ai.AssistantImages(images_py)
    assert_equal(parsed.model, String("dall-e-3"))
    assert_equal(parsed.timestamp, 1600000)

def main() raises:
    utils.console_log("🧪 Running test_pi_ai_types.mojo")
    test_thinking_budgets()
    test_user_message()
    test_usage()
    test_tool()
    test_text_signature()
    test_text_content()
    test_thinking_content()
    test_image_content()
    test_tool_result_message()
    test_provider_response()
    test_tool_call()
    test_assistant_message()
    test_assistant_images()
    utils.console_log("✅ test_pi_ai_types.mojo PASSED\n")


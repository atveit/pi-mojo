import packages.agent.pi_agent_types as types
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

def test_before_tool_call_result() raises:
    utils.console_log("  - test_before_tool_call_result")
    var res = types.BeforeToolCallResult(True, String("Safety constraint violation"))
    assert_true(res.block, "block should be true")
    assert_equal(res.reason, String("Safety constraint violation"))
    
    # Copy constructor
    var copy_res = types.BeforeToolCallResult(copy=res)
    assert_true(copy_res.block, "copied block should be true")
    assert_equal(copy_res.reason, String("Safety constraint violation"))

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
    
    # Copy constructor
    var copy_res = types.AfterToolCallResult(copy=res)
    assert_true(not copy_res.isError, "copied isError should be false")
    assert_true(copy_res.terminate, "copied terminate should be true")

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
    
    # Copy constructor
    var copy_ctx = types.AgentContext(copy=ctx)
    assert_equal(copy_ctx.systemPrompt, String("system instructions"))

    var ctx_py = ctx.to_py()
    var parsed = types.AgentContext(ctx_py)
    assert_equal(parsed.systemPrompt, String("system instructions"))

def test_should_stop_after_turn_context() raises:
    utils.console_log("  - test_should_stop_after_turn_context")
    var py_role = Python.evaluate("'assistant'")
    var py_content = Python.evaluate("'some output'")
    var py_api = Python.evaluate("'openai'")
    var py_prov = Python.evaluate("'provider-x'")
    var py_diag = Python.evaluate("{}")
    var py_stop = Python.evaluate("'stop'")
    var cost_py = Python.evaluate("0.001")
    var usage = ai.Usage(100, 50, 0, 0, 150, cost_py)
    var assistant_msg = ai.AssistantMessage(py_role, py_content, py_api, py_prov, String("gpt-4"), String("gpt-4-turbo"), String("resp-id-12"), py_diag, usage, py_stop, String(""), 1600000)
    
    var tool_results_py = Python.evaluate("[]")
    var msg_list_py = Python.evaluate("[]")
    var tool_list_py = Python.evaluate("[]")
    var context = types.AgentContext(String("system instructions"), msg_list_py, tool_list_py)
    
    var stop_ctx = types.ShouldStopAfterTurnContext(assistant_msg, tool_results_py, context, msg_list_py)
    assert_equal(stop_ctx.message.model, String("gpt-4"))
    assert_equal(stop_ctx.context.systemPrompt, String("system instructions"))
    
    # Copy constructor
    var copy_ctx = types.ShouldStopAfterTurnContext(copy=stop_ctx)
    assert_equal(copy_ctx.message.model, String("gpt-4"))
    assert_equal(copy_ctx.context.systemPrompt, String("system instructions"))
    
    var stop_ctx_py = stop_ctx.to_py()
    var parsed = types.ShouldStopAfterTurnContext(stop_ctx_py)
    assert_equal(parsed.message.model, String("gpt-4"))
    assert_equal(parsed.context.systemPrompt, String("system instructions"))

def test_agent_loop_turn_update() raises:
    utils.console_log("  - test_agent_loop_turn_update")
    var msg_list_py = Python.evaluate("[]")
    var tool_list_py = Python.evaluate("[]")
    var context = types.AgentContext(String("system instructions"), msg_list_py, tool_list_py)
    var model_py = Python.evaluate("'gpt-4'")
    var thinking_level_py = Python.evaluate("'high'")
    
    var turn_update = types.AgentLoopTurnUpdate(context, model_py, thinking_level_py)
    assert_equal(turn_update.context.systemPrompt, String("system instructions"))
    
    # Copy constructor
    var copy_update = types.AgentLoopTurnUpdate(copy=turn_update)
    assert_equal(copy_update.context.systemPrompt, String("system instructions"))
    
    var turn_update_py = turn_update.to_py()
    var parsed = types.AgentLoopTurnUpdate(turn_update_py)
    assert_equal(parsed.context.systemPrompt, String("system instructions"))

def test_prepare_next_turn_context() raises:
    utils.console_log("  - test_prepare_next_turn_context")
    var py_role = Python.evaluate("'assistant'")
    var py_content = Python.evaluate("'some output'")
    var py_api = Python.evaluate("'openai'")
    var py_prov = Python.evaluate("'provider-x'")
    var py_diag = Python.evaluate("{}")
    var py_stop = Python.evaluate("'stop'")
    var cost_py = Python.evaluate("0.001")
    var usage = ai.Usage(100, 50, 0, 0, 150, cost_py)
    var assistant_msg = ai.AssistantMessage(py_role, py_content, py_api, py_prov, String("gpt-4"), String("gpt-4-turbo"), String("resp-id-12"), py_diag, usage, py_stop, String(""), 1600000)
    
    var tool_results_py = Python.evaluate("[]")
    var msg_list_py = Python.evaluate("[]")
    var tool_list_py = Python.evaluate("[]")
    var context = types.AgentContext(String("system instructions"), msg_list_py, tool_list_py)
    
    var next_ctx = types.PrepareNextTurnContext(assistant_msg, tool_results_py, context, msg_list_py)
    assert_equal(next_ctx.message.model, String("gpt-4"))
    assert_equal(next_ctx.context.systemPrompt, String("system instructions"))
    
    # Copy constructor
    var copy_ctx = types.PrepareNextTurnContext(copy=next_ctx)
    assert_equal(copy_ctx.message.model, String("gpt-4"))
    assert_equal(copy_ctx.context.systemPrompt, String("system instructions"))
    
    var next_ctx_py = next_ctx.to_py()
    var parsed = types.PrepareNextTurnContext(next_ctx_py)
    assert_equal(parsed.message.model, String("gpt-4"))
    assert_equal(parsed.context.systemPrompt, String("system instructions"))

def test_agent_loop_config() raises:
    utils.console_log("  - test_agent_loop_config")
    var model_py = Python.evaluate("'gpt-4'")
    var fn_py = Python.evaluate("lambda *args: None")
    var thinking_budgets = ai.ThinkingBudgets(10, 20, 30, 40)
    var signal_py = Python.evaluate("None")
    var transport_py = Python.evaluate("None")
    var cache_retention_py = Python.evaluate("None")
    var on_payload_py = Python.evaluate("None")
    var on_response_py = Python.evaluate("None")
    var headers_py = Python.evaluate("{}")
    var metadata_py = Python.evaluate("{}")
    
    var config = types.AgentLoopConfig(
        model_py, fn_py, fn_py, fn_py, fn_py, fn_py, fn_py, fn_py, fn_py, fn_py, fn_py, fn_py,
        thinking_budgets, 1, 256, signal_py, String("api-key-xyz"), transport_py, cache_retention_py,
        String("session-abc"), on_payload_py, on_response_py, headers_py, 5000, 3, 1000, metadata_py
    )
    assert_equal(config.temperature, 1)
    assert_equal(config.maxTokens, 256)
    assert_equal(config.apiKey, String("api-key-xyz"))
    assert_equal(config.sessionId, String("session-abc"))
    assert_equal(config.timeoutMs, 5000)
    assert_equal(config.maxRetries, 3)
    assert_equal(config.maxRetryDelayMs, 1000)
    assert_equal(config.thinkingBudgets.minimal, 10)
    
    # Copy constructor
    var copy_config = types.AgentLoopConfig(copy=config)
    assert_equal(copy_config.temperature, 1)
    assert_equal(copy_config.maxTokens, 256)
    assert_equal(copy_config.apiKey, String("api-key-xyz"))
    assert_equal(copy_config.sessionId, String("session-abc"))
    
    var config_py = config.to_py()
    var parsed = types.AgentLoopConfig(config_py)
    assert_equal(parsed.temperature, 1)
    assert_equal(parsed.maxTokens, 256)
    assert_equal(parsed.apiKey, String("api-key-xyz"))
    assert_equal(parsed.sessionId, String("session-abc"))

def test_custom_agent_messages() raises:
    utils.console_log("  - test_custom_agent_messages")
    var custom = types.CustomAgentMessages()
    var custom_py = custom.to_py()
    # It passes if no exceptions are thrown

def test_agent_state() raises:
    utils.console_log("  - test_agent_state")
    var model_py = Python.evaluate("'gpt-4'")
    var thinking_level_py = Python.evaluate("'medium'")
    var tools_py = Python.evaluate("[]")
    var messages_py = Python.evaluate("[]")
    var streaming_message_py = Python.evaluate("None")
    var pending_tool_calls_py = Python.evaluate("[]")
    
    var state = types.AgentState(
        String("system instructions"), model_py, thinking_level_py, tools_py, messages_py,
        True, streaming_message_py, pending_tool_calls_py, String("error-desc")
    )
    assert_equal(state.systemPrompt, String("system instructions"))
    assert_true(state.isStreaming, "should be streaming")
    assert_equal(state.errorMessage, String("error-desc"))
    
    # Copy constructor
    var copy_state = types.AgentState(copy=state)
    assert_equal(copy_state.systemPrompt, String("system instructions"))
    assert_true(copy_state.isStreaming, "copied should be streaming")
    assert_equal(copy_state.errorMessage, String("error-desc"))
    
    var state_py = state.to_py()
    var parsed = types.AgentState(state_py)
    assert_equal(parsed.systemPrompt, String("system instructions"))
    assert_true(parsed.isStreaming, "parsed should be streaming")
    assert_equal(parsed.errorMessage, String("error-desc"))

def test_before_tool_call_context() raises:
    utils.console_log("  - test_before_tool_call_context")
    var py_role = Python.evaluate("'assistant'")
    var py_content = Python.evaluate("'some output'")
    var py_api = Python.evaluate("'openai'")
    var py_prov = Python.evaluate("'provider-x'")
    var py_diag = Python.evaluate("{}")
    var py_stop = Python.evaluate("'stop'")
    var cost_py = Python.evaluate("0.001")
    var usage = ai.Usage(100, 50, 0, 0, 150, cost_py)
    var assistant_msg = ai.AssistantMessage(py_role, py_content, py_api, py_prov, String("gpt-4"), String("gpt-4-turbo"), String("resp-id-12"), py_diag, usage, py_stop, String(""), 1600000)
    
    var tool_call_py = Python.evaluate("{'name': 'fetch'}")
    var args_py = Python.evaluate("{'url': 'google.com'}")
    var msg_list_py = Python.evaluate("[]")
    var tool_list_py = Python.evaluate("[]")
    var context = types.AgentContext(String("system instructions"), msg_list_py, tool_list_py)
    
    var before_ctx = types.BeforeToolCallContext(assistant_msg, tool_call_py, args_py, context)
    assert_equal(before_ctx.assistantMessage.model, String("gpt-4"))
    assert_equal(before_ctx.context.systemPrompt, String("system instructions"))
    
    # Copy constructor
    var copy_ctx = types.BeforeToolCallContext(copy=before_ctx)
    assert_equal(copy_ctx.assistantMessage.model, String("gpt-4"))
    assert_equal(copy_ctx.context.systemPrompt, String("system instructions"))
    
    var before_ctx_py = before_ctx.to_py()
    var parsed = types.BeforeToolCallContext(before_ctx_py)
    assert_equal(parsed.assistantMessage.model, String("gpt-4"))
    assert_equal(parsed.context.systemPrompt, String("system instructions"))

def test_after_tool_call_context() raises:
    utils.console_log("  - test_after_tool_call_context")
    var py_role = Python.evaluate("'assistant'")
    var py_content = Python.evaluate("'some output'")
    var py_api = Python.evaluate("'openai'")
    var py_prov = Python.evaluate("'provider-x'")
    var py_diag = Python.evaluate("{}")
    var py_stop = Python.evaluate("'stop'")
    var cost_py = Python.evaluate("0.001")
    var usage = ai.Usage(100, 50, 0, 0, 150, cost_py)
    var assistant_msg = ai.AssistantMessage(py_role, py_content, py_api, py_prov, String("gpt-4"), String("gpt-4-turbo"), String("resp-id-12"), py_diag, usage, py_stop, String(""), 1600000)
    
    var tool_call_py = Python.evaluate("{'name': 'fetch'}")
    var args_py = Python.evaluate("{'url': 'google.com'}")
    var result_py = Python.evaluate("'success'")
    var msg_list_py = Python.evaluate("[]")
    var tool_list_py = Python.evaluate("[]")
    var context = types.AgentContext(String("system instructions"), msg_list_py, tool_list_py)
    
    var after_ctx = types.AfterToolCallContext(assistant_msg, tool_call_py, args_py, result_py, True, context)
    assert_equal(after_ctx.assistantMessage.model, String("gpt-4"))
    assert_true(after_ctx.isError, "should be error")
    assert_equal(after_ctx.context.systemPrompt, String("system instructions"))
    
    # Copy constructor
    var copy_ctx = types.AfterToolCallContext(copy=after_ctx)
    assert_equal(copy_ctx.assistantMessage.model, String("gpt-4"))
    assert_true(copy_ctx.isError, "copied should be error")
    assert_equal(copy_ctx.context.systemPrompt, String("system instructions"))
    
    var after_ctx_py = after_ctx.to_py()
    var parsed = types.AfterToolCallContext(after_ctx_py)
    assert_equal(parsed.assistantMessage.model, String("gpt-4"))
    assert_true(parsed.isError, "parsed should be error")
    assert_equal(parsed.context.systemPrompt, String("system instructions"))

def test_agent_tool_result() raises:
    utils.console_log("  - test_agent_tool_result")
    var content_py = Python.evaluate("'output'")
    var details_py = Python.evaluate("{'time': 10}")
    
    var res = types.AgentToolResult(content_py, details_py, True)
    assert_true(res.terminate, "terminate should be true")
    
    # Copy constructor
    var copy_res = types.AgentToolResult(copy=res)
    assert_true(copy_res.terminate, "copied terminate should be true")
    
    var res_py = res.to_py()
    var parsed = types.AgentToolResult(res_py)
    assert_true(parsed.terminate, "parsed terminate should be true")

def test_agent_tool() raises:
    utils.console_log("  - test_agent_tool")
    var prepare_args_py = Python.evaluate("lambda *args: None")
    var execute_py = Python.evaluate("lambda *args: None")
    var exec_mode_py = Python.evaluate("'async'")
    var params_py = Python.evaluate("{}")
    
    var tool = types.AgentTool(String("Fetch"), prepare_args_py, execute_py, exec_mode_py, String("fetch"), String("fetch url description"), params_py)
    assert_equal(tool.label, String("Fetch"))
    assert_equal(tool.name, String("fetch"))
    assert_equal(tool.description, String("fetch url description"))
    
    # Copy constructor
    var copy_tool = types.AgentTool(copy=tool)
    assert_equal(copy_tool.label, String("Fetch"))
    assert_equal(copy_tool.name, String("fetch"))
    assert_equal(copy_tool.description, String("fetch url description"))
    
    var tool_py = tool.to_py()
    var parsed = types.AgentTool(tool_py)
    assert_equal(parsed.label, String("Fetch"))
    assert_equal(parsed.name, String("fetch"))
    assert_equal(parsed.description, String("fetch url description"))

def main() raises:
    utils.console_log("🧪 Running test_pi_agent_types.mojo")
    test_before_tool_call_result()
    test_after_tool_call_result()
    test_agent_context()
    test_should_stop_after_turn_context()
    test_agent_loop_turn_update()
    test_prepare_next_turn_context()
    test_agent_loop_config()
    test_custom_agent_messages()
    test_agent_state()
    test_before_tool_call_context()
    test_after_tool_call_context()
    test_agent_tool_result()
    test_agent_tool()
    utils.console_log("✅ test_pi_agent_types.mojo PASSED\n")

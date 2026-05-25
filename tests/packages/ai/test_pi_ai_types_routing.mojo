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

def test_stream_options() raises:
    utils.console_log("  - test_stream_options")
    var signal_py = Python.evaluate("None")
    var transport_py = Python.evaluate("None")
    var cache_retention_py = Python.evaluate("None")
    var on_payload_py = Python.evaluate("None")
    var on_response_py = Python.evaluate("None")
    var headers_py = Python.evaluate("{}")
    var metadata_py = Python.evaluate("{}")

    var opts = ai.StreamOptions(
        1, 100, signal_py, String("api-key-123"), transport_py, cache_retention_py,
        String("session-123"), on_payload_py, on_response_py, headers_py, 1000, 2, 500, metadata_py
    )
    assert_equal(opts.temperature, 1)
    assert_equal(opts.maxTokens, 100)
    assert_equal(opts.apiKey, String("api-key-123"))
    assert_equal(opts.sessionId, String("session-123"))
    assert_equal(opts.timeoutMs, 1000)
    assert_equal(opts.maxRetries, 2)
    assert_equal(opts.maxRetryDelayMs, 500)

    # Copy constructor
    var copy_opts = ai.StreamOptions(copy=opts)
    assert_equal(copy_opts.apiKey, String("api-key-123"))
    assert_equal(copy_opts.sessionId, String("session-123"))

    var py_opts = opts.to_py()
    var parsed = ai.StreamOptions(py_opts)
    assert_equal(parsed.apiKey, String("api-key-123"))
    assert_equal(parsed.sessionId, String("session-123"))

def test_images_options() raises:
    utils.console_log("  - test_images_options")
    var signal_py = Python.evaluate("None")
    var on_payload_py = Python.evaluate("None")
    var on_response_py = Python.evaluate("None")
    var headers_py = Python.evaluate("{}")
    var metadata_py = Python.evaluate("{}")

    var opts = ai.ImagesOptions(
        signal_py, String("api-key-images"), on_payload_py, on_response_py, headers_py, 2000, 3, 1000, metadata_py
    )
    assert_equal(opts.apiKey, String("api-key-images"))
    assert_equal(opts.timeoutMs, 2000)
    assert_equal(opts.maxRetries, 3)

    # Copy constructor
    var copy_opts = ai.ImagesOptions(copy=opts)
    assert_equal(copy_opts.apiKey, String("api-key-images"))

    var py_opts = opts.to_py()
    var parsed = ai.ImagesOptions(py_opts)
    assert_equal(parsed.apiKey, String("api-key-images"))

def test_simple_stream_options() raises:
    utils.console_log("  - test_simple_stream_options")
    var reasoning_py = Python.evaluate("True")
    var thinking_budgets = ai.ThinkingBudgets(10, 20, 30, 40)
    var signal_py = Python.evaluate("None")
    var transport_py = Python.evaluate("None")
    var cache_retention_py = Python.evaluate("None")
    var on_payload_py = Python.evaluate("None")
    var on_response_py = Python.evaluate("None")
    var headers_py = Python.evaluate("{}")
    var metadata_py = Python.evaluate("{}")

    var opts = ai.SimpleStreamOptions(
        reasoning_py, thinking_budgets, 1, 150, signal_py, String("api-key-simple"), transport_py,
        cache_retention_py, String("session-simple"), on_payload_py, on_response_py, headers_py, 3000, 4, 2000, metadata_py
    )
    assert_equal(opts.temperature, 1)
    assert_equal(opts.maxTokens, 150)
    assert_equal(opts.apiKey, String("api-key-simple"))
    assert_equal(opts.thinkingBudgets.minimal, 10)

    # Copy constructor
    var copy_opts = ai.SimpleStreamOptions(copy=opts)
    assert_equal(copy_opts.apiKey, String("api-key-simple"))

    var py_opts = opts.to_py()
    var parsed = ai.SimpleStreamOptions(py_opts)
    assert_equal(parsed.apiKey, String("api-key-simple"))

def test_openrouter_routing() raises:
    utils.console_log("  - test_openrouter_routing")
    var data_coll_py = Python.evaluate("None")
    var list_py = Python.evaluate("[]")
    var num_py = Python.evaluate("10.0")

    var route = ai.OpenRouterRouting(
        True, False, data_coll_py, True, False, list_py, list_py, list_py, list_py,
        Python.evaluate("'price'"), num_py, num_py, num_py
    )
    assert_true(route.allow_fallbacks, "allow_fallbacks should be true")
    assert_true(not route.require_parameters, "require_parameters should be false")

    # Copy constructor
    var copy_route = ai.OpenRouterRouting(copy=route)
    assert_true(copy_route.allow_fallbacks, "allow_fallbacks should be true")

    var py_route = route.to_py()
    var parsed = ai.OpenRouterRouting(py_route)
    assert_true(parsed.allow_fallbacks, "allow_fallbacks should be true")

def test_vercel_gateway_routing() raises:
    utils.console_log("  - test_vercel_gateway_routing")
    var only_py = Python.evaluate("['provider1']")
    var order_py = Python.evaluate("['order1']")

    var route = ai.VercelGatewayRouting(only_py, order_py)

    # Copy constructor
    _ = ai.VercelGatewayRouting(copy=route)

    var py_route = route.to_py()
    var parsed = ai.VercelGatewayRouting(py_route)

def test_openai_completions_compat() raises:
    utils.console_log("  - test_openai_completions_compat")
    var order_py = Python.evaluate("[]")
    var openrouter = ai.OpenRouterRouting(
        True, False, None, True, False, order_py, order_py, order_py, order_py,
        Python.evaluate("'price'"), None, None, None
    )
    var vercel = ai.VercelGatewayRouting(order_py, order_py)

    var compat = ai.OpenAICompletionsCompat(
        True, False, True, False, Python.evaluate("'max_tokens'"), True, False, True, False,
        Python.evaluate("'text'"), openrouter, vercel, True, False, Python.evaluate("'headers'"), True, False
    )
    assert_true(compat.supportsStore, "supportsStore should be true")
    assert_true(not compat.supportsDeveloperRole, "supportsDeveloperRole should be false")
    assert_true(compat.supportsReasoningEffort, "supportsReasoningEffort should be true")

    # Copy constructor
    var copy_compat = ai.OpenAICompletionsCompat(copy=compat)
    assert_true(copy_compat.supportsStore, "copied supportsStore should be true")

    var py_compat = compat.to_py()
    var parsed = ai.OpenAICompletionsCompat(py_compat)
    assert_true(parsed.supportsStore, "parsed supportsStore should be true")

def test_openai_responses_compat() raises:
    utils.console_log("  - test_openai_responses_compat")
    var compat = ai.OpenAIResponsesCompat(True, False)
    assert_true(compat.sendSessionIdHeader, "sendSessionIdHeader should be true")
    assert_true(not compat.supportsLongCacheRetention, "supportsLongCacheRetention should be false")

    # Copy constructor
    var copy_compat = ai.OpenAIResponsesCompat(copy=compat)
    assert_true(copy_compat.sendSessionIdHeader, "copied sendSessionIdHeader should be true")

    var py_compat = compat.to_py()
    var parsed = ai.OpenAIResponsesCompat(py_compat)
    assert_true(parsed.sendSessionIdHeader, "parsed sendSessionIdHeader should be true")

def test_anthropic_messages_compat() raises:
    utils.console_log("  - test_anthropic_messages_compat")
    var compat = ai.AnthropicMessagesCompat(True, False, True, False, True)
    assert_true(compat.supportsEagerToolInputStreaming, "supportsEagerToolInputStreaming should be true")
    assert_true(compat.forceAdaptiveThinking, "forceAdaptiveThinking should be true")

    # Copy constructor
    var copy_compat = ai.AnthropicMessagesCompat(copy=compat)
    assert_true(copy_compat.supportsEagerToolInputStreaming, "copied supportsEagerToolInputStreaming should be true")

    var py_compat = compat.to_py()
    var parsed = ai.AnthropicMessagesCompat(py_compat)
    assert_true(parsed.supportsEagerToolInputStreaming, "parsed supportsEagerToolInputStreaming should be true")

def test_model() raises:
    utils.console_log("  - test_model")
    var api_py = Python.evaluate("'openai'")
    var provider_py = Python.evaluate("'openai'")
    var thinking_map_py = Python.evaluate("{}")
    var input_py = Python.evaluate("{}")
    var cost_py = Python.evaluate("0.0015")
    var headers_py = Python.evaluate("{}")
    var compat_py = Python.evaluate("None")

    var model = ai.Model(
        String("gpt-4"), String("GPT-4"), api_py, provider_py, String("https://api.openai.com"),
        True, thinking_map_py, input_py, cost_py, 8192, 2048, headers_py, compat_py
    )
    assert_equal(model.id, String("gpt-4"))
    assert_equal(model.name, String("GPT-4"))
    assert_equal(model.baseUrl, String("https://api.openai.com"))
    assert_true(model.reasoning, "reasoning should be true")
    assert_equal(model.contextWindow, 8192)
    assert_equal(model.maxTokens, 2048)

    # Copy constructor
    var copy_model = ai.Model(copy=model)
    assert_equal(copy_model.id, String("gpt-4"))

    var py_model = model.to_py()
    var parsed = ai.Model(py_model)
    assert_equal(parsed.id, String("gpt-4"))

def test_images_model() raises:
    utils.console_log("  - test_images_model")
    var api_py = Python.evaluate("'openai'")
    var provider_py = Python.evaluate("'openai'")
    var output_py = Python.evaluate("'url'")

    var model = ai.ImagesModel(api_py, provider_py, output_py)

    # Copy constructor
    _ = ai.ImagesModel(copy=model)

    var py_model = model.to_py()
    var parsed = ai.ImagesModel(py_model)

def main() raises:
    utils.console_log("🧪 Running test_pi_ai_types_routing.mojo")
    test_stream_options()
    test_images_options()
    test_simple_stream_options()
    test_openrouter_routing()
    test_vercel_gateway_routing()
    test_openai_completions_compat()
    test_openai_responses_compat()
    test_anthropic_messages_compat()
    test_model()
    test_images_model()
    utils.console_log("✅ test_pi_ai_types_routing.mojo PASSED\n")

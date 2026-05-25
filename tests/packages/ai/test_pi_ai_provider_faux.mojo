import packages.ai.pi_ai_provider_faux as faux
import packages.ai.pi_ai_types as ai
import packages.ai.pi_ai_stream as ai_stream
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

def test_token_estimation() raises:
    utils.console_log("  - test_token_estimation")
    var count = faux.estimateTokens(String("hello world from mojo language unit test!"))
    assert_true(count > 0, "token estimation should return positive integer")

def test_random_id() raises:
    utils.console_log("  - test_random_id")
    var id1 = faux.randomId(String("pi-test-prefix"))
    assert_true(id1.startswith("pi-test-prefix:"), "randomId should start with correct prefix and separator")

def test_common_prefix_length() raises:
    utils.console_log("  - test_common_prefix_length")
    var common_len = faux.commonPrefixLength(String("antigravity-agent"), String("antigravity-ai"))
    assert_equal(common_len, 13)
    
    var common_len_zero = faux.commonPrefixLength(String("mojo"), String("python"))
    assert_equal(common_len_zero, 0)

def test_faux_model_definition() raises:
    utils.console_log("  - test_faux_model_definition")
    var input_py = Python.evaluate("['text']")
    var cost_map_py = Python.evaluate("{}")
    var model_def = faux.FauxModelDefinition(
        String("model-1"), String("Model 1"), True, input_py, cost_map_py, 1000, 200
    )
    assert_equal(model_def.id, String("model-1"))
    assert_true(model_def.reasoning, "reasoning should be true")
    
    # Copy constructor
    var copy_def = faux.FauxModelDefinition(copy=model_def)
    assert_equal(copy_def.id, String("model-1"))
    
    var py_def = model_def.to_py()
    var parsed_def = faux.FauxModelDefinition(py_def)
    assert_equal(parsed_def.id, String("model-1"))

def test_register_faux_provider() raises:
    utils.console_log("  - test_register_faux_provider")
    
    var builtins = Python.import_module("builtins")
    var token_size_py = Python.evaluate("{'min': 1, 'max': 3}")
    var models_py = builtins.list()
    
    var opt = faux.RegisterFauxProviderOptions(
        String("custom-faux"), String("custom-provider"), models_py, 100, token_size_py
    )
    assert_equal(opt.api, String("custom-faux"))
    
    # Copy constructor
    var copy_opt = faux.RegisterFauxProviderOptions(copy=opt)
    assert_equal(copy_opt.api, String("custom-faux"))
    
    # Register the provider
    var registration = faux.registerFauxProvider(opt.to_py())
    assert_equal(registration.api, String("custom-faux"))
    
    # Test copy constructor on registration
    var copy_reg = faux.FauxProviderRegistration(copy=registration)
    assert_equal(copy_reg.api, String("custom-faux"))
    
    # Test state and responses
    var state = registration.state
    assert_equal(Int(py=state.callCount), 0)
    
    # Queue responses
    var responses = builtins.list()
    var cost_py = Python.evaluate("0.002")
    var usage = ai.Usage(10, 5, 0, 0, 15, cost_py)
    
    var py_role = Python.evaluate("'assistant'")
    var py_content = Python.evaluate("['mock-response-text']")
    var py_api = Python.evaluate("'custom-faux'")
    var py_prov = Python.evaluate("'custom-provider'")
    var py_diag = Python.evaluate("{}")
    var py_stop = Python.evaluate("'stop'")
    
    var assistant_msg = ai.AssistantMessage(
        py_role, py_content, py_api, py_prov, String("model-id"), String("model-id-turbo"),
        String("resp-abc"), py_diag, usage, py_stop, String(""), 1600000
    )
    _ = responses.append(assistant_msg.to_py())
    
    var set_resp_fn = registration.setResponses
    _ = set_resp_fn(responses)
    
    var count_fn = registration.getPendingResponseCount
    assert_equal(Int(py=count_fn()), 1)
    
    # Unregister provider
    var unreg_fn = registration.unregister
    _ = unreg_fn()

def test_resolve_api_provider() raises:
    utils.console_log("  - test_resolve_api_provider")
    
    # 1. Test resolving an unregistered API raises an error
    var unregistered = Python.evaluate("'nonexistent-api'")
    var raised = False
    try:
        _ = ai_stream.resolveApiProvider(unregistered)
    except:
        raised = True
    assert_true(raised, "Resolving an unregistered api should raise an error")

    # 2. Register a faux provider
    var builtins = Python.import_module("builtins")
    var token_size_py = Python.evaluate("{'min': 1, 'max': 3}")
    var models_py = builtins.list()
    var opt = faux.RegisterFauxProviderOptions(
        String("stream-test-api"), String("stream-test-provider"), models_py, 100, token_size_py
    )
    var registration = faux.registerFauxProvider(opt.to_py())
    
    # 3. Verify it resolves successfully now
    var resolved = ai_stream.resolveApiProvider(Python.evaluate("'stream-test-api'"))
    assert_equal(String(resolved.api), "stream-test-api")
    
    # Cleanup registered provider
    registration.unregister()

def test_streaming_and_completion() raises:
    utils.console_log("  - test_streaming_and_completion")
    
    # 1. Register a faux provider
    var builtins = Python.import_module("builtins")
    var token_size_py = Python.evaluate("{'min': 1, 'max': 3}")
    var models_py = builtins.list()
    var opt = faux.RegisterFauxProviderOptions(
        String("stream-exec-api"), String("stream-exec-provider"), models_py, 100, token_size_py
    )
    var registration = faux.registerFauxProvider(opt.to_py())
    
    # 2. Queue responses
    var responses = builtins.list()
    var cost_py = Python.evaluate("0.002")
    var usage = ai.Usage(10, 5, 0, 0, 15, cost_py)
    
    var py_role = Python.evaluate("'assistant'")
    var py_content = Python.evaluate("['mock stream response']")
    var py_api = Python.evaluate("'stream-exec-api'")
    var py_prov = Python.evaluate("'stream-exec-provider'")
    var py_diag = Python.evaluate("{}")
    var py_stop = Python.evaluate("'stop'")
    
    var assistant_msg = ai.AssistantMessage(
        py_role, py_content, py_api, py_prov, String("model-id"), String("model-id-turbo"),
        String("resp-abc"), py_diag, usage, py_stop, String(""), 1600000
    )
    _ = responses.append(assistant_msg.to_py())
    
    var set_resp_fn = registration.setResponses
    _ = set_resp_fn(responses)
    
    # 3. Create Model and Context
    var api_py = Python.evaluate("'stream-exec-api'")
    var provider_py = Python.evaluate("'stream-exec-provider'")
    var thinking_map_py = Python.evaluate("{}")
    var input_py = Python.evaluate("{}")
    var cost_map_py = Python.evaluate("0.0015")
    var headers_py = Python.evaluate("{}")
    var compat_py = Python.evaluate("None")

    var model = ai.Model(
        String("model-id"), String("Model Name"), api_py, provider_py, String("http://localhost"),
        True, thinking_map_py, input_py, cost_map_py, 8192, 2048, headers_py, compat_py
    )
    
    var messages_py = builtins.list()
    var tools_py = builtins.list()
    var context = ai.Context(String(""), messages_py, tools_py)
    
    # 4. Run streamSimple / completeSimple / stream / complete
    var provider = ai_stream.resolveApiProvider(model.api)
    var s = provider.streamSimple(model.to_py(), context.to_py(), Python.evaluate("None"))
    var res = s.result()
    print("Res:", res)
    
    # Cleanup registered provider
    registration.unregister()

def main() raises:
    utils.console_log("🧪 Running test_pi_ai_provider_faux.mojo")
    test_token_estimation()
    test_random_id()
    test_common_prefix_length()
    test_faux_model_definition()
    test_register_faux_provider()
    test_resolve_api_provider()
    test_streaming_and_completion()
    utils.console_log("✅ test_pi_ai_provider_faux.mojo PASSED\n")

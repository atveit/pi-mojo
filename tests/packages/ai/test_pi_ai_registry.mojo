import packages.ai.pi_ai_registry as registry
from std.python import Python, PythonObject
import t2m_runtime.utils as utils

def assert_equal(a: String, b: String) raises:
    if a != b:
        raise Error("Assertion failed: '" + a + "' != '" + b + "'")

def assert_true(cond: Bool, msg: String) raises:
    if not cond:
        raise Error("Assertion failed: " + msg)

def test_api_provider_structs() raises:
    utils.console_log("  - test_api_provider_structs")
    var api_py = Python.evaluate("'mock-api'")
    var stream_py = Python.evaluate("lambda: None")
    var stream_simple_py = Python.evaluate("lambda: None")
    
    var provider = registry.ApiProvider(api_py, stream_py, stream_simple_py)
    assert_equal(String(provider.api), "mock-api")
    
    var provider_py = provider.to_py()
    var parsed = registry.ApiProvider(provider_py)
    assert_equal(String(parsed.api), "mock-api")

def test_api_provider_internal() raises:
    utils.console_log("  - test_api_provider_internal")
    var api_py = Python.evaluate("'internal-mock'")
    var stream_py = Python.evaluate("lambda: None")
    var stream_simple_py = Python.evaluate("lambda: None")
    
    var provider = registry.ApiProviderInternal(api_py, stream_py, stream_simple_py)
    assert_equal(String(provider.api), "internal-mock")
    
    var provider_py = provider.to_py()
    var parsed = registry.ApiProviderInternal(provider_py)
    assert_equal(String(parsed.api), "internal-mock")

def main() raises:
    utils.console_log("🧪 Running test_pi_ai_registry.mojo")
    test_api_provider_structs()
    test_api_provider_internal()
    utils.console_log("✅ test_pi_ai_registry.mojo PASSED\n")

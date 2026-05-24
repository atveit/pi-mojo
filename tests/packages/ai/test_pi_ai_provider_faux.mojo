import packages.ai.pi_ai_provider_faux as faux
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

def main() raises:
    utils.console_log("🧪 Running test_pi_ai_provider_faux.mojo")
    test_token_estimation()
    test_random_id()
    test_common_prefix_length()
    utils.console_log("✅ test_pi_ai_provider_faux.mojo PASSED\n")

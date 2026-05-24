import packages.coding_agent.pi_coding_bash as bash
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

def test_bash_result() raises:
    utils.console_log("  - test_bash_result")
    var exit_code_py = Python.evaluate("0")
    var res = bash.BashResult(
        String("stdout content\nsecond line"),
        exit_code_py,
        False,
        False,
        String("/path/to/log.txt")
    )
    assert_equal(res.output, String("stdout content\nsecond line"))
    assert_equal(res.fullOutputPath, String("/path/to/log.txt"))
    assert_true(not res.cancelled, "cancelled should be false")
    assert_true(not res.truncated, "truncated should be false")
    
    var res_py = res.to_py()
    var parsed = bash.BashResult(res_py)
    assert_equal(parsed.output, String("stdout content\nsecond line"))
    assert_equal(parsed.fullOutputPath, String("/path/to/log.txt"))
    assert_true(not parsed.cancelled, "cancelled should be false")
    assert_true(not parsed.truncated, "truncated should be false")

def main() raises:
    utils.console_log("🧪 Running test_pi_coding_bash.mojo")
    test_bash_result()
    utils.console_log("✅ test_pi_coding_bash.mojo PASSED\n")

import packages.coding_agent.pi_coding_exec as exec_pkg
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

def test_exec_result() raises:
    utils.console_log("  - test_exec_result")
    var exec_res = exec_pkg.ExecResult(
        String("standard output"),
        String("error output"),
        1,
        True
    )
    assert_equal(exec_res.stdout, String("standard output"))
    assert_equal(exec_res.stderr, String("error output"))
    assert_equal(exec_res.code, 1)
    assert_true(exec_res.killed, "execution should be killed")
    
    var exec_res_py = exec_res.to_py()
    var parsed_exec_res = exec_pkg.ExecResult(exec_res_py)
    assert_equal(parsed_exec_res.stdout, String("standard output"))
    assert_equal(parsed_exec_res.stderr, String("error output"))
    assert_equal(parsed_exec_res.code, 1)
    assert_true(parsed_exec_res.killed, "execution should be killed")

def test_exec_options() raises:
    utils.console_log("  - test_exec_options")
    var builtins = Python.import_module("builtins")
    var g = builtins.dict()
    var signal = builtins.eval("type('MockSignal', (object,), {'aborted': False})()", g)

    var timeout = 5000
    var cwd = String("/Users/amund/workspace")
    
    var opts = exec_pkg.ExecOptions(signal, timeout, cwd)
    assert_true(Bool(opts.signal == signal), "signal should match")
    assert_equal(opts.timeout, timeout)
    assert_equal(opts.cwd, cwd)
    
    var opts_py = opts.to_py()
    var parsed = exec_pkg.ExecOptions(opts_py)
    assert_true(Bool(parsed.signal == signal), "parsed signal should match")
    assert_equal(parsed.timeout, timeout)
    assert_equal(parsed.cwd, cwd)


def main() raises:
    utils.console_log("🧪 Running test_pi_coding_exec.mojo")
    test_exec_result()
    test_exec_options()
    utils.console_log("✅ test_pi_coding_exec.mojo PASSED\n")


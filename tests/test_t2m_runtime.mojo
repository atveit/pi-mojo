import t2m_runtime.utils as utils
import t2m_runtime.fs_pure as fs
import t2m_runtime.llm as llm
import t2m_runtime.date as date
import t2m_runtime.timer as timer
from std.python import Python, PythonObject

def assert_equal(a: String, b: String) raises:
    if a != b:
        raise Error("Assertion failed: '" + a + "' != '" + b + "'")

def assert_equal(a: Int, b: Int) raises:
    if a != b:
        raise Error("Assertion failed: " + String(a) + " != " + String(b))

def assert_true(cond: Bool, msg: String) raises:
    if not cond:
        raise Error("Assertion failed: " + msg)

def test_string_view() raises:
    utils.console_log("Testing StringView Slicing...")
    var text = String("hello world")
    
    # 1. Slice String to StringView
    var view = utils.slice(text, 0, 5)
    assert_equal(view.byte_length(), 5)
    assert_equal(view.to_string(), String("hello"))
    
    # 2. Slice StringView to StringView (zero-copy sub-slicing)
    var subview = utils.slice(view, 1, 4)
    assert_equal(subview.byte_length(), 3)
    assert_equal(subview.to_string(), String("ell"))

def test_fs() raises:
    utils.console_log("Testing POSIX File Sync FFI...")
    var filename = String("temp_unit_test.txt")
    var content = String("Mojo POSIX FFI compiled unit testing works!")
    
    # Write file
    fs.writeFileSync(filename, content)
    
    # Read file back
    var read_content = fs.readFileSync(filename)
    assert_equal(read_content, content)
    
    # Delete file
    fs.rmSync(filename)

def test_clean_command() raises:
    utils.console_log("Testing llm clean_command...")
    assert_equal(llm.clean_command("```bash\nls -1\n```"), String("ls -1"))
    assert_equal(llm.clean_command("```sh\ndate\n```"), String("date"))
    assert_equal(llm.clean_command("  pwd  "), String("pwd"))

def test_date_and_timer() raises:
    utils.console_log("Testing Date & Timer FFI utilities...")
    var now_ms = date.Date.now()
    assert_true(now_ms > 0, "date.Date.now() should return a valid positive timestamp")
    
    var builtins = Python.import_module("builtins")
    var mock_callback = Python.evaluate("lambda: None")
    _ = timer.setTimeout(mock_callback, 10)

def main() raises:
    utils.console_log("=========================================================")
    utils.console_log("🧪 Running t2m_runtime Core Unit Tests")
    utils.console_log("=========================================================\n")
    
    test_string_view()
    test_fs()
    test_clean_command()
    test_date_and_timer()
    
    utils.console_log("\n=========================================================")
    utils.console_log("✅ All t2m_runtime Unit Tests PASSED Successfully")
    utils.console_log("=========================================================\n")

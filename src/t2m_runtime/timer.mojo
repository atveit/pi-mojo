from std.python import Python, PythonObject

def setTimeout(callback: PythonObject, delay_ms: Int) raises -> PythonObject:
    var time_mod = Python.import_module("time")
    _ = time_mod.sleep(Float64(delay_ms) / 1000.0)
    _ = callback()
    return None

def clearTimeout(timeout_id: PythonObject) raises:
    pass

from std.python import Python, PythonObject
from t2m_runtime.utils import _init_globals

def fetch(url: String) raises -> PythonObject:
    var g = _init_globals()
    var builtins = Python.import_module("builtins")
    var py_none = builtins.getattr(builtins, "None")
    return g["http_fetch"](url, py_none)

def fetch(url: String, init: PythonObject) raises -> PythonObject:
    var g = _init_globals()
    return g["http_fetch"](url, init)

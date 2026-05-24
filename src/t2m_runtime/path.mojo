from std.python import Python, PythonObject
from t2m_runtime.utils import _init_globals

def join(*paths: String) raises -> String:
    var g = _init_globals()
    var builtins = Python.import_module("builtins")
    var py_list = builtins.list()
    for path in paths:
        _ = py_list.append(path)
    return String(py=g["path_join"](py_list))

def resolve(*paths: String) raises -> String:
    var g = _init_globals()
    var builtins = Python.import_module("builtins")
    var py_list = builtins.list()
    for path in paths:
        _ = py_list.append(path)
    return String(py=g["path_resolve"](py_list))

def dirname(path: String) raises -> String:
    var os = Python.import_module("os.path")
    return String(py=os.dirname(path))

def basename(path: String) raises -> String:
    var os = Python.import_module("os.path")
    return String(py=os.basename(path))

def extname(path: String) raises -> String:
    var os = Python.import_module("os.path")
    return String(py=os.splitext(path)[1])

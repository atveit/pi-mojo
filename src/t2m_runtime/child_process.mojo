from std.ffi import OwnedDLHandle
from std.python import Python, PythonObject
from t2m_runtime.utils import _init_globals

def execSync(command: String) raises -> String:
    var lib = OwnedDLHandle("libSystem.B.dylib")
    var popen = lib.get_function[def(Int, Int) thin abi("C") -> Int]("popen")
    var pclose = lib.get_function[def(Int) thin abi("C") -> Int32]("pclose")
    var fgets = lib.get_function[def(Int, Int32, Int) thin abi("C") -> Int]("fgets")
    
    var cmd_null = command + "\0"
    var cmd_bytes = cmd_null.as_bytes()
    var mode = String("r\0")
    var mode_bytes = mode.as_bytes()
    
    var fp = popen(Int(cmd_bytes.unsafe_ptr()), Int(mode_bytes.unsafe_ptr()))
    if fp == 0:
        raise Error("Failed to spawn process for command: " + command)
        
    var buf = List[UInt8]()
    for _ in range(1024):
        buf.append(0)
    var buf_ptr = buf.unsafe_ptr()
    
    var output = String("")
    while fgets(Int(buf_ptr), 1024, fp) != 0:
        var chunk_len = 0
        for i in range(1024):
            if buf[i] == 0:
                chunk_len = i
                break
        var chunk = String("")
        for i in range(chunk_len):
            chunk += chr(Int(buf[i]))
        output += chunk
        
        for i in range(1024):
            buf[i] = 0
            
    _ = pclose(fp)
    return output

def execSync(command: String, options: PythonObject) raises -> String:
    return execSync(command)

def spawn(command: String) raises -> PythonObject:
    var g = _init_globals()
    var builtins = Python.import_module("builtins")
    var py_none = builtins.getattr(builtins, "None")
    return g["child_process_spawn"](command, py_none, py_none)

def spawn(command: String, args: PythonObject) raises -> PythonObject:
    var g = _init_globals()
    var builtins = Python.import_module("builtins")
    var py_none = builtins.getattr(builtins, "None")
    return g["child_process_spawn"](command, args, py_none)

def spawn(command: String, args: PythonObject, options: PythonObject) raises -> PythonObject:
    var g = _init_globals()
    return g["child_process_spawn"](command, args, options)

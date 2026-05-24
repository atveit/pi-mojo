from std.python import Python, PythonObject
from std.os import mkdir, makedirs, remove, rmdir
from std.os.path import exists, isdir, isfile

# Import pure functions and types from fs_pure
from t2m_runtime.fs_pure import JSStats, readFileSync, writeFileSync, existsSync, mkdirSync as pure_mkdirSync, rmSync as pure_rmSync, statSync

def mkdirSync(path: String) raises:
    pure_mkdirSync(path)

def mkdirSync(path: String, options: PythonObject) raises:
    var recursive = False
    try:
        recursive = Bool(py=options["recursive"])
    except:
        pass
    if recursive:
        makedirs(path)
    else:
        pure_mkdirSync(path)

def rmSync(path: String) raises:
    pure_rmSync(path)

def rmSync(path: String, options: PythonObject) raises:
    var recursive = False
    try:
        recursive = Bool(py=options["recursive"])
    except:
        pass
    if recursive:
        if isdir(path):
            var files = readdirSync(path)
            var builtins = Python.import_module("builtins")
            var files_len = Int(py=builtins.len(files))
            for i in range(files_len):
                var file_name = String(py=files[i])
                var sub_path = path + "/" + file_name
                rmSync(sub_path, options)
            rmdir(path)
        else:
            remove(path)
    else:
        pure_rmSync(path)

def readdirSync(path: String) raises -> PythonObject:
    var os_mod = Python.import_module("os")
    return os_mod.listdir(path)

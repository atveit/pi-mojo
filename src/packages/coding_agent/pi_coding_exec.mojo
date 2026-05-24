from std.python import Python, PythonObject
from t2m_runtime.timer import clearTimeout, setTimeout
from t2m_runtime.utils import Promise, _init_globals, get_property, objectIs, to_js_obj

struct ExecOptions(ImplicitlyCopyable):
    var signal: PythonObject
    var timeout: Int
    var cwd: String

    def __init__(out self, signal: PythonObject, timeout: Int, cwd: String):
        self.signal = signal
        self.timeout = timeout
        self.cwd = cwd

    def __init__(out self, *, copy: Self):
        self.signal = copy.signal
        self.timeout = copy.timeout
        self.cwd = copy.cwd

    def __init__(out self, py: PythonObject) raises:
        self.signal = get_property(py, "signal", None)
        self.timeout = Int(py=get_property(py, "timeout", 0))
        self.cwd = String(get_property(py, "cwd", ""))

    def to_py(self) raises -> PythonObject:
        var builtins = Python.import_module("builtins")
        var d = builtins.dict()
        d["signal"] = self.signal
        d["timeout"] = self.timeout
        d["cwd"] = self.cwd
        return d

struct ExecResult(ImplicitlyCopyable):
    var stdout: String
    var stderr: String
    var code: Int
    var killed: Bool

    def __init__(out self, stdout: String, stderr: String, code: Int, killed: Bool):
        self.stdout = stdout
        self.stderr = stderr
        self.code = code
        self.killed = killed

    def __init__(out self, *, copy: Self):
        self.stdout = copy.stdout
        self.stderr = copy.stderr
        self.code = copy.code
        self.killed = copy.killed

    def __init__(out self, py: PythonObject) raises:
        self.stdout = String(get_property(py, "stdout", ""))
        self.stderr = String(get_property(py, "stderr", ""))
        self.code = Int(py=get_property(py, "code", 0))
        self.killed = Bool(py=get_property(py, "killed", False))

    def to_py(self) raises -> PythonObject:
        var builtins = Python.import_module("builtins")
        var d = builtins.dict()
        d["stdout"] = self.stdout
        d["stderr"] = self.stderr
        d["code"] = self.code
        d["killed"] = self.killed
        return d

def execCommand(command: PythonObject, args: PythonObject, cwd: PythonObject, options: PythonObject = None) raises -> PythonObject:
    var builtins = Python.import_module("builtins")
    _init_module()
    var g = _init_globals()
    var code = """
def execCommand(command, args, cwd, options=None):
    command = to_js_obj(command)
    args = to_js_obj(args)
    cwd = to_js_obj(cwd)
    options = to_js_obj(options)
    def _closure_637(resolve):
        resolve = to_js_obj(resolve)
        _obj_180 = to_js_obj({"cwd": cwd, "shell": False, "stdio": JSList(["ignore", "pipe", "pipe"])})
        proc = spawn(command, args, _obj_180)
        stdout = ""
        stderr = ""
        killed = False
        timeoutId = None
        def _closure_286():
            nonlocal killed
            if not killed:
                killed = True
                proc.kill("SIGTERM")
                def _closure_283():
                    if not proc.killed:
                        proc.kill("SIGKILL")
                setTimeout(_closure_283, 5000)
        killProcess = _closure_286
        if options.signal:
            if options.signal.aborted:
                killProcess()
            else:
                _obj_343 = to_js_obj({"once": True})
                options.signal.addEventListener("abort", killProcess, _obj_343)
        if options.timeout and options.timeout > 0:
            def _closure_384():
                killProcess()
            timeoutId = setTimeout(_closure_384, options.timeout)
        def _closure_428(data):
            nonlocal stdout
            data = to_js_obj(data)
            stdout = stdout + data.toString()
        proc.stdout.on("data", _closure_428)
        def _closure_467(data):
            nonlocal stderr
            data = to_js_obj(data)
            stderr = stderr + data.toString()
        proc.stderr.on("data", _closure_467)
        def _closure_566(code):
            code = to_js_obj(code)
            if timeoutId:
                clearTimeout(timeoutId)
            if options.signal:
                options.signal.removeEventListener("abort", killProcess)
            _obj_566 = to_js_obj({"stdout": stdout, "stderr": stderr, "code": (code if not objectIs(code, None) else 0), "killed": killed})
            resolve(_obj_566)
        def _closure_636(_err):
            _err = to_js_obj(_err)
            if timeoutId:
                clearTimeout(timeoutId)
            if options.signal:
                options.signal.removeEventListener("abort", killProcess)
            _obj_635 = to_js_obj({"stdout": stdout, "stderr": stderr, "code": 1, "killed": killed})
            resolve(_obj_635)
        waitForChildProcess(proc).then(_closure_566).catch(_closure_636)
    return Promise(_closure_637)
    """
    try:
        builtins.exec(code, g)
    except e:
        var traceback_mod = Python.import_module("traceback")
        _ = traceback_mod.print_exc()
        raise e^
    var sys_mod = Python.import_module("sys")
    _ = sys_mod.stdout.flush()
    var res: PythonObject
    try:
        res = g["execCommand"](command, args, cwd, options)
    except e:
        var traceback_mod = Python.import_module("traceback")
        _ = traceback_mod.print_exc()
        raise e^
    return res

def _init_module() raises:
    var builtins = Python.import_module("builtins")
    var g = _init_globals()
    if builtins.bool(g.get("_module_init_0ab3a243", False)):
        return
    g["_module_init_0ab3a243"] = True
    var code = """

import time
import subprocess
import urllib.request
import math

def String(*args, **kwargs):
    if not args:
        return ""
    val = args[0]
    if val is None:
        return "null"
    if val is True:
        return "true"
    if val is False:
        return "false"
    return str(val)

def Int(*args, **kwargs):
    if "py" in kwargs:
        val = kwargs["py"]
    elif args:
        val = args[0]
    else:
        return 0
    if val is None:
        return 0
    try:
        return int(val)
    except:
        return 0

def Float64(*args, **kwargs):
    if "py" in kwargs:
        val = kwargs["py"]
    elif args:
        val = args[0]
    else:
        return 0.0
    if val is None:
        return 0.0
    try:
        return float(val)
    except:
        return 0.0

def Bool(*args, **kwargs):
    if "py" in kwargs:
        val = kwargs["py"]
    elif args:
        val = args[0]
    else:
        return False
    return bool(val)

def slice(obj, start=None, end=None):
    if obj is None:
        return ""
    if start is None and end is None:
        return obj[:]
    if end is None:
        return obj[start:]
    return obj[start:end]


class JSList(list):
    def map(self, fn):
        return JSList(fn(x) for x in self)
    def filter(self, fn):
        return JSList(x for x in self if fn(x))
    def find(self, fn):
        for x in self:
            if fn(x):
                return x
        return None
    def forEach(self, fn):
        for x in self:
            fn(x)
    def push(self, x):
        self.append(x)
        return len(self)
    def unshift(self, x):
        self.insert(0, x)
        return len(self)
    def shift(self):
        if self:
            return self.pop(0)
        return None
    def join(self, sep=""):
        return sep.join(str(x) for x in self)
    def some(self, fn):
        return any(fn(x) for x in self)
    def every(self, fn):
        return all(fn(x) for x in self)
    def includes(self, x):
        return x in self
    def indexOf(self, x):
        try:
            return self.index(x)
        except ValueError:
            return -1
    def concat(self, *args):
        res = JSList(self)
        for arg in args:
            if isinstance(arg, list):
                res.extend(arg)
            else:
                res.append(arg)
        return res


def ArrayFrom(iterable, map_fn=None):
    items = list(iterable)
    if map_fn:
        return JSList(map_fn(x) for x in items)
    return JSList(items)

def get_property(obj, name, default=None):
    if obj is None:
        return default
    if hasattr(obj, "get"):
        try:
            return obj.get(name, default)
        except:
            pass
    return getattr(obj, name, default)

def to_py_list(*args):
    if len(args) == 1:
        val = args[0]
        if isinstance(val, (list, tuple)):
            return JSList(val)
        return JSList([val])
    return JSList(args)

class PythonEmulator:
    @staticmethod
    def import_module(name):
        if name == "t2m_runtime.utils":
            class MockUtilsModule:
                def __init__(self):
                    self.Math = Math
                    self.Date = Date
                    self.slice = slice
                    self.to_py_list = to_js_obj
                    self.ArrayFrom = ArrayFrom
                    self.objectIs = objectIs
                    self.isArray = isArray
                    self.typeOf = typeOf
                    self.console_log = console_log
                    self.keys = keys
                    self.getOwnPropertyNames = getOwnPropertyNames
                    self.readFileSync = readFileSync
                    self.writeFileSync = writeFileSync
                    self.execSync = execSync
                    self.fetch = fetch
                    self.set_global = set_global
                    self.get_global = get_global
                    self.Promise = Promise
                    self.wait_promise = wait_promise
                    self.to_js_obj = to_js_obj
                    self.instanceOf = instanceOf
                    self.get_property = get_property
                    self.Map = Map
                    self.JSON = JSON
                    self.structuredClone = structuredClone
                    import builtins
                    g = getattr(builtins, "_t2m_globals", {})
                    self.validateToolArguments = g.get("validateToolArguments")
                    self.validateToolCall = g.get("validateToolCall")
            return MockUtilsModule()
        if name.startswith("test_datasets.pi"):
            import builtins
            class MockProjectModule:
                def __getattr__(self, attr):
                    g = getattr(builtins, "_t2m_globals", {})
                    return g.get(attr)
            return MockProjectModule()
        import importlib
        return importlib.import_module(name)

Python = PythonEmulator()

class JSString(str):
    def toString(self):
        return self
    def trim(self):
        return JSString(self.strip())
    def startsWith(self, prefix):
        return self.startswith(prefix)
    def endsWith(self, suffix):
        return self.endswith(suffix)
    def indexOf(self, sub, start=None):
        return self.find(sub, start)
    def includes(self, sub):
        return sub in self
    def substring(self, start, end=None):
        return JSString(self[start:end])
    def replace(self, old, new):
        return JSString(super().replace(old, new))

class JSUndefined:
    def __getattr__(self, name):
        return self
    def __getitem__(self, key):
        return self
    def __bool__(self):
        return False
    def __len__(self):
        return 0
    def __call__(self, *args, **kwargs):
        return self
    def __hash__(self):
        return hash(None)
    def __eq__(self, other):
        try:
            if other is None:
                return True
            if isinstance(other, JSUndefined):
                return True
            import builtins
            if isinstance(other, builtins.str):
                return other == "null" or other == "undefined"
            return False
        except:
            return False
    def __ne__(self, other):
        return not self.__eq__(other)

    def __repr__(self):
        return "undefined"
    def __str__(self):
        return "undefined"

class Map(dict):
    def get(self, key, default=None):
        res = super().get(key, default)
        if res is None:
            return JSUndefined()
        return res
    def set(self, key, value):
        self[key] = value
        return self
    def has(self, key):
        return key in self
    def delete(self, key):
        if key in self:
            del self[key]
            return True
        return False

class JSObject(dict):
    def toString(self):
        return str(self)
    def __getattr__(self, name):
        try:
            return self[name]
        except KeyError:
            return JSUndefined()
    def __getitem__(self, key):
        try:
            return super().__getitem__(key)
        except KeyError:
            return JSUndefined()
    def __setattr__(self, name, value):
        self[name] = value
    def update(self, other):
        if other is None:
            return
        if hasattr(other, "__dict__"):
            super().update(other.__dict__)
        elif isinstance(other, dict):
            super().update(other)
        else:
            try:
                super().update(other)
            except:
                import builtins
                for k in dir(other):
                    if not k.startswith("_") and not builtins.callable(getattr(other, k)):
                        self[k] = getattr(other, k)


def to_js_obj(val):
    if val is None:
        return JSUndefined()
    if isinstance(val, dict):
        if not isinstance(val, JSObject):
            return JSObject({k: to_js_obj(v) for k, v in val.items()})
        return val
    if isinstance(val, list):
        if not isinstance(val, JSList):
            return JSList([to_js_obj(x) for x in val])
        return val
    if isinstance(val, str) and not isinstance(val, JSString):
        return JSString(val)
    return val

class JSInt(int):
    def toString(self, radix=10):
        if radix == 36:
            import string
            chars = string.digits + string.ascii_lowercase
            n = int(self)
            if n == 0:
                return "0"
            res = ""
            while n > 0:
                res = chars[n % 36] + res
                n //= 36
            return res
        return str(self)

class JSFloat(float):
    def toString(self, radix=10):
        if radix == 36:
            import string
            chars = string.digits + string.ascii_lowercase
            val = float(self)
            int_part = int(val)
            frac_part = val - int_part
            int_str = ""
            if int_part == 0:
                int_str = "0"
            else:
                n = int_part
                while n > 0:
                    int_str = chars[n % 36] + int_str
                    n //= 36
            frac_str = []
            f = frac_part
            for _ in range(12):
                f *= 36
                digit = int(f)
                frac_str.append(chars[digit])
                f -= digit
                if f == 0:
                    break
            return int_str + "." + "".join(frac_str)
        return str(self)

class MathNamespace:
    @staticmethod
    def max(*args): return max(*args)
    @staticmethod
    def min(*args): return min(*args)
    @staticmethod
    def abs(x): return abs(x)
    @staticmethod
    def round(x): return round(x)
    @staticmethod
    def floor(x): return math.floor(x)
    @staticmethod
    def ceil(x): return math.ceil(x)
    @staticmethod
    def sqrt(x): return math.sqrt(x)
    @staticmethod
    def pow(x, y): return pow(x, y)
    @staticmethod
    def random():
        import random
        return JSFloat(random.random())
Math = MathNamespace()

class Date:
    @staticmethod
    def now():
        return JSInt(time.time() * 1000)

def setTimeout(callback, delay_ms):
    time.sleep(delay_ms / 1000.0)
    callback()
    return None

def clearTimeout(timeout_id):
    pass

def queueMicrotask(callback):
    callback()
    return None

def structuredClone(obj):
    import copy
    return copy.deepcopy(obj)


class Promise:
    def __init__(self, executor):
        self.value = None
        self.state = 'pending'
        self.callbacks = []
        self.err_callbacks = []
        def resolve(val=None):
            if self.state == 'pending':
                self.value = val
                self.state = 'resolved'
                for cb in self.callbacks:
                    try: cb(val)
                    except: pass
        def reject(err=None):
            if self.state == 'pending':
                self.value = err
                self.state = 'rejected'
                for cb in self.err_callbacks:
                    try: cb(err)
                    except: pass

        
        num_params = 2
        try:
            if hasattr(executor, "__code__"):
                num_params = executor.__code__.co_argcount
            elif hasattr(executor, "__call__") and hasattr(executor.__call__, "__code__"):
                num_params = executor.__call__.__code__.co_argcount - 1
        except:
            pass
            
        try:
            if num_params == 1:
                executor(resolve)
            else:
                executor(resolve, reject)
        except Exception as e:
            reject(e)

    def then(self, on_fulfilled, on_rejected=None):
        if self.state == 'resolved':
            try: on_fulfilled(self.value)
            except: pass
        elif self.state == 'pending':
            self.callbacks.append(on_fulfilled)
            if on_rejected:
                self.err_callbacks.append(on_rejected)
        return self

    def catch(self, on_rejected):
        if self.state == 'rejected':
            try: on_rejected(self.value)
            except: pass
        elif self.state == 'pending':
            self.err_callbacks.append(on_rejected)
        return self
    @staticmethod
    def resolve(val=None):
        return Promise(lambda resolve, reject: resolve(val))

    @staticmethod
    def all(promises):
        promises = list(promises)
        if not promises:
            return Promise(lambda resolve, reject: resolve(JSList([])))
        def executor(resolve, reject):
            results = [None] * len(promises)
            completed = [False] * len(promises)
            has_failed = [False]
            def make_resolver(idx):
                def resolver(val):
                    if has_failed[0]: return
                    results[idx] = val
                    completed[idx] = True
                    if all(completed):
                        resolve(JSList(results))
                return resolver
            def make_rejecter(idx):
                def rejecter(err):
                    if has_failed[0]: return
                    has_failed[0] = True
                    reject(err)
                return rejecter
            for idx, p in enumerate(promises):
                if hasattr(p, "then"):
                    p.then(make_resolver(idx), make_rejecter(idx))
                else:
                    make_resolver(idx)(p)
        return Promise(executor)


def wait_promise(promise):
    if promise is None:
        return None
    if hasattr(promise, 'state'):
        import time
        while getattr(promise, 'state') == 'pending':
            time.sleep(0.001)
        val = getattr(promise, 'value')
        if getattr(promise, 'state') == 'rejected':
            raise val if isinstance(val, Exception) else Exception(str(val))
        return val
    if hasattr(promise, 'result') and callable(promise.result):
        if not hasattr(promise, '__aiter__') and not hasattr(promise, '__iter__'):
            return wait_promise(promise.result())
    return promise

def objectIs(a, b):
    return a == b

def isArray(obj):
    return isinstance(obj, list)

def instanceOf(obj, cls_name):
    if cls_name == "Error":
        import builtins
        return isinstance(obj, builtins.BaseException)
    return str(type(obj)).find(cls_name) != -1

def typeOf(obj):
    if obj is None:
        return "object"
    if isinstance(obj, bool):
        return "boolean"
    if isinstance(obj, (int, float)):
        return "number"
    if isinstance(obj, str):
        return "string"
    if callable(obj):
        return "function"
    return "object"

def toNumber(obj):
    try:
        if isinstance(obj, str):
            if "." in obj:
                return float(obj)
            return int(obj)
        if isinstance(obj, bool):
            return 1 if obj else 0
        return float(obj)
    except:
        return float("nan")

def console_log(*args):
    parts = []
    for arg in args:
        if arg is True:
            parts.append("true")
        elif arg is False:
            parts.append("false")
        elif arg is None:
            parts.append("null")
        else:
            parts.append(str(arg))
    print(" ".join(parts))

def keys(obj):
    if isinstance(obj, list):
        return list(range(len(obj)))
    if hasattr(obj, "keys"):
        return list(obj.keys())
    return []

def getOwnPropertyNames(obj):
    if isinstance(obj, dict):
        return list(obj.keys())
    return list(dir(obj))

def readFileSync(path):
    with open(path, "r", encoding="utf-8") as f:
        return f.read()

def writeFileSync(path, content):
    with open(path, "w", encoding="utf-8") as f:
        f.write(content)

def execSync(command):
    return subprocess.run(command, shell=True, capture_output=True, text=True).stdout

def fetch(url):
    with urllib.request.urlopen(url) as response:
        return response.read().decode("utf-8")

def set_global(name, val):
    globals()[name] = val

def get_global(name):
    return globals().get(name)

class GlobalThis:
    def __getattr__(self, name):
        return globals().get(name)
globalThis = GlobalThis()

# ============================================================================
# Python-native child_process and streaming emulation
# ============================================================================
class PyChildProcess:
    def __init__(self, command, args, cwd=None, env=None):
        import subprocess
        import threading
        import sys
        
        all_args = [command] + list(args)
        self.proc = subprocess.Popen(
            all_args,
            cwd=cwd,
            env=env,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            text=True
        )
        self.stdout = PyStream(self.proc.stdout)
        self.stderr = PyStream(self.proc.stderr)
        self.killed = False
        self._exit_listeners = []
        self._error_listeners = []
        
        def wait_thread():
            try:
                code = self.proc.wait()
                self.stdout.join()
                self.stderr.join()
                for cb in list(self._exit_listeners):
                    try: cb(code)
                    except: pass
            except Exception as e:
                for cb in list(self._error_listeners):
                    try: cb(e)
                    except: pass
        
        threading.Thread(target=wait_thread, daemon=True).start()
        
    def on(self, event, callback):
        if event == 'exit':
            self._exit_listeners.append(callback)
            if self.proc.poll() is not None:
                callback(self.proc.returncode)
        elif event == 'error':
            self._error_listeners.append(callback)
            
    def kill(self, signal='SIGTERM'):
        self.killed = True
        self.proc.kill()

class PyStream:
    def __init__(self, stream):
        import threading
        self.stream = stream
        self._listeners = []
        self._thread = threading.Thread(target=self._read, daemon=True)
        self._thread.start()
        
    def on(self, event, callback):
        if event == 'data':
            self._listeners.append(callback)
            
    def _read(self):
        while True:
            line = self.stream.readline()
            if not line:
                break
            for cb in list(self._listeners):
                try: cb(line)
                except: pass
                
    def join(self):
        self._thread.join(timeout=0.1)

def spawn(command, args, options=None):
    cwd = None
    if options:
        cwd = options.get('cwd')
    return PyChildProcess(command, args, cwd=cwd)

def waitForChildProcess(proc):
    return Promise(lambda resolve, reject: proc.on('exit', resolve))

# ============================================================================
# api-registry and stream emulation
# ============================================================================
if 'apiProviderRegistry' not in globals():
    apiProviderRegistry = {}

def registerApiProvider(provider, sourceId):
    api = provider.get('api') if hasattr(provider, 'get') else getattr(provider, 'api', None)
    if api:
        apiProviderRegistry[api] = to_js_obj({"provider": provider, "sourceId": sourceId})

def unregisterApiProviders(sourceId):
    to_delete = [k for k, v in apiProviderRegistry.items() if v.get("sourceId") == sourceId]
    for k in to_delete:
        del apiProviderRegistry[k]

def getApiProvider(api):
    res = apiProviderRegistry.get(api)
    return res.get('provider') if res else None

def getApiProviders():
    return list(apiProviderRegistry.values())

def resolveApiProvider(api):
    p = getApiProvider(api)
    if not p:
        raise ValueError("No API provider registered for api: " + str(api))
    return p

def stream(model, context, options):
    api = model.get('api') if hasattr(model, 'get') else getattr(model, 'api', None)
    provider = resolveApiProvider(api)
    s = provider.get('stream') if hasattr(provider, 'get') else getattr(provider, 'stream', None)
    return s(model, context, options)

def complete(model, context, options):
    s = stream(model, context, options)
    return s.result()

def streamSimple(model, context, options):
    api = model.get('api') if hasattr(model, 'get') else getattr(model, 'api', None)
    provider = resolveApiProvider(api)
    s_simple = provider.get('streamSimple') if hasattr(provider, 'get') else getattr(provider, 'streamSimple', None)
    return s_simple(model, context, options)

def completeSimple(model, context, options):
    s = streamSimple(model, context, options)
    return s.result()

# ============================================================================
# coding-agent tools helpers
# ============================================================================
def stripAnsi(text):
    import re
    return re.sub(r'\\x1B(?:[@-Z\\\\-_]|\\[[0-9?]*[ -/]*[@-~])', '', text)

def sanitizeBinaryOutput(text):
    return ''.join(c if (32 <= ord(c) < 127 or c in '\\n\\r\\t') else '?' for c in text)

def truncateTail(content, options=None):
    maxBytes = 1000000
    maxLines = 10000
    if options:
        maxBytes = options.get('maxBytes', maxBytes)
        maxLines = options.get('maxLines', maxLines)
    
    lines = content.splitlines()
    truncated = False
    if len(lines) > maxLines:
        lines = lines[-maxLines:]
        truncated = True
    
    truncated_content = "\\n".join(lines)
    b_content = truncated_content.encode('utf-8')
    if len(b_content) > maxBytes:
        b_content = b_content[-maxBytes:]
        truncated_content = b_content.decode('utf-8', errors='ignore')
        truncated = True
        
    return {"content": truncated_content, "truncated": truncated}

DEFAULT_MAX_BYTES = 1000000
DEFAULT_MAX_LINES = 10000

class JSONNamespace:
    @staticmethod
    def stringify(obj, *args, **kwargs):
        import json
        def to_standard(x):
            if isinstance(x, dict):
                return {k: to_standard(v) for k, v in x.items()}
            if isinstance(x, list):
                return [to_standard(v) for v in x]
            if x is None or str(type(x)).find("JSUndefined") != -1:
                return None
            if hasattr(x, "to_py"):
                try:
                    py_val = x.to_py()
                    if py_val is not x:
                        return to_standard(py_val)
                except:
                    pass
            if hasattr(x, "__dict__"):
                return {k: to_standard(v) for k, v in x.__dict__.items() if not k.startswith("_")}
            if not isinstance(x, (str, int, float, bool)):
                return str(x)
            return x
        return json.dumps(to_standard(obj))
        
    @staticmethod
    def parse(s, *args, **kwargs):
        import json
        return to_js_obj(json.loads(s))
JSON = JSONNamespace()

def safe_call(fn, *args):
    import inspect
    try:
        sig = inspect.signature(fn)
        params = list(sig.parameters.values())
        has_var_positional = any(p.kind == inspect.Parameter.VAR_POSITIONAL for p in params)
        if has_var_positional:
            return fn(*args)
        max_args = 0
        for p in params:
            if p.kind in (inspect.Parameter.POSITIONAL_ONLY, inspect.Parameter.POSITIONAL_OR_KEYWORD):
                max_args += 1
        if len(args) > max_args:
            return fn(*args[:max_args])
        return fn(*args)
    except:
        return fn(*args)

def validateToolArguments(*args, **kwargs):
    import builtins
    g = getattr(builtins, "_t2m_globals", {})
    fn = g.get("validateToolArguments")
    if fn:
        return fn(*args, **kwargs)
    raise NameError("validateToolArguments is not defined in _t2m_globals")

def validateToolCall(*args, **kwargs):
    import builtins
    g = getattr(builtins, "_t2m_globals", {})
    fn = g.get("validateToolCall")
    if fn:
        return fn(*args, **kwargs)
    raise NameError("validateToolCall is not defined in _t2m_globals")


class ExecOptions:
    def __init__(self, *args, **kwargs):
        if len(args) == 1 and args[0] is not None and not isinstance(args[0], (int, float, str, bool)):
            obj = args[0]
            self.signal = obj.get('signal') if hasattr(obj, 'get') else getattr(obj, 'signal', None)
            self.timeout = obj.get('timeout') if hasattr(obj, 'get') else getattr(obj, 'timeout', None)
            self.cwd = obj.get('cwd') if hasattr(obj, 'get') else getattr(obj, 'cwd', None)
        else:
            self.signal = args[0] if 0 < len(args) else kwargs.get('signal', None)
            self.timeout = args[1] if 1 < len(args) else kwargs.get('timeout', None)
            self.cwd = args[2] if 2 < len(args) else kwargs.get('cwd', None)
    def to_py(self):
        return self

class ExecResult:
    def __init__(self, *args, **kwargs):
        if len(args) == 1 and args[0] is not None and not isinstance(args[0], (int, float, str, bool)):
            obj = args[0]
            self.stdout = obj.get('stdout') if hasattr(obj, 'get') else getattr(obj, 'stdout', None)
            self.stderr = obj.get('stderr') if hasattr(obj, 'get') else getattr(obj, 'stderr', None)
            self.code = obj.get('code') if hasattr(obj, 'get') else getattr(obj, 'code', None)
            self.killed = obj.get('killed') if hasattr(obj, 'get') else getattr(obj, 'killed', None)
        else:
            self.stdout = args[0] if 0 < len(args) else kwargs.get('stdout', None)
            self.stderr = args[1] if 1 < len(args) else kwargs.get('stderr', None)
            self.code = args[2] if 2 < len(args) else kwargs.get('code', None)
            self.killed = args[3] if 3 < len(args) else kwargs.get('killed', None)
    def to_py(self):
        return self

def execCommand(command, args, cwd, options=None):
    command = to_js_obj(command)
    args = to_js_obj(args)
    cwd = to_js_obj(cwd)
    options = to_js_obj(options)
    def _closure_637(resolve):
        resolve = to_js_obj(resolve)
        _obj_180 = to_js_obj({"cwd": cwd, "shell": False, "stdio": JSList(["ignore", "pipe", "pipe"])})
        proc = spawn(command, args, _obj_180)
        stdout = ""
        stderr = ""
        killed = False
        timeoutId = None
        def _closure_286():
            nonlocal killed
            if not killed:
                killed = True
                proc.kill("SIGTERM")
                def _closure_283():
                    if not proc.killed:
                        proc.kill("SIGKILL")
                setTimeout(_closure_283, 5000)
        killProcess = _closure_286
        if options.signal:
            if options.signal.aborted:
                killProcess()
            else:
                _obj_343 = to_js_obj({"once": True})
                options.signal.addEventListener("abort", killProcess, _obj_343)
        if options.timeout and options.timeout > 0:
            def _closure_384():
                killProcess()
            timeoutId = setTimeout(_closure_384, options.timeout)
        def _closure_428(data):
            nonlocal stdout
            data = to_js_obj(data)
            stdout = stdout + data.toString()
        proc.stdout.on("data", _closure_428)
        def _closure_467(data):
            nonlocal stderr
            data = to_js_obj(data)
            stderr = stderr + data.toString()
        proc.stderr.on("data", _closure_467)
        def _closure_566(code):
            code = to_js_obj(code)
            if timeoutId:
                clearTimeout(timeoutId)
            if options.signal:
                options.signal.removeEventListener("abort", killProcess)
            _obj_566 = to_js_obj({"stdout": stdout, "stderr": stderr, "code": (code if not objectIs(code, None) else 0), "killed": killed})
            resolve(_obj_566)
        def _closure_636(_err):
            _err = to_js_obj(_err)
            if timeoutId:
                clearTimeout(timeoutId)
            if options.signal:
                options.signal.removeEventListener("abort", killProcess)
            _obj_635 = to_js_obj({"stdout": stdout, "stderr": stderr, "code": 1, "killed": killed})
            resolve(_obj_635)
        waitForChildProcess(proc).then(_closure_566).catch(_closure_636)
    return Promise(_closure_637)
    """
    try:
        builtins.exec(code, g)
    except e:
        var traceback_mod = Python.import_module("traceback")
        _ = traceback_mod.print_exc()
        raise e^

def main() raises:
    _init_module()

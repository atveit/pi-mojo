from std.python import Python, PythonObject

struct Math:
    @staticmethod
    def ceil(val: PythonObject) raises -> PythonObject:
        var math = Python.import_module("math")
        return math.ceil(val)

    @staticmethod
    def floor(val: PythonObject) raises -> PythonObject:
        var math = Python.import_module("math")
        return math.floor(val)

    @staticmethod
    def max(a: PythonObject, b: PythonObject) raises -> PythonObject:
        var builtins = Python.import_module("builtins")
        return builtins.max(a, b)

    @staticmethod
    def min(a: PythonObject, b: PythonObject) raises -> PythonObject:
        var builtins = Python.import_module("builtins")
        return builtins.min(a, b)

    @staticmethod
    def random() raises -> PythonObject:
        var random = Python.import_module("random")
        return random.random()

def structuredClone(obj: PythonObject) raises -> PythonObject:
    var copy_mod = Python.import_module("copy")
    return copy_mod.deepcopy(obj)

def isArray(obj: PythonObject) raises -> Bool:
    var builtins = Python.import_module("builtins")
    return Bool(py=builtins.isinstance(obj, builtins.list))

def getTypeName(obj: PythonObject) raises -> String:
    if not obj:
        return "None"
    return String(py=obj.__class__.__name__)

def isNaN(obj: PythonObject) raises -> Bool:
    var math = Python.import_module("math")
    return Bool(py=math.isnan(obj))

def objectIs(a: PythonObject, b: PythonObject) raises -> Bool:
    var builtins = Python.import_module("builtins")
    if builtins.id(a) == builtins.id(b):
        return True
    try:
        var res = a == b
        if builtins.id(res) == builtins.id(builtins.NotImplemented):
            return False
        return Bool(py=res)
    except:
        return False


def console_log(*args: PythonObject) raises:
    var builtins = Python.import_module("builtins")
    var parts = builtins.list()
    for arg in args:
        if builtins.isinstance(arg, builtins.bool):
            if Bool(py=arg):
                _ = parts.append("true")
            else:
                _ = parts.append("false")
        elif arg is None:
            _ = parts.append("null")
        else:
            _ = parts.append(builtins.str(arg))
    print(builtins.str(" ").join(parts))

def keys(obj: PythonObject) raises -> PythonObject:
    var builtins = Python.import_module("builtins")
    if builtins.isinstance(obj, builtins.list):
        # Return indices as string keys or just integers?
        # In JS they are strings, but integers are usually more useful/compatible in Mojo.
        # Let's return range list.
        return builtins.list(builtins.range(builtins.len(obj)))
    try:
        return obj.keys()
    except:
        return builtins.list()

def typeOf(obj: PythonObject) raises -> String:
    var builtins = Python.import_module("builtins")
    if not obj:
        return "object"
    if builtins.isinstance(obj, builtins.bool):
        return "boolean"
    if builtins.isinstance(obj, builtins.int) or builtins.isinstance(obj, builtins.float):
        return "number"
    if builtins.isinstance(obj, builtins.str):
        return "string"
    if builtins.callable(obj):
        return "function"
    return "object"

def toNumber(obj: PythonObject) raises -> PythonObject:
    var builtins = Python.import_module("builtins")
    try:
        if builtins.isinstance(obj, builtins.str):
            if builtins.str(".") in obj:
                return builtins.float(obj)
            return builtins.int(obj)
        if builtins.isinstance(obj, builtins.bool):
            return 1 if Bool(py=obj) else 0
        return builtins.float(obj)
    except:
        var math = Python.import_module("math")
        return math.nan

def _init_globals() raises -> PythonObject:
    var builtins = Python.import_module("builtins")
    var sys = Python.import_module("sys")
    var os = Python.import_module("os")
    var cwd = os.getcwd()
    var src_path = os.path.join(cwd, "src")
    if not sys.path.count(cwd):
        _ = sys.path.insert(0, cwd)
    if not sys.path.count(src_path):
        _ = sys.path.insert(0, src_path)
    if not sys.path.count(""):
        _ = sys.path.insert(0, "")
    if not builtins.hasattr(builtins, "_t2m_globals"):
        var d = builtins.dict()
        var py_globals = builtins.dict()
        builtins.exec(
            "class GlobalThis:\n"
            "    def __getattr__(self, name):\n"
            "        return None\n"
            "global_this = GlobalThis()\n"
            "class JSString(str):\n"
            "    def toString(self):\n"
            "        return self\n"
            "    def trim(self):\n"
            "        return JSString(self.strip())\n"
            "    def startsWith(self, prefix):\n"
            "        return self.startswith(prefix)\n"
            "    def endsWith(self, suffix):\n"
            "        return self.endswith(suffix)\n"
            "    def indexOf(self, sub, start=None):\n"
            "        return self.find(sub, start)\n"
            "    def includes(self, sub):\n"
            "        return sub in self\n"
            "    def substring(self, start, end=None):\n"
            "        return JSString(self[start:end])\n"
            "    def replace(self, old, new):\n"
            "        return JSString(super().replace(old, new))\n"
            "class JSObject(dict):\n"
            "    def toString(self):\n"
            "        return str(self)\n"
            "    def __getattr__(self, name):\n"
            "        try: return self[name]\n"
            "        except KeyError: return None\n"
            "    def __setattr__(self, name, value):\n"
            "        self[name] = value\n"
            "def to_js_obj(val):\n"
            "    import builtins\n"
            "    if isinstance(val, builtins.dict):\n"
            "        if not isinstance(val, JSObject):\n"
            "            return JSObject({k: to_js_obj(v) for k, v in val.items()})\n"
            "        return val\n"
            "    if isinstance(val, builtins.list):\n"
            "        return [to_js_obj(x) for x in val]\n"
            "    if isinstance(val, builtins.str) and not isinstance(val, JSString):\n"
            "        return JSString(val)\n"
            "    return val\n"
            "class PyPromise:\n"
            "    def __init__(self, executor):\n"
            "        self.value = None\n"
            "        self.state = 'pending'\n"
            "        self.callbacks = []\n"
            "        self.err_callbacks = []\n"
            "        def resolve(val):\n"
            "            if self.state == 'pending':\n"
            "                val_coerced = to_js_obj(val)\n"
            "                self.value = val_coerced\n"
            "                self.state = 'resolved'\n"
            "                for cb in self.callbacks:\n"
            "                    try: cb(val_coerced)\n"
            "                    except: pass\n"
            "        def reject(err):\n"
            "            if self.state == 'pending':\n"
            "                self.value = err\n"
            "                self.state = 'rejected'\n"
            "                for cb in self.err_callbacks:\n"
            "                    try: cb(err)\n"
            "                    except: pass\n"
            "        num_params = 2\n"
            "        try:\n"
            "            if hasattr(executor, '__code__'):\n"
            "                num_params = executor.__code__.co_argcount\n"
            "            elif hasattr(executor, '__call__') and hasattr(executor.__call__, '__code__'):\n"
            "                num_params = executor.__call__.__code__.co_argcount - 1\n"
            "        except:\n"
            "            pass\n"
            "        try:\n"
            "            if num_params == 1:\n"
            "                executor(resolve)\n"
            "            else:\n"
            "                executor(resolve, reject)\n"
            "        except Exception as e:\n"
            "            reject(e)\n"
            "    def then(self, on_fulfilled, on_rejected=None):\n"
            "        if self.state == 'resolved':\n"
            "            try: on_fulfilled(self.value)\n"
            "            except: pass\n"
            "        elif self.state == 'pending':\n"
            "            self.callbacks.append(on_fulfilled)\n"
            "            if on_rejected:\n"
            "                self.err_callbacks.append(on_rejected)\n"
            "        return self\n"
            "    def catch(self, on_rejected):\n"
            "        if self.state == 'rejected':\n"
            "            try: on_rejected(self.value)\n"
            "            except: pass\n"
            "        elif self.state == 'pending':\n"
            "            self.err_callbacks.append(on_rejected)\n"
            "        return self\n"
            "    @staticmethod\n"
            "    def resolve(val=None):\n"
            "        return PyPromise(lambda resolve, reject: resolve(val))\n"
            "    @staticmethod\n"
            "    def all(promises):\n"
            "        promises = list(promises)\n"
            "        if not promises:\n"
            "            return PyPromise(lambda resolve, reject: resolve([]))\n"
            "        def executor(resolve, reject):\n"
            "            results = [None] * len(promises)\n"
            "            completed = [False] * len(promises)\n"
            "            has_failed = [False]\n"
            "            def make_resolver(idx):\n"
            "                def resolver(val):\n"
            "                    if has_failed[0]: return\n"
            "                    results[idx] = val\n"
            "                    completed[idx] = True\n"
            "                    if all(completed):\n"
            "                        resolve(results)\n"
            "                return resolver\n"
            "            def make_rejecter(idx):\n"
            "                def rejecter(err):\n"
            "                    if has_failed[0]: return\n"
            "                    has_failed[0] = True\n"
            "                    reject(err)\n"
            "                return rejecter\n"
            "            for idx, p in enumerate(promises):\n"
            "                if hasattr(p, 'then'):\n"
            "                    p.then(make_resolver(idx), make_rejecter(idx))\n"
            "                else:\n"
            "                    make_resolver(idx)(p)\n"
            "        return PyPromise(executor)\n"
            "class Map:\n"
            "    def __init__(self):\n"
            "        self._dict = {}\n"
            "    def set(self, key, val):\n"
            "        self._dict[key] = val\n"
            "        return self\n"
            "    def get(self, key):\n"
            "        return self._dict.get(key, None)\n"
            "    def has(self, key):\n"
            "        return key in self._dict\n"
            "    def delete(self, key):\n"
            "        if key in self._dict:\n"
            "            del self._dict[key]\n"
            "            return True\n"
            "        return False\n"
            "    def clear(self):\n"
            "        self._dict.clear()\n"
            "    def entries(self):\n"
            "        import builtins\n"
            "        return builtins.list(self._dict.items())\n"
            "    def keys(self):\n"
            "        import builtins\n"
            "        return builtins.list(self._dict.keys())\n"
            "    def values(self):\n"
            "        import builtins\n"
            "        return builtins.list(self._dict.values())\n"
            "class Set:\n"
            "    def __init__(self):\n"
            "        self._set = set()\n"
            "    def add(self, val):\n"
            "        self._set.add(val)\n"
            "        return self\n"
            "    def has(self, val):\n"
            "        return val in self._set\n"
            "    def delete(self, val):\n"
            "        if val in self._set:\n"
            "            self._set.remove(val)\n"
            "            return True\n"
            "        return False\n"
            "    def clear(self):\n"
            "        self._set.clear()\n"
            "    def values(self):\n"
            "        import builtins\n"
            "        return builtins.list(self._set)\n"
            "def validateToolArguments(tool, toolCall):\n"
            "    import copy\n"
            "    tc = to_js_obj(toolCall)\n"
            "    return copy.deepcopy(tc.arguments)\n"
            "def validateToolCall(tools, toolCall):\n"
            "    import copy\n"
            "    tc = to_js_obj(toolCall)\n"
            "    return copy.deepcopy(tc.arguments)\n"
            "def path_join(paths):\n"
            "    import os\n"
            "    return os.path.join(*paths)\n"
            "def path_resolve(paths):\n"
            "    import os\n"
            "    return os.path.abspath(os.path.join(*paths))\n"
            "class StreamWrapper:\n"
            "    def __init__(self, content):\n"
            "        self.content = content\n"
            "    def on(self, event, callback):\n"
            "        if event == 'data':\n"
            "            if self.content:\n"
            "                try: callback(self.content)\n"
            "                except: pass\n"
            "        return self\n"
            "class JSChildProcess:\n"
            "    def __init__(self, command, args=None, options=None):\n"
            "        import subprocess\n"
            "        cmd_args = [command]\n"
            "        if args is not None:\n"
            "            for a in args:\n"
            "                cmd_args.append(str(a))\n"
            "        shell = False\n"
            "        if args is None:\n"
            "            cmd_payload = command\n"
            "            shell = True\n"
            "        else:\n"
            "            cmd_payload = cmd_args\n"
            "        self.proc = subprocess.Popen(\n"
            "            cmd_payload,\n"
            "            shell=shell,\n"
            "            stdout=subprocess.PIPE,\n"
            "            stderr=subprocess.PIPE,\n"
            "            text=True\n"
            "        )\n"
            "        self.stdout_content, self.stderr_content = self.proc.communicate()\n"
            "        self.exit_code = self.proc.returncode\n"
            "        self.stdout = StreamWrapper(self.stdout_content)\n"
            "        self.stderr = StreamWrapper(self.stderr_content)\n"
            "    def on(self, event, callback):\n"
            "        if event == 'exit':\n"
            "            try: callback(self.exit_code)\n"
            "            except: pass\n"
            "        return self\n"
            "def child_process_spawn(command, args=None, options=None):\n"
            "    return JSChildProcess(command, args, options)\n"
            "class JSResponse:\n"
            "    def __init__(self, status, text_content):\n"
            "        self.status = status\n"
            "        self.text_content = text_content\n"
            "    def text(self):\n"
            "        import builtins\n"
            "        PyPromise = builtins._t2m_globals['Promise']\n"
            "        return PyPromise.resolve(self.text_content)\n"
            "    def json(self):\n"
            "        import json, builtins\n"
            "        PyPromise = builtins._t2m_globals['Promise']\n"
            "        try:\n"
            "            parsed = json.loads(self.text_content)\n"
            "            return PyPromise.resolve(to_js_obj(parsed))\n"
            "        except: \n"
            "            return PyPromise.resolve(None)\n"
            "def http_fetch(url, init=None):\n"
            "    import builtins\n"
            "    PyPromise = builtins._t2m_globals['Promise']\n"
            "    def executor(resolve, reject):\n"
            "        import urllib.request\n"
            "        import urllib.error\n"
            "        try:\n"
            "            req_headers = {}\n"
            "            method = 'GET'\n"
            "            data = None\n"
            "            if init is not None:\n"
            "                if 'method' in init and init['method'] is not None:\n"
            "                    method = str(init['method'])\n"
            "                if 'headers' in init and init['headers'] is not None:\n"
            "                    req_headers = dict(init['headers'])\n"
            "                if 'body' in init and init['body'] is not None:\n"
            "                    data = init['body']\n"
            "                    if isinstance(data, str):\n"
            "                        data = data.encode('utf-8')\n"
            "            req = urllib.request.Request(url, headers=req_headers, method=method, data=data)\n"
            "            try:\n"
            "                response = urllib.request.urlopen(req)\n"
            "                status = response.status\n"
            "                content = response.read().decode('utf-8')\n"
            "                response.close()\n"
            "                resolve(JSResponse(status, content))\n"
            "            except urllib.error.HTTPError as e:\n"
            "                try: content = e.read().decode('utf-8')\n"
            "                except: content = ''\n"
            "                resolve(JSResponse(e.code, content))\n"
            "        except Exception as err:\n"
            "            reject(err)\n"
            "    return PyPromise(executor)\n"
            "import sys\n"
            "import math\n"
            "import random\n"
            "from types import ModuleType\n"
            "class JSInt(int):\n"
            "    def toString(self, radix=10):\n"
            "        if radix == 36:\n"
            "            import string\n"
            "            chars = string.digits + string.ascii_lowercase\n"
            "            n = int(self)\n"
            "            if n == 0:\n"
            "                return '0'\n"
            "            res = ''\n"
            "            while n > 0:\n"
            "                res = chars[n % 36] + res\n"
            "                n //= 36\n"
            "            return res\n"
            "        return str(self)\n"
            "class JSFloat(float):\n"
            "    def toString(self, radix=10):\n"
            "        if radix == 36:\n"
            "            import string\n"
            "            chars = string.digits + string.ascii_lowercase\n"
            "            val = float(self)\n"
            "            int_part = int(val)\n"
            "            frac_part = val - int_part\n"
            "            int_str = ''\n"
            "            if int_part == 0:\n"
            "                int_str = '0'\n"
            "            else:\n"
            "                n = int_part\n"
            "                while n > 0:\n"
            "                    int_str = chars[n % 36] + int_str\n"
            "                    n //= 36\n"
            "            frac_str = []\n"
            "            f = frac_part\n"
            "            for _ in range(12):\n"
            "                f *= 36\n"
            "                digit = int(f)\n"
            "                frac_str.append(chars[digit])\n"
            "                f -= digit\n"
            "                if f == 0:\n"
            "                    break\n"
            "            return int_str + '.' + ''.join(frac_str)\n"
            "        return str(self)\n"
            "class PyMath:\n"
            "    @staticmethod\n"
            "    def ceil(x): return JSInt(math.ceil(x))\n"
            "    @staticmethod\n"
            "    def floor(x): return JSInt(math.floor(x))\n"
            "    @staticmethod\n"
            "    def max(*args): return max(*args)\n"
            "    @staticmethod\n"
            "    def min(*args): return min(*args)\n"
            "    @staticmethod\n"
            "    def random(): return JSFloat(random.random())\n"
            "class T2MRuntimeUtils(ModuleType):\n"
            "    def __getattr__(self, name):\n"
            "        import builtins\n"
            "        if name == 'Math':\n"
            "            return PyMath\n"
            "        if name == 'Promise':\n"
            "            return builtins._t2m_globals.get('Promise') if hasattr(builtins, '_t2m_globals') else None\n"
            "        if hasattr(builtins, '_t2m_globals'):\n"
            "            g = builtins._t2m_globals\n"
            "            if name in g:\n"
            "                return g[name]\n"
            "        raise AttributeError(f'module \\'t2m_runtime.utils\\' has no attribute \\'{name}\\'')\n"
            "sys.modules['t2m_runtime'] = sys.modules.get('t2m_runtime', ModuleType('t2m_runtime'))\n"
            "sys.modules['t2m_runtime.utils'] = T2MRuntimeUtils('t2m_runtime.utils')\n",
            py_globals
        )
        d["globalThis"] = py_globals["global_this"]
        d["Map"] = py_globals["Map"]
        d["Set"] = py_globals["Set"]
        d["to_js_obj"] = py_globals["to_js_obj"]
        d["validateToolArguments"] = py_globals["validateToolArguments"]
        d["validateToolCall"] = py_globals["validateToolCall"]
        d["path_join"] = py_globals["path_join"]
        d["path_resolve"] = py_globals["path_resolve"]
        d["child_process_spawn"] = py_globals["child_process_spawn"]
        d["http_fetch"] = py_globals["http_fetch"]
        d["Promise"] = py_globals["PyPromise"]
        builtins.setattr(builtins, "_t2m_globals", d)
    return builtins.getattr(builtins, "_t2m_globals")

def Map() raises -> PythonObject:
    var g = _init_globals()
    return g["Map"]()

def Set() raises -> PythonObject:
    var g = _init_globals()
    return g["Set"]()

def to_js_obj(val: PythonObject) raises -> PythonObject:
    var g = _init_globals()
    return g["to_js_obj"](val)

def validateToolArguments(tool: PythonObject, toolCall: PythonObject) raises -> PythonObject:
    var g = _init_globals()
    return g["validateToolArguments"](tool, toolCall)

def validateToolCall(tools: PythonObject, toolCall: PythonObject) raises -> PythonObject:
    var g = _init_globals()
    return g["validateToolCall"](tools, toolCall)


def get_global(name: String) raises -> PythonObject:
    var g = _init_globals()
    return g[name]

def set_global(name: String, val: PythonObject) raises:
    var g = _init_globals()
    g[name] = val

def getOwnPropertyNames(obj: PythonObject) raises -> PythonObject:
    var builtins = Python.import_module("builtins")
    if not obj:
        return builtins.list()
    try:
        if builtins.isinstance(obj, builtins.dict):
            return builtins.list(obj.keys())
        return builtins.list(obj.keys())
    except:
        try:
            return builtins.list(builtins.dir(obj))
        except:
            return builtins.list()

def Promise(executor: PythonObject) raises -> PythonObject:
    var g = _init_globals()
    return g["Promise"](executor)

struct JSON:
    @staticmethod
    def stringify(obj: PythonObject) raises -> String:
        var json = Python.import_module("json")
        return String(py=json.dumps(obj))

    @staticmethod
    def parse(text: String) raises -> PythonObject:
        var json = Python.import_module("json")
        return json.loads(text)

def indexOf(s: String, sub: String) -> Int:
    var n = s.byte_length()
    var sub_len = sub.byte_length()
    if sub_len == 0:
        return 0
    if sub_len > n:
        return -1
        
    var ptr = s.unsafe_ptr()
    if sub_len == 1:
        var target = sub.unsafe_ptr()[0]
        var i = 0
        comptime SIMD_WIDTH = 16
        while i + SIMD_WIDTH <= n:
            var chunk = ptr.load[width=SIMD_WIDTH](i)
            var diff = chunk - target
            if diff.reduce_min() == 0:
                for j in range(SIMD_WIDTH):
                    if chunk[j] == target:
                        return i + j
            i += SIMD_WIDTH
        while i < n:
            if ptr[i] == target:
                return i
            i += 1
        return -1
        
    var sub_ptr = sub.unsafe_ptr()
    for i in range(n - sub_len + 1):
        var is_match = True
        for j in range(sub_len):
            if ptr[i + j] != sub_ptr[j]:
                is_match = False
                break
        if is_match:
            return i
    return -1

@always_inline
def slice(obj: String) -> String:
    return obj

def slice(obj: PythonObject) raises -> PythonObject:
    var builtins = Python.import_module("builtins")
    var py_none = builtins.getattr(builtins, "None")
    var slice_obj = builtins.slice(py_none, py_none)
    return obj[slice_obj]

struct StringView[origin: Origin](Copyable, Movable):
    var ptr: UnsafePointer[UInt8, Self.origin]
    var length: Int

    @always_inline
    def __init__(out self, ptr: UnsafePointer[UInt8, Self.origin], length: Int):
        self.ptr = ptr
        self.length = length

    @always_inline
    def __copyinit__(mut self, other: Self):
        self.ptr = other.ptr
        self.length = other.length

    @always_inline
    def __moveinit__(mut self, deinit other: Self):
        self.ptr = other.ptr
        self.length = other.length

    @always_inline
    def byte_length(self) -> Int:
        return self.length

    @always_inline
    def unsafe_ptr(self) -> UnsafePointer[UInt8, Self.origin]:
        return self.ptr

    @always_inline
    def to_string(self) -> String:
        if self.length <= 0:
            return String()
        var bytes = List[UInt8](capacity=self.length)
        for i in range(self.length):
            bytes.append(self.ptr[i])
        return String(unsafe_from_utf8=bytes^)

    @always_inline
    def __str__(self) -> String:
        return self.to_string()

    @always_inline
    def __add__(self, other: String) -> String:
        return self.to_string() + other

    @always_inline
    def __radd__(self, other: String) -> String:
        return other + self.to_string()

    @always_inline
    def __add__[other_origin: Origin](self, other: StringView[other_origin]) -> String:
        return self.to_string() + other.to_string()

@always_inline
def slice(obj: String, start: Int) -> StringView[origin_of(obj)]:
    var n = obj.byte_length()
    var s_idx = start
    if s_idx < 0:
        s_idx = n + s_idx
        if s_idx < 0: s_idx = 0
    if s_idx >= n:
        return StringView[origin_of(obj)](obj.unsafe_ptr(), 0)
    var size = n - s_idx
    return StringView[origin_of(obj)](obj.unsafe_ptr() + s_idx, size)

@always_inline
def slice(obj: String, start: Int, end: Int) -> StringView[origin_of(obj)]:
    var n = obj.byte_length()
    var s_idx = start
    if s_idx < 0:
        s_idx = n + s_idx
        if s_idx < 0: s_idx = 0
    var e_idx = end
    if e_idx < 0:
        e_idx = n + e_idx
        if e_idx < 0: e_idx = 0
    if e_idx > n:
        e_idx = n
    if s_idx >= e_idx:
        return StringView[origin_of(obj)](obj.unsafe_ptr(), 0)
    var size = e_idx - s_idx
    return StringView[origin_of(obj)](obj.unsafe_ptr() + s_idx, size)

@always_inline
def slice[origin: Origin](obj: StringView[origin], start: Int) -> StringView[origin]:
    var n = obj.byte_length()
    var s_idx = start
    if s_idx < 0:
        s_idx = n + s_idx
        if s_idx < 0: s_idx = 0
    if s_idx >= n:
        return StringView[origin](obj.unsafe_ptr(), 0)
    var size = n - s_idx
    return StringView[origin](obj.unsafe_ptr() + s_idx, size)

@always_inline
def slice[origin: Origin](obj: StringView[origin], start: Int, end: Int) -> StringView[origin]:
    var n = obj.byte_length()
    var s_idx = start
    if s_idx < 0:
        s_idx = n + s_idx
        if s_idx < 0: s_idx = 0
    var e_idx = end
    if e_idx < 0:
        e_idx = n + e_idx
        if e_idx < 0: e_idx = 0
    if e_idx > n:
        e_idx = n
    if s_idx >= e_idx:
        return StringView[origin](obj.unsafe_ptr(), 0)
    var size = e_idx - s_idx
    return StringView[origin](obj.unsafe_ptr() + s_idx, size)


def slice(obj: PythonObject, start: PythonObject) raises -> PythonObject:
    var builtins = Python.import_module("builtins")
    var py_none = builtins.getattr(builtins, "None")
    var slice_obj = builtins.slice(start, py_none)
    return obj[slice_obj]

def slice(obj: PythonObject, start: PythonObject, end: PythonObject) raises -> PythonObject:
    var builtins = Python.import_module("builtins")
    if objectIs(end, None):
        var py_none = builtins.getattr(builtins, "None")
        var slice_obj = builtins.slice(start, py_none)
        return obj[slice_obj]
    var slice_obj = builtins.slice(start, end)
    return obj[slice_obj]

def py_range(end: PythonObject) raises -> PythonObject:
    var builtins = Python.import_module("builtins")
    return builtins.range(end)

def py_range(start: PythonObject, end: PythonObject) raises -> PythonObject:
    var builtins = Python.import_module("builtins")
    return builtins.range(start, end)

def instanceOf(obj: PythonObject, cls_name: String) raises -> Bool:
    var builtins = Python.import_module("builtins")
    if cls_name == "Error":
        return Bool(py=builtins.isinstance(obj, builtins.BaseException))
    return Bool(py=builtins.str(builtins.type(obj)).find(cls_name) != -1)

def get_property(obj: PythonObject, key: String, default: PythonObject) raises -> PythonObject:
    var builtins = Python.import_module("builtins")
    if not obj or objectIs(obj, None):
        return default
    if builtins.isinstance(obj, builtins.dict):
        return obj.get(key, default)
    try:
        return builtins.getattr(obj, key)
    except:
        return default

def wait_promise(promise: PythonObject) raises -> PythonObject:
    var builtins = Python.import_module("builtins")
    var time = Python.import_module("time")
    var p = promise
    
    if builtins.hasattr(p, "result"):
        if not builtins.hasattr(p, "__aiter__") and not builtins.hasattr(p, "__iter__"):
            p = p.result()
        
    if builtins.hasattr(p, "state"):
        while p.state == "pending":
            _ = time.sleep(0.001)
        if p.state == "rejected":
            raise Error("Promise rejected: " + String(p.value))
        return p.value
    return p

def to_py_list(*args: PythonObject) raises -> PythonObject:
    var builtins = Python.import_module("builtins")
    var l = builtins.list()
    for arg in args:
        _ = l.append(arg)
    return l

def ArrayFrom(iterable: PythonObject, map_fn: PythonObject = None) raises -> PythonObject:
    var builtins = Python.import_module("builtins")
    var l = builtins.list()
    if not map_fn or objectIs(map_fn, None):
        return builtins.list(iterable)
    for item in iterable:
        _ = l.append(map_fn(item))
    return l

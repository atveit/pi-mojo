from std.python import Python, PythonObject
from t2m_runtime.utils import _init_globals, get_property
from packages.ai.pi_ai_provider_faux import FauxProviderRegistration, RegisterFauxProviderOptions
from packages.ai.pi_ai_stream import streamSimple
from packages.ai.pi_ai_types import AssistantMessage, Context, ImageContent, Model, OpenRouterRouting, SimpleStreamOptions, TextContent, ThinkingBudgets, ThinkingContent, Tool, ToolCall, ToolResultMessage, Usage, VercelGatewayRouting

import packages.ai.pi_ai_provider_faux as pi_ai_provider_faux
import packages.ai.pi_ai_stream as pi_ai_stream
import packages.ai.pi_ai_types as pi_ai_types

from packages.agent.pi_agent_types_tool import BeforeToolCallResult, AfterToolCallResult, BeforeToolCallContext, AfterToolCallContext, AgentToolResult, AgentTool
from packages.agent.pi_agent_types_loop import AgentContext, ShouldStopAfterTurnContext, AgentLoopTurnUpdate, PrepareNextTurnContext, AgentLoopConfig, CustomAgentMessages, AgentState

def _init_module() raises:
    var builtins = Python.import_module("builtins")
    var g = _init_globals()
    if builtins.bool(g.get("_module_init_5945f3fd", False)):
        return
    g["_module_init_5945f3fd"] = True
    pi_ai_provider_faux._init_module()
    pi_ai_stream._init_module()
    pi_ai_types._init_module()
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


class BeforeToolCallResult:
    def __init__(self, *args, **kwargs):
        if len(args) == 1 and args[0] is not None and not isinstance(args[0], (int, float, str, bool)):
            obj = args[0]
            self.block = obj.get('block') if hasattr(obj, 'get') else getattr(obj, 'block', None)
            self.reason = obj.get('reason') if hasattr(obj, 'get') else getattr(obj, 'reason', None)
        else:
            self.block = args[0] if 0 < len(args) else kwargs.get('block', None)
            self.reason = args[1] if 1 < len(args) else kwargs.get('reason', None)
    def to_py(self):
        return self

class AfterToolCallResult:
    def __init__(self, *args, **kwargs):
        if len(args) == 1 and args[0] is not None and not isinstance(args[0], (int, float, str, bool)):
            obj = args[0]
            self.content = obj.get('content') if hasattr(obj, 'get') else getattr(obj, 'content', None)
            self.details = obj.get('details') if hasattr(obj, 'get') else getattr(obj, 'details', None)
            self.isError = obj.get('isError') if hasattr(obj, 'get') else getattr(obj, 'isError', None)
            self.terminate = obj.get('terminate') if hasattr(obj, 'get') else getattr(obj, 'terminate', None)
        else:
            self.content = args[0] if 0 < len(args) else kwargs.get('content', None)
            self.details = args[1] if 1 < len(args) else kwargs.get('details', None)
            self.isError = args[2] if 2 < len(args) else kwargs.get('isError', None)
            self.terminate = args[3] if 3 < len(args) else kwargs.get('terminate', None)
    def to_py(self):
        return self

class BeforeToolCallContext:
    def __init__(self, *args, **kwargs):
        if len(args) == 1 and args[0] is not None and not isinstance(args[0], (int, float, str, bool)):
            obj = args[0]
            self.assistantMessage = obj.get('assistantMessage') if hasattr(obj, 'get') else getattr(obj, 'assistantMessage', None)
            self.toolCall = obj.get('toolCall') if hasattr(obj, 'get') else getattr(obj, 'toolCall', None)
            self.args = obj.get('args') if hasattr(obj, 'get') else getattr(obj, 'args', None)
            self.context = obj.get('context') if hasattr(obj, 'get') else getattr(obj, 'context', None)
        else:
            self.assistantMessage = args[0] if 0 < len(args) else kwargs.get('assistantMessage', None)
            self.toolCall = args[1] if 1 < len(args) else kwargs.get('toolCall', None)
            self.args = args[2] if 2 < len(args) else kwargs.get('args', None)
            self.context = args[3] if 3 < len(args) else kwargs.get('context', None)
    def to_py(self):
        return self

class AfterToolCallContext:
    def __init__(self, *args, **kwargs):
        if len(args) == 1 and args[0] is not None and not isinstance(args[0], (int, float, str, bool)):
            obj = args[0]
            self.assistantMessage = obj.get('assistantMessage') if hasattr(obj, 'get') else getattr(obj, 'assistantMessage', None)
            self.toolCall = obj.get('toolCall') if hasattr(obj, 'get') else getattr(obj, 'toolCall', None)
            self.args = obj.get('args') if hasattr(obj, 'get') else getattr(obj, 'args', None)
            self.result = obj.get('result') if hasattr(obj, 'get') else getattr(obj, 'result', None)
            self.isError = obj.get('isError') if hasattr(obj, 'get') else getattr(obj, 'isError', None)
            self.context = obj.get('context') if hasattr(obj, 'get') else getattr(obj, 'context', None)
        else:
            self.assistantMessage = args[0] if 0 < len(args) else kwargs.get('assistantMessage', None)
            self.toolCall = args[1] if 1 < len(args) else kwargs.get('toolCall', None)
            self.args = args[2] if 2 < len(args) else kwargs.get('args', None)
            self.result = args[3] if 3 < len(args) else kwargs.get('result', None)
            self.isError = args[4] if 4 < len(args) else kwargs.get('isError', None)
            self.context = args[5] if 5 < len(args) else kwargs.get('context', None)
    def to_py(self):
        return self

class ShouldStopAfterTurnContext:
    def __init__(self, *args, **kwargs):
        if len(args) == 1 and args[0] is not None and not isinstance(args[0], (int, float, str, bool)):
            obj = args[0]
            self.message = obj.get('message') if hasattr(obj, 'get') else getattr(obj, 'message', None)
            self.toolResults = obj.get('toolResults') if hasattr(obj, 'get') else getattr(obj, 'toolResults', None)
            self.context = obj.get('context') if hasattr(obj, 'get') else getattr(obj, 'context', None)
            self.newMessages = obj.get('newMessages') if hasattr(obj, 'get') else getattr(obj, 'newMessages', None)
        else:
            self.message = args[0] if 0 < len(args) else kwargs.get('message', None)
            self.toolResults = args[1] if 1 < len(args) else kwargs.get('toolResults', None)
            self.context = args[2] if 2 < len(args) else kwargs.get('context', None)
            self.newMessages = args[3] if 3 < len(args) else kwargs.get('newMessages', None)
    def to_py(self):
        return self

class AgentLoopTurnUpdate:
    def __init__(self, *args, **kwargs):
        if len(args) == 1 and args[0] is not None and not isinstance(args[0], (int, float, str, bool)):
            obj = args[0]
            self.context = obj.get('context') if hasattr(obj, 'get') else getattr(obj, 'context', None)
            self.model = obj.get('model') if hasattr(obj, 'get') else getattr(obj, 'model', None)
            self.thinkingLevel = obj.get('thinkingLevel') if hasattr(obj, 'get') else getattr(obj, 'thinkingLevel', None)
        else:
            self.context = args[0] if 0 < len(args) else kwargs.get('context', None)
            self.model = args[1] if 1 < len(args) else kwargs.get('model', None)
            self.thinkingLevel = args[2] if 2 < len(args) else kwargs.get('thinkingLevel', None)
    def to_py(self):
        return self

class PrepareNextTurnContext:
    def __init__(self, *args, **kwargs):
        if len(args) == 1 and args[0] is not None and not isinstance(args[0], (int, float, str, bool)):
            obj = args[0]
            self.message = obj.get('message') if hasattr(obj, 'get') else getattr(obj, 'message', None)
            self.toolResults = obj.get('toolResults') if hasattr(obj, 'get') else getattr(obj, 'toolResults', None)
            self.context = obj.get('context') if hasattr(obj, 'get') else getattr(obj, 'context', None)
            self.newMessages = obj.get('newMessages') if hasattr(obj, 'get') else getattr(obj, 'newMessages', None)
        else:
            self.message = args[0] if 0 < len(args) else kwargs.get('message', None)
            self.toolResults = args[1] if 1 < len(args) else kwargs.get('toolResults', None)
            self.context = args[2] if 2 < len(args) else kwargs.get('context', None)
            self.newMessages = args[3] if 3 < len(args) else kwargs.get('newMessages', None)
    def to_py(self):
        return self

class AgentLoopConfig:
    def __init__(self, *args, **kwargs):
        if len(args) == 1 and args[0] is not None and not isinstance(args[0], (int, float, str, bool)):
            obj = args[0]
            self.model = obj.get('model') if hasattr(obj, 'get') else getattr(obj, 'model', None)
            self.convertToLlm = obj.get('convertToLlm') if hasattr(obj, 'get') else getattr(obj, 'convertToLlm', None)
            self.transformContext = obj.get('transformContext') if hasattr(obj, 'get') else getattr(obj, 'transformContext', None)
            self.getApiKey = obj.get('getApiKey') if hasattr(obj, 'get') else getattr(obj, 'getApiKey', None)
            self.shouldStopAfterTurn = obj.get('shouldStopAfterTurn') if hasattr(obj, 'get') else getattr(obj, 'shouldStopAfterTurn', None)
            self.prepareNextTurn = obj.get('prepareNextTurn') if hasattr(obj, 'get') else getattr(obj, 'prepareNextTurn', None)
            self.getSteeringMessages = obj.get('getSteeringMessages') if hasattr(obj, 'get') else getattr(obj, 'getSteeringMessages', None)
            self.getFollowUpMessages = obj.get('getFollowUpMessages') if hasattr(obj, 'get') else getattr(obj, 'getFollowUpMessages', None)
            self.toolExecution = obj.get('toolExecution') if hasattr(obj, 'get') else getattr(obj, 'toolExecution', None)
            self.beforeToolCall = obj.get('beforeToolCall') if hasattr(obj, 'get') else getattr(obj, 'beforeToolCall', None)
            self.afterToolCall = obj.get('afterToolCall') if hasattr(obj, 'get') else getattr(obj, 'afterToolCall', None)
            self.reasoning = obj.get('reasoning') if hasattr(obj, 'get') else getattr(obj, 'reasoning', None)
            self.thinkingBudgets = obj.get('thinkingBudgets') if hasattr(obj, 'get') else getattr(obj, 'thinkingBudgets', None)
            self.temperature = obj.get('temperature') if hasattr(obj, 'get') else getattr(obj, 'temperature', None)
            self.maxTokens = obj.get('maxTokens') if hasattr(obj, 'get') else getattr(obj, 'maxTokens', None)
            self.signal = obj.get('signal') if hasattr(obj, 'get') else getattr(obj, 'signal', None)
            self.apiKey = obj.get('apiKey') if hasattr(obj, 'get') else getattr(obj, 'apiKey', None)
            self.transport = obj.get('transport') if hasattr(obj, 'get') else getattr(obj, 'transport', None)
            self.cacheRetention = obj.get('cacheRetention') if hasattr(obj, 'get') else getattr(obj, 'cacheRetention', None)
            self.sessionId = obj.get('sessionId') if hasattr(obj, 'get') else getattr(obj, 'sessionId', None)
            self.onPayload = obj.get('onPayload') if hasattr(obj, 'get') else getattr(obj, 'onPayload', None)
            self.onResponse = obj.get('onResponse') if hasattr(obj, 'get') else getattr(obj, 'onResponse', None)
            self.headers = obj.get('headers') if hasattr(obj, 'get') else getattr(obj, 'headers', None)
            self.timeoutMs = obj.get('timeoutMs') if hasattr(obj, 'get') else getattr(obj, 'timeoutMs', None)
            self.maxRetries = obj.get('maxRetries') if hasattr(obj, 'get') else getattr(obj, 'maxRetries', None)
            self.maxRetryDelayMs = obj.get('maxRetryDelayMs') if hasattr(obj, 'get') else getattr(obj, 'maxRetryDelayMs', None)
            self.metadata = obj.get('metadata') if hasattr(obj, 'get') else getattr(obj, 'metadata', None)
        else:
            self.model = args[0] if 0 < len(args) else kwargs.get('model', None)
            self.convertToLlm = args[1] if 1 < len(args) else kwargs.get('convertToLlm', None)
            self.transformContext = args[2] if 2 < len(args) else kwargs.get('transformContext', None)
            self.getApiKey = args[3] if 3 < len(args) else kwargs.get('getApiKey', None)
            self.shouldStopAfterTurn = args[4] if 4 < len(args) else kwargs.get('shouldStopAfterTurn', None)
            self.prepareNextTurn = args[5] if 5 < len(args) else kwargs.get('prepareNextTurn', None)
            self.getSteeringMessages = args[6] if 6 < len(args) else kwargs.get('getSteeringMessages', None)
            self.getFollowUpMessages = args[7] if 7 < len(args) else kwargs.get('getFollowUpMessages', None)
            self.toolExecution = args[8] if 8 < len(args) else kwargs.get('toolExecution', None)
            self.beforeToolCall = args[9] if 9 < len(args) else kwargs.get('beforeToolCall', None)
            self.afterToolCall = args[10] if 10 < len(args) else kwargs.get('afterToolCall', None)
            self.reasoning = args[11] if 11 < len(args) else kwargs.get('reasoning', None)
            self.thinkingBudgets = args[12] if 12 < len(args) else kwargs.get('thinkingBudgets', None)
            self.temperature = args[13] if 13 < len(args) else kwargs.get('temperature', None)
            self.maxTokens = args[14] if 14 < len(args) else kwargs.get('maxTokens', None)
            self.signal = args[15] if 15 < len(args) else kwargs.get('signal', None)
            self.apiKey = args[16] if 16 < len(args) else kwargs.get('apiKey', None)
            self.transport = args[17] if 17 < len(args) else kwargs.get('transport', None)
            self.cacheRetention = args[18] if 18 < len(args) else kwargs.get('cacheRetention', None)
            self.sessionId = args[19] if 19 < len(args) else kwargs.get('sessionId', None)
            self.onPayload = args[20] if 20 < len(args) else kwargs.get('onPayload', None)
            self.onResponse = args[21] if 21 < len(args) else kwargs.get('onResponse', None)
            self.headers = args[22] if 22 < len(args) else kwargs.get('headers', None)
            self.timeoutMs = args[23] if 23 < len(args) else kwargs.get('timeoutMs', None)
            self.maxRetries = args[24] if 24 < len(args) else kwargs.get('maxRetries', None)
            self.maxRetryDelayMs = args[25] if 25 < len(args) else kwargs.get('maxRetryDelayMs', None)
            self.metadata = args[26] if 26 < len(args) else kwargs.get('metadata', None)
    def to_py(self):
        return self

class CustomAgentMessages:
    def __init__(self, *args, **kwargs):
        pass
    def to_py(self):
        return self

class AgentState:
    def __init__(self, *args, **kwargs):
        if len(args) == 1 and args[0] is not None and not isinstance(args[0], (int, float, str, bool)):
            obj = args[0]
            self.systemPrompt = obj.get('systemPrompt') if hasattr(obj, 'get') else getattr(obj, 'systemPrompt', None)
            self.model = obj.get('model') if hasattr(obj, 'get') else getattr(obj, 'model', None)
            self.thinkingLevel = obj.get('thinkingLevel') if hasattr(obj, 'get') else getattr(obj, 'thinkingLevel', None)
            self.tools = obj.get('tools') if hasattr(obj, 'get') else getattr(obj, 'tools', None)
            self.messages = obj.get('messages') if hasattr(obj, 'get') else getattr(obj, 'messages', None)
            self.isStreaming = obj.get('isStreaming') if hasattr(obj, 'get') else getattr(obj, 'isStreaming', None)
            self.streamingMessage = obj.get('streamingMessage') if hasattr(obj, 'get') else getattr(obj, 'streamingMessage', None)
            self.pendingToolCalls = obj.get('pendingToolCalls') if hasattr(obj, 'get') else getattr(obj, 'pendingToolCalls', None)
            self.errorMessage = obj.get('errorMessage') if hasattr(obj, 'get') else getattr(obj, 'errorMessage', None)
        else:
            self.systemPrompt = args[0] if 0 < len(args) else kwargs.get('systemPrompt', None)
            self.model = args[1] if 1 < len(args) else kwargs.get('model', None)
            self.thinkingLevel = args[2] if 2 < len(args) else kwargs.get('thinkingLevel', None)
            self.tools = args[3] if 3 < len(args) else kwargs.get('tools', None)
            self.messages = args[4] if 4 < len(args) else kwargs.get('messages', None)
            self.isStreaming = args[5] if 5 < len(args) else kwargs.get('isStreaming', None)
            self.streamingMessage = args[6] if 6 < len(args) else kwargs.get('streamingMessage', None)
            self.pendingToolCalls = args[7] if 7 < len(args) else kwargs.get('pendingToolCalls', None)
            self.errorMessage = args[8] if 8 < len(args) else kwargs.get('errorMessage', None)
    def to_py(self):
        return self

class AgentToolResult:
    def __init__(self, *args, **kwargs):
        if len(args) == 1 and args[0] is not None and not isinstance(args[0], (int, float, str, bool)):
            obj = args[0]
            self.content = obj.get('content') if hasattr(obj, 'get') else getattr(obj, 'content', None)
            self.details = obj.get('details') if hasattr(obj, 'get') else getattr(obj, 'details', None)
            self.terminate = obj.get('terminate') if hasattr(obj, 'get') else getattr(obj, 'terminate', None)
        else:
            self.content = args[0] if 0 < len(args) else kwargs.get('content', None)
            self.details = args[1] if 1 < len(args) else kwargs.get('details', None)
            self.terminate = args[2] if 2 < len(args) else kwargs.get('terminate', None)
    def to_py(self):
        return self

class AgentTool:
    def __init__(self, *args, **kwargs):
        if len(args) == 1 and args[0] is not None and not isinstance(args[0], (int, float, str, bool)):
            obj = args[0]
            self.label = obj.get('label') if hasattr(obj, 'get') else getattr(obj, 'label', None)
            self.prepareArguments = obj.get('prepareArguments') if hasattr(obj, 'get') else getattr(obj, 'prepareArguments', None)
            self.execute = obj.get('execute') if hasattr(obj, 'get') else getattr(obj, 'execute', None)
            self.executionMode = obj.get('executionMode') if hasattr(obj, 'get') else getattr(obj, 'executionMode', None)
            self.name = obj.get('name') if hasattr(obj, 'get') else getattr(obj, 'name', None)
            self.description = obj.get('description') if hasattr(obj, 'get') else getattr(obj, 'description', None)
            self.parameters = obj.get('parameters') if hasattr(obj, 'get') else getattr(obj, 'parameters', None)
        else:
            self.label = args[0] if 0 < len(args) else kwargs.get('label', None)
            self.prepareArguments = args[1] if 1 < len(args) else kwargs.get('prepareArguments', None)
            self.execute = args[2] if 2 < len(args) else kwargs.get('execute', None)
            self.executionMode = args[3] if 3 < len(args) else kwargs.get('executionMode', None)
            self.name = args[4] if 4 < len(args) else kwargs.get('name', None)
            self.description = args[5] if 5 < len(args) else kwargs.get('description', None)
            self.parameters = args[6] if 6 < len(args) else kwargs.get('parameters', None)
    def to_py(self):
        return self

class AgentContext:
    def __init__(self, *args, **kwargs):
        if len(args) == 1 and args[0] is not None and not isinstance(args[0], (int, float, str, bool)):
            obj = args[0]
            self.systemPrompt = obj.get('systemPrompt') if hasattr(obj, 'get') else getattr(obj, 'systemPrompt', None)
            self.messages = obj.get('messages') if hasattr(obj, 'get') else getattr(obj, 'messages', None)
            self.tools = obj.get('tools') if hasattr(obj, 'get') else getattr(obj, 'tools', None)
        else:
            self.systemPrompt = args[0] if 0 < len(args) else kwargs.get('systemPrompt', None)
            self.messages = args[1] if 1 < len(args) else kwargs.get('messages', None)
            self.tools = args[2] if 2 < len(args) else kwargs.get('tools', None)
    def to_py(self):
        return self
    """
    try:
        builtins.exec(code, g)
    except e:
        var traceback_mod = Python.import_module("traceback")
        _ = traceback_mod.print_exc()
        raise e^

def main() raises:
    _init_module()

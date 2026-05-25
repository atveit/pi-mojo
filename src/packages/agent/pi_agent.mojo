from std.python import Python, PythonObject
from t2m_runtime.date import Date
from t2m_runtime.utils import Promise, Set, _init_globals, get_property, instanceOf, isArray, objectIs, slice, to_js_obj, to_py_list, typeOf, wait_promise
from packages.agent.pi_agent_types import AfterToolCallContext, AfterToolCallResult, AgentContext, AgentLoopConfig, AgentLoopTurnUpdate, AgentState, AgentTool, BeforeToolCallContext, BeforeToolCallResult
from packages.ai.pi_ai_provider_faux import FauxProviderRegistration, RegisterFauxProviderOptions
from packages.ai.pi_ai_stream import streamSimple
from packages.ai.pi_ai_types import AssistantMessage, Context, ImageContent, Model, OpenRouterRouting, SimpleStreamOptions, TextContent, ThinkingBudgets, ThinkingContent, ToolCall, ToolResultMessage, Usage, VercelGatewayRouting

import packages.agent.pi_agent_types as pi_agent_types
import packages.ai.pi_ai_provider_faux as pi_ai_provider_faux
import packages.ai.pi_ai_stream as pi_ai_stream
import packages.ai.pi_ai_types as pi_ai_types

struct AgentOptions(ImplicitlyCopyable):
    var initialState: PythonObject
    var convertToLlm: PythonObject
    var transformContext: PythonObject
    var streamFn: PythonObject
    var getApiKey: PythonObject
    var onPayload: PythonObject
    var onResponse: PythonObject
    var beforeToolCall: PythonObject
    var afterToolCall: PythonObject
    var prepareNextTurn: PythonObject
    var steeringMode: PythonObject
    var followUpMode: PythonObject
    var sessionId: String
    var thinkingBudgets: ThinkingBudgets
    var transport: PythonObject
    var maxRetryDelayMs: Int
    var toolExecution: PythonObject

    def __init__(out self, initialState: PythonObject, convertToLlm: PythonObject, transformContext: PythonObject, streamFn: PythonObject, getApiKey: PythonObject, onPayload: PythonObject, onResponse: PythonObject, beforeToolCall: PythonObject, afterToolCall: PythonObject, prepareNextTurn: PythonObject, steeringMode: PythonObject, followUpMode: PythonObject, sessionId: String, thinkingBudgets: ThinkingBudgets, transport: PythonObject, maxRetryDelayMs: Int, toolExecution: PythonObject):
        self.initialState = initialState
        self.convertToLlm = convertToLlm
        self.transformContext = transformContext
        self.streamFn = streamFn
        self.getApiKey = getApiKey
        self.onPayload = onPayload
        self.onResponse = onResponse
        self.beforeToolCall = beforeToolCall
        self.afterToolCall = afterToolCall
        self.prepareNextTurn = prepareNextTurn
        self.steeringMode = steeringMode
        self.followUpMode = followUpMode
        self.sessionId = sessionId
        self.thinkingBudgets = thinkingBudgets
        self.transport = transport
        self.maxRetryDelayMs = maxRetryDelayMs
        self.toolExecution = toolExecution

    def __init__(out self, *, copy: Self):
        self.initialState = copy.initialState
        self.convertToLlm = copy.convertToLlm
        self.transformContext = copy.transformContext
        self.streamFn = copy.streamFn
        self.getApiKey = copy.getApiKey
        self.onPayload = copy.onPayload
        self.onResponse = copy.onResponse
        self.beforeToolCall = copy.beforeToolCall
        self.afterToolCall = copy.afterToolCall
        self.prepareNextTurn = copy.prepareNextTurn
        self.steeringMode = copy.steeringMode
        self.followUpMode = copy.followUpMode
        self.sessionId = copy.sessionId
        self.thinkingBudgets = copy.thinkingBudgets
        self.transport = copy.transport
        self.maxRetryDelayMs = copy.maxRetryDelayMs
        self.toolExecution = copy.toolExecution

    def __init__(out self, py: PythonObject) raises:
        self.initialState = get_property(py, "initialState", None)
        self.convertToLlm = get_property(py, "convertToLlm", None)
        self.transformContext = get_property(py, "transformContext", None)
        self.streamFn = get_property(py, "streamFn", None)
        self.getApiKey = get_property(py, "getApiKey", None)
        self.onPayload = get_property(py, "onPayload", None)
        self.onResponse = get_property(py, "onResponse", None)
        self.beforeToolCall = get_property(py, "beforeToolCall", None)
        self.afterToolCall = get_property(py, "afterToolCall", None)
        self.prepareNextTurn = get_property(py, "prepareNextTurn", None)
        self.steeringMode = get_property(py, "steeringMode", None)
        self.followUpMode = get_property(py, "followUpMode", None)
        self.sessionId = String(get_property(py, "sessionId", ""))
        self.thinkingBudgets = ThinkingBudgets(get_property(py, "thinkingBudgets", None))
        self.transport = get_property(py, "transport", None)
        self.maxRetryDelayMs = Int(py=get_property(py, "maxRetryDelayMs", 0))
        self.toolExecution = get_property(py, "toolExecution", None)

    def to_py(self) raises -> PythonObject:
        var builtins = Python.import_module("builtins")
        var d = builtins.dict()
        d["initialState"] = self.initialState
        d["convertToLlm"] = self.convertToLlm
        d["transformContext"] = self.transformContext
        d["streamFn"] = self.streamFn
        d["getApiKey"] = self.getApiKey
        d["onPayload"] = self.onPayload
        d["onResponse"] = self.onResponse
        d["beforeToolCall"] = self.beforeToolCall
        d["afterToolCall"] = self.afterToolCall
        d["prepareNextTurn"] = self.prepareNextTurn
        d["steeringMode"] = self.steeringMode
        d["followUpMode"] = self.followUpMode
        d["sessionId"] = self.sessionId
        d["thinkingBudgets"] = self.thinkingBudgets.to_py()
        d["transport"] = self.transport
        d["maxRetryDelayMs"] = self.maxRetryDelayMs
        d["toolExecution"] = self.toolExecution
        return d



def defaultConvertToLlm(messages: PythonObject) raises -> PythonObject:
    var builtins = Python.import_module("builtins")
    _init_module()
    var g = _init_globals()
    var code = """
def defaultConvertToLlm(messages):
    messages = to_js_obj(messages)
    def _closure_184(message):
        message = to_js_obj(message)
        return message.role == "user" or message.role == "assistant" or message.role == "toolResult"
    return messages.filter(_closure_184)
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
        res = g["defaultConvertToLlm"](messages)
    except e:
        var traceback_mod = Python.import_module("traceback")
        _ = traceback_mod.print_exc()
        raise e^
    return res

def createMutableAgentState(initialState: PythonObject = None) raises -> PythonObject:
    var builtins = Python.import_module("builtins")
    _init_module()
    var g = _init_globals()
    var code = """
def createMutableAgentState(initialState=None):
    initialState = to_js_obj(initialState)
    tools = (slice(initialState.tools) if not objectIs(slice(initialState.tools), None) else JSList([]))
    messages = (slice(initialState.messages) if not objectIs(slice(initialState.messages), None) else JSList([]))
    def _closure_537():
        return tools
    def _closure_568(nextTools):
        nonlocal tools
        nextTools = to_js_obj(nextTools)
        tools = slice(nextTools)
    def _closure_580():
        return messages
    def _closure_605(nextMessages):
        nonlocal messages
        nextMessages = to_js_obj(nextMessages)
        messages = slice(nextMessages)
    _obj_633 = to_js_obj({"systemPrompt": (initialState.systemPrompt if not objectIs(initialState.systemPrompt, None) else ""), "model": (initialState.model if not objectIs(initialState.model, None) else DEFAULT_MODEL), "thinkingLevel": (initialState.thinkingLevel if not objectIs(initialState.thinkingLevel, None) else "off"), "tools": _closure_537, "tools": _closure_568, "messages": _closure_580, "messages": _closure_605, "isStreaming": False, "streamingMessage": None, "pendingToolCalls": Set(), "errorMessage": None})
    return _obj_633
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
        res = g["createMutableAgentState"](initialState)
    except e:
        var traceback_mod = Python.import_module("traceback")
        _ = traceback_mod.print_exc()
        raise e^
    return res

def _init_module() raises:
    var builtins = Python.import_module("builtins")
    var g = _init_globals()
    if builtins.bool(g.get("_module_init_2f3de63c", False)):
        return
    g["_module_init_2f3de63c"] = True
    pi_agent_types._init_module()
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


DEFAULT_MODEL = to_js_obj({"id": "unknown", "name": "unknown", "api": "unknown", "provider": "unknown", "baseUrl": "", "reasoning": False, "input": JSList([]), "cost": to_js_obj({"input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0}), "contextWindow": 0, "maxTokens": 0})

EMPTY_USAGE = to_js_obj({"input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0, "totalTokens": 0, "cost": to_js_obj({"input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0, "total": 0})})

class AgentOptions:
    def __init__(self, *args, **kwargs):
        if len(args) == 1 and args[0] is not None and not isinstance(args[0], (int, float, str, bool)):
            obj = args[0]
            self.initialState = obj.get('initialState') if hasattr(obj, 'get') else getattr(obj, 'initialState', None)
            self.convertToLlm = obj.get('convertToLlm') if hasattr(obj, 'get') else getattr(obj, 'convertToLlm', None)
            self.transformContext = obj.get('transformContext') if hasattr(obj, 'get') else getattr(obj, 'transformContext', None)
            self.streamFn = obj.get('streamFn') if hasattr(obj, 'get') else getattr(obj, 'streamFn', None)
            self.getApiKey = obj.get('getApiKey') if hasattr(obj, 'get') else getattr(obj, 'getApiKey', None)
            self.onPayload = obj.get('onPayload') if hasattr(obj, 'get') else getattr(obj, 'onPayload', None)
            self.onResponse = obj.get('onResponse') if hasattr(obj, 'get') else getattr(obj, 'onResponse', None)
            self.beforeToolCall = obj.get('beforeToolCall') if hasattr(obj, 'get') else getattr(obj, 'beforeToolCall', None)
            self.afterToolCall = obj.get('afterToolCall') if hasattr(obj, 'get') else getattr(obj, 'afterToolCall', None)
            self.prepareNextTurn = obj.get('prepareNextTurn') if hasattr(obj, 'get') else getattr(obj, 'prepareNextTurn', None)
            self.steeringMode = obj.get('steeringMode') if hasattr(obj, 'get') else getattr(obj, 'steeringMode', None)
            self.followUpMode = obj.get('followUpMode') if hasattr(obj, 'get') else getattr(obj, 'followUpMode', None)
            self.sessionId = obj.get('sessionId') if hasattr(obj, 'get') else getattr(obj, 'sessionId', None)
            self.thinkingBudgets = obj.get('thinkingBudgets') if hasattr(obj, 'get') else getattr(obj, 'thinkingBudgets', None)
            self.transport = obj.get('transport') if hasattr(obj, 'get') else getattr(obj, 'transport', None)
            self.maxRetryDelayMs = obj.get('maxRetryDelayMs') if hasattr(obj, 'get') else getattr(obj, 'maxRetryDelayMs', None)
            self.toolExecution = obj.get('toolExecution') if hasattr(obj, 'get') else getattr(obj, 'toolExecution', None)
        else:
            self.initialState = args[0] if 0 < len(args) else kwargs.get('initialState', None)
            self.convertToLlm = args[1] if 1 < len(args) else kwargs.get('convertToLlm', None)
            self.transformContext = args[2] if 2 < len(args) else kwargs.get('transformContext', None)
            self.streamFn = args[3] if 3 < len(args) else kwargs.get('streamFn', None)
            self.getApiKey = args[4] if 4 < len(args) else kwargs.get('getApiKey', None)
            self.onPayload = args[5] if 5 < len(args) else kwargs.get('onPayload', None)
            self.onResponse = args[6] if 6 < len(args) else kwargs.get('onResponse', None)
            self.beforeToolCall = args[7] if 7 < len(args) else kwargs.get('beforeToolCall', None)
            self.afterToolCall = args[8] if 8 < len(args) else kwargs.get('afterToolCall', None)
            self.prepareNextTurn = args[9] if 9 < len(args) else kwargs.get('prepareNextTurn', None)
            self.steeringMode = args[10] if 10 < len(args) else kwargs.get('steeringMode', None)
            self.followUpMode = args[11] if 11 < len(args) else kwargs.get('followUpMode', None)
            self.sessionId = args[12] if 12 < len(args) else kwargs.get('sessionId', None)
            self.thinkingBudgets = args[13] if 13 < len(args) else kwargs.get('thinkingBudgets', None)
            self.transport = args[14] if 14 < len(args) else kwargs.get('transport', None)
            self.maxRetryDelayMs = args[15] if 15 < len(args) else kwargs.get('maxRetryDelayMs', None)
            self.toolExecution = args[16] if 16 < len(args) else kwargs.get('toolExecution', None)
    def to_py(self):
        return self

class PendingMessageQueue:
    def to_py(self):
        return self
    def __init__(self, mode):
        self = to_js_obj(self)
        mode = to_js_obj(mode)
        self.messages = JSList([])
        self.mode = mode
    def enqueue(self, message):
        self = to_js_obj(self)
        message = to_js_obj(message)
        self.messages.append(message)
    def hasItems(self):
        self = to_js_obj(self)
        return len(self.messages) > 0
    def drain(self):
        self = to_js_obj(self)
        if self.mode == "all":
            drained = slice(self.messages)
            self.messages = JSList([])
            return drained
        first = self.messages[0]
        if not first:
            return JSList([])
        self.messages = slice(self.messages, 1)
        return JSList([first])
    def clear(self):
        self = to_js_obj(self)
        self.messages = JSList([])

class Agent:
    def to_py(self):
        return self
    def __init__(self, options=None):
        self = to_js_obj(self)
        options = to_js_obj(options)
        self.listeners = Set()
        if options == None:
            options = to_js_obj({})
        self._state = createMutableAgentState(options.initialState)
        self.convertToLlm = (options.convertToLlm if not objectIs(options.convertToLlm, None) else defaultConvertToLlm)
        self.transformContext = options.transformContext
        self.streamFn = (options.streamFn if not objectIs(options.streamFn, None) else Python.import_module("test_datasets.pi.pi_ai_stream").streamSimple)
        self.getApiKey = options.getApiKey
        self.onPayload = options.onPayload
        self.onResponse = options.onResponse
        self.beforeToolCall = options.beforeToolCall
        self.afterToolCall = options.afterToolCall
        self.prepareNextTurn = options.prepareNextTurn
        self.steeringQueue = PendingMessageQueue((options.steeringMode if not objectIs(options.steeringMode, None) else "one-at-a-time"))
        self.followUpQueue = PendingMessageQueue((options.followUpMode if not objectIs(options.followUpMode, None) else "one-at-a-time"))
        self.sessionId = options.sessionId
        self.thinkingBudgets = options.thinkingBudgets
        self.transport = (options.transport if not objectIs(options.transport, None) else "auto")
        self.maxRetryDelayMs = options.maxRetryDelayMs
        self.toolExecution = (options.toolExecution if not objectIs(options.toolExecution, None) else "parallel")
    def subscribe(self, listener):
        self = to_js_obj(self)
        listener = to_js_obj(listener)
        self.listeners.add(listener)
        def _closure_1566():
            return self.listeners.delete(listener)
        return _closure_1566
    def state(self):
        self = to_js_obj(self)
        return self._state
    def steeringMode(self, *args):
        self = to_js_obj(self)
        if args:
            self.steeringQueue.mode = to_js_obj(args[0])
        else:
            return self.steeringQueue.mode
    def followUpMode(self, *args):
        self = to_js_obj(self)
        if args:
            self.followUpQueue.mode = to_js_obj(args[0])
        else:
            return self.followUpQueue.mode
    def steer(self, message):
        self = to_js_obj(self)
        message = to_js_obj(message)
        self.steeringQueue.enqueue(message)
    def followUp(self, message):
        self = to_js_obj(self)
        message = to_js_obj(message)
        self.followUpQueue.enqueue(message)
    def clearSteeringQueue(self):
        self = to_js_obj(self)
        self.steeringQueue.clear()
    def clearFollowUpQueue(self):
        self = to_js_obj(self)
        self.followUpQueue.clear()
    def clearAllQueues(self):
        self = to_js_obj(self)
        self.clearSteeringQueue()
        self.clearFollowUpQueue()
    def hasQueuedMessages(self):
        self = to_js_obj(self)
        return self.steeringQueue.hasItems() or self.followUpQueue.hasItems()
    def signal(self):
        self = to_js_obj(self)
        return self.activeRun.abortController.signal
    def abort(self):
        self = to_js_obj(self)
        self.activeRun.abortController.abort()
    def waitForIdle(self):
        self = to_js_obj(self)
        return (self.activeRun.promise if not objectIs(self.activeRun.promise, None) else Python.import_module("t2m_runtime.utils").Promise.resolve())
    def reset(self):
        self = to_js_obj(self)
        self._state.messages = JSList([])
        self._state.isStreaming = False
        self._state.streamingMessage = None
        self._state.pendingToolCalls = Set()
        self._state.errorMessage = None
        self.clearFollowUpQueue()
        self.clearSteeringQueue()
    def prompt(self, input, images=None):
        self = to_js_obj(self)
        input = to_js_obj(input)
        images = to_js_obj(images)
        if self.activeRun:
            raise Error("Agent is already processing a prompt. Use steer() or followUp() to queue messages, or wait for completion.")
        messages = self.normalizePromptInput(input, images)
        wait_promise(self.runPromptMessages(messages))
    def continue_(self):
        self = to_js_obj(self)
        if self.activeRun:
            raise Error("Agent is already processing. Wait for completion before continuing.")
        lastMessage = self._state.messages[len(self._state.messages) - 1]
        if not lastMessage:
            raise Error("No messages to continue from")
        if lastMessage.role == "assistant":
            queuedSteering = self.steeringQueue.drain()
            if len(queuedSteering) > 0:
                _obj_2234 = to_js_obj({"skipInitialSteeringPoll": True})
                wait_promise(self.runPromptMessages(queuedSteering, _obj_2234))
                return
            queuedFollowUps = self.followUpQueue.drain()
            if len(queuedFollowUps) > 0:
                wait_promise(self.runPromptMessages(queuedFollowUps))
                return
            raise Error("Cannot continue from message role: assistant")
        wait_promise(self.runContinuation())
    def normalizePromptInput(self, input, images=None):
        self = to_js_obj(self)
        input = to_js_obj(input)
        images = to_js_obj(images)
        if isArray(input):
            return input
        if typeOf(input) != "string":
            return JSList([input])
        _obj_2408 = to_js_obj({"type": "text", "text": input})
        content = to_py_list(_obj_2408)
        if images and len(images) > 0:
            content.extend(images)
            None
        _obj_2459 = to_js_obj({"role": "user", "content": content, "timestamp": Date.now()})
        return JSList([_obj_2459])
    def runPromptMessages(self, messages, options=None):
        self = to_js_obj(self)
        messages = to_js_obj(messages)
        options = to_js_obj(options)
        if options == None:
            options = to_js_obj({})
        def _closure_2575(signal):
            signal = to_js_obj(signal)
            def _closure_2570(event):
                event = to_js_obj(event)
                return self.processEvents(event)
            wait_promise(runAgentLoop(messages, AgentContext(self.createContextSnapshot()), AgentLoopConfig(self.createLoopConfig(options)), _closure_2570, signal, self.streamFn))
        wait_promise(self.runWithLifecycle(_closure_2575))
    def runContinuation(self):
        self = to_js_obj(self)
        def _closure_2662(signal):
            signal = to_js_obj(signal)
            def _closure_2657(event):
                event = to_js_obj(event)
                return self.processEvents(event)
            wait_promise(runAgentLoopContinue(AgentContext(self.createContextSnapshot()), AgentLoopConfig(self.createLoopConfig()), _closure_2657, signal, self.streamFn))
        wait_promise(self.runWithLifecycle(_closure_2662))
    def createContextSnapshot(self):
        self = to_js_obj(self)
        _obj_2716 = to_js_obj({"systemPrompt": self._state.systemPrompt, "messages": slice(self._state.messages), "tools": slice(self._state.tools)})
        return _obj_2716
    def createLoopConfig(self, options=None):
        self = to_js_obj(self)
        options = to_js_obj(options)
        if options == None:
            options = to_js_obj({})
        skipInitialSteeringPoll = options.skipInitialSteeringPoll == True
        def _closure_2867():
            return wait_promise(self.prepareNextTurn(self.signal) if self.prepareNextTurn else None)
        def _closure_2926():
            nonlocal skipInitialSteeringPoll
            if skipInitialSteeringPoll:
                skipInitialSteeringPoll = False
                return JSList([])
            return self.steeringQueue.drain()
        def _closure_2945():
            return self.followUpQueue.drain()
        _obj_2947 = to_js_obj({"model": self._state.model, "reasoning": None if self._state.thinkingLevel == "off" else self._state.thinkingLevel, "sessionId": self.sessionId, "onPayload": self.onPayload, "onResponse": self.onResponse, "transport": self.transport, "thinkingBudgets": self.thinkingBudgets, "maxRetryDelayMs": self.maxRetryDelayMs, "toolExecution": self.toolExecution, "beforeToolCall": self.beforeToolCall, "afterToolCall": self.afterToolCall, "prepareNextTurn": _closure_2867 if self.prepareNextTurn else None, "convertToLlm": self.convertToLlm, "transformContext": self.transformContext, "getApiKey": self.getApiKey, "getSteeringMessages": _closure_2926, "getFollowUpMessages": _closure_2945})
        return _obj_2947
    def runWithLifecycle(self, executor):
        self = to_js_obj(self)
        executor = to_js_obj(executor)
        if self.activeRun:
            raise Error("Agent is already processing.")
        abortController = AbortController()
        def _closure_3026():
            pass
        resolvePromise = _closure_3026
        def _closure_3052(resolve):
            nonlocal resolvePromise
            resolve = to_js_obj(resolve)
            resolvePromise = resolve
        promise = Promise(_closure_3052)
        self.activeRun = to_js_obj({"promise": promise, "resolve": resolvePromise, "abortController": abortController})
        self._state.isStreaming = True
        self._state.streamingMessage = None
        self._state.errorMessage = None
        try:
            wait_promise(executor(abortController.signal))
        except Exception as error:
            wait_promise(self.handleRunFailure(error, abortController.signal.aborted))
        finally:
            self.finishRun()
    def handleRunFailure(self, error, aborted):
        self = to_js_obj(self)
        error = to_js_obj(error)
        aborted = to_js_obj(aborted)
        _obj_3209 = to_js_obj({"type": "text", "text": ""})
        failureMessage = to_js_obj({"role": "assistant", "content": JSList([_obj_3209]), "api": self._state.model.api, "provider": self._state.model.provider, "model": self._state.model.id, "usage": EMPTY_USAGE, "stopReason": "aborted" if aborted else "error", "errorMessage": error.message if instanceOf(error, "Error") else String(error), "timestamp": Date.now()})
        _obj_3317 = to_js_obj({"type": "message_start", "message": failureMessage})
        wait_promise(self.processEvents(_obj_3317))
        _obj_3341 = to_js_obj({"type": "message_end", "message": failureMessage})
        wait_promise(self.processEvents(_obj_3341))
        _obj_3371 = to_js_obj({"type": "turn_end", "message": failureMessage, "toolResults": JSList([])})
        wait_promise(self.processEvents(_obj_3371))
        _obj_3398 = to_js_obj({"type": "agent_end", "messages": JSList([failureMessage])})
        wait_promise(self.processEvents(_obj_3398))
    def finishRun(self):
        self = to_js_obj(self)
        self._state.isStreaming = False
        self._state.streamingMessage = None
        self._state.pendingToolCalls = Set()
        self.activeRun.resolve()
        self.activeRun = None
    def processEvents(self, event):
        self = to_js_obj(self)
        event = to_js_obj(event)
        if event.type == "message_start":
            self._state.streamingMessage = event.message
        elif event.type == "message_update":
            self._state.streamingMessage = event.message
        elif event.type == "message_end":
            self._state.streamingMessage = None
            self._state.messages.append(event.message)
        elif event.type == "tool_execution_start":
            pendingToolCalls = Set(self._state.pendingToolCalls)
            pendingToolCalls.add(event.toolCallId)
            self._state.pendingToolCalls = pendingToolCalls
        elif event.type == "tool_execution_end":
            pendingToolCalls = Set(self._state.pendingToolCalls)
            pendingToolCalls.delete(event.toolCallId)
            self._state.pendingToolCalls = pendingToolCalls
        elif event.type == "turn_end":
            if event.message.role == "assistant" and event.message.errorMessage:
                self._state.errorMessage = event.message.errorMessage
        elif event.type == "agent_end":
            self._state.streamingMessage = None
        signal = self.activeRun.abortController.signal
        if not signal:
            raise Error("Agent listener invoked outside active run")
        for listener in self.listeners:
            wait_promise(listener(event, signal))

def defaultConvertToLlm(messages):
    messages = to_js_obj(messages)
    def _closure_184(message):
        message = to_js_obj(message)
        return message.role == "user" or message.role == "assistant" or message.role == "toolResult"
    return messages.filter(_closure_184)

def createMutableAgentState(initialState=None):
    initialState = to_js_obj(initialState)
    tools = (slice(initialState.tools) if not objectIs(slice(initialState.tools), None) else JSList([]))
    messages = (slice(initialState.messages) if not objectIs(slice(initialState.messages), None) else JSList([]))
    def _closure_537():
        return tools
    def _closure_568(nextTools):
        nonlocal tools
        nextTools = to_js_obj(nextTools)
        tools = slice(nextTools)
    def _closure_580():
        return messages
    def _closure_605(nextMessages):
        nonlocal messages
        nextMessages = to_js_obj(nextMessages)
        messages = slice(nextMessages)
    _obj_633 = to_js_obj({"systemPrompt": (initialState.systemPrompt if not objectIs(initialState.systemPrompt, None) else ""), "model": (initialState.model if not objectIs(initialState.model, None) else DEFAULT_MODEL), "thinkingLevel": (initialState.thinkingLevel if not objectIs(initialState.thinkingLevel, None) else "off"), "tools": _closure_537, "tools": _closure_568, "messages": _closure_580, "messages": _closure_605, "isStreaming": False, "streamingMessage": None, "pendingToolCalls": Set(), "errorMessage": None})
    return _obj_633
    """
    try:
        builtins.exec(code, g)
    except e:
        var traceback_mod = Python.import_module("traceback")
        _ = traceback_mod.print_exc()
        raise e^

def PendingMessageQueue(mode: PythonObject) raises -> PythonObject:
    _init_module()
    var g = _init_globals()
    return g["PendingMessageQueue"](mode)

def Agent(options: PythonObject) raises -> PythonObject:
    _init_module()
    var g = _init_globals()
    return g["Agent"](options)

def main() raises:
    _init_module()

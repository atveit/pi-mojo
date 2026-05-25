from std.python import Python, PythonObject
from t2m_runtime.date import Date
from t2m_runtime.utils import JSON, Map, Math, Promise, _init_globals, get_property, isArray, objectIs, slice, structuredClone, to_js_obj, to_py_list, typeOf, wait_promise
from packages.ai.pi_ai_types import AssistantMessage, Context, ImageContent, Model, OpenRouterRouting, SimpleStreamOptions, TextContent, ThinkingBudgets, ThinkingContent, ToolCall, ToolResultMessage, Usage, VercelGatewayRouting

import packages.ai.pi_ai_event_stream as pi_ai_event_stream
import packages.ai.pi_ai_registry as pi_ai_registry
import packages.ai.pi_ai_types as pi_ai_types

comptime DEFAULT_API: String = "faux"
comptime DEFAULT_PROVIDER: String = "faux"
comptime DEFAULT_MODEL_ID: String = "faux-1"
comptime DEFAULT_MODEL_NAME: String = "Faux Model"
comptime DEFAULT_BASE_URL: String = "http://localhost:0"
comptime DEFAULT_MIN_TOKEN_SIZE: Int = 3
comptime DEFAULT_MAX_TOKEN_SIZE: Int = 5

struct FauxModelDefinition(ImplicitlyCopyable):
    var id: String
    var name: String
    var reasoning: Bool
    var input: PythonObject
    var cost: PythonObject
    var contextWindow: Int
    var maxTokens: Int

    def __init__(out self, id: String, name: String, reasoning: Bool, input: PythonObject, cost: PythonObject, contextWindow: Int, maxTokens: Int):
        self.id = id
        self.name = name
        self.reasoning = reasoning
        self.input = input
        self.cost = cost
        self.contextWindow = contextWindow
        self.maxTokens = maxTokens

    def __init__(out self, *, copy: Self):
        self.id = copy.id
        self.name = copy.name
        self.reasoning = copy.reasoning
        self.input = copy.input
        self.cost = copy.cost
        self.contextWindow = copy.contextWindow
        self.maxTokens = copy.maxTokens

    def __init__(out self, py: PythonObject) raises:
        self.id = String(get_property(py, "id", ""))
        self.name = String(get_property(py, "name", ""))
        self.reasoning = Bool(py=get_property(py, "reasoning", False))
        self.input = get_property(py, "input", None)
        self.cost = get_property(py, "cost", None)
        self.contextWindow = Int(py=get_property(py, "contextWindow", 0))
        self.maxTokens = Int(py=get_property(py, "maxTokens", 0))

    def to_py(self) raises -> PythonObject:
        var builtins = Python.import_module("builtins")
        var d = builtins.dict()
        d["id"] = self.id
        d["name"] = self.name
        d["reasoning"] = self.reasoning
        d["input"] = self.input
        d["cost"] = self.cost
        d["contextWindow"] = self.contextWindow
        d["maxTokens"] = self.maxTokens
        return d

struct RegisterFauxProviderOptions(ImplicitlyCopyable):
    var api: String
    var provider: String
    var models: PythonObject
    var tokensPerSecond: Int
    var tokenSize: PythonObject

    def __init__(out self, api: String, provider: String, models: PythonObject, tokensPerSecond: Int, tokenSize: PythonObject):
        self.api = api
        self.provider = provider
        self.models = models
        self.tokensPerSecond = tokensPerSecond
        self.tokenSize = tokenSize

    def __init__(out self, *, copy: Self):
        self.api = copy.api
        self.provider = copy.provider
        self.models = copy.models
        self.tokensPerSecond = copy.tokensPerSecond
        self.tokenSize = copy.tokenSize

    def __init__(out self, py: PythonObject) raises:
        self.api = String(get_property(py, "api", ""))
        self.provider = String(get_property(py, "provider", ""))
        self.models = get_property(py, "models", None)
        self.tokensPerSecond = Int(py=get_property(py, "tokensPerSecond", 0))
        self.tokenSize = get_property(py, "tokenSize", None)

    def to_py(self) raises -> PythonObject:
        var builtins = Python.import_module("builtins")
        var d = builtins.dict()
        d["api"] = self.api
        d["provider"] = self.provider
        d["models"] = self.models
        d["tokensPerSecond"] = self.tokensPerSecond
        d["tokenSize"] = self.tokenSize
        return d

struct FauxProviderRegistration(ImplicitlyCopyable):
    var api: String
    var models: PythonObject
    var getModel: PythonObject
    var state: PythonObject
    var setResponses: PythonObject
    var appendResponses: PythonObject
    var getPendingResponseCount: PythonObject
    var unregister: PythonObject

    def __init__(out self, api: String, models: PythonObject, getModel: PythonObject, state: PythonObject, setResponses: PythonObject, appendResponses: PythonObject, getPendingResponseCount: PythonObject, unregister: PythonObject):
        self.api = api
        self.models = models
        self.getModel = getModel
        self.state = state
        self.setResponses = setResponses
        self.appendResponses = appendResponses
        self.getPendingResponseCount = getPendingResponseCount
        self.unregister = unregister

    def __init__(out self, *, copy: Self):
        self.api = copy.api
        self.models = copy.models
        self.getModel = copy.getModel
        self.state = copy.state
        self.setResponses = copy.setResponses
        self.appendResponses = copy.appendResponses
        self.getPendingResponseCount = copy.getPendingResponseCount
        self.unregister = copy.unregister

    def __init__(out self, py: PythonObject) raises:
        self.api = String(get_property(py, "api", ""))
        self.models = get_property(py, "models", None)
        self.getModel = get_property(py, "getModel", None)
        self.state = get_property(py, "state", None)
        self.setResponses = get_property(py, "setResponses", None)
        self.appendResponses = get_property(py, "appendResponses", None)
        self.getPendingResponseCount = get_property(py, "getPendingResponseCount", None)
        self.unregister = get_property(py, "unregister", None)

    def to_py(self) raises -> PythonObject:
        var builtins = Python.import_module("builtins")
        var d = builtins.dict()
        d["api"] = self.api
        d["models"] = self.models
        d["getModel"] = self.getModel
        d["state"] = self.state
        d["setResponses"] = self.setResponses
        d["appendResponses"] = self.appendResponses
        d["getPendingResponseCount"] = self.getPendingResponseCount
        d["unregister"] = self.unregister
        return d

def _init_module() raises:
    var builtins = Python.import_module("builtins")
    var g = _init_globals()
    if builtins.bool(g.get("_module_init_3a36321f", False)):
        return
    g["_module_init_3a36321f"] = True
    g["DEFAULT_API"] = DEFAULT_API
    g["DEFAULT_PROVIDER"] = DEFAULT_PROVIDER
    g["DEFAULT_MODEL_ID"] = DEFAULT_MODEL_ID
    g["DEFAULT_MODEL_NAME"] = DEFAULT_MODEL_NAME
    g["DEFAULT_BASE_URL"] = DEFAULT_BASE_URL
    g["DEFAULT_MIN_TOKEN_SIZE"] = DEFAULT_MIN_TOKEN_SIZE
    g["DEFAULT_MAX_TOKEN_SIZE"] = DEFAULT_MAX_TOKEN_SIZE
    pi_ai_event_stream._init_module()
    pi_ai_registry._init_module()
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

def randomId(prefix):
    import time
    import random
    now_ms = int(time.time() * 1000)
    chars = "abcdefghijklmnopqrstuvwxyz0123456789"
    rand_suffix = "".join(random.choice(chars) for _ in range(11))
    return f"{prefix}:{now_ms}:{rand_suffix}"

def FauxProviderRegistration(api, models, getModel, state, setResponses, appendResponses, getPendingResponseCount, unregister):
    return to_js_obj({
        "api": api,
        "models": models,
        "getModel": getModel,
        "state": state,
        "setResponses": setResponses,
        "appendResponses": appendResponses,
        "getPendingResponseCount": getPendingResponseCount,
        "unregister": unregister
    })

def DEFAULT_USAGE():
    return to_js_obj({
        "input": 0,
        "output": 0,
        "cacheRead": 0,
        "cacheWrite": 0,
        "totalTokens": 0,
        "cost": 0.0
    })

def createErrorMessage(error, api, provider, modelId):
    return to_js_obj({
        "role": "assistant",
        "content": JSList([]),
        "api": api,
        "provider": provider,
        "model": modelId,
        "responseModel": "",
        "responseId": "",
        "diagnostics": None,
        "usage": to_js_obj(DEFAULT_USAGE()),
        "stopReason": "error",
        "errorMessage": String(error),
        "timestamp": Date.now()
    })

def createAssistantMessageEventStream():
    return AssistantMessageEventStream()

def cloneMessage(message, api, provider, modelId):
    message = to_js_obj(message)
    cloned = to_js_obj(structuredClone(message))
    cloned.api = api
    cloned.provider = provider
    cloned.model = modelId
    cloned.timestamp = (cloned.timestamp if not objectIs(cloned.timestamp, None) else Date.now())
    cloned.usage = (cloned.usage if not objectIs(cloned.usage, None) else to_js_obj(DEFAULT_USAGE()))
    return cloned

def withUsageEstimate(message, context, options, promptCache):
    message = to_js_obj(message)
    context = to_js_obj(context)
    options = to_js_obj(options)
    promptCache = to_js_obj(promptCache)
    
    promptText = serializeContext(context)
    promptTokens = estimateTokens(promptText)
    outputTokens = estimateTokens(String(assistantContentToText(message.content)))
    input_val = promptTokens
    cacheRead = 0
    cacheWrite = 0
    sessionId = options.sessionId
    if sessionId and options.cacheRetention != "none":
        previousPrompt = promptCache.get(sessionId)
        if previousPrompt:
            cachedChars = commonPrefixLength(String(previousPrompt), promptText)
            cacheRead = estimateTokens(String(slice(previousPrompt, 0, cachedChars)))
            cacheWrite = estimateTokens(String(slice(promptText, cachedChars)))
            input_val = max(0, promptTokens - cacheRead)
        else:
            cacheWrite = promptTokens
        promptCache.set(sessionId, promptText)
    
    cloned = to_js_obj(structuredClone(message))
    cloned.usage = to_js_obj({
        "input": input_val,
        "output": outputTokens,
        "cacheRead": cacheRead,
        "cacheWrite": cacheWrite,
        "totalTokens": input_val + outputTokens + cacheRead + cacheWrite,
        "cost": to_js_obj({"input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0, "total": 0})
    })
    return cloned

def createAbortedMessage(partial):
    cloned = to_js_obj(structuredClone(partial))
    cloned.stopReason = "aborted"
    cloned.errorMessage = "Request was aborted"
    cloned.timestamp = Date.now()
    return cloned

def streamWithDeltas(stream, message, minTokenSize, maxTokenSize, tokensPerSecond, signal):
    stream = to_js_obj(stream)
    message = to_js_obj(message)
    minTokenSize = Int(minTokenSize)
    maxTokenSize = Int(maxTokenSize)
    tokensPerSecond = to_js_obj(tokensPerSecond)
    signal = to_js_obj(signal)
    
    cloned = to_js_obj(structuredClone(message))
    cloned.content = to_js_obj([])
    partial = cloned
    
    if signal.aborted:
        aborted = createAbortedMessage(partial)
        stream.append(to_js_obj({"type": "error", "reason": "aborted", "error": aborted}))
        stream.end(aborted)
        return
        
    stream.append(to_js_obj({"type": "start", "partial": partial}))
    
    for index in range(len(message.content)):
        if signal.aborted:
            aborted = createAbortedMessage(partial)
            stream.append(to_js_obj({"type": "error", "reason": "aborted", "error": aborted}))
            stream.end(aborted)
            return
            
        block = to_js_obj(message.content[index])
        if block.type == "thinking":
            new_content = list(partial.content)
            new_content.append(to_js_obj({"type": "thinking", "thinking": ""}))
            partial.content = JSList(new_content)
            
            stream.append(to_js_obj({"type": "thinking_start", "contentIndex": index, "partial": partial}))
            
            for chunk in splitStringByTokenSize(String(block.thinking), minTokenSize, maxTokenSize):
                wait_promise(scheduleChunk(chunk, tokensPerSecond))
                if signal.aborted:
                    aborted = createAbortedMessage(partial)
                    stream.append(to_js_obj({"type": "error", "reason": "aborted", "error": aborted}))
                    stream.end(aborted)
                    return
                partial.content[index].thinking = String(partial.content[index].thinking) + String(chunk)
                stream.append(to_js_obj({"type": "thinking_delta", "contentIndex": index, "delta": chunk, "partial": partial}))
                
            stream.append(to_js_obj({"type": "thinking_end", "contentIndex": index, "content": block.thinking, "partial": partial}))
            continue
            
        if block.type == "text":
            new_content = list(partial.content)
            new_content.append(to_js_obj({"type": "text", "text": ""}))
            partial.content = JSList(new_content)
            
            stream.append(to_js_obj({"type": "text_start", "contentIndex": index, "partial": partial}))
            
            for chunk in splitStringByTokenSize(String(block.text), minTokenSize, maxTokenSize):
                wait_promise(scheduleChunk(chunk, tokensPerSecond))
                if signal.aborted:
                    aborted = createAbortedMessage(partial)
                    stream.append(to_js_obj({"type": "error", "reason": "aborted", "error": aborted}))
                    stream.end(aborted)
                    return
                partial.content[index].text = String(partial.content[index].text) + String(chunk)
                stream.append(to_js_obj({"type": "text_delta", "contentIndex": index, "delta": chunk, "partial": partial}))
                
            stream.append(to_js_obj({"type": "text_end", "contentIndex": index, "content": block.text, "partial": partial}))
            continue
            
        new_content = list(partial.content)
        new_content.append(to_js_obj({"type": "toolCall", "id": block.id, "name": block.name, "arguments": to_js_obj({})}))
        partial.content = JSList(new_content)
        
        stream.append(to_js_obj({"type": "toolcall_start", "contentIndex": index, "partial": partial}))
        
        for chunk in splitStringByTokenSize(String(JSON.stringify(block.arguments)), minTokenSize, maxTokenSize):
            wait_promise(scheduleChunk(chunk, tokensPerSecond))
            if signal.aborted:
                aborted = createAbortedMessage(partial)
                stream.append(to_js_obj({"type": "error", "reason": "aborted", "error": aborted}))
                stream.end(aborted)
                return
            stream.append(to_js_obj({"type": "toolcall_delta", "contentIndex": index, "delta": chunk, "partial": partial}))
            
        partial.content[index].arguments = block.arguments
        stream.append(to_js_obj({"type": "toolcall_end", "contentIndex": index, "toolCall": block, "partial": partial}))
        
    if message.stopReason == "error" or message.stopReason == "aborted":
        stream.append(to_js_obj({"type": "error", "reason": message.stopReason, "error": message}))
        stream.end(message)
        return
        
    stream.append(to_js_obj({"type": "done", "reason": message.stopReason, "message": message}))
    stream.end(message)
    """
    try:
        builtins.exec(code, g)
    except e:
        var traceback_mod = Python.import_module("traceback")
        _ = traceback_mod.print_exc()
        raise e^

def DEFAULT_USAGE() raises -> Usage:
    _init_module()
    var builtins = Python.import_module("builtins")
    var g = _init_globals()
    if builtins.bool(g.get("_var_cache_DEFAULT_USAGE", False)):
        return Usage(g["_var_cache_DEFAULT_USAGE"])
    var res = Usage(0, 0, 0, 0, 0, to_js_obj({"input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0, "total": 0}))
    g["_var_cache_DEFAULT_USAGE"] = res.to_py()
    return res

def fauxText(text: String) raises -> TextContent:
    _init_module()
    return TextContent("text", text, "")

def fauxThinking(thinking: String) raises -> ThinkingContent:
    _init_module()
    return ThinkingContent("thinking", thinking, "", False)

def fauxToolCall(name: PythonObject, arguments_: PythonObject, options: PythonObject = None) raises -> ToolCall:
    _init_module()
    var builtins = Python.import_module("builtins")
    var g = _init_globals()
    var code = """
def fauxToolCall(name, arguments_, options=None):
    name = to_js_obj(name)
    arguments_ = to_js_obj(arguments_)
    options = to_js_obj(options)
    if options == None:
        options = to_js_obj({})
    return ToolCall("toolCall", String((options.id if not objectIs(options.id, None) else randomId("tool"))), name, arguments_, "")
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
        res = g["fauxToolCall"](name, arguments_, options)
    except e:
        var traceback_mod = Python.import_module("traceback")
        _ = traceback_mod.print_exc()
        raise e^
    return ToolCall(res)

def normalizeFauxAssistantContent(content: PythonObject) raises -> PythonObject:
    _init_module()
    if typeOf(content) == "string":
        return [fauxText(String(content)).to_py()]
    return content if isArray(content) else [content]

def fauxAssistantMessage(content: PythonObject, options: PythonObject = None) raises -> AssistantMessage:
    _init_module()
    var builtins = Python.import_module("builtins")
    var g = _init_globals()
    var code = """
def fauxAssistantMessage(content, options=None):
    content = to_js_obj(content)
    options = to_js_obj(options)
    if options == None:
        options = to_js_obj({})
    return AssistantMessage("assistant", normalizeFauxAssistantContent(content), DEFAULT_API, DEFAULT_PROVIDER, DEFAULT_MODEL_ID, "", String(options.responseId), None, Usage(DEFAULT_USAGE().to_py()), (options.stopReason if not objectIs(options.stopReason, None) else "stop"), String(options.errorMessage), Int(py=(options.timestamp if not objectIs(options.timestamp, None) else Date.now())))
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
        res = g["fauxAssistantMessage"](content, options)
    except e:
        var traceback_mod = Python.import_module("traceback")
        _ = traceback_mod.print_exc()
        raise e^
    return AssistantMessage(res)

def estimateTokens(text: String) raises -> Int:
    _init_module()
    return Int(py=Python.import_module("t2m_runtime.utils").Math.ceil(text.byte_length() / 4))

def randomId(prefix: String) raises -> String:
    _init_module()
    return String(prefix) + ":" + String(Date.now()) + ":" + String(slice(Python.import_module("t2m_runtime.utils").Math.random().toString(36), 2))

def contentToText(content: PythonObject) raises -> String:
    _init_module()
    var builtins = Python.import_module("builtins")
    var g = _init_globals()
    var code = """
def contentToText(content):
    content = to_js_obj(content)
    if typeOf(content) == "string":
        return String(content)
    def _closure_947(block):
        block = to_js_obj(block)
        if block.type == "text":
            return block.text
        return "[image:" + String(block.mimeType) + ":" + String(len(block.data)) + "]"
    return String(content.map(_closure_947).join("\\n"))
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
        res = g["contentToText"](content)
    except e:
        var traceback_mod = Python.import_module("traceback")
        _ = traceback_mod.print_exc()
        raise e^
    return String(res)

def assistantContentToText(content: PythonObject) raises -> String:
    _init_module()
    var builtins = Python.import_module("builtins")
    var g = _init_globals()
    var code = """
def assistantContentToText(content):
    content = to_js_obj(content)
    def _closure_1083(block):
        block = to_js_obj(block)
        if block.type == "text":
            return block.text
        if block.type == "thinking":
            return block.thinking
        return String(block.name) + ":" + String(JSON.stringify(block.arguments))
    return String(content.map(_closure_1083).join("\\n"))
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
        res = g["assistantContentToText"](content)
    except e:
        var traceback_mod = Python.import_module("traceback")
        _ = traceback_mod.print_exc()
        raise e^
    return String(res)

def toolResultToText(message: PythonObject) raises -> String:
    _init_module()
    var builtins = Python.import_module("builtins")
    var g = _init_globals()
    var code = """
def toolResultToText(message):
    message = to_js_obj(message)
    _arr_1148 = JSList()
    _arr_1148.append(message.toolName)
    def _closure_1148(block):
        block = to_js_obj(block)
        return contentToText(to_py_list(block))
    _arr_1148.extend(message.content.map(_closure_1148))
    return String(_arr_1148.join("\\n"))
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
        res = g["toolResultToText"](message)
    except e:
        var traceback_mod = Python.import_module("traceback")
        _ = traceback_mod.print_exc()
        raise e^
    return String(res)

def messageToText(message: PythonObject) raises -> String:
    _init_module()
    if message.role == "user":
        return String(contentToText(message.content))
    if message.role == "assistant":
        return String(assistantContentToText(message.content))
    return String(toolResultToText(message))

def serializeContext(context: Context) raises -> String:
    _init_module()
    var parts: PythonObject = to_py_list()
    if context.systemPrompt:
        parts.append("system:" + String(context.systemPrompt))
    for message in context.messages:
        parts.append(String(message.role) + ":" + String(messageToText(message)))
    if len(context.tools):
        parts.append("tools:" + String(JSON.stringify(context.tools)))
    return String(parts.join("\\n\\n"))

def commonPrefixLength(a: String, b: String) raises -> Int:
    _init_module()
    var length: Int = min(a.byte_length(), b.byte_length())
    var index: Int = 0
    while (index < length and a[byte=index] == b[byte=index]):
        index = index + 1
    return index

def splitStringByTokenSize(text: String, minTokenSize: Int, maxTokenSize: Int) raises -> PythonObject:
    _init_module()
    var chunks: PythonObject = to_py_list()
    var index: Int = 0
    while (index < len(text)):
        var tokenSize: PythonObject = minTokenSize + Python.import_module("t2m_runtime.utils").Math.floor(Python.import_module("t2m_runtime.utils").Math.random() * (maxTokenSize - minTokenSize + 1))
        var charSize: Int = max(1, Int(py=tokenSize * 4))
        chunks.append(slice(text, index, index + charSize))
        index = index + charSize
    return chunks if len(chunks) > 0 else [""]

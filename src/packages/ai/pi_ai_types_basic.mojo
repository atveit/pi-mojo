from std.python import Python, PythonObject
from t2m_runtime.utils import _init_globals, get_property

struct ThinkingBudgets(ImplicitlyCopyable):
    var minimal: Int
    var low: Int
    var medium: Int
    var high: Int

    def __init__(out self, minimal: Int, low: Int, medium: Int, high: Int):
        self.minimal = minimal
        self.low = low
        self.medium = medium
        self.high = high

    def __init__(out self, *, copy: Self):
        self.minimal = copy.minimal
        self.low = copy.low
        self.medium = copy.medium
        self.high = copy.high

    def __init__(out self, py: PythonObject) raises:
        self.minimal = Int(py=get_property(py, "minimal", 0))
        self.low = Int(py=get_property(py, "low", 0))
        self.medium = Int(py=get_property(py, "medium", 0))
        self.high = Int(py=get_property(py, "high", 0))

    def to_py(self) raises -> PythonObject:
        var builtins = Python.import_module("builtins")
        var d = builtins.dict()
        d["minimal"] = self.minimal
        d["low"] = self.low
        d["medium"] = self.medium
        d["high"] = self.high
        return d

struct Usage(ImplicitlyCopyable):
    var input: Int
    var output: Int
    var cacheRead: Int
    var cacheWrite: Int
    var totalTokens: Int
    var cost: PythonObject

    def __init__(out self, input: Int, output: Int, cacheRead: Int, cacheWrite: Int, totalTokens: Int, cost: PythonObject):
        self.input = input
        self.output = output
        self.cacheRead = cacheRead
        self.cacheWrite = cacheWrite
        self.totalTokens = totalTokens
        self.cost = cost

    def __init__(out self, *, copy: Self):
        self.input = copy.input
        self.output = copy.output
        self.cacheRead = copy.cacheRead
        self.cacheWrite = copy.cacheWrite
        self.totalTokens = copy.totalTokens
        self.cost = copy.cost

    def __init__(out self, py: PythonObject) raises:
        self.input = Int(py=get_property(py, "input", 0))
        self.output = Int(py=get_property(py, "output", 0))
        self.cacheRead = Int(py=get_property(py, "cacheRead", 0))
        self.cacheWrite = Int(py=get_property(py, "cacheWrite", 0))
        self.totalTokens = Int(py=get_property(py, "totalTokens", 0))
        self.cost = get_property(py, "cost", None)

    def to_py(self) raises -> PythonObject:
        var builtins = Python.import_module("builtins")
        var d = builtins.dict()
        d["input"] = self.input
        d["output"] = self.output
        d["cacheRead"] = self.cacheRead
        d["cacheWrite"] = self.cacheWrite
        d["totalTokens"] = self.totalTokens
        d["cost"] = self.cost
        return d

struct UserMessage(ImplicitlyCopyable):
    var role: PythonObject
    var content: PythonObject
    var timestamp: Int

    def __init__(out self, role: PythonObject, content: PythonObject, timestamp: Int):
        self.role = role
        self.content = content
        self.timestamp = timestamp

    def __init__(out self, *, copy: Self):
        self.role = copy.role
        self.content = copy.content
        self.timestamp = copy.timestamp

    def __init__(out self, py: PythonObject) raises:
        self.role = get_property(py, "role", None)
        self.content = get_property(py, "content", None)
        self.timestamp = Int(py=get_property(py, "timestamp", 0))

    def to_py(self) raises -> PythonObject:
        var builtins = Python.import_module("builtins")
        var d = builtins.dict()
        d["role"] = self.role
        d["content"] = self.content
        d["timestamp"] = self.timestamp
        return d

struct Tool(ImplicitlyCopyable):
    var name: String
    var description: String
    var parameters: PythonObject

    def __init__(out self, name: String, description: String, parameters: PythonObject):
        self.name = name
        self.description = description
        self.parameters = parameters

    def __init__(out self, *, copy: Self):
        self.name = copy.name
        self.description = copy.description
        self.parameters = copy.parameters

    def __init__(out self, py: PythonObject) raises:
        self.name = String(get_property(py, "name", ""))
        self.description = String(get_property(py, "description", ""))
        self.parameters = get_property(py, "parameters", None)

    def to_py(self) raises -> PythonObject:
        var builtins = Python.import_module("builtins")
        var d = builtins.dict()
        d["name"] = self.name
        d["description"] = self.description
        d["parameters"] = self.parameters
        return d

struct Context(ImplicitlyCopyable):
    var systemPrompt: String
    var messages: PythonObject
    var tools: PythonObject

    def __init__(out self, systemPrompt: String, messages: PythonObject, tools: PythonObject):
        self.systemPrompt = systemPrompt
        self.messages = messages
        self.tools = tools

    def __init__(out self, *, copy: Self):
        self.systemPrompt = copy.systemPrompt
        self.messages = copy.messages
        self.tools = copy.tools

    def __init__(out self, py: PythonObject) raises:
        self.systemPrompt = String(get_property(py, "systemPrompt", ""))
        self.messages = get_property(py, "messages", None)
        self.tools = get_property(py, "tools", None)

    def to_py(self) raises -> PythonObject:
        var builtins = Python.import_module("builtins")
        var d = builtins.dict()
        d["systemPrompt"] = self.systemPrompt
        d["messages"] = self.messages
        d["tools"] = self.tools
        return d

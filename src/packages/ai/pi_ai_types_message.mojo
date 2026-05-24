from std.python import Python, PythonObject
from t2m_runtime.utils import _init_globals, get_property
from packages.ai.pi_ai_types_basic import Usage

struct ProviderResponse(ImplicitlyCopyable):
    var status: Int
    var headers: PythonObject

    def __init__(out self, status: Int, headers: PythonObject):
        self.status = status
        self.headers = headers

    def __init__(out self, *, copy: Self):
        self.status = copy.status
        self.headers = copy.headers

    def __init__(out self, py: PythonObject) raises:
        self.status = Int(py=get_property(py, "status", 0))
        self.headers = get_property(py, "headers", None)

    def to_py(self) raises -> PythonObject:
        var builtins = Python.import_module("builtins")
        var d = builtins.dict()
        d["status"] = self.status
        d["headers"] = self.headers
        return d

struct ToolCall(ImplicitlyCopyable):
    var type: PythonObject
    var id: String
    var name: String
    var arguments: PythonObject
    var thoughtSignature: String

    def __init__(out self, type: PythonObject, id: String, name: String, arguments: PythonObject, thoughtSignature: String):
        self.type = type
        self.id = id
        self.name = name
        self.arguments = arguments
        self.thoughtSignature = thoughtSignature

    def __init__(out self, *, copy: Self):
        self.type = copy.type
        self.id = copy.id
        self.name = copy.name
        self.arguments = copy.arguments
        self.thoughtSignature = copy.thoughtSignature

    def __init__(out self, py: PythonObject) raises:
        self.type = get_property(py, "type", None)
        self.id = String(get_property(py, "id", ""))
        self.name = String(get_property(py, "name", ""))
        self.arguments = get_property(py, "arguments", None)
        self.thoughtSignature = String(get_property(py, "thoughtSignature", ""))

    def to_py(self) raises -> PythonObject:
        var builtins = Python.import_module("builtins")
        var d = builtins.dict()
        d["type"] = self.type
        d["id"] = self.id
        d["name"] = self.name
        d["arguments"] = self.arguments
        d["thoughtSignature"] = self.thoughtSignature
        return d

struct AssistantMessage(ImplicitlyCopyable):
    var role: PythonObject
    var content: PythonObject
    var api: PythonObject
    var provider: PythonObject
    var model: String
    var responseModel: String
    var responseId: String
    var diagnostics: PythonObject
    var usage: Usage
    var stopReason: PythonObject
    var errorMessage: String
    var timestamp: Int

    def __init__(out self, role: PythonObject, content: PythonObject, api: PythonObject, provider: PythonObject, model: String, responseModel: String, responseId: String, diagnostics: PythonObject, usage: Usage, stopReason: PythonObject, errorMessage: String, timestamp: Int):
        self.role = role
        self.content = content
        self.api = api
        self.provider = provider
        self.model = model
        self.responseModel = responseModel
        self.responseId = responseId
        self.diagnostics = diagnostics
        self.usage = usage
        self.stopReason = stopReason
        self.errorMessage = errorMessage
        self.timestamp = timestamp

    def __init__(out self, *, copy: Self):
        self.role = copy.role
        self.content = copy.content
        self.api = copy.api
        self.provider = copy.provider
        self.model = copy.model
        self.responseModel = copy.responseModel
        self.responseId = copy.responseId
        self.diagnostics = copy.diagnostics
        self.usage = copy.usage
        self.stopReason = copy.stopReason
        self.errorMessage = copy.errorMessage
        self.timestamp = copy.timestamp

    def __init__(out self, py: PythonObject) raises:
        self.role = get_property(py, "role", None)
        self.content = get_property(py, "content", None)
        self.api = get_property(py, "api", None)
        self.provider = get_property(py, "provider", None)
        self.model = String(get_property(py, "model", ""))
        self.responseModel = String(get_property(py, "responseModel", ""))
        self.responseId = String(get_property(py, "responseId", ""))
        self.diagnostics = get_property(py, "diagnostics", None)
        self.usage = Usage(get_property(py, "usage", None))
        self.stopReason = get_property(py, "stopReason", None)
        self.errorMessage = String(get_property(py, "errorMessage", ""))
        self.timestamp = Int(py=get_property(py, "timestamp", 0))

    def to_py(self) raises -> PythonObject:
        var builtins = Python.import_module("builtins")
        var d = builtins.dict()
        d["role"] = self.role
        d["content"] = self.content
        d["api"] = self.api
        d["provider"] = self.provider
        d["model"] = self.model
        d["responseModel"] = self.responseModel
        d["responseId"] = self.responseId
        d["diagnostics"] = self.diagnostics
        d["usage"] = self.usage.to_py()
        d["stopReason"] = self.stopReason
        d["errorMessage"] = self.errorMessage
        d["timestamp"] = self.timestamp
        return d

struct ImagesContext(ImplicitlyCopyable):
    var input: PythonObject

    def __init__(out self, input: PythonObject):
        self.input = input

    def __init__(out self, *, copy: Self):
        self.input = copy.input

    def __init__(out self, py: PythonObject) raises:
        self.input = get_property(py, "input", None)

    def to_py(self) raises -> PythonObject:
        var builtins = Python.import_module("builtins")
        var d = builtins.dict()
        d["input"] = self.input
        return d

struct AssistantImages(ImplicitlyCopyable):
    var api: PythonObject
    var provider: PythonObject
    var model: String
    var output: PythonObject
    var responseId: String
    var usage: Usage
    var stopReason: PythonObject
    var errorMessage: String
    var timestamp: Int

    def __init__(out self, api: PythonObject, provider: PythonObject, model: String, output: PythonObject, responseId: String, usage: Usage, stopReason: PythonObject, errorMessage: String, timestamp: Int):
        self.api = api
        self.provider = provider
        self.model = model
        self.output = output
        self.responseId = responseId
        self.usage = usage
        self.stopReason = stopReason
        self.errorMessage = errorMessage
        self.timestamp = timestamp

    def __init__(out self, *, copy: Self):
        self.api = copy.api
        self.provider = copy.provider
        self.model = copy.model
        self.output = copy.output
        self.responseId = copy.responseId
        self.usage = copy.usage
        self.stopReason = copy.stopReason
        self.errorMessage = copy.errorMessage
        self.timestamp = copy.timestamp

    def __init__(out self, py: PythonObject) raises:
        self.api = get_property(py, "api", None)
        self.provider = get_property(py, "provider", None)
        self.model = String(get_property(py, "model", ""))
        self.output = get_property(py, "output", None)
        self.responseId = String(get_property(py, "responseId", ""))
        self.usage = Usage(get_property(py, "usage", None))
        self.stopReason = get_property(py, "stopReason", None)
        self.errorMessage = String(get_property(py, "errorMessage", ""))
        self.timestamp = Int(py=get_property(py, "timestamp", 0))

    def to_py(self) raises -> PythonObject:
        var builtins = Python.import_module("builtins")
        var d = builtins.dict()
        d["api"] = self.api
        d["provider"] = self.provider
        d["model"] = self.model
        d["output"] = self.output
        d["responseId"] = self.responseId
        d["usage"] = self.usage.to_py()
        d["stopReason"] = self.stopReason
        d["errorMessage"] = self.errorMessage
        d["timestamp"] = self.timestamp
        return d

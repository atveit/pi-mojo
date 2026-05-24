from std.python import Python, PythonObject
from t2m_runtime.utils import _init_globals, get_property

struct TextSignatureV1(ImplicitlyCopyable):
    var v: PythonObject
    var id: String
    var phase: PythonObject

    def __init__(out self, v: PythonObject, id: String, phase: PythonObject):
        self.v = v
        self.id = id
        self.phase = phase

    def __init__(out self, *, copy: Self):
        self.v = copy.v
        self.id = copy.id
        self.phase = copy.phase

    def __init__(out self, py: PythonObject) raises:
        self.v = get_property(py, "v", None)
        self.id = String(get_property(py, "id", ""))
        self.phase = get_property(py, "phase", None)

    def to_py(self) raises -> PythonObject:
        var builtins = Python.import_module("builtins")
        var d = builtins.dict()
        d["v"] = self.v
        d["id"] = self.id
        d["phase"] = self.phase
        return d

struct TextContent(ImplicitlyCopyable):
    var type: PythonObject
    var text: String
    var textSignature: String

    def __init__(out self, type: PythonObject, text: String, textSignature: String):
        self.type = type
        self.text = text
        self.textSignature = textSignature

    def __init__(out self, *, copy: Self):
        self.type = copy.type
        self.text = copy.text
        self.textSignature = copy.textSignature

    def __init__(out self, py: PythonObject) raises:
        self.type = get_property(py, "type", None)
        self.text = String(get_property(py, "text", ""))
        self.textSignature = String(get_property(py, "textSignature", ""))

    def to_py(self) raises -> PythonObject:
        var builtins = Python.import_module("builtins")
        var d = builtins.dict()
        d["type"] = self.type
        d["text"] = self.text
        d["textSignature"] = self.textSignature
        return d

struct ThinkingContent(ImplicitlyCopyable):
    var type: PythonObject
    var thinking: String
    var thinkingSignature: String
    var redacted: Bool

    def __init__(out self, type: PythonObject, thinking: String, thinkingSignature: String, redacted: Bool):
        self.type = type
        self.thinking = thinking
        self.thinkingSignature = thinkingSignature
        self.redacted = redacted

    def __init__(out self, *, copy: Self):
        self.type = copy.type
        self.thinking = copy.thinking
        self.thinkingSignature = copy.thinkingSignature
        self.redacted = copy.redacted

    def __init__(out self, py: PythonObject) raises:
        self.type = get_property(py, "type", None)
        self.thinking = String(get_property(py, "thinking", ""))
        self.thinkingSignature = String(get_property(py, "thinkingSignature", ""))
        self.redacted = Bool(py=get_property(py, "redacted", False))

    def to_py(self) raises -> PythonObject:
        var builtins = Python.import_module("builtins")
        var d = builtins.dict()
        d["type"] = self.type
        d["thinking"] = self.thinking
        d["thinkingSignature"] = self.thinkingSignature
        d["redacted"] = self.redacted
        return d

struct ImageContent(ImplicitlyCopyable):
    var type: PythonObject
    var data: String
    var mimeType: String

    def __init__(out self, type: PythonObject, data: String, mimeType: String):
        self.type = type
        self.data = data
        self.mimeType = mimeType

    def __init__(out self, *, copy: Self):
        self.type = copy.type
        self.data = copy.data
        self.mimeType = copy.mimeType

    def __init__(out self, py: PythonObject) raises:
        self.type = get_property(py, "type", None)
        self.data = String(get_property(py, "data", ""))
        self.mimeType = String(get_property(py, "mimeType", ""))

    def to_py(self) raises -> PythonObject:
        var builtins = Python.import_module("builtins")
        var d = builtins.dict()
        d["type"] = self.type
        d["data"] = self.data
        d["mimeType"] = self.mimeType
        return d

struct ToolResultMessage(ImplicitlyCopyable):
    var role: PythonObject
    var toolCallId: String
    var toolName: String
    var content: PythonObject
    var details: PythonObject
    var isError: Bool
    var timestamp: Int

    def __init__(out self, role: PythonObject, toolCallId: String, toolName: String, content: PythonObject, details: PythonObject, isError: Bool, timestamp: Int):
        self.role = role
        self.toolCallId = toolCallId
        self.toolName = toolName
        self.content = content
        self.details = details
        self.isError = isError
        self.timestamp = timestamp

    def __init__(out self, *, copy: Self):
        self.role = copy.role
        self.toolCallId = copy.toolCallId
        self.toolName = copy.toolName
        self.content = copy.content
        self.details = copy.details
        self.isError = copy.isError
        self.timestamp = copy.timestamp

    def __init__(out self, py: PythonObject) raises:
        self.role = get_property(py, "role", None)
        self.toolCallId = String(get_property(py, "toolCallId", ""))
        self.toolName = String(get_property(py, "toolName", ""))
        self.content = get_property(py, "content", None)
        self.details = get_property(py, "details", None)
        self.isError = Bool(py=get_property(py, "isError", False))
        self.timestamp = Int(py=get_property(py, "timestamp", 0))

    def to_py(self) raises -> PythonObject:
        var builtins = Python.import_module("builtins")
        var d = builtins.dict()
        d["role"] = self.role
        d["toolCallId"] = self.toolCallId
        d["toolName"] = self.toolName
        d["content"] = self.content
        d["details"] = self.details
        d["isError"] = self.isError
        d["timestamp"] = self.timestamp
        return d

from std.python import Python, PythonObject
from t2m_runtime.utils import _init_globals, get_property
from packages.ai.pi_ai_types import AssistantMessage
from packages.agent.pi_agent_types_loop import AgentContext

struct BeforeToolCallResult(ImplicitlyCopyable):
    var block: Bool
    var reason: String

    def __init__(out self, block: Bool, reason: String):
        self.block = block
        self.reason = reason

    def __init__(out self, *, copy: Self):
        self.block = copy.block
        self.reason = copy.reason

    def __init__(out self, py: PythonObject) raises:
        self.block = Bool(py=get_property(py, "block", False))
        self.reason = String(get_property(py, "reason", ""))

    def to_py(self) raises -> PythonObject:
        var builtins = Python.import_module("builtins")
        var d = builtins.dict()
        d["block"] = self.block
        d["reason"] = self.reason
        return d

struct AfterToolCallResult(ImplicitlyCopyable):
    var content: PythonObject
    var details: PythonObject
    var isError: Bool
    var terminate: Bool

    def __init__(out self, content: PythonObject, details: PythonObject, isError: Bool, terminate: Bool):
        self.content = content
        self.details = details
        self.isError = isError
        self.terminate = terminate

    def __init__(out self, *, copy: Self):
        self.content = copy.content
        self.details = copy.details
        self.isError = copy.isError
        self.terminate = copy.terminate

    def __init__(out self, py: PythonObject) raises:
        self.content = get_property(py, "content", None)
        self.details = get_property(py, "details", None)
        self.isError = Bool(py=get_property(py, "isError", False))
        self.terminate = Bool(py=get_property(py, "terminate", False))

    def to_py(self) raises -> PythonObject:
        var builtins = Python.import_module("builtins")
        var d = builtins.dict()
        d["content"] = self.content
        d["details"] = self.details
        d["isError"] = self.isError
        d["terminate"] = self.terminate
        return d

struct BeforeToolCallContext(ImplicitlyCopyable):
    var assistantMessage: AssistantMessage
    var toolCall: PythonObject
    var args: PythonObject
    var context: AgentContext

    def __init__(out self, assistantMessage: AssistantMessage, toolCall: PythonObject, args: PythonObject, context: AgentContext):
        self.assistantMessage = assistantMessage
        self.toolCall = toolCall
        self.args = args
        self.context = context

    def __init__(out self, *, copy: Self):
        self.assistantMessage = copy.assistantMessage
        self.toolCall = copy.toolCall
        self.args = copy.args
        self.context = copy.context

    def __init__(out self, py: PythonObject) raises:
        self.assistantMessage = AssistantMessage(get_property(py, "assistantMessage", None))
        self.toolCall = get_property(py, "toolCall", None)
        self.args = get_property(py, "args", None)
        self.context = AgentContext(get_property(py, "context", None))

    def to_py(self) raises -> PythonObject:
        var builtins = Python.import_module("builtins")
        var d = builtins.dict()
        d["assistantMessage"] = self.assistantMessage.to_py()
        d["toolCall"] = self.toolCall
        d["args"] = self.args
        d["context"] = self.context.to_py()
        return d

struct AfterToolCallContext(ImplicitlyCopyable):
    var assistantMessage: AssistantMessage
    var toolCall: PythonObject
    var args: PythonObject
    var result: PythonObject
    var isError: Bool
    var context: AgentContext

    def __init__(out self, assistantMessage: AssistantMessage, toolCall: PythonObject, args: PythonObject, result: PythonObject, isError: Bool, context: AgentContext):
        self.assistantMessage = assistantMessage
        self.toolCall = toolCall
        self.args = args
        self.result = result
        self.isError = isError
        self.context = context

    def __init__(out self, *, copy: Self):
        self.assistantMessage = copy.assistantMessage
        self.toolCall = copy.toolCall
        self.args = copy.args
        self.result = copy.result
        self.isError = copy.isError
        self.context = copy.context

    def __init__(out self, py: PythonObject) raises:
        self.assistantMessage = AssistantMessage(get_property(py, "assistantMessage", None))
        self.toolCall = get_property(py, "toolCall", None)
        self.args = get_property(py, "args", None)
        self.result = get_property(py, "result", None)
        self.isError = Bool(py=get_property(py, "isError", False))
        self.context = AgentContext(get_property(py, "context", None))

    def to_py(self) raises -> PythonObject:
        var builtins = Python.import_module("builtins")
        var d = builtins.dict()
        d["assistantMessage"] = self.assistantMessage.to_py()
        d["toolCall"] = self.toolCall
        d["args"] = self.args
        d["result"] = self.result
        d["isError"] = self.isError
        d["context"] = self.context.to_py()
        return d

struct AgentToolResult(ImplicitlyCopyable):
    var content: PythonObject
    var details: PythonObject
    var terminate: Bool

    def __init__(out self, content: PythonObject, details: PythonObject, terminate: Bool):
        self.content = content
        self.details = details
        self.terminate = terminate

    def __init__(out self, *, copy: Self):
        self.content = copy.content
        self.details = copy.details
        self.terminate = copy.terminate

    def __init__(out self, py: PythonObject) raises:
        self.content = get_property(py, "content", None)
        self.details = get_property(py, "details", None)
        self.terminate = Bool(py=get_property(py, "terminate", False))

    def to_py(self) raises -> PythonObject:
        var builtins = Python.import_module("builtins")
        var d = builtins.dict()
        d["content"] = self.content
        d["details"] = self.details
        d["terminate"] = self.terminate
        return d

struct AgentTool(ImplicitlyCopyable):
    var label: String
    var prepareArguments: PythonObject
    var execute: PythonObject
    var executionMode: PythonObject
    var name: String
    var description: String
    var parameters: PythonObject

    def __init__(out self, label: String, prepareArguments: PythonObject, execute: PythonObject, executionMode: PythonObject, name: String, description: String, parameters: PythonObject):
        self.label = label
        self.prepareArguments = prepareArguments
        self.execute = execute
        self.executionMode = executionMode
        self.name = name
        self.description = description
        self.parameters = parameters

    def __init__(out self, *, copy: Self):
        self.label = copy.label
        self.prepareArguments = copy.prepareArguments
        self.execute = copy.execute
        self.executionMode = copy.executionMode
        self.name = copy.name
        self.description = copy.description
        self.parameters = copy.parameters

    def __init__(out self, py: PythonObject) raises:
        self.label = String(get_property(py, "label", ""))
        self.prepareArguments = get_property(py, "prepareArguments", None)
        self.execute = get_property(py, "execute", None)
        self.executionMode = get_property(py, "executionMode", None)
        self.name = String(get_property(py, "name", ""))
        self.description = String(get_property(py, "description", ""))
        self.parameters = get_property(py, "parameters", None)

    def to_py(self) raises -> PythonObject:
        var builtins = Python.import_module("builtins")
        var d = builtins.dict()
        d["label"] = self.label
        d["prepareArguments"] = self.prepareArguments
        d["execute"] = self.execute
        d["executionMode"] = self.executionMode
        d["name"] = self.name
        d["description"] = self.description
        d["parameters"] = self.parameters
        return d

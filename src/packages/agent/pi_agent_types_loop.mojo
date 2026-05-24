from std.python import Python, PythonObject
from t2m_runtime.utils import _init_globals, get_property
from packages.ai.pi_ai_types import AssistantMessage, ThinkingBudgets

struct AgentContext(ImplicitlyCopyable):
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

struct ShouldStopAfterTurnContext(ImplicitlyCopyable):
    var message: AssistantMessage
    var toolResults: PythonObject
    var context: AgentContext
    var newMessages: PythonObject

    def __init__(out self, message: AssistantMessage, toolResults: PythonObject, context: AgentContext, newMessages: PythonObject):
        self.message = message
        self.toolResults = toolResults
        self.context = context
        self.newMessages = newMessages

    def __init__(out self, *, copy: Self):
        self.message = copy.message
        self.toolResults = copy.toolResults
        self.context = copy.context
        self.newMessages = copy.newMessages

    def __init__(out self, py: PythonObject) raises:
        self.message = AssistantMessage(get_property(py, "message", None))
        self.toolResults = get_property(py, "toolResults", None)
        self.context = AgentContext(get_property(py, "context", None))
        self.newMessages = get_property(py, "newMessages", None)

    def to_py(self) raises -> PythonObject:
        var builtins = Python.import_module("builtins")
        var d = builtins.dict()
        d["message"] = self.message.to_py()
        d["toolResults"] = self.toolResults
        d["context"] = self.context.to_py()
        d["newMessages"] = self.newMessages
        return d

struct AgentLoopTurnUpdate(ImplicitlyCopyable):
    var context: AgentContext
    var model: PythonObject
    var thinkingLevel: PythonObject

    def __init__(out self, context: AgentContext, model: PythonObject, thinkingLevel: PythonObject):
        self.context = context
        self.model = model
        self.thinkingLevel = thinkingLevel

    def __init__(out self, *, copy: Self):
        self.context = copy.context
        self.model = copy.model
        self.thinkingLevel = copy.thinkingLevel

    def __init__(out self, py: PythonObject) raises:
        self.context = AgentContext(get_property(py, "context", None))
        self.model = get_property(py, "model", None)
        self.thinkingLevel = get_property(py, "thinkingLevel", None)

    def to_py(self) raises -> PythonObject:
        var builtins = Python.import_module("builtins")
        var d = builtins.dict()
        d["context"] = self.context.to_py()
        d["model"] = self.model
        d["thinkingLevel"] = self.thinkingLevel
        return d

struct PrepareNextTurnContext(ImplicitlyCopyable):
    var message: AssistantMessage
    var toolResults: PythonObject
    var context: AgentContext
    var newMessages: PythonObject

    def __init__(out self, message: AssistantMessage, toolResults: PythonObject, context: AgentContext, newMessages: PythonObject):
        self.message = message
        self.toolResults = toolResults
        self.context = context
        self.newMessages = newMessages

    def __init__(out self, *, copy: Self):
        self.message = copy.message
        self.toolResults = copy.toolResults
        self.context = copy.context
        self.newMessages = copy.newMessages

    def __init__(out self, py: PythonObject) raises:
        self.message = AssistantMessage(get_property(py, "message", None))
        self.toolResults = get_property(py, "toolResults", None)
        self.context = AgentContext(get_property(py, "context", None))
        self.newMessages = get_property(py, "newMessages", None)

    def to_py(self) raises -> PythonObject:
        var builtins = Python.import_module("builtins")
        var d = builtins.dict()
        d["message"] = self.message.to_py()
        d["toolResults"] = self.toolResults
        d["context"] = self.context.to_py()
        d["newMessages"] = self.newMessages
        return d

struct AgentLoopConfig(ImplicitlyCopyable):
    var model: PythonObject
    var convertToLlm: PythonObject
    var transformContext: PythonObject
    var getApiKey: PythonObject
    var shouldStopAfterTurn: PythonObject
    var prepareNextTurn: PythonObject
    var getSteeringMessages: PythonObject
    var getFollowUpMessages: PythonObject
    var toolExecution: PythonObject
    var beforeToolCall: PythonObject
    var afterToolCall: PythonObject
    var reasoning: PythonObject
    var thinkingBudgets: ThinkingBudgets
    var temperature: Int
    var maxTokens: Int
    var signal: PythonObject
    var apiKey: String
    var transport: PythonObject
    var cacheRetention: PythonObject
    var sessionId: String
    var onPayload: PythonObject
    var onResponse: PythonObject
    var headers: PythonObject
    var timeoutMs: Int
    var maxRetries: Int
    var maxRetryDelayMs: Int
    var metadata: PythonObject

    def __init__(out self, model: PythonObject, convertToLlm: PythonObject, transformContext: PythonObject, getApiKey: PythonObject, shouldStopAfterTurn: PythonObject, prepareNextTurn: PythonObject, getSteeringMessages: PythonObject, getFollowUpMessages: PythonObject, toolExecution: PythonObject, beforeToolCall: PythonObject, afterToolCall: PythonObject, reasoning: PythonObject, thinkingBudgets: ThinkingBudgets, temperature: Int, maxTokens: Int, signal: PythonObject, apiKey: String, transport: PythonObject, cacheRetention: PythonObject, sessionId: String, onPayload: PythonObject, onResponse: PythonObject, headers: PythonObject, timeoutMs: Int, maxRetries: Int, maxRetryDelayMs: Int, metadata: PythonObject):
        self.model = model
        self.convertToLlm = convertToLlm
        self.transformContext = transformContext
        self.getApiKey = getApiKey
        self.shouldStopAfterTurn = shouldStopAfterTurn
        self.prepareNextTurn = prepareNextTurn
        self.getSteeringMessages = getSteeringMessages
        self.getFollowUpMessages = getFollowUpMessages
        self.toolExecution = toolExecution
        self.beforeToolCall = beforeToolCall
        self.afterToolCall = afterToolCall
        self.reasoning = reasoning
        self.thinkingBudgets = thinkingBudgets
        self.temperature = temperature
        self.maxTokens = maxTokens
        self.signal = signal
        self.apiKey = apiKey
        self.transport = transport
        self.cacheRetention = cacheRetention
        self.sessionId = sessionId
        self.onPayload = onPayload
        self.onResponse = onResponse
        self.headers = headers
        self.timeoutMs = timeoutMs
        self.maxRetries = maxRetries
        self.maxRetryDelayMs = maxRetryDelayMs
        self.metadata = metadata

    def __init__(out self, *, copy: Self):
        self.model = copy.model
        self.convertToLlm = copy.convertToLlm
        self.transformContext = copy.transformContext
        self.getApiKey = copy.getApiKey
        self.shouldStopAfterTurn = copy.shouldStopAfterTurn
        self.prepareNextTurn = copy.prepareNextTurn
        self.getSteeringMessages = copy.getSteeringMessages
        self.getFollowUpMessages = copy.getFollowUpMessages
        self.toolExecution = copy.toolExecution
        self.beforeToolCall = copy.beforeToolCall
        self.afterToolCall = copy.afterToolCall
        self.reasoning = copy.reasoning
        self.thinkingBudgets = copy.thinkingBudgets
        self.temperature = copy.temperature
        self.maxTokens = copy.maxTokens
        self.signal = copy.signal
        self.apiKey = copy.apiKey
        self.transport = copy.transport
        self.cacheRetention = copy.cacheRetention
        self.sessionId = copy.sessionId
        self.onPayload = copy.onPayload
        self.onResponse = copy.onResponse
        self.headers = copy.headers
        self.timeoutMs = copy.timeoutMs
        self.maxRetries = copy.maxRetries
        self.maxRetryDelayMs = copy.maxRetryDelayMs
        self.metadata = copy.metadata

    def __init__(out self, py: PythonObject) raises:
        self.model = get_property(py, "model", None)
        self.convertToLlm = get_property(py, "convertToLlm", None)
        self.transformContext = get_property(py, "transformContext", None)
        self.getApiKey = get_property(py, "getApiKey", None)
        self.shouldStopAfterTurn = get_property(py, "shouldStopAfterTurn", None)
        self.prepareNextTurn = get_property(py, "prepareNextTurn", None)
        self.getSteeringMessages = get_property(py, "getSteeringMessages", None)
        self.getFollowUpMessages = get_property(py, "getFollowUpMessages", None)
        self.toolExecution = get_property(py, "toolExecution", None)
        self.beforeToolCall = get_property(py, "beforeToolCall", None)
        self.afterToolCall = get_property(py, "afterToolCall", None)
        self.reasoning = get_property(py, "reasoning", None)
        self.thinkingBudgets = ThinkingBudgets(get_property(py, "thinkingBudgets", None))
        self.temperature = Int(py=get_property(py, "temperature", 0))
        self.maxTokens = Int(py=get_property(py, "maxTokens", 0))
        self.signal = get_property(py, "signal", None)
        self.apiKey = String(get_property(py, "apiKey", ""))
        self.transport = get_property(py, "transport", None)
        self.cacheRetention = get_property(py, "cacheRetention", None)
        self.sessionId = String(get_property(py, "sessionId", ""))
        self.onPayload = get_property(py, "onPayload", None)
        self.onResponse = get_property(py, "onResponse", None)
        self.headers = get_property(py, "headers", None)
        self.timeoutMs = Int(py=get_property(py, "timeoutMs", 0))
        self.maxRetries = Int(py=get_property(py, "maxRetries", 0))
        self.maxRetryDelayMs = Int(py=get_property(py, "maxRetryDelayMs", 0))
        self.metadata = get_property(py, "metadata", None)

    def to_py(self) raises -> PythonObject:
        var builtins = Python.import_module("builtins")
        var d = builtins.dict()
        d["model"] = self.model
        d["convertToLlm"] = self.convertToLlm
        d["transformContext"] = self.transformContext
        d["getApiKey"] = self.getApiKey
        d["shouldStopAfterTurn"] = self.shouldStopAfterTurn
        d["prepareNextTurn"] = self.prepareNextTurn
        d["getSteeringMessages"] = self.getSteeringMessages
        d["getFollowUpMessages"] = self.getFollowUpMessages
        d["toolExecution"] = self.toolExecution
        d["beforeToolCall"] = self.beforeToolCall
        d["afterToolCall"] = self.afterToolCall
        d["reasoning"] = self.reasoning
        d["thinkingBudgets"] = self.thinkingBudgets.to_py()
        d["temperature"] = self.temperature
        d["maxTokens"] = self.maxTokens
        d["signal"] = self.signal
        d["apiKey"] = self.apiKey
        d["transport"] = self.transport
        d["cacheRetention"] = self.cacheRetention
        d["sessionId"] = self.sessionId
        d["onPayload"] = self.onPayload
        d["onResponse"] = self.onResponse
        d["headers"] = self.headers
        d["timeoutMs"] = self.timeoutMs
        d["maxRetries"] = self.maxRetries
        d["maxRetryDelayMs"] = self.maxRetryDelayMs
        d["metadata"] = self.metadata
        return d

struct CustomAgentMessages(ImplicitlyCopyable):
    pass

struct AgentState(ImplicitlyCopyable):
    var systemPrompt: String
    var model: PythonObject
    var thinkingLevel: PythonObject
    var tools: PythonObject
    var messages: PythonObject
    var isStreaming: Bool
    var streamingMessage: PythonObject
    var pendingToolCalls: PythonObject
    var errorMessage: String

    def __init__(out self, systemPrompt: String, model: PythonObject, thinkingLevel: PythonObject, tools: PythonObject, messages: PythonObject, isStreaming: Bool, streamingMessage: PythonObject, pendingToolCalls: PythonObject, errorMessage: String):
        self.systemPrompt = systemPrompt
        self.model = model
        self.thinkingLevel = thinkingLevel
        self.tools = tools
        self.messages = messages
        self.isStreaming = isStreaming
        self.streamingMessage = streamingMessage
        self.pendingToolCalls = pendingToolCalls
        self.errorMessage = errorMessage

    def __init__(out self, *, copy: Self):
        self.systemPrompt = copy.systemPrompt
        self.model = copy.model
        self.thinkingLevel = copy.thinkingLevel
        self.tools = copy.tools
        self.messages = copy.messages
        self.isStreaming = copy.isStreaming
        self.streamingMessage = copy.streamingMessage
        self.pendingToolCalls = copy.pendingToolCalls
        self.errorMessage = copy.errorMessage

    def __init__(out self, py: PythonObject) raises:
        self.systemPrompt = String(get_property(py, "systemPrompt", ""))
        self.model = get_property(py, "model", None)
        self.thinkingLevel = get_property(py, "thinkingLevel", None)
        self.tools = get_property(py, "tools", None)
        self.messages = get_property(py, "messages", None)
        self.isStreaming = Bool(py=get_property(py, "isStreaming", False))
        self.streamingMessage = get_property(py, "streamingMessage", None)
        self.pendingToolCalls = get_property(py, "pendingToolCalls", None)
        self.errorMessage = String(get_property(py, "errorMessage", ""))

    def to_py(self) raises -> PythonObject:
        var builtins = Python.import_module("builtins")
        var d = builtins.dict()
        d["systemPrompt"] = self.systemPrompt
        d["model"] = self.model
        d["thinkingLevel"] = self.thinkingLevel
        d["tools"] = self.tools
        d["messages"] = self.messages
        d["isStreaming"] = self.isStreaming
        d["streamingMessage"] = self.streamingMessage
        d["pendingToolCalls"] = self.pendingToolCalls
        d["errorMessage"] = self.errorMessage
        return d

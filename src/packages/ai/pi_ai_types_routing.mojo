from std.python import Python, PythonObject
from t2m_runtime.utils import _init_globals, get_property
from packages.ai.pi_ai_types_basic import ThinkingBudgets

struct StreamOptions(ImplicitlyCopyable):
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

    def __init__(out self, temperature: Int, maxTokens: Int, signal: PythonObject, apiKey: String, transport: PythonObject, cacheRetention: PythonObject, sessionId: String, onPayload: PythonObject, onResponse: PythonObject, headers: PythonObject, timeoutMs: Int, maxRetries: Int, maxRetryDelayMs: Int, metadata: PythonObject):
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

struct ImagesOptions(ImplicitlyCopyable):
    var signal: PythonObject
    var apiKey: String
    var onPayload: PythonObject
    var onResponse: PythonObject
    var headers: PythonObject
    var timeoutMs: Int
    var maxRetries: Int
    var maxRetryDelayMs: Int
    var metadata: PythonObject

    def __init__(out self, signal: PythonObject, apiKey: String, onPayload: PythonObject, onResponse: PythonObject, headers: PythonObject, timeoutMs: Int, maxRetries: Int, maxRetryDelayMs: Int, metadata: PythonObject):
        self.signal = signal
        self.apiKey = apiKey
        self.onPayload = onPayload
        self.onResponse = onResponse
        self.headers = headers
        self.timeoutMs = timeoutMs
        self.maxRetries = maxRetries
        self.maxRetryDelayMs = maxRetryDelayMs
        self.metadata = metadata

    def __init__(out self, *, copy: Self):
        self.signal = copy.signal
        self.apiKey = copy.apiKey
        self.onPayload = copy.onPayload
        self.onResponse = copy.onResponse
        self.headers = copy.headers
        self.timeoutMs = copy.timeoutMs
        self.maxRetries = copy.maxRetries
        self.maxRetryDelayMs = copy.maxRetryDelayMs
        self.metadata = copy.metadata

    def __init__(out self, py: PythonObject) raises:
        self.signal = get_property(py, "signal", None)
        self.apiKey = String(get_property(py, "apiKey", ""))
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
        d["signal"] = self.signal
        d["apiKey"] = self.apiKey
        d["onPayload"] = self.onPayload
        d["onResponse"] = self.onResponse
        d["headers"] = self.headers
        d["timeoutMs"] = self.timeoutMs
        d["maxRetries"] = self.maxRetries
        d["maxRetryDelayMs"] = self.maxRetryDelayMs
        d["metadata"] = self.metadata
        return d

struct SimpleStreamOptions(ImplicitlyCopyable):
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

    def __init__(out self, reasoning: PythonObject, thinkingBudgets: ThinkingBudgets, temperature: Int, maxTokens: Int, signal: PythonObject, apiKey: String, transport: PythonObject, cacheRetention: PythonObject, sessionId: String, onPayload: PythonObject, onResponse: PythonObject, headers: PythonObject, timeoutMs: Int, maxRetries: Int, maxRetryDelayMs: Int, metadata: PythonObject):
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

struct OpenAICompletionsCompat(ImplicitlyCopyable):
    var supportsStore: Bool
    var supportsDeveloperRole: Bool
    var supportsReasoningEffort: Bool
    var supportsUsageInStreaming: Bool
    var maxTokensField: PythonObject
    var requiresToolResultName: Bool
    var requiresAssistantAfterToolResult: Bool
    var requiresThinkingAsText: Bool
    var requiresReasoningContentOnAssistantMessages: Bool
    var thinkingFormat: PythonObject
    var openRouterRouting: OpenRouterRouting
    var vercelGatewayRouting: VercelGatewayRouting
    var zaiToolStream: Bool
    var supportsStrictMode: Bool
    var cacheControlFormat: PythonObject
    var sendSessionAffinityHeaders: Bool
    var supportsLongCacheRetention: Bool

    def __init__(out self, supportsStore: Bool, supportsDeveloperRole: Bool, supportsReasoningEffort: Bool, supportsUsageInStreaming: Bool, maxTokensField: PythonObject, requiresToolResultName: Bool, requiresAssistantAfterToolResult: Bool, requiresThinkingAsText: Bool, requiresReasoningContentOnAssistantMessages: Bool, thinkingFormat: PythonObject, openRouterRouting: OpenRouterRouting, vercelGatewayRouting: VercelGatewayRouting, zaiToolStream: Bool, supportsStrictMode: Bool, cacheControlFormat: PythonObject, sendSessionAffinityHeaders: Bool, supportsLongCacheRetention: Bool):
        self.supportsStore = supportsStore
        self.supportsDeveloperRole = supportsDeveloperRole
        self.supportsReasoningEffort = supportsReasoningEffort
        self.supportsUsageInStreaming = supportsUsageInStreaming
        self.maxTokensField = maxTokensField
        self.requiresToolResultName = requiresToolResultName
        self.requiresAssistantAfterToolResult = requiresAssistantAfterToolResult
        self.requiresThinkingAsText = requiresThinkingAsText
        self.requiresReasoningContentOnAssistantMessages = requiresReasoningContentOnAssistantMessages
        self.thinkingFormat = thinkingFormat
        self.openRouterRouting = openRouterRouting
        self.vercelGatewayRouting = vercelGatewayRouting
        self.zaiToolStream = zaiToolStream
        self.supportsStrictMode = supportsStrictMode
        self.cacheControlFormat = cacheControlFormat
        self.sendSessionAffinityHeaders = sendSessionAffinityHeaders
        self.supportsLongCacheRetention = supportsLongCacheRetention

    def __init__(out self, *, copy: Self):
        self.supportsStore = copy.supportsStore
        self.supportsDeveloperRole = copy.supportsDeveloperRole
        self.supportsReasoningEffort = copy.supportsReasoningEffort
        self.supportsUsageInStreaming = copy.supportsUsageInStreaming
        self.maxTokensField = copy.maxTokensField
        self.requiresToolResultName = copy.requiresToolResultName
        self.requiresAssistantAfterToolResult = copy.requiresAssistantAfterToolResult
        self.requiresThinkingAsText = copy.requiresThinkingAsText
        self.requiresReasoningContentOnAssistantMessages = copy.requiresReasoningContentOnAssistantMessages
        self.thinkingFormat = copy.thinkingFormat
        self.openRouterRouting = copy.openRouterRouting
        self.vercelGatewayRouting = copy.vercelGatewayRouting
        self.zaiToolStream = copy.zaiToolStream
        self.supportsStrictMode = copy.supportsStrictMode
        self.cacheControlFormat = copy.cacheControlFormat
        self.sendSessionAffinityHeaders = copy.sendSessionAffinityHeaders
        self.supportsLongCacheRetention = copy.supportsLongCacheRetention

    def __init__(out self, py: PythonObject) raises:
        self.supportsStore = Bool(py=get_property(py, "supportsStore", False))
        self.supportsDeveloperRole = Bool(py=get_property(py, "supportsDeveloperRole", False))
        self.supportsReasoningEffort = Bool(py=get_property(py, "supportsReasoningEffort", False))
        self.supportsUsageInStreaming = Bool(py=get_property(py, "supportsUsageInStreaming", False))
        self.maxTokensField = get_property(py, "maxTokensField", None)
        self.requiresToolResultName = Bool(py=get_property(py, "requiresToolResultName", False))
        self.requiresAssistantAfterToolResult = Bool(py=get_property(py, "requiresAssistantAfterToolResult", False))
        self.requiresThinkingAsText = Bool(py=get_property(py, "requiresThinkingAsText", False))
        self.requiresReasoningContentOnAssistantMessages = Bool(py=get_property(py, "requiresReasoningContentOnAssistantMessages", False))
        self.thinkingFormat = get_property(py, "thinkingFormat", None)
        self.openRouterRouting = OpenRouterRouting(get_property(py, "openRouterRouting", None))
        self.vercelGatewayRouting = VercelGatewayRouting(get_property(py, "vercelGatewayRouting", None))
        self.zaiToolStream = Bool(py=get_property(py, "zaiToolStream", False))
        self.supportsStrictMode = Bool(py=get_property(py, "supportsStrictMode", False))
        self.cacheControlFormat = get_property(py, "cacheControlFormat", None)
        self.sendSessionAffinityHeaders = Bool(py=get_property(py, "sendSessionAffinityHeaders", False))
        self.supportsLongCacheRetention = Bool(py=get_property(py, "supportsLongCacheRetention", False))

    def to_py(self) raises -> PythonObject:
        var builtins = Python.import_module("builtins")
        var d = builtins.dict()
        d["supportsStore"] = self.supportsStore
        d["supportsDeveloperRole"] = self.supportsDeveloperRole
        d["supportsReasoningEffort"] = self.supportsReasoningEffort
        d["supportsUsageInStreaming"] = self.supportsUsageInStreaming
        d["maxTokensField"] = self.maxTokensField
        d["requiresToolResultName"] = self.requiresToolResultName
        d["requiresAssistantAfterToolResult"] = self.requiresAssistantAfterToolResult
        d["requiresThinkingAsText"] = self.requiresThinkingAsText
        d["requiresReasoningContentOnAssistantMessages"] = self.requiresReasoningContentOnAssistantMessages
        d["thinkingFormat"] = self.thinkingFormat
        d["openRouterRouting"] = self.openRouterRouting.to_py()
        d["vercelGatewayRouting"] = self.vercelGatewayRouting.to_py()
        d["zaiToolStream"] = self.zaiToolStream
        d["supportsStrictMode"] = self.supportsStrictMode
        d["cacheControlFormat"] = self.cacheControlFormat
        d["sendSessionAffinityHeaders"] = self.sendSessionAffinityHeaders
        d["supportsLongCacheRetention"] = self.supportsLongCacheRetention
        return d

struct OpenAIResponsesCompat(ImplicitlyCopyable):
    var sendSessionIdHeader: Bool
    var supportsLongCacheRetention: Bool

    def __init__(out self, sendSessionIdHeader: Bool, supportsLongCacheRetention: Bool):
        self.sendSessionIdHeader = sendSessionIdHeader
        self.supportsLongCacheRetention = supportsLongCacheRetention

    def __init__(out self, *, copy: Self):
        self.sendSessionIdHeader = copy.sendSessionIdHeader
        self.supportsLongCacheRetention = copy.supportsLongCacheRetention

    def __init__(out self, py: PythonObject) raises:
        self.sendSessionIdHeader = Bool(py=get_property(py, "sendSessionIdHeader", False))
        self.supportsLongCacheRetention = Bool(py=get_property(py, "supportsLongCacheRetention", False))

    def to_py(self) raises -> PythonObject:
        var builtins = Python.import_module("builtins")
        var d = builtins.dict()
        d["sendSessionIdHeader"] = self.sendSessionIdHeader
        d["supportsLongCacheRetention"] = self.supportsLongCacheRetention
        return d

struct AnthropicMessagesCompat(ImplicitlyCopyable):
    var supportsEagerToolInputStreaming: Bool
    var supportsLongCacheRetention: Bool
    var sendSessionAffinityHeaders: Bool
    var supportsCacheControlOnTools: Bool
    var forceAdaptiveThinking: Bool

    def __init__(out self, supportsEagerToolInputStreaming: Bool, supportsLongCacheRetention: Bool, sendSessionAffinityHeaders: Bool, supportsCacheControlOnTools: Bool, forceAdaptiveThinking: Bool):
        self.supportsEagerToolInputStreaming = supportsEagerToolInputStreaming
        self.supportsLongCacheRetention = supportsLongCacheRetention
        self.sendSessionAffinityHeaders = sendSessionAffinityHeaders
        self.supportsCacheControlOnTools = supportsCacheControlOnTools
        self.forceAdaptiveThinking = forceAdaptiveThinking

    def __init__(out self, *, copy: Self):
        self.supportsEagerToolInputStreaming = copy.supportsEagerToolInputStreaming
        self.supportsLongCacheRetention = copy.supportsLongCacheRetention
        self.sendSessionAffinityHeaders = copy.sendSessionAffinityHeaders
        self.supportsCacheControlOnTools = copy.supportsCacheControlOnTools
        self.forceAdaptiveThinking = copy.forceAdaptiveThinking

    def __init__(out self, py: PythonObject) raises:
        self.supportsEagerToolInputStreaming = Bool(py=get_property(py, "supportsEagerToolInputStreaming", False))
        self.supportsLongCacheRetention = Bool(py=get_property(py, "supportsLongCacheRetention", False))
        self.sendSessionAffinityHeaders = Bool(py=get_property(py, "sendSessionAffinityHeaders", False))
        self.supportsCacheControlOnTools = Bool(py=get_property(py, "supportsCacheControlOnTools", False))
        self.forceAdaptiveThinking = Bool(py=get_property(py, "forceAdaptiveThinking", False))

    def to_py(self) raises -> PythonObject:
        var builtins = Python.import_module("builtins")
        var d = builtins.dict()
        d["supportsEagerToolInputStreaming"] = self.supportsEagerToolInputStreaming
        d["supportsLongCacheRetention"] = self.supportsLongCacheRetention
        d["sendSessionAffinityHeaders"] = self.sendSessionAffinityHeaders
        d["supportsCacheControlOnTools"] = self.supportsCacheControlOnTools
        d["forceAdaptiveThinking"] = self.forceAdaptiveThinking
        return d

struct OpenRouterRouting(ImplicitlyCopyable):
    var allow_fallbacks: Bool
    var require_parameters: Bool
    var data_collection: PythonObject
    var zdr: Bool
    var enforce_distillable_text: Bool
    var order: PythonObject
    var only: PythonObject
    var ignore: PythonObject
    var quantizations: PythonObject
    var sort: PythonObject
    var max_price: PythonObject
    var preferred_min_throughput: PythonObject
    var preferred_max_latency: PythonObject

    def __init__(out self, allow_fallbacks: Bool, require_parameters: Bool, data_collection: PythonObject, zdr: Bool, enforce_distillable_text: Bool, order: PythonObject, only: PythonObject, ignore: PythonObject, quantizations: PythonObject, sort: PythonObject, max_price: PythonObject, preferred_min_throughput: PythonObject, preferred_max_latency: PythonObject):
        self.allow_fallbacks = allow_fallbacks
        self.require_parameters = require_parameters
        self.data_collection = data_collection
        self.zdr = zdr
        self.enforce_distillable_text = enforce_distillable_text
        self.order = order
        self.only = only
        self.ignore = ignore
        self.quantizations = quantizations
        self.sort = sort
        self.max_price = max_price
        self.preferred_min_throughput = preferred_min_throughput
        self.preferred_max_latency = preferred_max_latency

    def __init__(out self, *, copy: Self):
        self.allow_fallbacks = copy.allow_fallbacks
        self.require_parameters = copy.require_parameters
        self.data_collection = copy.data_collection
        self.zdr = copy.zdr
        self.enforce_distillable_text = copy.enforce_distillable_text
        self.order = copy.order
        self.only = copy.only
        self.ignore = copy.ignore
        self.quantizations = copy.quantizations
        self.sort = copy.sort
        self.max_price = copy.max_price
        self.preferred_min_throughput = copy.preferred_min_throughput
        self.preferred_max_latency = copy.preferred_max_latency

    def __init__(out self, py: PythonObject) raises:
        self.allow_fallbacks = Bool(py=get_property(py, "allow_fallbacks", False))
        self.require_parameters = Bool(py=get_property(py, "require_parameters", False))
        self.data_collection = get_property(py, "data_collection", None)
        self.zdr = Bool(py=get_property(py, "zdr", False))
        self.enforce_distillable_text = Bool(py=get_property(py, "enforce_distillable_text", False))
        self.order = get_property(py, "order", None)
        self.only = get_property(py, "only", None)
        self.ignore = get_property(py, "ignore", None)
        self.quantizations = get_property(py, "quantizations", None)
        self.sort = get_property(py, "sort", None)
        self.max_price = get_property(py, "max_price", None)
        self.preferred_min_throughput = get_property(py, "preferred_min_throughput", None)
        self.preferred_max_latency = get_property(py, "preferred_max_latency", None)

    def to_py(self) raises -> PythonObject:
        var builtins = Python.import_module("builtins")
        var d = builtins.dict()
        d["allow_fallbacks"] = self.allow_fallbacks
        d["require_parameters"] = self.require_parameters
        d["data_collection"] = self.data_collection
        d["zdr"] = self.zdr
        d["enforce_distillable_text"] = self.enforce_distillable_text
        d["order"] = self.order
        d["only"] = self.only
        d["ignore"] = self.ignore
        d["quantizations"] = self.quantizations
        d["sort"] = self.sort
        d["max_price"] = self.max_price
        d["preferred_min_throughput"] = self.preferred_min_throughput
        d["preferred_max_latency"] = self.preferred_max_latency
        return d

struct VercelGatewayRouting(ImplicitlyCopyable):
    var only: PythonObject
    var order: PythonObject

    def __init__(out self, only: PythonObject, order: PythonObject):
        self.only = only
        self.order = order

    def __init__(out self, *, copy: Self):
        self.only = copy.only
        self.order = copy.order

    def __init__(out self, py: PythonObject) raises:
        self.only = get_property(py, "only", None)
        self.order = get_property(py, "order", None)

    def to_py(self) raises -> PythonObject:
        var builtins = Python.import_module("builtins")
        var d = builtins.dict()
        d["only"] = self.only
        d["order"] = self.order
        return d

struct Model(ImplicitlyCopyable):
    var id: String
    var name: String
    var api: PythonObject
    var provider: PythonObject
    var baseUrl: String
    var reasoning: Bool
    var thinkingLevelMap: PythonObject
    var input: PythonObject
    var cost: PythonObject
    var contextWindow: Int
    var maxTokens: Int
    var headers: PythonObject
    var compat: PythonObject

    def __init__(out self, id: String, name: String, api: PythonObject, provider: PythonObject, baseUrl: String, reasoning: Bool, thinkingLevelMap: PythonObject, input: PythonObject, cost: PythonObject, contextWindow: Int, maxTokens: Int, headers: PythonObject, compat: PythonObject):
        self.id = id
        self.name = name
        self.api = api
        self.provider = provider
        self.baseUrl = baseUrl
        self.reasoning = reasoning
        self.thinkingLevelMap = thinkingLevelMap
        self.input = input
        self.cost = cost
        self.contextWindow = contextWindow
        self.maxTokens = maxTokens
        self.headers = headers
        self.compat = compat

    def __init__(out self, *, copy: Self):
        self.id = copy.id
        self.name = copy.name
        self.api = copy.api
        self.provider = copy.provider
        self.baseUrl = copy.baseUrl
        self.reasoning = copy.reasoning
        self.thinkingLevelMap = copy.thinkingLevelMap
        self.input = copy.input
        self.cost = copy.cost
        self.contextWindow = copy.contextWindow
        self.maxTokens = copy.maxTokens
        self.headers = copy.headers
        self.compat = copy.compat

    def __init__(out self, py: PythonObject) raises:
        self.id = String(get_property(py, "id", ""))
        self.name = String(get_property(py, "name", ""))
        self.api = get_property(py, "api", None)
        self.provider = get_property(py, "provider", None)
        self.baseUrl = String(get_property(py, "baseUrl", ""))
        self.reasoning = Bool(py=get_property(py, "reasoning", False))
        self.thinkingLevelMap = get_property(py, "thinkingLevelMap", None)
        self.input = get_property(py, "input", None)
        self.cost = get_property(py, "cost", None)
        self.contextWindow = Int(py=get_property(py, "contextWindow", 0))
        self.maxTokens = Int(py=get_property(py, "maxTokens", 0))
        self.headers = get_property(py, "headers", None)
        self.compat = get_property(py, "compat", None)

    def to_py(self) raises -> PythonObject:
        var builtins = Python.import_module("builtins")
        var d = builtins.dict()
        d["id"] = self.id
        d["name"] = self.name
        d["api"] = self.api
        d["provider"] = self.provider
        d["baseUrl"] = self.baseUrl
        d["reasoning"] = self.reasoning
        d["thinkingLevelMap"] = self.thinkingLevelMap
        d["input"] = self.input
        d["cost"] = self.cost
        d["contextWindow"] = self.contextWindow
        d["maxTokens"] = self.maxTokens
        d["headers"] = self.headers
        d["compat"] = self.compat
        return d

struct ImagesModel(ImplicitlyCopyable):
    var api: PythonObject
    var provider: PythonObject
    var output: PythonObject

    def __init__(out self, api: PythonObject, provider: PythonObject, output: PythonObject):
        self.api = api
        self.provider = provider
        self.output = output

    def __init__(out self, *, copy: Self):
        self.api = copy.api
        self.provider = copy.provider
        self.output = copy.output

    def __init__(out self, py: PythonObject) raises:
        self.api = get_property(py, "api", None)
        self.provider = get_property(py, "provider", None)
        self.output = get_property(py, "output", None)

    def to_py(self) raises -> PythonObject:
        var builtins = Python.import_module("builtins")
        var d = builtins.dict()
        d["api"] = self.api
        d["provider"] = self.provider
        d["output"] = self.output
        return d

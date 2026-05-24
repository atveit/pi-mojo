from std.python import Python, PythonObject
from t2m_runtime.date import Date
from t2m_runtime.utils import JSON, Map, Math, Promise, _init_globals, get_property, isArray, objectIs, slice, structuredClone, to_js_obj, to_py_list, typeOf, wait_promise
from packages.ai.pi_ai_event_stream import createAssistantMessageEventStream
from packages.ai.pi_ai_registry import registerApiProvider, unregisterApiProviders
from packages.ai.pi_ai_types import AssistantMessage, AssistantMessageEventStream, Context, ImageContent, Model, OpenRouterRouting, SimpleStreamOptions, StreamOptions, TextContent, ThinkingBudgets, ThinkingContent, ToolCall, ToolResultMessage, Usage, VercelGatewayRouting

from packages.ai.pi_ai_provider_faux_defs import (
    DEFAULT_API,
    DEFAULT_PROVIDER,
    DEFAULT_MODEL_ID,
    DEFAULT_MODEL_NAME,
    DEFAULT_BASE_URL,
    DEFAULT_MIN_TOKEN_SIZE,
    DEFAULT_MAX_TOKEN_SIZE,
    FauxModelDefinition,
    RegisterFauxProviderOptions,
    FauxProviderRegistration,
    DEFAULT_USAGE,
    estimateTokens,
    randomId,
    assistantContentToText,
    serializeContext,
    commonPrefixLength,
    splitStringByTokenSize,
    _init_module
)

def withUsageEstimate(message: AssistantMessage, context: Context, options: PythonObject, promptCache: PythonObject) raises -> AssistantMessage:
    _init_module()
    var promptText: String = serializeContext(context)
    var promptTokens: Int = estimateTokens(promptText)
    var outputTokens: Int = estimateTokens(String(assistantContentToText(message.content)))
    var input: Int = promptTokens
    var cacheRead: Int = 0
    var cacheWrite: Int = 0
    var sessionId: PythonObject = options.sessionId
    if sessionId and options.cacheRetention != "none":
        var previousPrompt: PythonObject = promptCache.get(sessionId)
        if previousPrompt:
            var cachedChars: Int = commonPrefixLength(String(previousPrompt), promptText)
            cacheRead = estimateTokens(String(slice(previousPrompt, 0, cachedChars)))
            cacheWrite = estimateTokens(String(slice(promptText, cachedChars)))
            input = max(0, promptTokens - cacheRead)
        else:
            cacheWrite = promptTokens
        promptCache.set(sessionId, promptText)
    var _obj_1667: PythonObject = Python.import_module("builtins").dict()
    _obj_1667.update(message.to_py())
    _obj_1667["usage"] = to_js_obj({"input": input, "output": outputTokens, "cacheRead": cacheRead, "cacheWrite": cacheWrite, "totalTokens": input + outputTokens + cacheRead + cacheWrite, "cost": to_js_obj({"input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0, "total": 0})})
    return AssistantMessage(_obj_1667)

def cloneMessage(message: AssistantMessage, api: String, provider: String, modelId: String) raises -> AssistantMessage:
    _init_module()
    var cloned: PythonObject = structuredClone(message.to_py())
    var _obj_1925: PythonObject = Python.import_module("builtins").dict()
    _obj_1925.update(cloned)
    _obj_1925["api"] = api
    _obj_1925["provider"] = provider
    _obj_1925["model"] = modelId
    _obj_1925["timestamp"] = (cloned.timestamp if not objectIs(cloned.timestamp, None) else Date.now())
    _obj_1925["usage"] = (cloned.usage if not objectIs(cloned.usage, None) else DEFAULT_USAGE().to_py())
    return AssistantMessage(_obj_1925)

def createErrorMessage(error: PythonObject, api: String, provider: String, modelId: String) raises -> AssistantMessage:
    _init_module()
    return AssistantMessage("assistant", [], api, provider, modelId, "", "", None, Usage(DEFAULT_USAGE().to_py()), "error", String(error), Int(py=Date.now()))

def createAbortedMessage(partial: AssistantMessage) raises -> AssistantMessage:
    _init_module()
    var _obj_2070: PythonObject = Python.import_module("builtins").dict()
    _obj_2070.update(partial.to_py())
    _obj_2070["stopReason"] = "aborted"
    _obj_2070["errorMessage"] = "Request was aborted"
    _obj_2070["timestamp"] = Date.now()
    return AssistantMessage(_obj_2070)

def scheduleChunk(chunk: PythonObject, tokensPerSecond: PythonObject) raises -> PythonObject:
    _init_module()
    var builtins = Python.import_module("builtins")
    var g = _init_globals()
    var code = """
def scheduleChunk(chunk, tokensPerSecond):
    chunk = to_js_obj(chunk)
    tokensPerSecond = to_js_obj(tokensPerSecond)
    if not tokensPerSecond or tokensPerSecond <= 0:
        def _closure_2166(resolve):
            resolve = to_js_obj(resolve)
            return queueMicrotask(resolve)
        return Promise(_closure_2166)
    delayMs = (estimateTokens(chunk) / tokensPerSecond) * 1000
    def _closure_2208(resolve):
        resolve = to_js_obj(resolve)
        return setTimeout(resolve, delayMs)
    return Promise(_closure_2208)
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
        res = g["scheduleChunk"](chunk, tokensPerSecond)
    except e:
        var traceback_mod = Python.import_module("traceback")
        _ = traceback_mod.print_exc()
        raise e^
    return res

def streamWithDeltas(stream: PythonObject, message: AssistantMessage, minTokenSize: Int, maxTokenSize: Int, tokensPerSecond: PythonObject, signal: PythonObject) raises -> PythonObject:
    _init_module()
    var _obj_2273: PythonObject = Python.import_module("builtins").dict()
    _obj_2273.update(message.to_py())
    _obj_2273["content"] = []
    var partial: AssistantMessage = AssistantMessage(_obj_2273)
    if signal.aborted:
        var aborted: AssistantMessage = createAbortedMessage(partial)
        var _obj_2330: PythonObject = to_js_obj({"type": "error", "reason": "aborted", "error": aborted.to_py()})
        stream.append(_obj_2330)
        stream.end(aborted.to_py())
        return
    var _obj_2364: PythonObject = Python.import_module("builtins").dict()
    _obj_2364.update(partial.to_py())
    var _obj_2369: PythonObject = to_js_obj({"type": "start", "partial": _obj_2364})
    stream.append(_obj_2369)
    for index in range(len(message.content)):
        if signal.aborted:
            var aborted: AssistantMessage = createAbortedMessage(partial)
            var _obj_2435: PythonObject = to_js_obj({"type": "error", "reason": "aborted", "error": aborted.to_py()})
            stream.append(_obj_2435)
            stream.end(aborted.to_py())
            return
        var block: PythonObject = message.content[index]
        if block.type == "thinking":
            var _arr_2476: PythonObject = Python.import_module("builtins").list()
            _arr_2476.extend(partial.content)
            var _obj_2498: PythonObject = to_js_obj({"type": "thinking", "thinking": ""})
            _arr_2476.append(_obj_2498)
            partial.content = _arr_2476
            var _obj_2527: PythonObject = Python.import_module("builtins").dict()
            _obj_2527.update(partial.to_py())
            var _obj_2532: PythonObject = to_js_obj({"type": "thinking_start", "contentIndex": index, "partial": _obj_2527})
            stream.append(_obj_2532)
            for chunk in splitStringByTokenSize(String(block.thinking), minTokenSize, maxTokenSize):
                wait_promise(scheduleChunk(chunk, tokensPerSecond))
                if signal.aborted:
                    var aborted: AssistantMessage = createAbortedMessage(partial)
                    var _obj_2611: PythonObject = to_js_obj({"type": "error", "reason": "aborted", "error": aborted.to_py()})
                    stream.append(_obj_2611)
                    stream.end(aborted.to_py())
                    return
                (partial.content[index]).thinking = (partial.content[index]).thinking + chunk
                var _obj_2672: PythonObject = Python.import_module("builtins").dict()
                _obj_2672.update(partial.to_py())
                var _obj_2677: PythonObject = to_js_obj({"type": "thinking_delta", "contentIndex": index, "delta": chunk, "partial": _obj_2672})
                stream.append(_obj_2677)
            var _obj_2709: PythonObject = Python.import_module("builtins").dict()
            _obj_2709.update(partial.to_py())
            var _obj_2715: PythonObject = to_js_obj({"type": "thinking_end", "contentIndex": index, "content": block.thinking, "partial": _obj_2709})
            stream.append(_obj_2715)
            continue
        if block.type == "text":
            var _arr_2737: PythonObject = Python.import_module("builtins").list()
            _arr_2737.extend(partial.content)
            var _obj_2759: PythonObject = to_js_obj({"type": "text", "text": ""})
            _arr_2737.append(_obj_2759)
            partial.content = _arr_2737
            var _obj_2788: PythonObject = Python.import_module("builtins").dict()
            _obj_2788.update(partial.to_py())
            var _obj_2793: PythonObject = to_js_obj({"type": "text_start", "contentIndex": index, "partial": _obj_2788})
            stream.append(_obj_2793)
            for chunk in splitStringByTokenSize(String(block.text), minTokenSize, maxTokenSize):
                wait_promise(scheduleChunk(chunk, tokensPerSecond))
                if signal.aborted:
                    var aborted: AssistantMessage = createAbortedMessage(partial)
                    var _obj_2872: PythonObject = to_js_obj({"type": "error", "reason": "aborted", "error": aborted.to_py()})
                    stream.append(_obj_2872)
                    stream.end(aborted.to_py())
                    return
                (partial.content[index]).text = (partial.content[index]).text + chunk
                var _obj_2933: PythonObject = Python.import_module("builtins").dict()
                _obj_2933.update(partial.to_py())
                var _obj_2938: PythonObject = to_js_obj({"type": "text_delta", "contentIndex": index, "delta": chunk, "partial": _obj_2933})
                stream.append(_obj_2938)
            var _obj_2970: PythonObject = Python.import_module("builtins").dict()
            _obj_2970.update(partial.to_py())
            var _obj_2975: PythonObject = to_js_obj({"type": "text_end", "contentIndex": index, "content": block.text, "partial": _obj_2970})
            stream.append(_obj_2975)
            continue
        var _arr_2982: PythonObject = Python.import_module("builtins").list()
        _arr_2982.extend(partial.content)
        var _obj_3016: PythonObject = to_js_obj({"type": "toolCall", "id": block.id, "name": block.name, "arguments": to_js_obj({})})
        _arr_2982.append(_obj_3016)
        partial.content = _arr_2982
        var _obj_3045: PythonObject = Python.import_module("builtins").dict()
        _obj_3045.update(partial.to_py())
        var _obj_3050: PythonObject = to_js_obj({"type": "toolcall_start", "contentIndex": index, "partial": _obj_3045})
        stream.append(_obj_3050)
        for chunk in splitStringByTokenSize(String(JSON.stringify(block.arguments)), minTokenSize, maxTokenSize):
            wait_promise(scheduleChunk(chunk, tokensPerSecond))
            if signal.aborted:
                var aborted: AssistantMessage = createAbortedMessage(partial)
                var _obj_3137: PythonObject = to_js_obj({"type": "error", "reason": "aborted", "error": aborted.to_py()})
                stream.append(_obj_3137)
                stream.end(aborted.to_py())
                return
            var _obj_3179: PythonObject = Python.import_module("builtins").dict()
            _obj_3179.update(partial.to_py())
            var _obj_3184: PythonObject = to_js_obj({"type": "toolcall_delta", "contentIndex": index, "delta": chunk, "partial": _obj_3179})
            stream.append(_obj_3184)
        (partial.content[index]).arguments = block.arguments
        var _obj_3234: PythonObject = Python.import_module("builtins").dict()
        _obj_3234.update(partial.to_py())
        var _obj_3239: PythonObject = to_js_obj({"type": "toolcall_end", "contentIndex": index, "toolCall": block, "partial": _obj_3234})
        stream.append(_obj_3239)
    if message.stopReason == "error" or message.stopReason == "aborted":
        var _obj_3294: PythonObject = to_js_obj({"type": "error", "reason": message.stopReason, "error": message.to_py()})
        stream.append(_obj_3294)
        stream.end(message.to_py())
        return
    var _obj_3333: PythonObject = to_js_obj({"type": "done", "reason": message.stopReason, "message": message.to_py()})
    stream.append(_obj_3333)
    stream.end(message.to_py())
    return None

def registerFauxProvider(options: PythonObject = None) raises -> FauxProviderRegistration:
    _init_module()
    var builtins = Python.import_module("builtins")
    var g = _init_globals()
    var code = """
def registerFauxProvider(options=None):
    options = to_js_obj(options)
    if options == None:
        options = to_js_obj({})
    api = (options.api if not objectIs(options.api, None) else randomId(DEFAULT_API))
    provider = (options.provider if not objectIs(options.provider, None) else DEFAULT_PROVIDER)
    sourceId = randomId("faux-provider")
    minTokenSize = max(1, min(Int(py=(options.tokenSize.min if not objectIs(options.tokenSize.min, None) else DEFAULT_MIN_TOKEN_SIZE)), Int(py=(options.tokenSize.max if not objectIs(options.tokenSize.max, None) else DEFAULT_MAX_TOKEN_SIZE))))
    maxTokenSize = max(minTokenSize, Int(py=(options.tokenSize.max if not objectIs(options.tokenSize.max, None) else DEFAULT_MAX_TOKEN_SIZE)))
    pendingResponses = to_py_list()
    tokensPerSecond = options.tokensPerSecond
    state = to_js_obj({"callCount": 0})
    promptCache = Map()
    _obj_3595 = to_js_obj({"id": DEFAULT_MODEL_ID, "name": DEFAULT_MODEL_NAME, "reasoning": False, "input": JSList(["text", "image"]), "cost": to_js_obj({"input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0}), "contextWindow": 128000, "maxTokens": 16384})
    modelDefinitions = options.models if len(options.models) else JSList([_obj_3595])
    def _closure_3720(definition):
        definition = to_js_obj(definition)
        _obj_3700 = to_js_obj({"input": 0, "output": 0, "cacheRead": 0, "cacheWrite": 0})
        return (to_js_obj({"id": definition.id, "name": (definition.name if not objectIs(definition.name, None) else definition.id), "api": api, "provider": provider, "baseUrl": DEFAULT_BASE_URL, "reasoning": (definition.reasoning if not objectIs(definition.reasoning, None) else False), "input": (definition.input if not objectIs(definition.input, None) else JSList(["text", "image"])), "cost": (definition.cost if not objectIs(definition.cost, None) else _obj_3700), "contextWindow": (definition.contextWindow if not objectIs(definition.contextWindow, None) else 128000), "maxTokens": (definition.maxTokens if not objectIs(definition.maxTokens, None) else 16384)}))
    models = modelDefinitions.map(_closure_3720)
    def _closure_4084(requestModel, context, streamOptions):
        requestModel = to_js_obj(requestModel)
        context = to_js_obj(context)
        streamOptions = to_js_obj(streamOptions)
        outer = createAssistantMessageEventStream()
        step = pendingResponses.shift()
        state.callCount = state.callCount + 1
        def _closure_4080():
            try:
                _obj_3837 = to_js_obj({"status": 200, "headers": to_js_obj({})})
                wait_promise(streamOptions.onResponse(_obj_3837, requestModel) if streamOptions.onResponse else None)
                if not step:
                    message = createErrorMessage(Error("No more faux responses queued"), String(api), String(provider), String(requestModel.id))
                    message = withUsageEstimate(message, Context(context), streamOptions, promptCache)
                    _obj_3918 = to_js_obj({"type": "error", "reason": "error", "error": message.to_py()})
                    outer.append(_obj_3918)
                    outer.end(message.to_py())
                    return
                resolved = wait_promise(step(context, streamOptions, state, requestModel)) if typeOf(step) == "function" else step
                message = cloneMessage(AssistantMessage(resolved), String(api), String(provider), String(requestModel.id))
                message = withUsageEstimate(message, Context(context), streamOptions, promptCache)
                wait_promise(streamWithDeltas(outer, message, minTokenSize, maxTokenSize, tokensPerSecond, streamOptions.signal))
            except Exception as error:
                message = createErrorMessage(error, String(api), String(provider), String(requestModel.id))
                _obj_4068 = to_js_obj({"type": "error", "reason": "error", "error": message.to_py()})
                outer.append(_obj_4068)
                outer.end(message.to_py())
        queueMicrotask(_closure_4080)
        return outer
    stream = _closure_4084
    def _closure_4120(streamModel, context, streamOptions):
        streamModel = to_js_obj(streamModel)
        context = to_js_obj(context)
        streamOptions = to_js_obj(streamOptions)
        return stream(streamModel, context, streamOptions)
    streamSimple = _closure_4120
    _obj_4135 = to_js_obj({"api": api, "stream": stream, "streamSimple": streamSimple})
    registerApiProvider(_obj_4135, sourceId)
    def getModel(requestedModelId=None):
        requestedModelId = to_js_obj(requestedModelId)
        if not requestedModelId:
            return models[0]
        def _closure_4242(candidate):
            candidate = to_js_obj(candidate)
            return candidate.id == requestedModelId
        return models.find(_closure_4242)
    def _closure_4274(responses):
        nonlocal pendingResponses
        responses = to_js_obj(responses)
        _arr_4267 = JSList()
        _arr_4267.extend(responses)
        pendingResponses = _arr_4267
    def _closure_4293(responses):
        responses = to_js_obj(responses)
        pendingResponses.extend(responses)
        None
    def _closure_4307():
        return len(pendingResponses)
    def _closure_4323():
        unregisterApiProviders(sourceId)
    return FauxProviderRegistration(String(api), models, getModel, state, _closure_4274, _closure_4293, _closure_4307, _closure_4323)
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
        res = g["registerFauxProvider"](options)
    except e:
        var traceback_mod = Python.import_module("traceback")
        _ = traceback_mod.print_exc()
        raise e^
    return FauxProviderRegistration(res)

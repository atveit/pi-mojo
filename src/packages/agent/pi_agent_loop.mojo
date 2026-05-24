from std.python import Python, PythonObject
from t2m_runtime.date import Date
from t2m_runtime.utils import Promise, _init_globals, objectIs, to_js_obj, to_py_list, typeOf, validateToolArguments, wait_promise
from packages.agent.pi_agent_types import AgentContext, AgentLoopConfig, AgentTool, AgentToolResult
from packages.ai.pi_ai_event_stream import EventStream
from packages.ai.pi_ai_provider_faux import FauxProviderRegistration, RegisterFauxProviderOptions
from packages.ai.pi_ai_stream import streamSimple
from packages.ai.pi_ai_types import AssistantMessage, Context, OpenRouterRouting, TextContent, ThinkingBudgets, ThinkingContent, ToolCall, ToolResultMessage, Usage, VercelGatewayRouting

import packages.agent.pi_agent_types as pi_agent_types
import packages.ai.pi_ai_event_stream as pi_ai_event_stream
import packages.ai.pi_ai_provider_faux as pi_ai_provider_faux
import packages.ai.pi_ai_stream as pi_ai_stream
import packages.ai.pi_ai_types as pi_ai_types

def agentLoop(prompts: PythonObject, context: PythonObject, config: PythonObject, signal: PythonObject = None, streamFn: PythonObject = None) raises -> PythonObject:
    var builtins = Python.import_module("builtins")
    _init_module()
    var g = _init_globals()
    var code = """
def agentLoop(prompts, context, config, signal=None, streamFn=None):
    prompts = to_js_obj(prompts)
    context = to_js_obj(context)
    config = to_js_obj(config)
    signal = to_js_obj(signal)
    streamFn = to_js_obj(streamFn)
    stream = createAgentStream()
    def _closure_199(event):
        event = to_js_obj(event)
        stream.append(event)
    def _closure_221(messages):
        messages = to_js_obj(messages)
        stream.end(messages)
    runAgentLoop(prompts, context.to_py(), config.to_py(), _closure_199, signal, streamFn).then(_closure_221)
    return stream
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
        res = g["agentLoop"](prompts, context, config, signal, streamFn)
    except e:
        var traceback_mod = Python.import_module("traceback")
        _ = traceback_mod.print_exc()
        raise e^
    return res

def agentLoopContinue(context: PythonObject, config: PythonObject, signal: PythonObject = None, streamFn: PythonObject = None) raises -> PythonObject:
    var builtins = Python.import_module("builtins")
    _init_module()
    var g = _init_globals()
    var code = """
def agentLoopContinue(context, config, signal=None, streamFn=None):
    context = to_js_obj(context)
    config = to_js_obj(config)
    signal = to_js_obj(signal)
    streamFn = to_js_obj(streamFn)
    if len(context.messages) == 0:
        raise Error("Cannot continue: no messages in context")
    if context.messages[len(context.messages) - 1].role == "assistant":
        raise Error("Cannot continue from message role: assistant")
    stream = createAgentStream()
    def _closure_386(event):
        event = to_js_obj(event)
        stream.append(event)
    def _closure_408(messages):
        messages = to_js_obj(messages)
        stream.end(messages)
    runAgentLoopContinue(context.to_py(), config.to_py(), _closure_386, signal, streamFn).then(_closure_408)
    return stream
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
        res = g["agentLoopContinue"](context, config, signal, streamFn)
    except e:
        var traceback_mod = Python.import_module("traceback")
        _ = traceback_mod.print_exc()
        raise e^
    return res

def runAgentLoop(prompts: PythonObject, context: AgentContext, config: AgentLoopConfig, emit: PythonObject, signal: PythonObject = None, streamFn: PythonObject = None) raises -> PythonObject:
    _init_module()
    var _arr_474: PythonObject = Python.import_module("builtins").list()
    _arr_474.extend(prompts)
    var newMessages: PythonObject = _arr_474
    var _obj_485: PythonObject = Python.import_module("builtins").dict()
    _obj_485.update(context.to_py())
    var _arr_492: PythonObject = Python.import_module("builtins").list()
    _arr_492.extend(context.messages)
    _arr_492.extend(prompts)
    _obj_485["messages"] = _arr_492
    var currentContext: AgentContext = AgentContext(_obj_485)
    var _obj_522: PythonObject = to_js_obj({"type": "agent_start"})
    wait_promise(emit(_obj_522))
    var _obj_539: PythonObject = to_js_obj({"type": "turn_start"})
    wait_promise(emit(_obj_539))
    for prompt in prompts:
        var _obj_570: PythonObject = to_js_obj({"type": "message_start", "message": prompt})
        wait_promise(emit(_obj_570))
        var _obj_591: PythonObject = to_js_obj({"type": "message_end", "message": prompt})
        wait_promise(emit(_obj_591))
    wait_promise(runLoop(currentContext.to_py(), newMessages, config.to_py(), signal, emit, streamFn))
    return newMessages

def runAgentLoopContinue(context: AgentContext, config: AgentLoopConfig, emit: PythonObject, signal: PythonObject = None, streamFn: PythonObject = None) raises -> PythonObject:
    _init_module()
    if len(context.messages) == 0:
        raise Error("Cannot continue: no messages in context")
    if context.messages[len(context.messages) - 1].role == "assistant":
        raise Error("Cannot continue from message role: assistant")
    var newMessages: PythonObject = to_py_list()
    var _obj_745: PythonObject = Python.import_module("builtins").dict()
    _obj_745.update(context.to_py())
    var currentContext: AgentContext = AgentContext(_obj_745)
    var _obj_766: PythonObject = to_js_obj({"type": "agent_start"})
    wait_promise(emit(_obj_766))
    var _obj_783: PythonObject = to_js_obj({"type": "turn_start"})
    wait_promise(emit(_obj_783))
    wait_promise(runLoop(currentContext.to_py(), newMessages, config.to_py(), signal, emit, streamFn))
    return newMessages

def createAgentStream() raises -> PythonObject:
    var builtins = Python.import_module("builtins")
    _init_module()
    var g = _init_globals()
    var code = """
def createAgentStream():
    def _closure_859(event):
        event = to_js_obj(event)
        return event.type == "agent_end"
    def _closure_890(event):
        event = to_js_obj(event)
        return (event.messages if event.type == "agent_end" else JSList([]))
    return EventStream(_closure_859, _closure_890)
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
        res = g["createAgentStream"]()
    except e:
        var traceback_mod = Python.import_module("traceback")
        _ = traceback_mod.print_exc()
        raise e^
    return res

def runLoop(initialContext: PythonObject, newMessages: PythonObject, initialConfig: PythonObject, signal: PythonObject, emit: PythonObject, streamFn: PythonObject = None) raises -> PythonObject:
    var builtins = Python.import_module("builtins")
    _init_module()
    var g = _init_globals()
    var code = """
def runLoop(initialContext, newMessages, initialConfig, signal, emit, streamFn=None):
    initialContext = to_js_obj(initialContext)
    newMessages = to_js_obj(newMessages)
    initialConfig = to_js_obj(initialConfig)
    signal = to_js_obj(signal)
    emit = to_js_obj(emit)
    streamFn = to_js_obj(streamFn)
    currentContext = initialContext
    config = initialConfig
    firstTurn = True
    pendingMessages = (wait_promise(config.getSteeringMessages() if config.getSteeringMessages else None)) or JSList([])
    while (True):
        hasMoreToolCalls = True
        while (hasMoreToolCalls or len(pendingMessages) > 0):
            if not firstTurn:
                _obj_1042 = to_js_obj({"type": "turn_start"})
                wait_promise(emit(_obj_1042))
            else:
                firstTurn = False
            if len(pendingMessages) > 0:
                for message in pendingMessages:
                    _obj_1094 = to_js_obj({"type": "message_start", "message": message})
                    wait_promise(emit(_obj_1094))
                    _obj_1113 = to_js_obj({"type": "message_end", "message": message})
                    wait_promise(emit(_obj_1113))
                    currentContext.messages.append(message)
                    newMessages.append(message)
                pendingMessages = to_py_list()
            message = wait_promise(streamAssistantResponse(currentContext, config, signal, emit, streamFn))
            newMessages.append(message)
            if message.stopReason == "error" or message.stopReason == "aborted":
                _obj_1225 = to_js_obj({"type": "turn_end", "message": message, "toolResults": JSList([])})
                wait_promise(emit(_obj_1225))
                _obj_1246 = to_js_obj({"type": "agent_end", "messages": newMessages})
                wait_promise(emit(_obj_1246))
                return
            def _closure_1280(c):
                c = to_js_obj(c)
                return c.type == "toolCall"
            toolCalls = message.content.filter(_closure_1280)
            toolResults = to_py_list()
            hasMoreToolCalls = False
            if len(toolCalls) > 0:
                executedToolBatch = wait_promise(executeToolCalls(currentContext.to_py(), message, config.to_py(), signal, emit))
                toolResults.extend(executedToolBatch.messages)
                None
                hasMoreToolCalls = not executedToolBatch.terminate
                for result in toolResults:
                    currentContext.messages.append(result)
                    newMessages.append(result)
            _obj_1400 = to_js_obj({"type": "turn_end", "message": message, "toolResults": toolResults})
            wait_promise(emit(_obj_1400))
            nextTurnContext = to_js_obj({"message": message, "toolResults": toolResults, "context": currentContext.to_py(), "newMessages": newMessages})
            nextTurnSnapshot = wait_promise(config.prepareNextTurn(nextTurnContext) if config.prepareNextTurn else None)
            if nextTurnSnapshot:
                currentContext = AgentContext((nextTurnSnapshot.context if not objectIs(nextTurnSnapshot.context, None) else currentContext.to_py()))
                _obj_1449 = JSObject()
                _obj_1449.update(config.to_py())
                _obj_1449["model"] = (nextTurnSnapshot.model if not objectIs(nextTurnSnapshot.model, None) else config.model)
                _obj_1449["reasoning"] = config.reasoning if nextTurnSnapshot.thinkingLevel == None else None if nextTurnSnapshot.thinkingLevel == "off" else nextTurnSnapshot.thinkingLevel
                config = AgentLoopConfig(_obj_1449)
            _obj_1525 = to_js_obj({"message": message, "toolResults": toolResults, "context": currentContext.to_py(), "newMessages": newMessages})
            if wait_promise(config.shouldStopAfterTurn(_obj_1525) if config.shouldStopAfterTurn else None):
                _obj_1548 = to_js_obj({"type": "agent_end", "messages": newMessages})
                wait_promise(emit(_obj_1548))
                return
            pendingMessages = (wait_promise(config.getSteeringMessages() if config.getSteeringMessages else None)) or JSList([])
        followUpMessages = (wait_promise(config.getFollowUpMessages() if config.getFollowUpMessages else None)) or JSList([])
        if len(followUpMessages) > 0:
            pendingMessages = followUpMessages
            continue
        break
    _obj_1642 = to_js_obj({"type": "agent_end", "messages": newMessages})
    wait_promise(emit(_obj_1642))
    return None
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
        res = g["runLoop"](initialContext, newMessages, initialConfig, signal, emit, streamFn)
    except e:
        var traceback_mod = Python.import_module("traceback")
        _ = traceback_mod.print_exc()
        raise e^
    return res

def streamAssistantResponse(context: AgentContext, config: AgentLoopConfig, signal: PythonObject, emit: PythonObject, streamFn: PythonObject = None) raises -> PythonObject:
    _init_module()
    var messages: PythonObject = context.messages
    if config.transformContext:
        messages = wait_promise(config.transformContext(messages, signal))
    var llmMessages: PythonObject = wait_promise(config.convertToLlm(messages))
    var llmContext: Context = Context(context.systemPrompt, llmMessages, context.tools)
    var streamFunction: PythonObject = streamFn or Python.import_module("test_datasets.pi.pi_ai_stream").streamSimple
    var resolvedApiKey: PythonObject = (wait_promise(config.getApiKey(config.model.provider)) if config.getApiKey else None) or config.apiKey
    var _obj_1819: PythonObject = Python.import_module("builtins").dict()
    _obj_1819.update(config.to_py())
    _obj_1819["apiKey"] = resolvedApiKey
    _obj_1819["signal"] = signal
    var response: PythonObject = wait_promise(streamFunction(config.model, llmContext.to_py(), _obj_1819))
    var partialMessage: PythonObject = None
    var addedPartial: Bool = False
    for event in response:
        var _obj_1917: PythonObject = Python.import_module("builtins").dict()
        _obj_1917.update(partialMessage)
        var _obj_1922: PythonObject = to_js_obj({"type": "message_start", "message": _obj_1917})
        if event.type == "start":
            partialMessage = event.partial
            context.messages.append(partialMessage)
            addedPartial = True
            wait_promise(emit(_obj_1922))
        elif event.type == "text_start" or event.type == "text_delta" or event.type == "text_end" or event.type == "thinking_start" or event.type == "thinking_delta" or event.type == "thinking_end" or event.type == "toolcall_start" or event.type == "toolcall_delta" or event.type == "toolcall_end":
            if partialMessage:
                partialMessage = event.partial
                context.messages[len(context.messages) - 1] = partialMessage
                var _obj_2042: PythonObject = Python.import_module("builtins").dict()
                _obj_2042.update(partialMessage)
                var _obj_2048: PythonObject = to_js_obj({"type": "message_update", "assistantMessageEvent": event, "message": _obj_2042})
                wait_promise(emit(_obj_2048))
        elif event.type == "done" or event.type == "error":
            var finalMessage: PythonObject = wait_promise(response.result())
            if addedPartial:
                context.messages[len(context.messages) - 1] = finalMessage
            else:
                context.messages.append(finalMessage)
            if not addedPartial:
                var _obj_2150: PythonObject = Python.import_module("builtins").dict()
                _obj_2150.update(finalMessage)
                var _obj_2155: PythonObject = to_js_obj({"type": "message_start", "message": _obj_2150})
                wait_promise(emit(_obj_2155))
            var _obj_2177: PythonObject = to_js_obj({"type": "message_end", "message": finalMessage})
            wait_promise(emit(_obj_2177))
            return finalMessage
    var finalMessage: PythonObject = wait_promise(response.result())
    if addedPartial:
        context.messages[len(context.messages) - 1] = finalMessage
    else:
        context.messages.append(finalMessage)
        var _obj_2257: PythonObject = Python.import_module("builtins").dict()
        _obj_2257.update(finalMessage)
        var _obj_2262: PythonObject = to_js_obj({"type": "message_start", "message": _obj_2257})
        wait_promise(emit(_obj_2262))
    var _obj_2284: PythonObject = to_js_obj({"type": "message_end", "message": finalMessage})
    wait_promise(emit(_obj_2284))
    return finalMessage

def executeToolCalls(currentContext: PythonObject, assistantMessage: PythonObject, config: PythonObject, signal: PythonObject, emit: PythonObject) raises -> PythonObject:
    var builtins = Python.import_module("builtins")
    _init_module()
    var g = _init_globals()
    var code = """
def executeToolCalls(currentContext, assistantMessage, config, signal, emit):
    currentContext = to_js_obj(currentContext)
    assistantMessage = to_js_obj(assistantMessage)
    config = to_js_obj(config)
    signal = to_js_obj(signal)
    emit = to_js_obj(emit)
    def _closure_2363(c):
        c = to_js_obj(c)
        return c.type == "toolCall"
    toolCalls = assistantMessage.content.filter(_closure_2363)
    def _closure_2417(tc):
        tc = to_js_obj(tc)
        def _closure_2413(t):
            t = to_js_obj(t)
            return t.name == tc.name
        return currentContext.tools.find(_closure_2413).executionMode == "sequential"
    hasSequentialToolCall = toolCalls.some(_closure_2417)
    if config.toolExecution == "sequential" or hasSequentialToolCall:
        return executeToolCallsSequential(currentContext, assistantMessage, toolCalls, config, signal, emit)
    return executeToolCallsParallel(currentContext.to_py(), assistantMessage.to_py(), toolCalls, config.to_py(), signal, emit)
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
        res = g["executeToolCalls"](currentContext, assistantMessage, config, signal, emit)
    except e:
        var traceback_mod = Python.import_module("traceback")
        _ = traceback_mod.print_exc()
        raise e^
    return res

def executeToolCallsSequential(currentContext: AgentContext, assistantMessage: AssistantMessage, toolCalls: PythonObject, config: AgentLoopConfig, signal: PythonObject, emit: PythonObject) raises -> PythonObject:
    _init_module()
    var finalizedCalls: PythonObject = to_py_list()
    var messages: PythonObject = to_py_list()
    for toolCall in toolCalls:
        var _obj_2617: PythonObject = to_js_obj({"type": "tool_execution_start", "toolCallId": toolCall.id, "toolName": toolCall.name, "args": toolCall.arguments})
        wait_promise(emit(_obj_2617))
        var preparation: PythonObject = wait_promise(prepareToolCall(currentContext.to_py(), assistantMessage.to_py(), toolCall, config.to_py(), signal))
        var finalized: PythonObject
        if preparation.kind == "immediate":
            finalized = to_js_obj({"toolCall": toolCall, "result": preparation.result, "isError": preparation.isError})
        else:
            var executed: PythonObject = wait_promise(executePreparedToolCall(preparation, signal, emit))
            finalized = wait_promise(finalizeExecutedToolCall(currentContext, assistantMessage, preparation, executed, config, signal))
        wait_promise(emitToolExecutionEnd(finalized, emit))
        var toolResultMessage: ToolResultMessage = createToolResultMessage(finalized)
        wait_promise(emitToolResultMessage(toolResultMessage, emit))
        finalizedCalls.append(finalized)
        messages.append(toolResultMessage.to_py())
        if signal.aborted:
            break
    var _obj_2800: PythonObject = to_js_obj({"messages": messages, "terminate": shouldTerminateToolBatch(finalizedCalls)})
    return _obj_2800

def executeToolCallsParallel(currentContext: PythonObject, assistantMessage: PythonObject, toolCalls: PythonObject, config: PythonObject, signal: PythonObject, emit: PythonObject) raises -> PythonObject:
    var builtins = Python.import_module("builtins")
    _init_module()
    var g = _init_globals()
    var code = """
def executeToolCallsParallel(currentContext, assistantMessage, toolCalls, config, signal, emit):
    currentContext = to_js_obj(currentContext)
    assistantMessage = to_js_obj(assistantMessage)
    toolCalls = to_js_obj(toolCalls)
    config = to_js_obj(config)
    signal = to_js_obj(signal)
    emit = to_js_obj(emit)
    finalizedCalls = to_py_list()
    for toolCall in toolCalls:
        _obj_2910 = to_js_obj({"type": "tool_execution_start", "toolCallId": toolCall.id, "toolName": toolCall.name, "args": toolCall.arguments})
        wait_promise(emit(_obj_2910))
        preparation = wait_promise(prepareToolCall(currentContext.to_py(), assistantMessage.to_py(), toolCall, config.to_py(), signal))
        if preparation.kind == "immediate":
            finalized = to_js_obj({"toolCall": toolCall, "result": preparation.result, "isError": preparation.isError})
            wait_promise(emitToolExecutionEnd(finalized, emit))
            finalizedCalls.append(finalized)
            if signal.aborted:
                break
            continue
        def _closure_3072():
            executed = wait_promise(executePreparedToolCall(preparation, signal, emit))
            finalized = wait_promise(finalizeExecutedToolCall(currentContext, assistantMessage, preparation, executed, config, signal))
            wait_promise(emitToolExecutionEnd(finalized, emit))
            return finalized
        finalizedCalls.append(_closure_3072)
        if signal.aborted:
            break
    def _closure_3144(entry):
        entry = to_js_obj(entry)
        return (entry() if typeOf(entry) == "function" else Python.import_module("t2m_runtime.utils").Promise.resolve(entry))
    orderedFinalizedCalls = wait_promise(Python.import_module("t2m_runtime.utils").Promise.all(finalizedCalls.map(_closure_3144)))
    messages = to_py_list()
    for finalized in orderedFinalizedCalls:
        toolResultMessage = createToolResultMessage(finalized)
        wait_promise(emitToolResultMessage(toolResultMessage, emit))
        messages.append(toolResultMessage.to_py())
    _obj_3212 = to_js_obj({"messages": messages, "terminate": shouldTerminateToolBatch(orderedFinalizedCalls)})
    return _obj_3212
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
        res = g["executeToolCallsParallel"](currentContext, assistantMessage, toolCalls, config, signal, emit)
    except e:
        var traceback_mod = Python.import_module("traceback")
        _ = traceback_mod.print_exc()
        raise e^
    return res

def shouldTerminateToolBatch(finalizedCalls: PythonObject) raises -> Bool:
    var builtins = Python.import_module("builtins")
    _init_module()
    var g = _init_globals()
    var code = """
def shouldTerminateToolBatch(finalizedCalls):
    finalizedCalls = to_js_obj(finalizedCalls)
    def _closure_3425(finalized):
        finalized = to_js_obj(finalized)
        return finalized.result.terminate == True
    return Bool(py=len(finalizedCalls) > 0 and finalizedCalls.every(_closure_3425))
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
        res = g["shouldTerminateToolBatch"](finalizedCalls)
    except e:
        var traceback_mod = Python.import_module("traceback")
        _ = traceback_mod.print_exc()
        raise e^
    return Bool(py=res)

def prepareToolCallArguments(tool: PythonObject, toolCall: PythonObject) raises -> PythonObject:
    _init_module()
    if not tool.prepareArguments:
        return toolCall
    var preparedArguments: PythonObject = tool.prepareArguments(toolCall.arguments)
    if preparedArguments == toolCall.arguments:
        return toolCall
    var _obj_3498: PythonObject = Python.import_module("builtins").dict()
    _obj_3498.update(toolCall)
    _obj_3498["arguments"] = preparedArguments
    return _obj_3498

def prepareToolCall(currentContext: PythonObject, assistantMessage: PythonObject, toolCall: PythonObject, config: PythonObject, signal: PythonObject) raises -> PythonObject:
    var builtins = Python.import_module("builtins")
    _init_module()
    var g = _init_globals()
    var code = """
def prepareToolCall(currentContext, assistantMessage, toolCall, config, signal):
    currentContext = to_js_obj(currentContext)
    assistantMessage = to_js_obj(assistantMessage)
    toolCall = to_js_obj(toolCall)
    config = to_js_obj(config)
    signal = to_js_obj(signal)
    def _closure_3597(t):
        t = to_js_obj(t)
        return t.name == toolCall.name
    tool = currentContext.tools.find(_closure_3597)
    if not tool:
        _obj_3639 = to_js_obj({"kind": "immediate", "result": createErrorToolResult("Tool " + String(toolCall.name) + " not found"), "isError": True})
        return _obj_3639
    try:
        preparedToolCall = prepareToolCallArguments(tool, toolCall)
        validatedArgs = validateToolArguments(tool, preparedToolCall)
        if config.beforeToolCall:
            _obj_3705 = to_js_obj({"assistantMessage": assistantMessage.to_py(), "toolCall": toolCall, "args": validatedArgs, "context": currentContext.to_py()})
            beforeResult = wait_promise(config.beforeToolCall(_obj_3705, signal))
            if signal.aborted:
                _obj_3743 = to_js_obj({"kind": "immediate", "result": createErrorToolResult("Operation aborted"), "isError": True})
                return _obj_3743
            if beforeResult.block:
                _obj_3786 = to_js_obj({"kind": "immediate", "result": createErrorToolResult(String(beforeResult.reason or "Tool execution was blocked")), "isError": True})
                return _obj_3786
        if signal.aborted:
            _obj_3825 = to_js_obj({"kind": "immediate", "result": createErrorToolResult("Operation aborted"), "isError": True})
            return _obj_3825
        _obj_3846 = to_js_obj({"kind": "prepared", "toolCall": toolCall, "tool": tool, "args": validatedArgs})
        return _obj_3846
    except Exception as error:
        _obj_3894 = to_js_obj({"kind": "immediate", "result": createErrorToolResult(String(String(error) if True else String(error))), "isError": True})
        return _obj_3894
    return None
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
        res = g["prepareToolCall"](currentContext, assistantMessage, toolCall, config, signal)
    except e:
        var traceback_mod = Python.import_module("traceback")
        _ = traceback_mod.print_exc()
        raise e^
    return res

def executePreparedToolCall(prepared: PythonObject, signal: PythonObject, emit: PythonObject) raises -> PythonObject:
    var builtins = Python.import_module("builtins")
    _init_module()
    var g = _init_globals()
    var code = """
def executePreparedToolCall(prepared, signal, emit):
    prepared = to_js_obj(prepared)
    signal = to_js_obj(signal)
    emit = to_js_obj(emit)
    updateEvents = to_py_list()
    try:
        def _closure_4053(partialResult):
            partialResult = to_js_obj(partialResult)
            _obj_4052 = to_js_obj({"type": "tool_execution_update", "toolCallId": prepared.toolCall.id, "toolName": prepared.toolCall.name, "args": prepared.toolCall.arguments, "partialResult": partialResult})
            updateEvents.append(Python.import_module("t2m_runtime.utils").Promise.resolve(emit(_obj_4052)))
        result = wait_promise(safe_call(prepared.tool.execute, prepared.toolCall.id, prepared.args, signal, _closure_4053))
        wait_promise(Python.import_module("t2m_runtime.utils").Promise.all(updateEvents))
        _obj_4075 = to_js_obj({"result": result, "isError": False})
        return _obj_4075
    except Exception as error:
        wait_promise(Python.import_module("t2m_runtime.utils").Promise.all(updateEvents))
        _obj_4128 = to_js_obj({"result": createErrorToolResult(String(String(error) if True else String(error))), "isError": True})
        return _obj_4128
    return None
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
        res = g["executePreparedToolCall"](prepared, signal, emit)
    except e:
        var traceback_mod = Python.import_module("traceback")
        _ = traceback_mod.print_exc()
        raise e^
    return res

def finalizeExecutedToolCall(currentContext: AgentContext, assistantMessage: AssistantMessage, prepared: PythonObject, executed: PythonObject, config: AgentLoopConfig, signal: PythonObject) raises -> PythonObject:
    _init_module()
    var result: PythonObject = executed.result
    var isError: PythonObject = executed.isError
    if config.afterToolCall:
        try:
            var _obj_4244: PythonObject = to_js_obj({"assistantMessage": assistantMessage.to_py(), "toolCall": prepared.toolCall, "args": prepared.args, "result": result, "isError": isError, "context": currentContext.to_py()})
            var afterResult: PythonObject = wait_promise(config.afterToolCall(_obj_4244, signal))
            if afterResult:
                result = to_js_obj({"content": (afterResult.content if not objectIs(afterResult.content, None) else result.content), "details": (afterResult.details if not objectIs(afterResult.details, None) else result.details), "terminate": (afterResult.terminate if not objectIs(afterResult.terminate, None) else result.terminate)})
                isError = (afterResult.isError if not objectIs(afterResult.isError, None) else isError)
        except error:
            result = createErrorToolResult(String(String(error) if True else String(error)))
            isError = True
    var _obj_4354: PythonObject = to_js_obj({"toolCall": prepared.toolCall, "result": result, "isError": isError})
    return _obj_4354

def createErrorToolResult(message: String) raises -> PythonObject:
    _init_module()
    var _obj_4396: PythonObject = to_js_obj({"type": "text", "text": message})
    var _obj_4405: PythonObject = to_js_obj({"content": [_obj_4396], "details": to_js_obj({})})
    return _obj_4405

def emitToolExecutionEnd(finalized: PythonObject, emit: PythonObject) raises -> PythonObject:
    _init_module()
    var _obj_4477: PythonObject = to_js_obj({"type": "tool_execution_end", "toolCallId": finalized.toolCall.id, "toolName": finalized.toolCall.name, "result": finalized.result, "isError": finalized.isError})
    wait_promise(emit(_obj_4477))
    return None

def createToolResultMessage(finalized: PythonObject) raises -> ToolResultMessage:
    _init_module()
    return ToolResultMessage("toolResult", String(finalized.toolCall.id), String(finalized.toolCall.name), finalized.result.content, finalized.result.details, Bool(py=finalized.isError), Int(py=Date.now()))

def emitToolResultMessage(toolResultMessage: ToolResultMessage, emit: PythonObject) raises -> PythonObject:
    _init_module()
    var _obj_4599: PythonObject = to_js_obj({"type": "message_start", "message": toolResultMessage.to_py()})
    wait_promise(emit(_obj_4599))
    var _obj_4620: PythonObject = to_js_obj({"type": "message_end", "message": toolResultMessage.to_py()})
    wait_promise(emit(_obj_4620))
    return None

def _init_module() raises:
    var builtins = Python.import_module("builtins")
    var g = _init_globals()
    if builtins.bool(g.get("_module_init_d448f5a9", False)):
        return
    g["_module_init_d448f5a9"] = True
    pi_agent_types._init_module()
    pi_ai_event_stream._init_module()
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


def agentLoop(prompts, context, config, signal=None, streamFn=None):
    prompts = to_js_obj(prompts)
    context = to_js_obj(context)
    config = to_js_obj(config)
    signal = to_js_obj(signal)
    streamFn = to_js_obj(streamFn)
    stream = createAgentStream()
    def _closure_199(event):
        event = to_js_obj(event)
        stream.append(event)
    def _closure_221(messages):
        messages = to_js_obj(messages)
        stream.end(messages)
    runAgentLoop(prompts, context.to_py(), config.to_py(), _closure_199, signal, streamFn).then(_closure_221)
    return stream

def agentLoopContinue(context, config, signal=None, streamFn=None):
    context = to_js_obj(context)
    config = to_js_obj(config)
    signal = to_js_obj(signal)
    streamFn = to_js_obj(streamFn)
    if len(context.messages) == 0:
        raise Error("Cannot continue: no messages in context")
    if context.messages[len(context.messages) - 1].role == "assistant":
        raise Error("Cannot continue from message role: assistant")
    stream = createAgentStream()
    def _closure_386(event):
        event = to_js_obj(event)
        stream.append(event)
    def _closure_408(messages):
        messages = to_js_obj(messages)
        stream.end(messages)
    runAgentLoopContinue(context.to_py(), config.to_py(), _closure_386, signal, streamFn).then(_closure_408)
    return stream

def runAgentLoop(prompts, context, config, emit, signal=None, streamFn=None):
    prompts = to_js_obj(prompts)
    context = to_js_obj(context)
    config = to_js_obj(config)
    emit = to_js_obj(emit)
    signal = to_js_obj(signal)
    streamFn = to_js_obj(streamFn)
    _arr_474 = JSList()
    _arr_474.extend(prompts)
    newMessages = _arr_474
    _obj_485 = JSObject()
    _obj_485.update(context.to_py())
    _arr_492 = JSList()
    _arr_492.extend(context.messages)
    _arr_492.extend(prompts)
    _obj_485["messages"] = _arr_492
    currentContext = AgentContext(_obj_485)
    _obj_522 = to_js_obj({"type": "agent_start"})
    wait_promise(emit(_obj_522))
    _obj_539 = to_js_obj({"type": "turn_start"})
    wait_promise(emit(_obj_539))
    for prompt in prompts:
        _obj_570 = to_js_obj({"type": "message_start", "message": prompt})
        wait_promise(emit(_obj_570))
        _obj_591 = to_js_obj({"type": "message_end", "message": prompt})
        wait_promise(emit(_obj_591))
    wait_promise(runLoop(currentContext.to_py(), newMessages, config.to_py(), signal, emit, streamFn))
    return newMessages

def runAgentLoopContinue(context, config, emit, signal=None, streamFn=None):
    context = to_js_obj(context)
    config = to_js_obj(config)
    emit = to_js_obj(emit)
    signal = to_js_obj(signal)
    streamFn = to_js_obj(streamFn)
    if len(context.messages) == 0:
        raise Error("Cannot continue: no messages in context")
    if context.messages[len(context.messages) - 1].role == "assistant":
        raise Error("Cannot continue from message role: assistant")
    newMessages = to_py_list()
    _obj_745 = JSObject()
    _obj_745.update(context.to_py())
    currentContext = AgentContext(_obj_745)
    _obj_766 = to_js_obj({"type": "agent_start"})
    wait_promise(emit(_obj_766))
    _obj_783 = to_js_obj({"type": "turn_start"})
    wait_promise(emit(_obj_783))
    wait_promise(runLoop(currentContext.to_py(), newMessages, config.to_py(), signal, emit, streamFn))
    return newMessages

def createAgentStream():
    def _closure_859(event):
        event = to_js_obj(event)
        return event.type == "agent_end"
    def _closure_890(event):
        event = to_js_obj(event)
        return (event.messages if event.type == "agent_end" else JSList([]))
    return EventStream(_closure_859, _closure_890)

def runLoop(initialContext, newMessages, initialConfig, signal, emit, streamFn=None):
    initialContext = to_js_obj(initialContext)
    newMessages = to_js_obj(newMessages)
    initialConfig = to_js_obj(initialConfig)
    signal = to_js_obj(signal)
    emit = to_js_obj(emit)
    streamFn = to_js_obj(streamFn)
    currentContext = initialContext
    config = initialConfig
    firstTurn = True
    pendingMessages = (wait_promise(config.getSteeringMessages() if config.getSteeringMessages else None)) or JSList([])
    while (True):
        hasMoreToolCalls = True
        while (hasMoreToolCalls or len(pendingMessages) > 0):
            if not firstTurn:
                _obj_1042 = to_js_obj({"type": "turn_start"})
                wait_promise(emit(_obj_1042))
            else:
                firstTurn = False
            if len(pendingMessages) > 0:
                for message in pendingMessages:
                    _obj_1094 = to_js_obj({"type": "message_start", "message": message})
                    wait_promise(emit(_obj_1094))
                    _obj_1113 = to_js_obj({"type": "message_end", "message": message})
                    wait_promise(emit(_obj_1113))
                    currentContext.messages.append(message)
                    newMessages.append(message)
                pendingMessages = to_py_list()
            message = wait_promise(streamAssistantResponse(currentContext, config, signal, emit, streamFn))
            newMessages.append(message)
            if message.stopReason == "error" or message.stopReason == "aborted":
                _obj_1225 = to_js_obj({"type": "turn_end", "message": message, "toolResults": JSList([])})
                wait_promise(emit(_obj_1225))
                _obj_1246 = to_js_obj({"type": "agent_end", "messages": newMessages})
                wait_promise(emit(_obj_1246))
                return
            def _closure_1280(c):
                c = to_js_obj(c)
                return c.type == "toolCall"
            toolCalls = message.content.filter(_closure_1280)
            toolResults = to_py_list()
            hasMoreToolCalls = False
            if len(toolCalls) > 0:
                executedToolBatch = wait_promise(executeToolCalls(currentContext.to_py(), message, config.to_py(), signal, emit))
                toolResults.extend(executedToolBatch.messages)
                None
                hasMoreToolCalls = not executedToolBatch.terminate
                for result in toolResults:
                    currentContext.messages.append(result)
                    newMessages.append(result)
            _obj_1400 = to_js_obj({"type": "turn_end", "message": message, "toolResults": toolResults})
            wait_promise(emit(_obj_1400))
            nextTurnContext = to_js_obj({"message": message, "toolResults": toolResults, "context": currentContext.to_py(), "newMessages": newMessages})
            nextTurnSnapshot = wait_promise(config.prepareNextTurn(nextTurnContext) if config.prepareNextTurn else None)
            if nextTurnSnapshot:
                currentContext = AgentContext((nextTurnSnapshot.context if not objectIs(nextTurnSnapshot.context, None) else currentContext.to_py()))
                _obj_1449 = JSObject()
                _obj_1449.update(config.to_py())
                _obj_1449["model"] = (nextTurnSnapshot.model if not objectIs(nextTurnSnapshot.model, None) else config.model)
                _obj_1449["reasoning"] = config.reasoning if nextTurnSnapshot.thinkingLevel == None else None if nextTurnSnapshot.thinkingLevel == "off" else nextTurnSnapshot.thinkingLevel
                config = AgentLoopConfig(_obj_1449)
            _obj_1525 = to_js_obj({"message": message, "toolResults": toolResults, "context": currentContext.to_py(), "newMessages": newMessages})
            if wait_promise(config.shouldStopAfterTurn(_obj_1525) if config.shouldStopAfterTurn else None):
                _obj_1548 = to_js_obj({"type": "agent_end", "messages": newMessages})
                wait_promise(emit(_obj_1548))
                return
            pendingMessages = (wait_promise(config.getSteeringMessages() if config.getSteeringMessages else None)) or JSList([])
        followUpMessages = (wait_promise(config.getFollowUpMessages() if config.getFollowUpMessages else None)) or JSList([])
        if len(followUpMessages) > 0:
            pendingMessages = followUpMessages
            continue
        break
    _obj_1642 = to_js_obj({"type": "agent_end", "messages": newMessages})
    wait_promise(emit(_obj_1642))
    return None

def streamAssistantResponse(context, config, signal, emit, streamFn=None):
    context = to_js_obj(context)
    config = to_js_obj(config)
    signal = to_js_obj(signal)
    emit = to_js_obj(emit)
    streamFn = to_js_obj(streamFn)
    messages = context.messages
    if config.transformContext:
        messages = wait_promise(config.transformContext(messages, signal))
    llmMessages = wait_promise(config.convertToLlm(messages))
    llmContext = Context(context.systemPrompt, llmMessages, context.tools)
    streamFunction = streamFn or Python.import_module("test_datasets.pi.pi_ai_stream").streamSimple
    resolvedApiKey = (wait_promise(config.getApiKey(config.model.provider)) if config.getApiKey else None) or config.apiKey
    _obj_1819 = JSObject()
    _obj_1819.update(config.to_py())
    _obj_1819["apiKey"] = resolvedApiKey
    _obj_1819["signal"] = signal
    response = wait_promise(streamFunction(config.model, llmContext.to_py(), _obj_1819))
    partialMessage = None
    addedPartial = False
    for event in response:
        _obj_1917 = JSObject()
        _obj_1917.update(partialMessage)
        _obj_1922 = to_js_obj({"type": "message_start", "message": _obj_1917})
        if event.type == "start":
            partialMessage = event.partial
            context.messages.append(partialMessage)
            addedPartial = True
            wait_promise(emit(_obj_1922))
        elif event.type == "text_start" or event.type == "text_delta" or event.type == "text_end" or event.type == "thinking_start" or event.type == "thinking_delta" or event.type == "thinking_end" or event.type == "toolcall_start" or event.type == "toolcall_delta" or event.type == "toolcall_end":
            if partialMessage:
                partialMessage = event.partial
                context.messages[len(context.messages) - 1] = partialMessage
                _obj_2042 = JSObject()
                _obj_2042.update(partialMessage)
                _obj_2048 = to_js_obj({"type": "message_update", "assistantMessageEvent": event, "message": _obj_2042})
                wait_promise(emit(_obj_2048))
        elif event.type == "done" or event.type == "error":
            finalMessage = wait_promise(response.result())
            if addedPartial:
                context.messages[len(context.messages) - 1] = finalMessage
            else:
                context.messages.append(finalMessage)
            if not addedPartial:
                _obj_2150 = JSObject()
                _obj_2150.update(finalMessage)
                _obj_2155 = to_js_obj({"type": "message_start", "message": _obj_2150})
                wait_promise(emit(_obj_2155))
            _obj_2177 = to_js_obj({"type": "message_end", "message": finalMessage})
            wait_promise(emit(_obj_2177))
            return finalMessage
    finalMessage = wait_promise(response.result())
    if addedPartial:
        context.messages[len(context.messages) - 1] = finalMessage
    else:
        context.messages.append(finalMessage)
        _obj_2257 = JSObject()
        _obj_2257.update(finalMessage)
        _obj_2262 = to_js_obj({"type": "message_start", "message": _obj_2257})
        wait_promise(emit(_obj_2262))
    _obj_2284 = to_js_obj({"type": "message_end", "message": finalMessage})
    wait_promise(emit(_obj_2284))
    return finalMessage

def executeToolCalls(currentContext, assistantMessage, config, signal, emit):
    currentContext = to_js_obj(currentContext)
    assistantMessage = to_js_obj(assistantMessage)
    config = to_js_obj(config)
    signal = to_js_obj(signal)
    emit = to_js_obj(emit)
    def _closure_2363(c):
        c = to_js_obj(c)
        return c.type == "toolCall"
    toolCalls = assistantMessage.content.filter(_closure_2363)
    def _closure_2417(tc):
        tc = to_js_obj(tc)
        def _closure_2413(t):
            t = to_js_obj(t)
            return t.name == tc.name
        return currentContext.tools.find(_closure_2413).executionMode == "sequential"
    hasSequentialToolCall = toolCalls.some(_closure_2417)
    if config.toolExecution == "sequential" or hasSequentialToolCall:
        return executeToolCallsSequential(currentContext, assistantMessage, toolCalls, config, signal, emit)
    return executeToolCallsParallel(currentContext.to_py(), assistantMessage.to_py(), toolCalls, config.to_py(), signal, emit)

def executeToolCallsSequential(currentContext, assistantMessage, toolCalls, config, signal, emit):
    currentContext = to_js_obj(currentContext)
    assistantMessage = to_js_obj(assistantMessage)
    toolCalls = to_js_obj(toolCalls)
    config = to_js_obj(config)
    signal = to_js_obj(signal)
    emit = to_js_obj(emit)
    finalizedCalls = to_py_list()
    messages = to_py_list()
    for toolCall in toolCalls:
        _obj_2617 = to_js_obj({"type": "tool_execution_start", "toolCallId": toolCall.id, "toolName": toolCall.name, "args": toolCall.arguments})
        wait_promise(emit(_obj_2617))
        preparation = wait_promise(prepareToolCall(currentContext.to_py(), assistantMessage.to_py(), toolCall, config.to_py(), signal))
        finalized = None
        if preparation.kind == "immediate":
            finalized = to_js_obj({"toolCall": toolCall, "result": preparation.result, "isError": preparation.isError})
        else:
            executed = wait_promise(executePreparedToolCall(preparation, signal, emit))
            finalized = wait_promise(finalizeExecutedToolCall(currentContext, assistantMessage, preparation, executed, config, signal))
        wait_promise(emitToolExecutionEnd(finalized, emit))
        toolResultMessage = createToolResultMessage(finalized)
        wait_promise(emitToolResultMessage(toolResultMessage, emit))
        finalizedCalls.append(finalized)
        messages.append(toolResultMessage.to_py())
        if signal.aborted:
            break
    _obj_2800 = to_js_obj({"messages": messages, "terminate": shouldTerminateToolBatch(finalizedCalls)})
    return _obj_2800

def executeToolCallsParallel(currentContext, assistantMessage, toolCalls, config, signal, emit):
    currentContext = to_js_obj(currentContext)
    assistantMessage = to_js_obj(assistantMessage)
    toolCalls = to_js_obj(toolCalls)
    config = to_js_obj(config)
    signal = to_js_obj(signal)
    emit = to_js_obj(emit)
    finalizedCalls = to_py_list()
    for toolCall in toolCalls:
        _obj_2910 = to_js_obj({"type": "tool_execution_start", "toolCallId": toolCall.id, "toolName": toolCall.name, "args": toolCall.arguments})
        wait_promise(emit(_obj_2910))
        preparation = wait_promise(prepareToolCall(currentContext.to_py(), assistantMessage.to_py(), toolCall, config.to_py(), signal))
        if preparation.kind == "immediate":
            finalized = to_js_obj({"toolCall": toolCall, "result": preparation.result, "isError": preparation.isError})
            wait_promise(emitToolExecutionEnd(finalized, emit))
            finalizedCalls.append(finalized)
            if signal.aborted:
                break
            continue
        def _closure_3072():
            executed = wait_promise(executePreparedToolCall(preparation, signal, emit))
            finalized = wait_promise(finalizeExecutedToolCall(currentContext, assistantMessage, preparation, executed, config, signal))
            wait_promise(emitToolExecutionEnd(finalized, emit))
            return finalized
        finalizedCalls.append(_closure_3072)
        if signal.aborted:
            break
    def _closure_3144(entry):
        entry = to_js_obj(entry)
        return (entry() if typeOf(entry) == "function" else Python.import_module("t2m_runtime.utils").Promise.resolve(entry))
    orderedFinalizedCalls = wait_promise(Python.import_module("t2m_runtime.utils").Promise.all(finalizedCalls.map(_closure_3144)))
    messages = to_py_list()
    for finalized in orderedFinalizedCalls:
        toolResultMessage = createToolResultMessage(finalized)
        wait_promise(emitToolResultMessage(toolResultMessage, emit))
        messages.append(toolResultMessage.to_py())
    _obj_3212 = to_js_obj({"messages": messages, "terminate": shouldTerminateToolBatch(orderedFinalizedCalls)})
    return _obj_3212

def shouldTerminateToolBatch(finalizedCalls):
    finalizedCalls = to_js_obj(finalizedCalls)
    def _closure_3425(finalized):
        finalized = to_js_obj(finalized)
        return finalized.result.terminate == True
    return Bool(py=len(finalizedCalls) > 0 and finalizedCalls.every(_closure_3425))

def prepareToolCallArguments(tool, toolCall):
    tool = to_js_obj(tool)
    toolCall = to_js_obj(toolCall)
    if not tool.prepareArguments:
        return toolCall
    preparedArguments = tool.prepareArguments(toolCall.arguments)
    if preparedArguments == toolCall.arguments:
        return toolCall
    _obj_3498 = JSObject()
    _obj_3498.update(toolCall)
    _obj_3498["arguments"] = preparedArguments
    return _obj_3498

def prepareToolCall(currentContext, assistantMessage, toolCall, config, signal):
    currentContext = to_js_obj(currentContext)
    assistantMessage = to_js_obj(assistantMessage)
    toolCall = to_js_obj(toolCall)
    config = to_js_obj(config)
    signal = to_js_obj(signal)
    def _closure_3597(t):
        t = to_js_obj(t)
        return t.name == toolCall.name
    tool = currentContext.tools.find(_closure_3597)
    if not tool:
        _obj_3639 = to_js_obj({"kind": "immediate", "result": createErrorToolResult("Tool " + String(toolCall.name) + " not found"), "isError": True})
        return _obj_3639
    try:
        preparedToolCall = prepareToolCallArguments(tool, toolCall)
        validatedArgs = validateToolArguments(tool, preparedToolCall)
        if config.beforeToolCall:
            _obj_3705 = to_js_obj({"assistantMessage": assistantMessage.to_py(), "toolCall": toolCall, "args": validatedArgs, "context": currentContext.to_py()})
            beforeResult = wait_promise(config.beforeToolCall(_obj_3705, signal))
            if signal.aborted:
                _obj_3743 = to_js_obj({"kind": "immediate", "result": createErrorToolResult("Operation aborted"), "isError": True})
                return _obj_3743
            if beforeResult.block:
                _obj_3786 = to_js_obj({"kind": "immediate", "result": createErrorToolResult(String(beforeResult.reason or "Tool execution was blocked")), "isError": True})
                return _obj_3786
        if signal.aborted:
            _obj_3825 = to_js_obj({"kind": "immediate", "result": createErrorToolResult("Operation aborted"), "isError": True})
            return _obj_3825
        _obj_3846 = to_js_obj({"kind": "prepared", "toolCall": toolCall, "tool": tool, "args": validatedArgs})
        return _obj_3846
    except Exception as error:
        _obj_3894 = to_js_obj({"kind": "immediate", "result": createErrorToolResult(String(String(error) if True else String(error))), "isError": True})
        return _obj_3894
    return None

def executePreparedToolCall(prepared, signal, emit):
    prepared = to_js_obj(prepared)
    signal = to_js_obj(signal)
    emit = to_js_obj(emit)
    updateEvents = to_py_list()
    try:
        def _closure_4053(partialResult):
            partialResult = to_js_obj(partialResult)
            _obj_4052 = to_js_obj({"type": "tool_execution_update", "toolCallId": prepared.toolCall.id, "toolName": prepared.toolCall.name, "args": prepared.toolCall.arguments, "partialResult": partialResult})
            updateEvents.append(Python.import_module("t2m_runtime.utils").Promise.resolve(emit(_obj_4052)))
        result = wait_promise(safe_call(prepared.tool.execute, prepared.toolCall.id, prepared.args, signal, _closure_4053))
        wait_promise(Python.import_module("t2m_runtime.utils").Promise.all(updateEvents))
        _obj_4075 = to_js_obj({"result": result, "isError": False})
        return _obj_4075
    except Exception as error:
        wait_promise(Python.import_module("t2m_runtime.utils").Promise.all(updateEvents))
        _obj_4128 = to_js_obj({"result": createErrorToolResult(String(String(error) if True else String(error))), "isError": True})
        return _obj_4128
    return None

def finalizeExecutedToolCall(currentContext, assistantMessage, prepared, executed, config, signal):
    currentContext = to_js_obj(currentContext)
    assistantMessage = to_js_obj(assistantMessage)
    prepared = to_js_obj(prepared)
    executed = to_js_obj(executed)
    config = to_js_obj(config)
    signal = to_js_obj(signal)
    result = executed.result
    isError = executed.isError
    if config.afterToolCall:
        try:
            _obj_4244 = to_js_obj({"assistantMessage": assistantMessage.to_py(), "toolCall": prepared.toolCall, "args": prepared.args, "result": result, "isError": isError, "context": currentContext.to_py()})
            afterResult = wait_promise(config.afterToolCall(_obj_4244, signal))
            if afterResult:
                result = to_js_obj({"content": (afterResult.content if not objectIs(afterResult.content, None) else result.content), "details": (afterResult.details if not objectIs(afterResult.details, None) else result.details), "terminate": (afterResult.terminate if not objectIs(afterResult.terminate, None) else result.terminate)})
                isError = (afterResult.isError if not objectIs(afterResult.isError, None) else isError)
        except Exception as error:
            result = createErrorToolResult(String(String(error) if True else String(error)))
            isError = True
    _obj_4354 = to_js_obj({"toolCall": prepared.toolCall, "result": result, "isError": isError})
    return _obj_4354

def createErrorToolResult(message):
    message = to_js_obj(message)
    _obj_4396 = to_js_obj({"type": "text", "text": message})
    _obj_4405 = to_js_obj({"content": JSList([_obj_4396]), "details": to_js_obj({})})
    return _obj_4405

def emitToolExecutionEnd(finalized, emit):
    finalized = to_js_obj(finalized)
    emit = to_js_obj(emit)
    _obj_4477 = to_js_obj({"type": "tool_execution_end", "toolCallId": finalized.toolCall.id, "toolName": finalized.toolCall.name, "result": finalized.result, "isError": finalized.isError})
    wait_promise(emit(_obj_4477))
    return None

def createToolResultMessage(finalized):
    finalized = to_js_obj(finalized)
    return ToolResultMessage("toolResult", String(finalized.toolCall.id), String(finalized.toolCall.name), finalized.result.content, finalized.result.details, Bool(py=finalized.isError), Int(py=Date.now()))

def emitToolResultMessage(toolResultMessage, emit):
    toolResultMessage = to_js_obj(toolResultMessage)
    emit = to_js_obj(emit)
    _obj_4599 = to_js_obj({"type": "message_start", "message": toolResultMessage.to_py()})
    wait_promise(emit(_obj_4599))
    _obj_4620 = to_js_obj({"type": "message_end", "message": toolResultMessage.to_py()})
    wait_promise(emit(_obj_4620))
    return None
    """
    try:
        builtins.exec(code, g)
    except e:
        var traceback_mod = Python.import_module("traceback")
        _ = traceback_mod.print_exc()
        raise e^

def main() raises:
    _init_module()

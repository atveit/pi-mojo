from std.python import Python, PythonObject
from t2m_runtime.date import Date
from t2m_runtime.timer import setTimeout
from t2m_runtime.utils import JSON, Map, Math, Promise, _init_globals, get_property, isArray, objectIs, slice, structuredClone, to_js_obj, to_py_list, typeOf, wait_promise
from packages.ai.pi_ai_event_stream import createAssistantMessageEventStream
from packages.ai.pi_ai_registry import registerApiProvider, unregisterApiProviders
from packages.ai.pi_ai_types import AssistantMessage, AssistantMessageEventStream, Context, ImageContent, Model, OpenRouterRouting, SimpleStreamOptions, StreamOptions, TextContent, ThinkingBudgets, ThinkingContent, ToolCall, ToolResultMessage, Usage, VercelGatewayRouting

import packages.ai.pi_ai_event_stream as pi_ai_event_stream
import packages.ai.pi_ai_registry as pi_ai_registry
import packages.ai.pi_ai_types as pi_ai_types

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
    fauxText,
    fauxThinking,
    fauxToolCall,
    normalizeFauxAssistantContent,
    fauxAssistantMessage,
    estimateTokens,
    randomId,
    contentToText,
    assistantContentToText,
    toolResultToText,
    messageToText,
    serializeContext,
    commonPrefixLength,
    splitStringByTokenSize
)

from packages.ai.pi_ai_provider_faux_impl import (
    withUsageEstimate,
    cloneMessage,
    createErrorMessage,
    createAbortedMessage,
    scheduleChunk,
    streamWithDeltas,
    registerFauxProvider
)

def _init_module() raises:
    from packages.ai.pi_ai_provider_faux_defs import _init_module as init_defs
    init_defs()

def main() raises:
    _init_module()

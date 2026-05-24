import t2m_runtime.child_process as cp
import t2m_runtime.utils as utils
import t2m_runtime.llm as llm
from std.python import Python

# -------------------------------------------------------------
# NATIVE MOJO TOOLS
# -------------------------------------------------------------
def get_current_weather(city: String) raises -> String:
    utils.console_log("🔧 [Native Mojo Tool] get_current_weather invoked for city:", city)
    if city.lower().find("oslo") != -1:
        return '{"weather": "Sunny", "temperature": "21°C", "wind": "3 m/s"}'
    elif city.lower().find("london") != -1:
        return '{"weather": "Rainy", "temperature": "14°C", "wind": "7 m/s"}'
    else:
        return '{"weather": "Mild", "temperature": "18°C", "wind": "4 m/s"}'

def calculate_sum(a: Float64, b: Float64) raises -> String:
    utils.console_log("🔧 [Native Mojo Tool] calculate_sum invoked for values:", a, "+", b)
    return '{"sum": ' + String(a + b) + '}'

# -------------------------------------------------------------
# CLOUD LLM TOOL CALLING HANDLERS
# -------------------------------------------------------------
def call_gemini_with_tools(api_key: String, prompt: String) raises -> String:
    var json = Python.import_module("json")
    
    # Define tool configurations (declarations)
    var tools_def = json.loads(
        '[{'
        '  "function_declarations": ['
        '    {'
        '      "name": "get_current_weather",'
        '      "description": "Get the current weather for a given city.",'
        '      "parameters": {'
        '        "type": "OBJECT",'
        '        "properties": {'
        '          "city": {"type": "STRING", "description": "The city name."}'
        '        },'
        '        "required": ["city"]'
        '      }'
        '    },'
        '    {'
        '      "name": "calculate_sum",'
        '      "description": "Calculate the sum of two decimal numbers.",'
        '      "parameters": {'
        '        "type": "OBJECT",'
        '        "properties": {'
        '          "a": {"type": "NUMBER", "description": "First number."},'
        '          "b": {"type": "NUMBER", "description": "Second number."}'
        '        },'
        '        "required": ["a", "b"]'
        '      }'
        '    }'
        '  ]'
        '}]'
    )
    
    utils.console_log("Sending first request to Gemini API (with tools)...")
    var res_json = llm.call_gemini_with_tools(api_key, prompt, tools_def)
    
    # Check if LLM requested a function call
    var candidate = res_json["candidates"][0]
    if "content" in candidate and "parts" in candidate["content"]:
        var parts = candidate["content"]["parts"]
        var first_part = parts[0]
        if "functionCall" in first_part:
            var call = first_part["functionCall"]
            var func_name = String(call["name"])
            var args = call["args"]
            
            # Execute the correct native Mojo tool
            var tool_response: String
            if func_name == "get_current_weather":
                var city = String(args["city"])
                tool_response = get_current_weather(city)
            elif func_name == "calculate_sum":
                var a = Float64(py=args["a"])
                var b = Float64(py=args["b"])
                tool_response = calculate_sum(a, b)
            else:
                raise Error("Requested unknown tool: " + func_name)
                
            # Feed function response back to LLM to get the final answer
            utils.console_log("Feeding tool results back to Gemini API...")
            return llm.call_gemini_with_tool_response(api_key, prompt, func_name, args, tool_response)
        else:
            return String(first_part["text"])
    else:
        return String("No response candidates returned.")

def main() raises:
    utils.console_log("=========================================================")
    utils.console_log("🚀 Run Example: Native AI Tool Calling (Function Calling)")
    utils.console_log("=========================================================\n")
    
    var gemini_key: String
    var openrouter_key: String
    gemini_key, openrouter_key = llm.load_env_keys()
    
    if not gemini_key and not openrouter_key:
        utils.console_log("⚠️  Bypassed. Please configure GEMINI_API_KEY or OPENROUTER_API_KEY in your .env.")
        return
        
    var prompt = "What is the weather like in Oslo right now? Tell me the result in details."
    
    utils.console_log("Query Prompt:", prompt)
    utils.console_log("")
    
    if gemini_key:
        utils.console_log("[Engine: Gemini Direct FFI]")
        try:
            var answer = call_gemini_with_tools(gemini_key, prompt)
            utils.console_log("\nFinal AI Answer:")
            utils.console_log(answer.strip())
        except err:
            utils.console_log("❌ Error executing Gemini tool call:", String(err))
    else:
        utils.console_log("⚠️  Note: OpenRouter support is structured inside call_openrouter. Defaulting to Gemini Direct.")
    
    utils.console_log("\n=========================================================\n")

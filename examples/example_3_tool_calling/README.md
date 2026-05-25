# Native AI Tool Calling Example (example_tool_calling.mojo)

This example demonstrates how to register native Mojo functions as tools (Function Calling) and expose them to a cloud LLM (Google Gemini or OpenRouter). The agent acts as a controller that intercepts the LLM's requests, executes native Mojo logic, and feeds the results back to the LLM to construct the final response.

### ⚙️ How it Works
1. **Tool Definition**: Native Mojo functions (`get_current_weather` and `calculate_sum`) are registered with schemas defining their names, descriptions, and input parameters.
2. **First Request**: The agent sends the user prompt along with the tool schemas to the Gemini API.
3. **Function Interception**: If the model decides that it needs to call a tool, it returns a `functionCall` request containing the tool's name and arguments.
4. **Native Execution**: The agent catches this request, parses the arguments, executes the corresponding compiled Mojo function, and gets the return value.
5. **Final Request**: The agent attaches the tool execution result into the chat history as a `functionResponse` and re-submits it to the Gemini API to retrieve the final human-readable answer.

### 📄 Source Code & Captured Run
- **Source Code**: [example_tool_calling.mojo](example_tool_calling.mojo)
- **Sample Run Output**: [example_tool_calling_run.txt](example_tool_calling_run.txt)

### 🔍 Code Explanation & Key Snippets

This example demonstrates how to integrate native Mojo functions into LLM agent workflows:

#### 1. Defining Native Mojo Tools
Native functions must accept and return strict types, utilizing `raises` for interop safety:
```mojo
def get_current_weather(city: String) raises -> String:
    utils.console_log("🔧 [Native Mojo Tool] get_current_weather invoked for city:", city)
    if city.lower().find("oslo") != -1:
        return '{"weather": "Sunny", "temperature": "21°C", "wind": "3 m/s"}'
    return '{"weather": "Mild", "temperature": "18°C", "wind": "4 m/s"}'
```

#### 2. JSON Declarations Setup
Defining schema expectations for Gemini functions dynamically via Python's `json` parser:
```mojo
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
    '    }'
    '  ]'
    '}]'
)
```

#### 3. Intercepting Tool Decisions
Processing the first LLM turn response, extracting tool calls, and feeding values dynamically:
```mojo
var res_json = llm.call_gemini_with_tools(api_key, prompt, tools_def)
var candidate = res_json["candidates"][0]
if "content" in candidate and "parts" in candidate["content"]:
    var first_part = candidate["content"]["parts"][0]
    if "functionCall" in first_part:
        var call = first_part["functionCall"]
        var func_name = String(call["name"])
        var args = call["args"]
        
        # Dispatch dynamically and re-submit tool execution feedback
        var response = get_current_weather(String(args["city"]))
        var final_answer = llm.call_gemini_with_tool_response(api_key, prompt, func_name, args, response)
```

### 🚀 Execution
To run this example locally using your `.env` keys:
```bash
mojo -I src examples/example_3_tool_calling/example_tool_calling.mojo
```

### 🖥️ Console Output
Below is the real console output demonstrating a successful native tool invocation loop:

```text
=========================================================
🚀 Run Example: Native AI Tool Calling (Function Calling)
=========================================================

Query Prompt: What is the weather like in Oslo right now? Tell me the result in details.

[Engine: Gemini Direct interop]
Sending first request to Gemini API (with tools)...
🔧 [Native Mojo Tool] get_current_weather invoked for city: Oslo
Feeding tool results back to Gemini API...

Final AI Answer:
The weather in Oslo right now is **Sunny** with a temperature of **21°C**. The wind speed is **3 m/s**.

=========================================================
```

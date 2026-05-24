from std.python import Python, PythonObject
import t2m_runtime.utils as utils

def load_env_keys() raises -> Tuple[String, String]:
    var os = Python.import_module("os")
    var gemini_key = String(os.environ.get("GEMINI_API_KEY", ""))
    var openrouter_key = String(os.environ.get("OPENROUTER_API_KEY", ""))
    
    try:
        with open(".env", "r") as f:
            var content = f.read()
            var lines = content.split("\n")
            for i in range(len(lines)):
                var line = lines[i].strip()
                var clean_line = String(line)
                if clean_line.startswith("export "):
                    clean_line = String(clean_line.replace("export ", "").strip())
                if clean_line.find("=") != -1 and not clean_line.startswith("#"):
                    var parts = clean_line.split("=", 1)
                    var k = parts[0].strip()
                    var v = String(parts[1].strip().strip('"').strip("'"))
                    if k == "GEMINI_API_KEY" and not gemini_key:
                        gemini_key = v
                    elif k == "OPENROUTER_API_KEY" and not openrouter_key:
                        openrouter_key = v
    except:
        pass
    return gemini_key, openrouter_key

def call_local_llm(prompt: String, system_prompt: String) raises -> String:
    var json = Python.import_module("json")
    var urllib = Python.import_module("urllib.request")
    
    var url = "http://localhost:1234/api/v1/chat"
    
    var payload = json.loads('{"model": "qwen3.5-0.8b-mlx@8bit", "system_prompt": "", "input": ""}')
    payload["system_prompt"] = system_prompt
    payload["input"] = prompt
    
    var data = json.dumps(payload).encode("utf-8")
    var req = urllib.Request(
        url,
        data=data,
        headers={"Content-Type": "application/json"}
    )
    
    try:
        var response = urllib.urlopen(req, timeout=5)
        var res_body = response.read().decode("utf-8")
        response.close()
        
        var res_json = json.loads(res_body)
        var text = res_json["output"][0]["content"]
        return String(text)
    except err:
        raise Error("Local LLM API call failed: " + String(err))

def call_gemini(api_key: String, prompt: String) raises -> String:
    var json = Python.import_module("json")
    var urllib = Python.import_module("urllib.request")
    
    var url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=" + api_key
    
    var payload = json.loads('{"contents": [{"parts": [{"text": ""}]}]}')
    payload["contents"][0]["parts"][0]["text"] = prompt
    
    var data = json.dumps(payload).encode("utf-8")
    var req = urllib.Request(
        url,
        data=data,
        headers={"Content-Type": "application/json"}
    )
    
    try:
        var response = urllib.urlopen(req, timeout=10)
        var res_body = response.read().decode("utf-8")
        response.close()
        
        var res_json = json.loads(res_body)
        var text = res_json["candidates"][0]["content"]["parts"][0]["text"]
        return String(text)
    except err:
        raise Error("Gemini API call failed: " + String(err))

def call_openrouter(api_key: String, prompt: String, model: String = "google/gemini-3.5-flash") raises -> String:
    var json = Python.import_module("json")
    var urllib = Python.import_module("urllib.request")
    
    var url = "https://openrouter.ai/api/v1/chat/completions"
    
    var payload = json.loads('{"model": "", "messages": [{"role": "user", "content": ""}]}')
    payload["model"] = model
    payload["messages"][0]["content"] = prompt
    
    var data = json.dumps(payload).encode("utf-8")
    var req = urllib.Request(
        url,
        data=data,
        headers={
            "Content-Type": "application/json",
            "Authorization": "Bearer " + api_key
        }
    )
    
    try:
        var response = urllib.urlopen(req, timeout=10)
        var res_body = response.read().decode("utf-8")
        response.close()
        
        var res_json = json.loads(res_body)
        var text = res_json["choices"][0]["message"]["content"]
        return String(text)
    except err:
        raise Error("OpenRouter API call failed: " + String(err))

def clean_command(cmd: String) -> String:
    var res = String(cmd)
    if res.startswith("```"):
        res = res.replace("```bash", "").replace("```sh", "").replace("```", "")
    return String(res.strip())

def call_gemini_with_tools(api_key: String, prompt: String, tools_def: PythonObject) raises -> PythonObject:
    var json = Python.import_module("json")
    var urllib = Python.import_module("urllib.request")
    
    var url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=" + api_key
    
    var request_body = json.loads(
        '{'
        '  "contents": [{"parts": [{"text": ""}]}]'
        '}'
    )
    request_body["contents"][0]["parts"][0]["text"] = prompt
    request_body["tools"] = tools_def
    
    var data = json.dumps(request_body).encode("utf-8")
    var req = urllib.Request(url, data=data, headers={"Content-Type": "application/json"})
    
    try:
        var response = urllib.urlopen(req, timeout=12)
        var res_body = response.read().decode("utf-8")
        response.close()
        return json.loads(res_body)
    except err:
        raise Error("Gemini tool call API failed: " + String(err))

def call_gemini_with_tool_response(
    api_key: String,
    prompt: String,
    func_name: String,
    args: PythonObject,
    tool_response: String
) raises -> String:
    var json = Python.import_module("json")
    var urllib = Python.import_module("urllib.request")
    
    var url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=" + api_key
    
    var second_body = json.loads(
        '{'
        '  "contents": ['
        '    {"role": "user", "parts": [{"text": ""}]},'
        '    {"role": "model", "parts": [{"functionCall": {"name": "", "args": {}}}]},'
        '    {"role": "function", "parts": [{"functionResponse": {"name": "", "response": {}}}]}'
        '  ]'
        '}'
    )
    second_body["contents"][0]["parts"][0]["text"] = prompt
    second_body["contents"][1]["parts"][0]["functionCall"]["name"] = func_name
    second_body["contents"][1]["parts"][0]["functionCall"]["args"] = args
    second_body["contents"][2]["parts"][0]["functionResponse"]["name"] = func_name
    second_body["contents"][2]["parts"][0]["functionResponse"]["response"] = json.loads(tool_response)
    
    var data = json.dumps(second_body).encode("utf-8")
    var req = urllib.Request(url, data=data, headers={"Content-Type": "application/json"})
    
    try:
        var response = urllib.urlopen(req, timeout=12)
        var res_body = response.read().decode("utf-8")
        response.close()
        
        var final_json = json.loads(res_body)
        return String(final_json["candidates"][0]["content"]["parts"][0]["text"])
    except err:
        raise Error("Gemini tool feedback API failed: " + String(err))

def call_gemini_stream(api_key: String, prompt: String) raises:
    var json = Python.import_module("json")
    var urllib = Python.import_module("urllib.request")
    var sys = Python.import_module("sys")
    
    var url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:streamGenerateContent?key=" + api_key
    
    var payload = json.loads('{"contents": [{"parts": [{"text": ""}]}]}')
    payload["contents"][0]["parts"][0]["text"] = prompt
    
    var data = json.dumps(payload).encode("utf-8")
    var req = urllib.Request(
        url,
        data=data,
        headers={"Content-Type": "application/json"}
    )
    
    try:
        var response = urllib.urlopen(req, timeout=15)
        
        while True:
            var line_bytes = response.readline()
            if not line_bytes:
                break
            var line = line_bytes.decode("utf-8")
            if not line.strip():
                continue
            
            var py_line = line.strip()
            if not py_line:
                continue
                
            var target = String('"text": "')
            var idx = Int(py=py_line.find(target))
            if idx != -1:
                var start_pos = idx + 9
                var end_pos = Int(py=py_line.rfind('"'))
                if end_pos > start_pos:
                    var token = String(py_line[start_pos:end_pos])
                    var clean_token = token.replace("\\n", "\n").replace("\\t", "\t").replace('\\"', '"')
                    _ = sys.stdout.write(clean_token)
                    _ = sys.stdout.flush()
                
        response.close()
    except err:
        raise Error("Failed to parse event stream: " + String(err))


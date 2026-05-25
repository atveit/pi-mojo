from std.python import Python, PythonObject
import t2m_runtime.utils as utils

def call_gemini_long(api_key: String, prompt: String) raises -> String:
    var json = Python.import_module("json")
    var urllib = Python.import_module("urllib.request")
    var url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash:generateContent?key=" + api_key
    var payload = json.loads('{"contents": [{"parts": [{"text": ""}]}]}')
    payload["contents"][0]["parts"][0]["text"] = prompt
    var data = json.dumps(payload).encode("utf-8")
    var req = urllib.Request(url, data=data, headers={"Content-Type": "application/json"})
    try:
        var response = urllib.urlopen(req, timeout=90)
        var res_body = response.read().decode("utf-8")
        response.close()
        var res_json = json.loads(res_body)
        return String(res_json["candidates"][0]["content"]["parts"][0]["text"])
    except err:
        raise Error("Gemini API call failed: " + String(err))

def call_openrouter_long(api_key: String, prompt: String, model: String = "google/gemini-3.5-flash") raises -> String:
    var json = Python.import_module("json")
    var urllib = Python.import_module("urllib.request")
    var url = "https://openrouter.ai/api/v1/chat/completions"
    var payload = json.loads('{"model": "", "messages": [{"role": "user", "content": ""}]}')
    payload["model"] = model
    payload["messages"][0]["content"] = prompt
    var data = json.dumps(payload).encode("utf-8")
    var req = urllib.Request(url, data=data, headers={"Content-Type": "application/json", "Authorization": "Bearer " + api_key})
    try:
        var response = urllib.urlopen(req, timeout=90)
        var res_body = response.read().decode("utf-8")
        response.close()
        var res_json = json.loads(res_body)
        return String(res_json["choices"][0]["message"]["content"])
    except err:
        raise Error("OpenRouter API call failed: " + String(err))

struct ResearchPlanner:
    var active_key: String
    var is_openrouter: Bool

    def __init__(out self, active_key: String, is_openrouter: Bool):
        self.active_key = active_key
        self.is_openrouter = is_openrouter

    def plan_turn1(self, topic: String) raises -> String:
        var prompt = "You are a research query planner. Based on the topic '" + topic + "', generate a single highly optimized search query. Output only the query text without quotes."
        if self.is_openrouter:
            return call_openrouter_long(self.active_key, prompt, "google/gemini-3.5-flash")
        else:
            return call_gemini_long(self.active_key, prompt)

    def analyze_gaps(self, topic: String, turn1_context: String) raises -> String:
        var prompt = "You are an advanced researcher. We have gathered this Turn 1 context:\n\n" + turn1_context + "\nIdentify what is missing or deserves deeper investigation regarding the main topic '" + topic + "', and generate a highly targeted follow-up query. Output only the follow-up query text."
        if self.is_openrouter:
            return call_openrouter_long(self.active_key, prompt, "google/gemini-3.5-flash")
        else:
            return call_gemini_long(self.active_key, prompt)

    def synthesize_report(self, topic: String, consolidated_context: String) raises -> String:
        var prompt = "Generate a comprehensive, highly structured markdown Deep Research Report on the main topic '" + topic + "' based on this consolidated research context:\n\n" + consolidated_context
        if self.is_openrouter:
            return call_openrouter_long(self.active_key, prompt, "google/gemini-3.5-flash")
        else:
            return call_gemini_long(self.active_key, prompt)

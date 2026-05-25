import t2m_runtime.utils as utils
import t2m_runtime.llm as llm
from std.python import Python, PythonObject

def get_search_and_fetch_helpers() raises -> PythonObject:
    var py_code = (
        "def search_web(query, tavily_key='', exa_key='', brave_key='', google_key='', google_cx='', bing_key=''):\n"
        "    import urllib.request\n"
        "    import urllib.parse\n"
        "    import json\n"
        "    import ssl\n"
        "    context = ssl._create_unverified_context()\n"
        "    # 1. Try Tavily Search API\n"
        "    if tavily_key:\n"
        "        try:\n"
        "            req = urllib.request.Request(\n"
        "                'https://api.tavily.com/search',\n"
        "                data=json.dumps({\n"
        "                    'query': query,\n"
        "                    'search_depth': 'advanced',\n"
        "                    'max_results': 3\n"
        "                }).encode('utf-8'),\n"
        "                headers={'Authorization': f'Bearer {tavily_key}', 'Content-Type': 'application/json', 'User-Agent': 'Mozilla/5.0'},\n"
        "                method='POST'\n"
        "            )\n"
        "            with urllib.request.urlopen(req, context=context, timeout=5) as res:\n"
        "                data = json.loads(res.read().decode('utf-8'))\n"
        "                return [r['url'] for r in data.get('results', [])]\n"
        "        except:\n"
        "            pass\n"
        "    # 2. Try Exa Search API\n"
        "    if exa_key:\n"
        "        try:\n"
        "            req = urllib.request.Request(\n"
        "                'https://api.exa.ai/search',\n"
        "                data=json.dumps({'query': query, 'numResults': 3, 'useAutoprompt': True}).encode('utf-8'),\n"
        "                headers={'x-api-key': exa_key, 'Content-Type': 'application/json', 'User-Agent': 'Mozilla/5.0'},\n"
        "                method='POST'\n"
        "            )\n"
        "            with urllib.request.urlopen(req, context=context, timeout=5) as res:\n"
        "                data = json.loads(res.read().decode('utf-8'))\n"
        "                return [r['url'] for r in data.get('results', [])]\n"
        "        except:\n"
        "            pass\n"
        "    # 3. Try Brave Search API\n"
        "    if brave_key:\n"
        "        try:\n"
        "            url = f'https://api.search.brave.com/res/v1/web/search?q={urllib.parse.quote(query)}&count=3'\n"
        "            req = urllib.request.Request(url, headers={'X-Subscription-Token': brave_key, 'Accept': 'application/json', 'User-Agent': 'Mozilla/5.0'})\n"
        "            with urllib.request.urlopen(req, context=context, timeout=5) as res:\n"
        "                data = json.loads(res.read().decode('utf-8'))\n"
        "                return [r['url'] for r in data.get('web', {}).get('results', [])]\n"
        "        except:\n"
        "            pass\n"
        "    # 4. Try Google Custom Search Engine\n"
        "    if google_key and google_cx:\n"
        "        try:\n"
        "            url = f'https://www.googleapis.com/customsearch/v1?key={google_key}&cx={google_cx}&q={urllib.parse.quote(query)}&num=3'\n"
        "            req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})\n"
        "            with urllib.request.urlopen(req, context=context, timeout=5) as res:\n"
        "                data = json.loads(res.read().decode('utf-8'))\n"
        "                return [item['link'] for item in data.get('items', [])]\n"
        "        except:\n"
        "            pass\n"
        "    # 5. Try Bing Search API\n"
        "    if bing_key:\n"
        "        try:\n"
        "            url = f'https://api.bing.microsoft.com/v7.0/search?q={urllib.parse.quote(query)}&count=3'\n"
        "            req = urllib.request.Request(url, headers={'Ocp-Apim-Subscription-Key': bing_key, 'User-Agent': 'Mozilla/5.0'})\n"
        "            with urllib.request.urlopen(req, context=context, timeout=5) as res:\n"
        "                data = json.loads(res.read().decode('utf-8'))\n"
        "                return [r['url'] for r in data.get('webPages', {}).get('value', [])]\n"
        "        except:\n"
        "            pass\n"
        "    return []\n\n"
        "def parallel_fetch(urls):\n"
        "    import urllib.request\n"
        "    import ssl\n"
        "    from concurrent.futures import ThreadPoolExecutor\n"
        "    import re\n"
        "    context = ssl._create_unverified_context()\n"
        "    def fetch(url):\n"
        "        try:\n"
        "            req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})\n"
        "            with urllib.request.urlopen(req, context=context, timeout=5) as res:\n"
        "                html = res.read().decode('utf-8', errors='ignore')\n"
        "                clean = re.sub('<script.*?</script>|<style.*?</style>|<[^>]*>', ' ', html, flags=re.DOTALL)\n"
        "                return ' '.join(clean.split())\n"
        "        except Exception as e:\n"
        "            return f'Error fetching {url}: {str(e)}'\n"
        "    with ThreadPoolExecutor(max_workers=5) as ex:\n"
        "        results = list(ex.map(fetch, urls))\n"
        "    return results\n"
    )
    var builtins = Python.import_module("builtins")
    var py_globals = builtins.dict()
    builtins.exec(py_code, py_globals)
    
    var helpers = builtins.dict()
    helpers["search"] = py_globals["search_web"]
    helpers["fetch"] = py_globals["parallel_fetch"]
    return helpers

def call_gemini_long(api_key: String, prompt: String) raises -> String:
    var json = Python.import_module("json")
    var urllib = Python.import_module("urllib.request")
    var url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-3.5-flash:generateContent?key=" + api_key
    var payload = json.loads('{"contents": [{"parts": [{"text": ""}]}]}')
    payload["contents"][0]["parts"][0]["text"] = prompt
    var data = json.dumps(payload).encode("utf-8")
    var req = urllib.Request(url, data=data, headers={"Content-Type": "application/json"})
    try:
        var response = urllib.urlopen(req, timeout=45)
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
        var response = urllib.urlopen(req, timeout=45)
        var res_body = response.read().decode("utf-8")
        response.close()
        var res_json = json.loads(res_body)
        return String(res_json["choices"][0]["message"]["content"])
    except err:
        raise Error("OpenRouter API call failed: " + String(err))

def main() raises:
    utils.console_log("=========================================================")
    utils.console_log("🤖 Scenario 11: Iterative Deep Research Agent")
    utils.console_log("=========================================================\n")
    
    utils.console_log("Systems Narrative Story:")
    utils.console_log("An agent coordinates long-horizon, multi-turn information gathering.")
    utils.console_log("It refines search plans, queries web APIs (Tavily, Exa, Brave, Google, Bing),")
    utils.console_log("isolates context gaps, and synthesizes structured markdown reports.\n")

    var topic = "Mojo programming language memory management vs Rust ownership model"
    utils.console_log("Deep Research Topic:", topic)
    utils.console_log("")

    # Load dynamic search credentials from environment
    var os = Python.import_module("os")
    var tavily_key = String(py=os.environ.get("TAVILY_API_KEY", ""))
    var exa_key = String(py=os.environ.get("EXA_API_KEY", ""))
    var brave_key = String(py=os.environ.get("BRAVE_API_KEY", ""))
    var google_key = String(py=os.environ.get("GOOGLE_SEARCH_API_KEY", ""))
    var google_cx = String(py=os.environ.get("GOOGLE_CSE_ID", ""))
    var bing_key = String(py=os.environ.get("BING_SEARCH_API_KEY", ""))
    
    var gemini_key: String
    var openrouter_key: String
    gemini_key, openrouter_key = llm.load_env_keys()
    
    var active_key = openrouter_key if openrouter_key else gemini_key
    var is_openrouter = True if openrouter_key else False
    
    var builtins = Python.import_module("builtins")
    var helpers = get_search_and_fetch_helpers()
    
    var search_engine_active = tavily_key or exa_key or brave_key or google_key or bing_key

    if not active_key:
        utils.console_log("⚠️  No Gemini/OpenRouter keys found. Running in SIMULATED/MOCK mode.")
        utils.console_log("\n--- Turn 1: Initial Research & Context Generation ---")
        utils.console_log("1. Asking AI to generate optimized search query...")
        utils.console_log("   - Generated Turn 1 Query: 'Mojo memory management semantics value borrowing lifetimes'")
        
        utils.console_log("2. Querying active search engine...")
        if search_engine_active:
            utils.console_log("   - Active API detected. Simulated search complete.")
        else:
            utils.console_log("   - No search credentials found. Using fallback mock paths.")
        utils.console_log("   - Discovered URL: https://docs.modular.com/mojo/manual/basics/")
        utils.console_log("   - Discovered URL: https://docs.modular.com/mojo/manual/values/")
        
        utils.console_log("3. Fetching and cleaning target content in parallel...")
        utils.console_log("   [Thread 1] Scraped: https://docs.modular.com/mojo/manual/basics/ (3200 chars)")
        utils.console_log("   [Thread 2] Scraped: https://docs.modular.com/mojo/manual/values/ (4500 chars)")
        
        utils.console_log("4. Extracting key Turn 1 findings & identifying gaps...")
        utils.console_log("   - Insight: Mojo uses value semantics, strict alias structures, and explicit lifetimes.")
        utils.console_log("   - Gaps identified: Need details on how compiler borrow checker handles structs and multi-threading safety.")
        
        utils.console_log("\n--- Turn 2: Follow-up Deep Research ---")
        utils.console_log("1. Asking AI to plan Turn 2 sub-query...")
        utils.console_log("   - Generated Turn 2 Query: 'Mojo struct borrow checker concurrency thread safety'")
        
        utils.console_log("2. Querying search engine for Turn 2...")
        utils.console_log("   - Discovered URL: https://docs.modular.com/mojo/manual/structures/")
        utils.console_log("   - Discovered URL: https://docs.modular.com/mojo/manual/lifecycle/")
        
        utils.console_log("3. Scraping Turn 2 pages in parallel...")
        utils.console_log("   [Thread 1] Scraped: https://docs.modular.com/mojo/manual/structures/ (5200 chars)")
        utils.console_log("   [Thread 2] Scraped: https://docs.modular.com/mojo/manual/lifecycle/ (3900 chars)")
        
        utils.console_log("\n--- Final Synthesis Phase ---")
        utils.console_log("Consolidating Turn 1 & Turn 2 contexts (Total: 16800 characters)")
        utils.console_log("Synthesizing comprehensive Deep Research Report...")
        
        var mock_report = (
            "# Deep Research Report: Mojo Memory Management vs Rust Ownership\n\n"
            "## Executive Summary\n"
            "Mojo combines high-level ease of use (resembling Python) with zero-cost systems programming features (similar to Rust). It introduces explicit parameterization, dynamic value lifespans, and a strict ownership compiler model.\n\n"
            "## 1. Turn 1 Insights: Core Semantics\n"
            "* **Value Semantics**: Mojo variables are values, not pointers, by default. It features `borrowed`, `inout`, and `owned` argument passing conventions.\n"
            "* **Variable Lifespans**: Value destruction is deterministic and occurs immediately after the last use of a variable, unlike Rust's lexical scopes.\n\n"
            "## 2. Turn 2 Insights: Structures & Concurrency\n"
            "* **Borrow Checker**: Ensures alias safety at compile time. Structs in Mojo declare strict lifespans and field assignments.\n"
            "* **Thread Safety**: Combined with SIMD structures, safe references ensure data race freedom during multi-core execution.\n\n"
            "## Conclusion\n"
            "Mojo offers a robust alternative to Rust by prioritizing value semantics and eager destruction, reducing lifetime bookkeeping overhead while matching performance."
        )
        
        # Save simulated report
        var f = builtins.open("deep_research_report.md", "w", encoding="utf-8")
        _ = f.write(mock_report)
        _ = f.close()
        
        utils.console_log("\n✅ Deep Research Report generated: deep_research_report.md")
        utils.console_log("---------------------------------------------------------")
        utils.console_log(mock_report)
        utils.console_log("---------------------------------------------------------")
        utils.console_log("=========================================================\n")
        return

    # Real Cloud Deep Research Execution
    var current_query = topic
    var accumulated_context = String("")
    
    # --- Turn 1 ---
    utils.console_log("\n--- Turn 1: Initial Research & Context Generation ---")
    utils.console_log("1. Asking AI to generate optimized search query...")
    var turn1_prompt = "You are a research query planner. Based on the topic '" + topic + "', generate a single highly optimized search query. Output only the query text without quotes."
    
    try:
        if is_openrouter:
            current_query = call_openrouter_long(active_key, turn1_prompt, "google/gemini-3.5-flash")
        else:
            current_query = call_gemini_long(active_key, turn1_prompt)
    except:
        pass
    
    utils.console_log("   - Turn 1 Query: " + current_query.strip())
    
    utils.console_log("2. Querying active search engine...")
    var py_urls = builtins.list()
    if search_engine_active:
        var search_fn = helpers["search"]
        var results_py = search_fn(current_query.strip(), tavily_key, exa_key, brave_key, google_key, google_cx, bing_key)
        var search_len = Int(py=builtins.len(results_py))
        if search_len > 0:
            for i in range(search_len):
                _ = py_urls.append(results_py[i])
                utils.console_log("   - Found URL: " + String(py=results_py[i]))
        else:
            utils.console_log("   ⚠️ Search API returned 0 results. Using fallback doc paths.")
            _ = py_urls.append("https://docs.modular.com/mojo/manual/basics/")
            _ = py_urls.append("https://docs.modular.com/mojo/manual/values/")
    else:
        utils.console_log("   ℹ️ No active search keys found. Using high-reliability documentation paths.")
        _ = py_urls.append("https://docs.modular.com/mojo/manual/basics/")
        _ = py_urls.append("https://docs.modular.com/mojo/manual/values/")

    utils.console_log("3. Fetching and cleaning target content in parallel...")
    var fetch_fn = helpers["fetch"]
    var fetched_py = fetch_fn(py_urls)
    var fetched_len = Int(py=builtins.len(fetched_py))
    for i in range(fetched_len):
        var page_text = String(py=fetched_py[i])
        var url_str = String(py=py_urls[i])
        utils.console_log("   [Thread " + String(i+1) + "] Scraped: " + url_str + " (Length: " + String(page_text.byte_length()) + " chars)")
        accumulated_context += "--- Turn 1 Document (" + url_str + ") ---\n" + page_text + "\n\n"

    # --- Turn 2 ---
    utils.console_log("\n--- Turn 2: Follow-up Deep Research ---")
    utils.console_log("1. Asking AI to analyze Turn 1 and identify context gaps...")
    var turn2_prompt = "You are an advanced researcher. We have gathered this Turn 1 context:\n\n" + accumulated_context + "\nIdentify what is missing or deserves deeper investigation regarding the main topic '" + topic + "', and generate a highly targeted follow-up query. Output only the follow-up query text."
    
    var turn2_query = String("Mojo compiler borrow checker structures")
    try:
        if is_openrouter:
            turn2_query = call_openrouter_long(active_key, turn2_prompt, "google/gemini-3.5-flash")
        else:
            turn2_query = call_gemini_long(active_key, turn2_prompt)
    except:
        pass
        
    utils.console_log("   - Turn 2 Query: " + turn2_query.strip())
    
    utils.console_log("2. Querying search engine for Turn 2...")
    var py_urls2 = builtins.list()
    if search_engine_active:
        var search_fn = helpers["search"]
        var results_py = search_fn(turn2_query.strip(), tavily_key, exa_key, brave_key, google_key, google_cx, bing_key)
        var search_len = Int(py=builtins.len(results_py))
        if search_len > 0:
            for i in range(search_len):
                _ = py_urls2.append(results_py[i])
                utils.console_log("   - Found URL: " + String(py=results_py[i]))
        else:
            utils.console_log("   ⚠️ Search API returned 0 results. Using fallback doc paths.")
            _ = py_urls2.append("https://docs.modular.com/mojo/manual/structures/")
            _ = py_urls2.append("https://docs.modular.com/mojo/manual/lifecycle/")
    else:
        utils.console_log("   ℹ️ No active search keys found. Using high-reliability documentation paths.")
        _ = py_urls2.append("https://docs.modular.com/mojo/manual/structures/")
        _ = py_urls2.append("https://docs.modular.com/mojo/manual/lifecycle/")
        
    utils.console_log("3. Scraping Turn 2 pages in parallel...")
    var fetched_py2 = fetch_fn(py_urls2)
    var fetched_len2 = Int(py=builtins.len(fetched_py2))
    for i in range(fetched_len2):
        var page_text = String(py=fetched_py2[i])
        var url_str = String(py=py_urls2[i])
        utils.console_log("   [Thread " + String(i+1) + "] Scraped: " + url_str + " (Length: " + String(page_text.byte_length()) + " chars)")
        accumulated_context += "--- Turn 2 Document (" + url_str + ") ---\n" + page_text + "\n\n"

    # --- Synthesis ---
    utils.console_log("\n--- Final Synthesis Phase ---")
    utils.console_log("Consolidating Turn 1 & Turn 2 contexts (Total: " + String(accumulated_context.byte_length()) + " characters)")
    utils.console_log("Synthesizing comprehensive Deep Research Report...")
    
    var synthesis_prompt = "Generate a structured markdown Deep Research Report comparing Mojo and Rust memory management/ownership, focusing on value semantics, borrowing, explicit lifespans, and thread safety, based on this consolidated context:\n\n" + accumulated_context
    
    var final_report: String
    if is_openrouter:
        final_report = call_openrouter_long(active_key, synthesis_prompt, "google/gemini-3.5-flash")
    else:
        final_report = call_gemini_long(active_key, synthesis_prompt)
        
    # Save report
    var f = builtins.open("deep_research_report.md", "w", encoding="utf-8")
    _ = f.write(final_report)
    _ = f.close()
    
    utils.console_log("\n✅ Deep Research Report generated: deep_research_report.md")
    utils.console_log("---------------------------------------------------------")
    utils.console_log(final_report.strip())
    utils.console_log("---------------------------------------------------------")
    utils.console_log("=========================================================\n")

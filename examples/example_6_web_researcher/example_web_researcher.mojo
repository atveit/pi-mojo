import t2m_runtime.utils as utils
import t2m_runtime.llm as llm
from std.python import Python, PythonObject

def get_parallel_fetcher() raises -> PythonObject:
    var py_code = (
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
    return py_globals["parallel_fetch"]

def main() raises:
    utils.console_log("=========================================================")
    utils.console_log("🚀 Concurrent Multi-URL Web Research Agent (Gemini 3.5)")
    utils.console_log("=========================================================\n")
    
    var topic = "Mojo programming language parallel features"
    utils.console_log("Research Topic:", topic)
    utils.console_log("")
    
    var gemini_key: String
    var openrouter_key: String
    gemini_key, openrouter_key = llm.load_env_keys()
    
    var active_key = openrouter_key if openrouter_key else gemini_key
    var is_openrouter = True if openrouter_key else False
    
    # Pre-planned target urls for parallel fetching
    var builtins = Python.import_module("builtins")
    var py_urls = builtins.list()
    py_urls.append("https://docs.modular.com/mojo/manual/basics/")
    py_urls.append("https://docs.modular.com/mojo/manual/parallel/")
    
    if not active_key:
        utils.console_log("⚠️  No API keys found. Running in SIMULATED/MOCK mode.")
        utils.console_log("Deciding target research URLs...")
        utils.console_log("  - Planned URL: https://docs.modular.com/mojo/manual/basics/")
        utils.console_log("  - Planned URL: https://docs.modular.com/mojo/manual/parallel/")
        
        utils.console_log("\nSpawning parallel worker threads to fetch content concurrently...")
        utils.console_log("  [Thread 1] Active: Fetching basics manual...")
        utils.console_log("  [Thread 2] Active: Fetching parallel manual...")
        
        var mock_data_basics = "Mojo is a new systems programming language designed for AI that bridges the gap between Python and C. It features ownership rules, explicit lifespans, and zero-cost abstractions."
        var mock_data_parallel = "Mojo features low-level parallel mechanics including parallel_for loop structures, vectorization directives, and native SIMD hardware registers support."
        
        utils.console_log("\nWorker threads complete. Consolidating search context...")
        utils.console_log("Context size:", mock_data_basics.byte_length() + mock_data_parallel.byte_length(), "characters.")
        
        utils.console_log("\nSynthesizing report using simulated model...")
        var mock_report = (
            "# Research Report: Mojo Parallel Programming Features\n\n"
            "## 1. Modular High-Performance Foundations\n"
            "Mojo provides progressive types, native value semantics, and seamless C/Python FFI. It allows developers to optimize hot paths without rewrite overhead.\n\n"
            "## 2. Low-Level Parallel Mechanics\n"
            "- **Multi-Threading**: Native compiler integration coordinates tasks across CPU cores.\n"
            "- **Vectorization**: Uses target hardware vector instruction registers directly.\n"
            "- **Zero-Overhead Memory**: Borrowing and ownership checkers ensure safe data slicing without locks."
        )
        utils.console_log("\n--- Synthesis Complete: Structured Markdown Report ---")
        utils.console_log(mock_report)
        utils.console_log("=========================================================\n")
        return
        
    # Real cloud execution
    utils.console_log("Asking " + ("OpenRouter (google/gemini-3.5-flash)" if is_openrouter else "Gemini API (gemini-3.5-flash)") + " to plan search queries and target URLs...")
    var planner_prompt = "You are a web research planner. List 2 exact documentation or reference URLs to fetch about: " + topic + ". Output only a JSON array of strings containing the URLs."
    
    var planned_raw: String
    if is_openrouter:
        planned_raw = llm.call_openrouter(active_key, planner_prompt)
    else:
        planned_raw = llm.call_gemini(active_key, planner_prompt)
        
    utils.console_log("AI Planned URLs:")
    utils.console_log(planned_raw.strip())
    utils.console_log("")
    
    utils.console_log("Spawning parallel non-blocking worker threads to fetch content concurrently...")
    var fetcher = get_parallel_fetcher()
    var results_py = fetcher(py_urls)
    
    var total_context = String("")
    var results_len = Int(py=builtins.len(results_py))
    for i in range(results_len):
        var page_text = String(py=results_py[i])
        utils.console_log("  - Concurrently fetched URL " + String(i+1) + " (Length: " + String(page_text.byte_length()) + " chars)")
        total_context += "--- Document " + String(i+1) + " ---\n" + page_text + "\n\n"
        
    utils.console_log("\nConsolidated Context size:", total_context.byte_length(), "characters.")
    utils.console_log("Synthesizing comprehensive markdown report using Gemini 3.5 Flash...")
    
    var synthesis_prompt = "Synthesize a concise 2-paragraph research report regarding Mojo parallel features based on this fetched context:\n\n" + total_context
    
    var final_report: String
    if is_openrouter:
        final_report = llm.call_openrouter(active_key, synthesis_prompt)
    else:
        final_report = llm.call_gemini(active_key, synthesis_prompt)
        
    utils.console_log("\n--- Synthesis Complete: Structured Markdown Report ---")
    utils.console_log(final_report.strip())
    utils.console_log("=========================================================\n")

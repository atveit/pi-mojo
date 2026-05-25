# Concurrent Multi-URL Web Research Agent (example_web_researcher.mojo)

This example implements a Concurrent Multi-URL Web Research Agent that dynamically planning references, downloads multiple target URLs concurrently using parallel background threadpool workers, cleans the raw HTML payloads, and synthesizes a structured markdown summary report.

### ⚙️ How it Works
1. **Model Upgrades**: The agent defaults to `gemini-3.5-flash` natively or OpenRouter's `google/gemini-3.5-flash` endpoint, offering low-latency structured output.
2. **Parallel interop Workers**: Spawns multiple concurrent worker threads using Python's `concurrent.futures.ThreadPoolExecutor` via standard Mojo interop, fetching multiple URLs in parallel without blocking.
3. **HTML Sanitization**: Cleans and strips styling tags, headers, script definitions, and metadata using high-performance regex cleanups inside the parallel fetches.
4. **Context Consolidation**: Aggregates all cleaned website texts and feeds them to Gemini 3.5 Flash to synthesize a polished, structured markdown research report.

### 📄 Source Code & Captured Run
- **Source Code**: [example_web_researcher.mojo](example_web_researcher.mojo)
- **Sample Run Output**: [example_web_researcher_run.txt](example_web_researcher_run.txt)

### 🔍 Code Explanation & Key Snippets

This example showcases how to execute parallel/concurrent interoperability operations inside a Mojo agent context:

#### 1. Constructing the Parallel Fetcher
We define a Python module function in memory and compile/execute it using Python interop to orchestrate safe parallel socket connections:
```mojo
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
    ...
```

#### 2. Model Agnostic Credentials Loading
Dynamically extracts available API configurations from `.env` and defaults to either OpenRouter or direct Gemini API endpoint:
```mojo
var gemini_key: String
var openrouter_key: String
gemini_key, openrouter_key = llm.load_env_keys()
```

### 🚀 Execution
To run this example locally:
```bash
mojo run -I src examples/example_6_web_researcher/example_web_researcher.mojo
```

### 🖥️ Console Output
Below is the real console output when running without cloud credentials (Simulated mode):
```text
=========================================================
🚀 Concurrent Multi-URL Web Research Agent (Gemini 3.5)
=========================================================

Research Topic: Mojo programming language parallel features

⚠️  No API keys found. Running in SIMULATED/MOCK mode.
Deciding target research URLs...
  - Planned URL: https://docs.modular.com/mojo/manual/basics/
  - Planned URL: https://docs.modular.com/mojo/manual/parallel/

Spawning parallel worker threads to fetch content concurrently...
  [Thread 1] Active: Fetching basics manual...
  [Thread 2] Active: Fetching parallel manual...

Worker threads complete. Consolidating search context...
  Context size: 263 characters.

Synthesizing report using simulated model...

--- Synthesis Complete: Structured Markdown Report ---
# Research Report: Mojo Parallel Programming Features

## 1. Modular High-Performance Foundations
Mojo provides progressive types, native value semantics, and seamless C/Python interop. It allows developers to optimize hot paths without rewrite overhead.

## 2. Low-Level Parallel Mechanics
- **Multi-Threading**: Native compiler integration coordinates tasks across CPU cores.
- **Vectorization**: Uses target hardware vector instruction registers directly.
- **Zero-Overhead Memory**: Borrowing and ownership checkers ensure safe data slicing without locks.
=========================================================
```

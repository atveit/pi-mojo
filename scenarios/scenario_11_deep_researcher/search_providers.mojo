from std.python import Python, PythonObject
import t2m_runtime.utils as utils

def get_python_search_helper() raises -> PythonObject:
    var py_code = (
        "def query_all_search(query, bing_key='', brave_key='', exa_key='', google_key='', google_cx='', tavily_key=''):\n"
        "    import urllib.request\n"
        "    import urllib.parse\n"
        "    import json\n"
        "    import ssl\n"
        "    context = ssl._create_unverified_context()\n"
        "    # 1. Bing Search API (https://www.microsoft.com/en-us/bing/apis)\n"
        "    if bing_key:\n"
        "        try:\n"
        "            url = f'https://api.bing.microsoft.com/v7.0/search?q={urllib.parse.quote(query)}&count=3'\n"
        "            req = urllib.request.Request(url, headers={'Ocp-Apim-Subscription-Key': bing_key, 'User-Agent': 'Mozilla/5.0'})\n"
        "            with urllib.request.urlopen(req, context=context, timeout=5) as res:\n"
        "                data = json.loads(res.read().decode('utf-8'))\n"
        "                return [r['url'] for r in data.get('webPages', {}).get('value', [])]\n"
        "        except:\n"
        "            pass\n"
        "    # 2. Brave Search API (https://brave.com/search/api/)\n"
        "    if brave_key:\n"
        "        try:\n"
        "            url = f'https://api.search.brave.com/res/v1/web/search?q={urllib.parse.quote(query)}&count=3'\n"
        "            req = urllib.request.Request(url, headers={'X-Subscription-Token': brave_key, 'Accept': 'application/json', 'User-Agent': 'Mozilla/5.0'})\n"
        "            with urllib.request.urlopen(req, context=context, timeout=5) as res:\n"
        "                data = json.loads(res.read().decode('utf-8'))\n"
        "                return [r['url'] for r in data.get('web', {}).get('results', [])]\n"
        "        except:\n"
        "            pass\n"
        "    # 3. Exa Search API (https://exa.ai)\n"
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
        "    # 4. Google Custom Search Engine API (https://developers.google.com/custom-search)\n"
        "    if google_key and google_cx:\n"
        "        try:\n"
        "            url = f'https://www.googleapis.com/customsearch/v1?key={google_key}&cx={google_cx}&q={urllib.parse.quote(query)}&num=3'\n"
        "            req = urllib.request.Request(url, headers={'User-Agent': 'Mozilla/5.0'})\n"
        "            with urllib.request.urlopen(req, context=context, timeout=5) as res:\n"
        "                data = json.loads(res.read().decode('utf-8'))\n"
        "                return [item['link'] for item in data.get('items', [])]\n"
        "        except:\n"
        "            pass\n"
        "    # 5. Tavily Search API (https://tavily.com)\n"
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
        "    return []\n"
    )
    var builtins = Python.import_module("builtins")
    var py_globals = builtins.dict()
    builtins.exec(py_code, py_globals)
    return py_globals["query_all_search"]

struct SearchManager:
    var bing_key: String
    var brave_key: String
    var exa_key: String
    var google_key: String
    var google_cx: String
    var tavily_key: String
    var is_active: Bool

    def __init__(out self) raises:
        var os = Python.import_module("os")
        self.bing_key = String(py=os.environ.get("BING_SEARCH_API_KEY", ""))
        self.brave_key = String(py=os.environ.get("BRAVE_API_KEY", ""))
        self.exa_key = String(py=os.environ.get("EXA_API_KEY", ""))
        self.google_key = String(py=os.environ.get("GOOGLE_SEARCH_API_KEY", ""))
        self.google_cx = String(py=os.environ.get("GOOGLE_CSE_ID", ""))
        self.tavily_key = String(py=os.environ.get("TAVILY_API_KEY", ""))
        self.is_active = (
            self.bing_key != "" or
            self.brave_key != "" or
            self.exa_key != "" or
            (self.google_key != "" and self.google_cx != "") or
            self.tavily_key != ""
        )

    def execute_search(self, query: String) raises -> PythonObject:
        var search_fn = get_python_search_helper()
        return search_fn(
            query,
            self.bing_key,
            self.brave_key,
            self.exa_key,
            self.google_key,
            self.google_cx,
            self.tavily_key
        )

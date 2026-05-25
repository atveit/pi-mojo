from std.python import Python, PythonObject
import t2m_runtime.utils as utils

def get_python_fetch_helper() raises -> PythonObject:
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
        "                text = ' '.join(clean.split())\n"
        "                if len(text) > 40000:\n"
        "                    text = text[:40000] + ' ... [TRUNCATED] ...'\n"
        "                return text\n"
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

struct WebFetcher:
    def __init__(out self):
        pass

    def fetch_parallel(self, urls: PythonObject) raises -> PythonObject:
        var fetch_fn = get_python_fetch_helper()
        return fetch_fn(urls)

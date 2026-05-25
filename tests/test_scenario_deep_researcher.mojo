import t2m_runtime.utils as utils
from std.python import Python, PythonObject

import search_providers
import content_fetcher
import research_planner

def test_search_manager() raises:
    utils.console_log("  - Running test_search_manager...")
    var mgr = search_providers.SearchManager()
    # Ensure it constructs active state dynamically
    var active = mgr.is_active
    _ = active

def test_content_fetcher() raises:
    utils.console_log("  - Running test_content_fetcher...")
    var fetcher = content_fetcher.WebFetcher()
    var builtins = Python.import_module("builtins")
    var urls = builtins.list()
    _ = urls.append("https://docs.modular.com/mojo/manual/basics/")
    
    # We can fetch or mock fetch
    var results = fetcher.fetch_parallel(urls)
    var results_len = Int(py=builtins.len(results))
    utils.console_log("    * Scraped page length: " + String(results_len) + " results.")

def test_research_planner() raises:
    utils.console_log("  - Running test_research_planner...")
    var planner = research_planner.ResearchPlanner("dummy_key", False)
    # Verify struct members bind correctly
    var is_or = planner.is_openrouter
    _ = is_or

def main() raises:
    utils.console_log("=========================================================")
    utils.console_log("🧪 Running Scenario 11: Modular Deep Research Agent Tests")
    utils.console_log("=========================================================\n")
    
    test_search_manager()
    test_content_fetcher()
    test_research_planner()
    
    utils.console_log("\n=========================================================")
    utils.console_log("✅ All Scenario 11 Unit Tests PASSED Successfully")
    utils.console_log("=========================================================\n")

# 🎭 Scenario 11: Iterative Deep Research Agent (scenario_deep_researcher.mojo)

This scenario demonstrates a highly advanced, multi-turn **Iterative Deep Research Agent** designed to perform long-horizon web investigation tasks. 

Following the principles detailed in Tavily's deep research methodology, the agent refines its query plan, accesses multiple search APIs, identifies gaps in retrieved information, executes follow-up sub-queries, and synthesizes a comprehensive structured markdown intelligence briefing.

---

## 📖 Systems Narrative Story

In high-velocity systems engineering environments, engineers often need to research cutting-edge technologies (such as compiler borrow checkers, native SIMD vectorization, or async runtimes) that lack dense static documentation within the codebase.

Instead of a single-turn search which frequently suffers from surface-level results or missing context, the Deep Research Agent automates a multi-step investigation:
1. **Query Planning**: Receives a high-level research topic and uses a Gemini LLM to plan the optimal initial search queries.
2. **Multi-Provider Search**: Calls active search API credentials (prioritizing **Tavily**, then falling back to **Exa**, **Brave**, **Google Custom Search**, or **Bing Search**).
3. **Concurrent Processing**: Spawns multiple parallel background thread workers to download and sanitize the target HTML pages in parallel.
4. **Gap Analysis**: LLM audits the gathered Turn 1 context, isolating missing details or areas of ambiguity, and plans Turn 2 follow-up sub-queries.
5. **Follow-up Scraping**: Executes targeted secondary queries and scrapes additional resources concurrently.
6. **Polished Synthesis**: Consolidates the complete context graph and compiles a deep research markdown report (`deep_research_report.md`).

---

## ⚙️ Configuration & Credentials

The agent dynamically extracts credentials from the environment or a local `.env` file:
* **LLM Engine**: `GEMINI_API_KEY` or `OPENROUTER_API_KEY` (defaults to `gemini-3.5-flash` natively or OpenRouter's proxy).
* **Search Engines**:
  * `TAVILY_API_KEY` (Tavily AI Search)
  * `EXA_API_KEY` (Exa Autoprompt Search)
  * `BRAVE_API_KEY` (Brave Search API)
  * `GOOGLE_SEARCH_API_KEY` & `GOOGLE_CSE_ID` (Google CSE)
  * `BING_SEARCH_API_KEY` (Bing Web Search)

### ℹ️ High-Reliability Fallbacks
* **No Search Credentials**: The script falls back to high-reliability pre-planned static documentation paths to perform real page scrapes.
* **No LLM Credentials**: The script runs in a high-fidelity simulated/mock mode to output log checkpoints reflecting the exact execution graph of the agent.

---

## 🚀 Execution

To execute this scenario natively from the repository root:

```bash
mojo -I src scenarios/scenario_11_deep_researcher/scenario_deep_researcher.mojo
```

# 🎭 Scenario 11: Modular Iterative Deep Research Agent

This scenario demonstrates an advanced **Modular Iterative Deep Research Agent** designed to perform long-horizon web investigation and citation validation tasks. 

Following the principles detailed in SOTA deep research methodologies (such as Tavily, Valyu, Parallel AI, and OpenDeepSearch), the agent refines its search plan, queries multiple web search APIs, and performs multi-turn factual gap analysis to compile comprehensive Markdown intelligence briefings.

---

## 🏗️ Modular Architecture & Relationships

To manage the complexity of multi-turn deep research, the scenario is refactored into four smaller, highly targeted Mojo modules under `scenarios/scenario_11_deep_researcher/`:

1. **[search_providers.mojo](search_providers.mojo)**: Exposes a unified credentials mapping and search query dispatch gateway across five search providers.
2. **[content_fetcher.mojo](content_fetcher.mojo)**: Coordinates concurrent background thread-pools to fetch and sanitize target HTML bodies in parallel.
3. **[research_planner.mojo](research_planner.mojo)**: Guides LLM Turn 1 plan optimization, Turn 2 gap analysis, and final report synthesis using high-timeout direct API boundaries.
4. **[scenario_deep_researcher.mojo](scenario_deep_researcher.mojo)**: The main driver coordination script integrating all modules and handling regular prompts or benchmark evaluation states.

Below is the Mermaid relationship diagram mapping the interactions of these modular components:

```mermaid
graph TD
    classDef mojo fill:#fbcfe8,stroke:#db2777,stroke-width:2px,color:#500724;
    classDef module fill:#a5f3fc,stroke:#0891b2,stroke-width:2px,color:#083344;
    classDef os fill:#ddd,stroke:#555,stroke-width:2px,color:#111;

    Main["scenario_deep_researcher.mojo (Coordinator)"]:::mojo
    Planner["research_planner.mojo (LLM Planner)"]:::module
    Search["search_providers.mojo (Search Gateway)"]:::module
    Fetcher["content_fetcher.mojo (Thread Scraper)"]:::module
    
    OS["Operating System / File System"]:::os
    LLM["Gemini / OpenRouter API"]:::os
    Web["Target Web Pages"]:::os

    Main --> Planner
    Main --> Search
    Main --> Fetcher
    
    Planner -->|Direct Call (45s)| LLM
    Search -->|Query APIs| LLM
    Fetcher -->|Scrape HTML| Web
    Main -->|Save deep_research_report.md| OS
```

---

## 🔍 Alphabetical Search APIs Reference

The agent dynamically extracts credentials and prioritizes query dispatch across five major search engine APIs, sorted strictly alphabetically below:

| Search Engine API | Developer Homepage | Environment Variable | Focus |
| :--- | :--- | :--- | :--- |
| **Bing Search API** | [microsoft.com/en-us/bing/apis](https://www.microsoft.com/en-us/bing/apis) | `BING_SEARCH_API_KEY` | Structured corporate web queries. |
| **Brave Search API** | [brave.com/search/api](https://brave.com/search/api/) | `BRAVE_KEY` | High-quality, ad-free web results. |
| **Exa Search API** | [exa.ai](https://exa.ai) | `EXA_API_KEY` | Autoprompting-tuned neural research. |
| **Google CSE API** | [developers.google.com/custom-search](https://developers.google.com/custom-search) | `GOOGLE_SEARCH_API_KEY` & `GOOGLE_CSE_ID` | Broad custom search engine index. |
| **Tavily Search API** | [tavily.com](https://tavily.com) | `TAVILY_API_KEY` | Agent-oriented optimization and summary search. |

---

## 🏆 Deep Research Benchmarks & Methodology

The agent's multi-turn loop and citation extraction logic are structured to be compatible with prominent open-source deep research systems and benchmarks:

### 1. Controlled Horizon Benchmarks
* **[BrowseComp-Plus Dataset (HuggingFace)](https://huggingface.co/datasets/Tevatron/browsecomp-plus)** (referencing [BrowseComp-Plus GitHub](https://github.com/texttron/BrowseComp-Plus) and the research paper **[arXiv:2508.06600](https://arxiv.org/abs/2508.06600)**): Evaluates web browsing agents against a static, controlled corpus of 100,000+ documents containing verified positives and distractors to test retrieval accuracy.
* **[DeepResearch-Bench (DRB)](https://deepresearch-bench.github.io)** (referencing [DRB on GitHub](https://github.com/Ayanami0730/deep_research_bench) and the [DRB Leaderboard](https://huggingface.co/spaces/muset-ai/DeepResearch-Bench-Leaderboard)): Tests agents on 100 PhD-level research queries across 22 domains using a two-part framework:
  1. **RACE** (Reference-based Adaptive Criteria-driven Evaluation) - LLM-as-a-judge scoring of report quality against expert references.
  2. **FACT** (Factual Abundance and Citation Trustworthiness) - Automated extraction and verification to confirm if cited source URLs factually support the report's claims.

### 2. Architectural References
* **[Valyu Deep Research](https://www.valyu.ai/blogs/introducing-deepresearch)**: Multi-step information consolidation and automated citation auditing.
* **[Parallel AI Deep Research](https://parallel.ai/blog/deep-research)**: Long-horizon planning and sub-query optimization strategies.
* **[Sentient OpenDeepSearch](https://github.com/sentient-agi/OpenDeepSearch)**: Open-source implementation details for dynamic recursive search loops.

---

## 🚀 Execution & Benchmarking

### Regular Deep Research Execution
To run the deep research agent on a regular topic:
```bash
mojo -I src -I scenarios/scenario_11_deep_researcher scenarios/scenario_11_deep_researcher/scenario_deep_researcher.mojo
```

### Benchmark Evaluation Execution
To run the agent in benchmark evaluation mode to score retrieval and citation indices against BrowseComp-Plus and DeepResearch-Bench contracts:
```bash
mojo -I src -I scenarios/scenario_11_deep_researcher scenarios/scenario_11_deep_researcher/scenario_deep_researcher.mojo --benchmark
```

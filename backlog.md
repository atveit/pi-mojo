# 📋 pi-mojo Systems Backlog

This document outlines planned optimizations, features, and systems engineering enhancements for the `pi-mojo` compiled systems-agent platform.

---

## 🚀 Backlog Items

### 1. Robust PDF & Binary Document Parsing (High Priority)
* **Current State**: The parallel fetcher (`content_fetcher.mojo`) scrapes targets using a concurrent Python thread-pool and standard HTTP requests. If a search result points directly to a PDF document (such as academic ArXiv papers, `https://arxiv.org/pdf/...`), the binary stream is downloaded and decoded as UTF-8, resulting in unparseable text blocks.
* **Target Solution**: 
  * Integrate clean PDF/binary parsing within the `fetch(url)` worker function.
  * Leverage Python FFI libraries such as `pypdf`, `pymupdf`, or `pdfplumber` to extract semantic layout blocks and text segments before cleaning.
  * Gracefully handle binary parsing exceptions and fall back to metadata summaries if extraction fails.

### 2. Interactive Checkpoint Resume & Session Rehydration
* **Current State**: The deep research coordinator writes a robust session snapshot to `deep_research_checkpoint.json` at the end of each turn. However, restarting the script always initializes a new research run.
* **Target Solution**: 
  * Add a `--resume` flag to the coordinator command-line interface.
  * Load and parse `deep_research_checkpoint.json` using Python FFI JSON boundaries to restore the research topic, turn index, search histories, and accumulated context, allowing direct recovery from a crash or pause.

### 3. Context Deduplication & Factual Cross-Referencing
* **Current State**: Scraped content from multiple matching pages is appended directly to the accumulated context. This often introduces identical blocks, legal disclaimers, or repetitive headers across sites.
* **Target Solution**:
  * Implement an AST-based or semantic deduplication filter to strip redundant layout structures.
  * Add a cross-referencing model pass to check that facts or claims are supported by multiple source URLs before compiling the final markdown briefing.

### 4. Dynamic Token Budgeting & Adaptive Truncation
* **Current State**: Scraped page bodies are truncated to a hard static cap of 40,000 characters to prevent LLM API timeouts.
* **Target Solution**:
  * Dynamically scale the page truncation limits by measuring the target model's context bounds (`gemini-3.5-flash` context limits) and subtracting active prompt tokens, maximizing data density per turn.

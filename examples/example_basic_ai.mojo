import t2m_runtime.utils as utils
import t2m_runtime.llm as llm

def main() raises:
    utils.console_log("=========================================================")
    utils.console_log("🚀 Progressive AI Completions Example (Crawl, Walk, Run)")
    utils.console_log("=========================================================\n")
    
    # -------------------------------------------------------------
    # 1. CRAWL: Mocked / Simulated Completions
    # -------------------------------------------------------------
    utils.console_log("--- [CRAWL] Mocked / Simulated AI Completion ---")
    var crawl_prompt = "What is your favorite color?"
    utils.console_log("Prompt:", crawl_prompt)
    var simulated_response = "I have no eyes to see the light, but green is clean and blue is bright."
    utils.console_log("Simulated Response (Rhyming):", simulated_response)
    utils.console_log("")

    # -------------------------------------------------------------
    # 2. WALK: Local LLM via LM Studio / MLX
    # -------------------------------------------------------------
    utils.console_log("--- [WALK] Local LLM Connection (localhost:1234) ---")
    var walk_prompt = "What is your favorite color?"
    var system_prompt = "You answer only in rhymes."
    utils.console_log("Endpoint: http://localhost:1234/api/v1/chat")
    utils.console_log("Model: qwen3.5-0.8b-mlx@8bit")
    utils.console_log("Prompt:", walk_prompt)
    try:
        var local_response = llm.call_local_llm(walk_prompt, system_prompt)
        utils.console_log("Local LLM Response:")
        utils.console_log(local_response.strip())
    except err:
        utils.console_log("⚠️  Local LLM connection bypassed or failed.")
        utils.console_log("   Note: To enable this tier, run a local MLX or LM Studio server on port 1234.")
    utils.console_log("")

    # -------------------------------------------------------------
    # 3. RUN: Cloud LLM via OpenRouter or Gemini API
    # -------------------------------------------------------------
    utils.console_log("--- [RUN] Cloud LLM Connection (OpenRouter/Gemini) ---")
    var gemini_key: String
    var openrouter_key: String
    gemini_key, openrouter_key = llm.load_env_keys()
    
    var run_prompt = "Explain the advantages of Mojo for AI systems in one concise sentence."
    
    if openrouter_key:
        utils.console_log("Model Provider: OpenRouter (google/gemini-3.5-flash)")
        utils.console_log("Prompt:", run_prompt)
        try:
            var response = llm.call_openrouter(openrouter_key, run_prompt, "google/gemini-3.5-flash")
            utils.console_log("OpenRouter Response:")
            utils.console_log(response.strip())
        except err:
            utils.console_log("❌ OpenRouter API call failed:", String(err))
    elif gemini_key:
        utils.console_log("Model Provider: Google Gemini API (gemini-2.5-flash)")
        utils.console_log("Prompt:", run_prompt)
        try:
            var response = llm.call_gemini(gemini_key, run_prompt)
            utils.console_log("Gemini Response:")
            utils.console_log(response.strip())
        except err:
            utils.console_log("❌ Gemini API call failed:", String(err))
    else:
        utils.console_log("⚠️  Cloud LLM bypassed. No GEMINI_API_KEY or OPENROUTER_API_KEY found in environment or .env.")
    utils.console_log("")

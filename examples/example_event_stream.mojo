import t2m_runtime.utils as utils
import t2m_runtime.llm as llm
from std.python import Python, PythonObject



def main() raises:
    utils.console_log("=========================================================")
    utils.console_log("🚀 Run Example: Real-Time AI Event Streaming")
    utils.console_log("=========================================================\n")
    
    var gemini_key: String
    var _openrouter_key: String
    gemini_key, _openrouter_key = llm.load_env_keys()
    
    if not gemini_key:
        utils.console_log("⚠️  Bypassed. Please configure GEMINI_API_KEY in your .env to run this stream.")
        return
        
    var prompt = "Write a very short, inspiring, 3-sentence sci-fi story about compiling Mojo on Apple Silicon."
    utils.console_log("Prompt:", prompt)
    utils.console_log("")
    
    try:
        utils.console_log("Connecting stream to Gemini API...")
        utils.console_log("Streaming Response (Real-Time Tokens):")
        utils.console_log("---------------------------------------------------------")
        llm.call_gemini_stream(gemini_key, prompt)
        utils.console_log("\n---------------------------------------------------------")
    except err:
        utils.console_log("❌ Error running event stream:", String(err))
    
    utils.console_log("\n=========================================================\n")

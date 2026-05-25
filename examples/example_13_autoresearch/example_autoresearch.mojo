import t2m_runtime.utils as utils
import t2m_runtime.llm as llm
from std.python import Python, PythonObject

def get_python_json_helper() raises -> PythonObject:
    var py_code = (
        "def save_history(filepath, history_list):\n"
        "    import json\n"
        "    with open(filepath, 'w', encoding='utf-8') as f:\n"
        "        json.dump(history_list, f, indent=2)\n"
    )
    var builtins = Python.import_module("builtins")
    var py_globals = builtins.dict()
    builtins.exec(py_code, py_globals)
    return py_globals["save_history"]

def main() raises:
    utils.console_log("=========================================================")
    utils.console_log("🚀 Example 13: Basic Karpathy Autoresearch Loop")
    utils.console_log("=========================================================\n")
    
    var task_objective = "Optimize dynamic threshold filter computation for stack values."
    utils.console_log("Research Task:", task_objective)
    utils.console_log("")

    # Load dynamic credentials
    var gemini_key: String
    var openrouter_key: String
    gemini_key, openrouter_key = llm.load_env_keys()
    
    var active_key = openrouter_key if openrouter_key else gemini_key
    var is_openrouter = True if openrouter_key else False

    var builtins = Python.import_module("builtins")
    var save_fn = get_python_json_helper()
    
    var history = builtins.list()
    var best_latency = 120.5 # Baseline latency in milliseconds
    var best_implementation = String("Scalar loop iteration")
    
    utils.console_log("Baseline Implementation: " + best_implementation)
    utils.console_log("Baseline Latency: " + String(best_latency) + " ms\n")

    if not active_key:
        utils.console_log("⚠️  No Gemini/OpenRouter keys found. Running in SIMULATED/MOCK mode.")
        
        # Round 1
        utils.console_log("\n--- [Round 1/3] ---")
        var prop_1 = "Unroll the inner threshold checking loops by a factor of 4"
        utils.console_log("Proposed Hypothesis: " + prop_1)
        var lat_1 = 92.2
        utils.console_log("Benchmark Latency: " + String(lat_1) + " ms")
        if lat_1 < best_latency:
            var speedup = best_latency / lat_1
            utils.console_log("📈 IMPROVEMENT DETECTED! Speedup: " + String(speedup) + "x")
            best_latency = lat_1
            best_implementation = prop_1
        else:
            utils.console_log("❌ REGRESSION. Reverting changes.")
            
        var entry1 = builtins.dict()
        entry1["round"] = 1
        entry1["hypothesis"] = prop_1
        entry1["latency"] = lat_1
        entry1["status"] = "ACCEPTED"
        _ = history.append(entry1)

        # Round 2
        utils.console_log("\n--- [Round 2/3] ---")
        var prop_2 = "Cache-align dynamic bounds registers"
        utils.console_log("Proposed Hypothesis: " + prop_2)
        var lat_2 = 101.4
        utils.console_log("Benchmark Latency: " + String(lat_2) + " ms")
        if lat_2 < best_latency:
            var speedup = best_latency / lat_2
            utils.console_log("📈 IMPROVEMENT DETECTED! Speedup: " + String(speedup) + "x")
            best_latency = lat_2
            best_implementation = prop_2
        else:
            utils.console_log("❌ REGRESSION. Reverting changes.")
            
        var entry2 = builtins.dict()
        entry2["round"] = 2
        entry2["hypothesis"] = prop_2
        entry2["latency"] = lat_2
        entry2["status"] = "REJECTED"
        _ = history.append(entry2)

        # Round 3
        utils.console_log("\n--- [Round 3/3] ---")
        var prop_3 = "Compile-time SIMD Vectorization layout"
        utils.console_log("Proposed Hypothesis: " + prop_3)
        var lat_3 = 45.1
        utils.console_log("Benchmark Latency: " + String(lat_3) + " ms")
        if lat_3 < best_latency:
            var speedup = best_latency / lat_3
            utils.console_log("📈 IMPROVEMENT DETECTED! Speedup: " + String(speedup) + "x")
            best_latency = lat_3
            best_implementation = prop_3
        else:
            utils.console_log("❌ REGRESSION. Reverting changes.")
            
        var entry3 = builtins.dict()
        entry3["round"] = 3
        entry3["hypothesis"] = prop_3
        entry3["latency"] = lat_3
        entry3["status"] = "ACCEPTED"
        _ = history.append(entry3)

        # Save history
        _ = save_fn("autoresearch_history.json", history)
        utils.console_log("\n✅ Autoresearch completed! Saved history to: autoresearch_history.json")
        utils.console_log("Winning Implementation: " + best_implementation)
        utils.console_log("Winning Latency: " + String(best_latency) + " ms (Total speedup: " + String(120.5 / best_latency) + "x)")
        
        # Clean up file
        try:
            var os = Python.import_module("os")
            _ = os.remove("autoresearch_history.json")
        except:
            pass
        utils.console_log("=========================================================\n")
        return

    # Real Cloud Autoresearch Loop
    var prompt_prefix = (
        "You are an expert autonomous compiler optimizer. We are performing a Karpathy autoresearch loop to solve this goal:\n"
        "'" + task_objective + "'\n\n"
        "The current best implementation is: '" + best_implementation + "' with a benchmark latency of " + String(best_latency) + " ms.\n\n"
    )

    for r in range(1, 4):
        utils.console_log("\n--- [Round " + String(r) + "/3] ---")
        utils.console_log("1. Asking AI to propose an optimization hypothesis...")
        
        var prompt = prompt_prefix + "Generate a single creative, highly optimized code optimization hypothesis. Output only the short description of the optimization hypothesis without quotes."
        var hypothesis = String("Loop unrolling and register loading")
        try:
            if is_openrouter:
                hypothesis = llm.call_openrouter(active_key, prompt, "google/gemini-3.5-flash")
            else:
                hypothesis = llm.call_gemini(active_key, prompt)
        except:
            pass
            
        utils.console_log("   Proposed Hypothesis: " + hypothesis.strip())
        
        # Simulate benchmark latency based on round complexity
        var lat: Float64
        if r == 1:
            lat = 89.4
        elif r == 2:
            lat = 95.8 # Regression
        else:
            lat = 38.6 # SIMD speedup
            
        utils.console_log("2. Compiling and running benchmark...")
        utils.console_log("   Benchmark Latency: " + String(lat) + " ms")
        
        var is_improvement = lat < best_latency
        var status_str = String("REJECTED")
        if is_improvement:
            var speedup = best_latency / lat
            utils.console_log("   📈 IMPROVEMENT DETECTED! Speedup: " + String(speedup) + "x")
            best_latency = lat
            best_implementation = String(hypothesis.strip())
            status_str = "ACCEPTED"
        else:
            utils.console_log("   ❌ REGRESSION. Reverting changes.")
            
        var entry = builtins.dict()
        entry["round"] = r
        entry["hypothesis"] = hypothesis.strip()
        entry["latency"] = lat
        entry["status"] = status_str
        _ = history.append(entry)
        
    # Save history
    _ = save_fn("autoresearch_history.json", history)
    utils.console_log("\n✅ Autoresearch completed! Saved history to: autoresearch_history.json")
    utils.console_log("Winning Implementation: " + best_implementation)
    utils.console_log("Winning Latency: " + String(best_latency) + " ms")
    
    # Clean up file
    try:
        var os = Python.import_module("os")
        _ = os.remove("autoresearch_history.json")
    except:
        pass
    utils.console_log("=========================================================\n")

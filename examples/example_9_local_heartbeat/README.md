# Local LLM Service Heartbeat Check (example_local_heartbeat.mojo)

This example implements a Local LLM Service Heartbeat and connection health checker that demonstrates a **Hybrid Local-Cloud Agent Topology**. It pings a local service endpoint (like LM Studio or MLX running on port 1234) for fast connection probes, and combines it with a high-tier cloud model (Gemini 3.5 Flash via OpenRouter or direct Google AI Studio HTTP connection) to execute heavier, reasoning-intensive tasks based on the diagnostics.

### 🧠 Hybrid Local-Cloud Architectural Benefits
- **Cost Efficiency**: Local models handle frequent connection checks, raw latency tests, and fast heartbeat pings with zero cloud API billing costs.
- **Latency Control**: Bypasses heavy internet hops for rapid diagnostic loops.
- **High Reasoning**: Reserves high-tier cloud models (like Gemini 3.5 Flash) only for complex synthesis, planning, and long-horizon tasks.

### ⚙️ How it Works
1. **Heartbeat Diagnostics**: Sends a fast probe request to verify the connection status of the local server.
2. **Strict Rhyming Constraint**: Exercises the system prompt configuration of the local model using the query `"What is your favorite color?"` and system prompt `"You answer only in rhymes."`.
3. **Response Timing Metrics**: Captures high-resolution timing intervals to compute server latency.
4. **Cloud Non-Heartbeat Task Dispatch**: If a cloud connection is available, the agent triggers a heavy logical summary task on Gemini 3.5 Flash to synthesize the system health report.
5. **Offline Diagnostic Hint**: If the local connection fails, the agent gracefully falls back, reports the status, and shows the manual `curl` debugging command structure.

### 📄 Source Code & Captured Run
- **Source Code**: [example_local_heartbeat.mojo](example_local_heartbeat.mojo)
- **Sample Run Output**: [example_local_heartbeat_run.txt](example_local_heartbeat_run.txt)

### 🚀 Execution
To run this example locally:
```bash
mojo run -I src examples/example_9_local_heartbeat/example_local_heartbeat.mojo
```

### 🖥️ Console Output
Below is the real console output demonstrating the fully integrated hybrid workflow:
```text
=========================================================
💓 Local LLM Service Heartbeat Check (Qwen 3.5 MLX)
=========================================================

Pinging local service endpoint: http://localhost:1234/api/v1/chat
Model expected: qwen3.5-0.8b-mlx@8bit
System prompt: You answer only in rhymes.
Payload query: What is your favorite color?

💚 HEARTBEAT STATUS: ONLINE
Latency:             249.0 ms
Rhyming Response:    I love the colors of the sky and the stars. 🌟

---------------------------------------------------------
🧠 Hybrid Local-Cloud Workflow Integration
---------------------------------------------------------
Architectural Benefits:
 - Cost Efficiency: Local models handle frequent connection checks & raw latency tests with zero API costs.
 - High Reasoning: Reserves high-tier cloud models (Gemini 3.5 Flash) for heavy logical tasks and synthesis.

Dispatched heavy non-heartbeat task to Cloud Gemini 3.5 Flash...
Sending to Gemini API (gemini-3.5-flash)...
Cloud Report: The local service is fully operational and healthy, exhibiting an ONLINE status, nominal 249.0 ms latency, and coherent model inference capabilities.

=========================================================
```

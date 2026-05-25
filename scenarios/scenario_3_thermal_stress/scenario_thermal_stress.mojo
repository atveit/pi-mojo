import t2m_runtime.utils as utils
from std.python import Python

# Sensory functions using 'def' as preferred in current Mojo specifications
def get_datacenter_sensor_metrics() -> String:
    return "Node=Core-Rack-7, Temperature=38.8C, PowerLoad=185000W, Humidity=42%"

def calculate_cooling_load(temp: Float64, power: Float64) -> Float64:
    var delta_temp = temp - 20.0
    var power_kw = power / 1000.0
    return (delta_temp * 0.12) + (power_kw * 0.08)

def main() raises:
    utils.console_log("=========================================================")
    utils.console_log("🤖 Scenario 3: Operations Thermal Stress Monitor")
    utils.console_log("=========================================================\n")
    
    utils.console_log("Systems Narrative Story:")
    utils.console_log("An agent acts as a datacenter operations monitor. It queries native")
    utils.console_log("Mojo sensors and calls compiled math models to calculate heat")
    utils.console_log("dissipation, outputting automated mechanical cooling changes.\n")

    utils.console_log("📊 [NATIVE SENSOR RUN] Invoking native Mojo sensory tools...")
    
    # 1. Fetch metrics
    var sensor_data = get_datacenter_sensor_metrics()
    utils.console_log("Mojo tool 'get_datacenter_sensor_metrics' returned: " + sensor_data)
    
    # 2. Perform thermodynamics calculations natively
    var temp: Float64 = 38.8
    var power: Float64 = 185000.0
    var cooling_required = calculate_cooling_load(temp, power)
    
    utils.console_log("Mojo math model 'calculate_cooling_load(temp=" + String(temp) + ", power=" + String(power) + ")' computed cooling load: " + String(cooling_required) + " kW")
    
    # 3. Formulate recommendations
    utils.console_log("\n--- [Systems Operations Diagnosis Report] ---")
    utils.console_log("⚠️  STATUS: Datacenter Core temperature exceeds target bounds of 25.0C.")
    utils.console_log("💡 ACTION: Cooling infrastructure must shed at least " + String(cooling_required) + " kW of heat.")
    utils.console_log("👉 RECOMMENDATION: Increase Fan Rack speed by 25% and route transient tasks to Backup node Cluster-2.")
    utils.console_log("=========================================================\n")

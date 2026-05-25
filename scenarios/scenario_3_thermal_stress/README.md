# Scenario 3: The Operations Thermal Stress Monitor

This storyboard scenario complements **[Example 3: Native AI Tool Calling](../../examples/example_3_tool_calling)**. While Example 3 demonstrates basic API-level tool definition and schema registration, this scenario models a high-performance datacenter thermal monitoring suite that invokes native compiled thermodynamic calculators.

---

## 📖 The Operations Story

Datacenter operational metrics must be audited in real time to prevent hardware throttling and fire hazards. The agent represents an operations daemon that:
1. Queries native sensors using compiled Mojo tool `get_datacenter_sensor_metrics()`.
2. Intercepts the Temperature and Power readings.
3. Computes the required heat dissipation load in kilowatts using native Mojo mathematical model `calculate_cooling_load(temp, power)`.
4. Outputs an immediate, high-fidelity mechanical cooling recommendation to stabilize environmental heat boundaries.

---

## 🚀 Execution & Verification

To run this storyboard scenario, execute:

```bash
mojo -I src scenarios/scenario_3_thermal_stress/scenario_thermal_stress.mojo
```

---

## 📂 Files
- **Source Script**: [scenario_thermal_stress.mojo](scenario_thermal_stress.mojo)
- **Captured Console Output**: [scenario_thermal_stress_run.txt](scenario_thermal_stress_run.txt)

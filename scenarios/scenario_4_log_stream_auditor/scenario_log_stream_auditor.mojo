import t2m_runtime.utils as utils
from std.python import Python, PythonObject

def get_simulated_syslogs() raises -> PythonObject:
    var builtins = Python.import_module("builtins")
    var logs = builtins.list()
    _ = logs.append("May 25 12:01:05 server-node-1 sshd[12401]: Connection from 203.0.113.50 port 49152")
    _ = logs.append("May 25 12:01:06 server-node-1 sshd[12401]: WARNING: Password authentication failed for root")
    _ = logs.append("May 25 12:01:08 server-node-1 database[988]: INFO: Query latency nominal at 3ms")
    _ = logs.append("May 25 12:01:10 server-node-1 sshd[12401]: EXPLOIT_ATTEMPT: Root login attempt with CVE-2024-3094 signature")
    _ = logs.append("May 25 12:01:12 server-node-1 systemd[1]: ERROR: Disk space critical on /var/log")
    return logs

def main() raises:
    utils.console_log("=========================================================")
    utils.console_log("🤖 Scenario 4: Continuous Log Auditor Stream")
    utils.console_log("=========================================================\n")
    
    utils.console_log("Systems Narrative Story:")
    utils.console_log("High-throughput syslogs are audited in real time. The agent")
    utils.console_log("classifies entries by severity indexes and outputs immediate")
    utils.console_log("color-coded alerts for security and hardware warnings.\n")

    var logs = get_simulated_syslogs()
    var builtins = Python.import_module("builtins")
    var logs_len = Int(py=builtins.len(logs))
    
    utils.console_log("🌊 [syslog stream listener active]")
    utils.console_log("---------------------------------------------------------")
    
    for i in range(logs_len):
        var log_line = String(py=logs[i])
        
        # Immediate color-coded audit highlighting
        if "EXPLOIT_ATTEMPT" in log_line or "Exploit" in log_line:
            utils.console_log("🔴 [CRITICAL SECURITY] " + log_line)
        elif "WARNING" in log_line or "auth fail" in log_line.lower():
            utils.console_log("🟡 [WARNING ALERT]     " + log_line)
        elif "ERROR" in log_line or "critical" in log_line.lower():
            utils.console_log("🟠 [HARDWARE ALERT]    " + log_line)
        else:
            utils.console_log("🟢 [NOMINAL INFO]     " + log_line)
            
    utils.console_log("---------------------------------------------------------")
    utils.console_log("\n🔒 Stream audit check concluded: 1 Security Threat, 1 Hardware Issue flagged.")
    utils.console_log("=========================================================\n")

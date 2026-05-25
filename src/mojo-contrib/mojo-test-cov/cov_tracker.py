# cov_tracker.py
import json
import os
import atexit

class MojoCoverageTracker:
    def __init__(self):
        self.covered_lines = {}       # { file_path: set([line_numbers]) }
        self.executable_lines = {}    # { file_path: set([line_numbers]) }
        self.db_path = ".coverage_mojo.json"
        
        # Automatically register save on termination to collect coverage from subprocesses
        atexit.register(self.save)

    def log(self, file_path: str, line_number: int):
        if file_path not in self.covered_lines:
            self.covered_lines[file_path] = set()
        self.covered_lines[file_path].add(line_number)

    def register_executable_lines(self, file_path: str, lines_list: list):
        self.executable_lines[file_path] = set(lines_list)

    def save(self):
        # We merge with any existing coverage file to aggregate coverage from all subprocesses!
        existing_covered = {}
        if os.path.exists(self.db_path):
            try:
                with open(self.db_path, "r", encoding="utf-8") as f:
                    old_data = json.load(f)
                    for file_path, f_data in old_data.get("files", {}).items():
                        existing_covered[file_path] = set(f_data.get("covered_lines", []))
            except:
                pass

        # Merge current in-memory covered lines with existing ones
        has_new_data = False
        for file_path, lines in self.covered_lines.items():
            if not lines:
                continue
            if file_path not in existing_covered:
                existing_covered[file_path] = set()
            existing_covered[file_path] = existing_covered[file_path].union(lines)
            has_new_data = True

        # If there is no new data to save and the file already exists, we do not need to rewrite it
        if not has_new_data and os.path.exists(self.db_path):
            return

        # Now build the merged report data
        report_data = {
            "summary": {
                "total_statements": 0,
                "covered_statements": 0,
                "coverage_percentage": 0.0
            },
            "files": {}
        }

        total_exec = 0
        total_cov = 0

        all_files = set(self.executable_lines.keys()).union(existing_covered.keys())

        for file_path in all_files:
            exec_set = self.executable_lines.get(file_path, set())
            cov_set = existing_covered.get(file_path, set())

            exec_list = sorted(list(exec_set))
            cov_list = sorted(list(cov_set))

            total_exec += len(exec_list)
            total_cov += len(cov_list)

            pct = (len(cov_list) / len(exec_list) * 100) if exec_list else 100.0

            report_data["files"][file_path] = {
                "executable_lines": exec_list,
                "covered_lines": cov_list,
                "coverage_percentage": round(pct, 2)
            }

        report_data["summary"]["total_statements"] = total_exec
        report_data["summary"]["covered_statements"] = total_cov
        report_data["summary"]["coverage_percentage"] = round((total_cov / total_exec * 100) if total_exec else 100.0, 2)

        # Write to JSON
        with open(self.db_path, "w", encoding="utf-8") as f:
            json.dump(report_data, f, indent=2)

_tracker_instance = MojoCoverageTracker()

def get_tracker():
    return _tracker_instance

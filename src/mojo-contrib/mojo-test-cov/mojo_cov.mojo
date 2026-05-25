# mojo_cov.mojo
from std.python import Python, PythonObject

struct MojoCov:
    var tracker: PythonObject

    def __init__(out self):
        self.tracker = None
        try:
            var sys = Python.import_module("sys")
            # Append local directory to support finding cov_tracker in current run environments
            _ = sys.path.append(".")
            _ = sys.path.append("src")
            self.tracker = Python.import_module("cov_tracker").get_tracker()
        except:
            pass

    def hit(self, file_path: String, line: Int):
        try:
            if self.tracker:
                _ = self.tracker.log(file_path, line)
        except:
            pass

    def register_exec(self, file_path: String, lines: PythonObject):
        try:
            if self.tracker:
                _ = self.tracker.register_executable_lines(file_path, lines)
        except:
            pass

    def save(self):
        try:
            if self.tracker:
                _ = self.tracker.save()
        except:
            pass

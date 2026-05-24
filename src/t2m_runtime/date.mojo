from std.python import Python

struct Date:
    @staticmethod
    def now() raises -> Int:
        var time = Python.import_module("time")
        var val = time.time() * 1000
        return Int(py=val)

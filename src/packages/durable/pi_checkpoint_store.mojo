from std.python import Python, PythonObject
from std.os.path import exists, isdir
from t2m_runtime.fs import mkdirSync, readdirSync
import t2m_runtime.utils as utils

struct Checkpoint(ImplicitlyCopyable):
    var session_id: String
    var goal: String
    var current_step: Int
    var messages: PythonObject
    var metadata: PythonObject

    def __init__(out self, session_id: String, goal: String, current_step: Int, messages: PythonObject, metadata: PythonObject):
        self.session_id = session_id
        self.goal = goal
        self.current_step = current_step
        self.messages = messages
        self.metadata = metadata

    def __init__(out self, *, copy: Self):
        self.session_id = copy.session_id
        self.goal = copy.goal
        self.current_step = copy.current_step
        self.messages = copy.messages
        self.metadata = copy.metadata

struct CheckpointStore:
    var checkpoints_dir: String

    def __init__(out self, checkpoints_dir: String = ".pi_checkpoints"):
        self.checkpoints_dir = checkpoints_dir
        try:
            if not exists(self.checkpoints_dir):
                mkdirSync(self.checkpoints_dir)
        except:
            pass

    def exists_checkpoint(self, session_id: String) raises -> Bool:
        var filepath = self.checkpoints_dir + "/" + session_id + ".json"
        return exists(filepath)

    def save_checkpoint(self, checkpoint: Checkpoint) raises:
        var json = Python.import_module("json")
        var builtins = Python.import_module("builtins")
        
        var d = builtins.dict()
        d["session_id"] = checkpoint.session_id
        d["goal"] = checkpoint.goal
        d["current_step"] = checkpoint.current_step
        d["messages"] = checkpoint.messages
        d["metadata"] = checkpoint.metadata
        
        var json_str = json.dumps(d, indent=2)
        
        var filepath_py = PythonObject(self.checkpoints_dir) + "/" + PythonObject(checkpoint.session_id) + ".json"
        
        var f = builtins.open(filepath_py, "w", encoding="utf-8")
        _ = f.write(json_str)
        _ = f.close()

    def load_checkpoint(self, session_id: String) raises -> Checkpoint:
        var filepath = self.checkpoints_dir + "/" + session_id + ".json"
        if not exists(filepath):
            raise Error("No checkpoint found for session: " + session_id)
            
        var json = Python.import_module("json")
        var builtins = Python.import_module("builtins")
        
        var filepath_py = PythonObject(self.checkpoints_dir) + "/" + PythonObject(session_id) + ".json"
        
        var f = builtins.open(filepath_py, "r", encoding="utf-8")
        var json_str = f.read()
        _ = f.close()
        
        var d = json.loads(json_str)
        
        var goal = String(py=d["goal"])
        var current_step = Int(py=d["current_step"])
        var messages = d["messages"]
        var metadata = d["metadata"]
        
        return Checkpoint(session_id, goal, current_step, messages, metadata)

    def delete_checkpoint(self, session_id: String) raises:
        var filepath = self.checkpoints_dir + "/" + session_id + ".json"
        if exists(filepath):
            var os = Python.import_module("os")
            var filepath_py = PythonObject(self.checkpoints_dir) + "/" + PythonObject(session_id) + ".json"
            _ = os.remove(filepath_py)

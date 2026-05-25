from std.python import Python, PythonObject
from std.os.path import exists, isdir
from t2m_runtime.fs import mkdirSync, readdirSync

struct Playbook(ImplicitlyCopyable):
    var goal: String
    var tags: String
    var criteria: String
    var steps: PythonObject
    var filepath: String

    def __init__(out self, goal: String, tags: String, criteria: String, steps: PythonObject, filepath: String):
        self.goal = goal
        self.tags = tags
        self.criteria = criteria
        self.steps = steps
        self.filepath = filepath

    def __init__(out self, *, copy: Self):
        self.goal = copy.goal
        self.tags = copy.tags
        self.criteria = copy.criteria
        self.steps = copy.steps
        self.filepath = copy.filepath

    def to_markdown(self) -> String:
        var md = String("")
        md += "# Playbook: " + self.goal + "\n"
        md += "- **Tags**: " + self.tags + "\n"
        md += "- **Criteria**: " + self.criteria + "\n\n"
        md += "## Steps\n"
        try:
            var builtins = Python.import_module("builtins")
            var steps_len = Int(py=builtins.len(self.steps))
            for i in range(steps_len):
                md += String(i + 1) + ". `" + String(py=self.steps[i]) + "`\n"
        except:
            pass
        return md

struct PlaybookStore:
    var playbooks_dir: String

    def __init__(out self, playbooks_dir: String = ".pi_playbooks"):
        self.playbooks_dir = playbooks_dir
        try:
            if not exists(self.playbooks_dir):
                mkdirSync(self.playbooks_dir)
        except:
            pass

    def save_playbook(self, playbook: Playbook) raises:
        var re = Python.import_module("re")
        var builtins = Python.import_module("builtins")
        var py_goal = PythonObject(playbook.goal)
        
        var safe_goal = re.sub(r'[^a-zA-Z0-9]+', '_', py_goal.lower()).strip('_')
        var filename_py = safe_goal + ".md"
        var filepath_py = PythonObject(self.playbooks_dir) + "/" + filename_py
        
        var content_py = PythonObject(playbook.to_markdown())
        
        var f = builtins.open(filepath_py, "w", encoding="utf-8")
        _ = f.write(content_py)
        _ = f.close()

    def load_playbooks(self) raises -> List[Playbook]:
        var playbooks = List[Playbook]()
        if not exists(self.playbooks_dir):
            return playbooks^
        
        var files = readdirSync(self.playbooks_dir)
        var builtins = Python.import_module("builtins")
        var files_len = Int(py=builtins.len(files))
        
        for i in range(files_len):
            var filename_py = files[i]
            if Bool(py=filename_py.endswith(".md")):
                var filepath_py = PythonObject(self.playbooks_dir) + "/" + filename_py
                try:
                    var f = builtins.open(filepath_py, "r", encoding="utf-8")
                    var content_py = f.read()
                    _ = f.close()
                    
                    var playbook = self.parse_playbook_py(content_py, filepath_py)
                    playbooks.append(playbook)
                except e:
                    pass
        return playbooks^

    def parse_playbook_py(self, content_py: PythonObject, filepath_py: PythonObject) raises -> Playbook:
        var lines = content_py.split("\n")
        var builtins = Python.import_module("builtins")
        var lines_len = Int(py=builtins.len(lines))
        
        var goal = String("")
        var tags = String("")
        var criteria = String("")
        var steps = builtins.list()
        
        var in_steps = False
        
        for i in range(lines_len):
            var line_py = lines[i].strip()
            var line = String(py=line_py)
            if line.startswith("# Playbook:"):
                goal = String(py=line_py[11:].strip())
            elif line.startswith("- **Tags**:"):
                tags = String(py=line_py[11:].strip())
            elif line.startswith("- **Criteria**:"):
                criteria = String(py=line_py[14:].strip())
            elif line.startswith("## Steps"):
                in_steps = True
            elif in_steps and len(line) > 0:
                var dot_idx = line.find(".")
                if dot_idx != -1:
                    var cmd_part_py = line_py[dot_idx + 1:].strip()
                    var cmd_part = String(py=cmd_part_py)
                    if cmd_part.startswith("`") and cmd_part.endswith("`"):
                        _ = steps.append(String(py=cmd_part_py[1:-1]))
                    else:
                        _ = steps.append(String(py=cmd_part_py))
                        
        return Playbook(goal, tags, criteria, steps, String(py=filepath_py))

    def find_matching_playbook(self, task: String) raises -> Playbook:
        var playbooks = self.load_playbooks()
        var builtins = Python.import_module("builtins")
        var best_playbook = Playbook("", "", "", builtins.list(), "")
        
        var task_lower = task.lower()
        for i in range(len(playbooks)):
            var pb = playbooks[i]
            var goal_lower = pb.goal.lower()
            var tags_lower = pb.tags.lower()
            
            if goal_lower in task_lower or task_lower in goal_lower:
                return pb
                
            var tags_list = tags_lower.split(",")
            for j in range(len(tags_list)):
                var tag = tags_list[j].strip()
                if len(tag) > 2 and tag in task_lower:
                    return pb
                    
        return best_playbook

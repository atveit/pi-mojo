# instrumenter.py
import re
import os

def is_executable_line(line: str) -> bool:
    stripped = line.strip()
    if not stripped:
        return False
    # Exclude comments
    if stripped.startswith("#"):
        return False
    # Exclude imports
    if stripped.startswith(("import ", "from ")):
        return False
    # Exclude structural definitions
    if stripped.startswith(("struct ", "class ", "trait ", "fn ", "def ")):
        return False
    # Exclude closing symbols or pure punctuation
    if stripped in (")", "]", "}", "pass"):
        return False
    return True

def instrument_file(input_path: str, output_path: str, relative_path: str):
    with open(input_path, "r", encoding="utf-8") as f:
        lines = f.readlines()

    output = []
    output.append("from mojo_cov import MojoCov")
    output.append("")

    in_function = False
    function_indent = 0
    func_lines = []
    
    in_multiline_string = False
    multiline_char = None

    for idx, line in enumerate(lines, 1):
        stripped = line.strip()
        
        # Track triple-quoted string boundaries
        quotes3 = line.count('"""')
        quotes3_single = line.count("'''")
        
        line_was_inside = in_multiline_string
        
        if not in_multiline_string:
            if quotes3 % 2 != 0:
                in_multiline_string = True
                multiline_char = '"""'
            elif quotes3_single % 2 != 0:
                in_multiline_string = True
                multiline_char = "'''"
        else:
            if multiline_char == '"""' and quotes3 % 2 != 0:
                in_multiline_string = False
                multiline_char = None
            elif multiline_char == "'''" and quotes3_single % 2 != 0:
                in_multiline_string = False
                multiline_char = None

        is_string_literal = line_was_inside or in_multiline_string

        if not stripped:
            if in_function:
                func_lines.append((idx, line, is_string_literal))
            else:
                output.append(line)
            continue

        # Detect function declarations
        match = re.match(r"^(\s*)(fn|def)\s+(\w+).*:\s*$", line)
        if match and not is_string_literal:
            # If we were already in a function, flush it
            if in_function:
                flush_function_body(func_lines, output, function_indent, relative_path)
                func_lines = []
            
            in_function = True
            function_indent = len(match.group(1))
            output.append(line)
            continue

        if in_function:
            current_indent = len(line) - len(line.lstrip())
            if current_indent <= function_indent and stripped and not is_string_literal:
                in_function = False
                flush_function_body(func_lines, output, function_indent, relative_path)
                func_lines = []
                output.append(line)
            else:
                func_lines.append((idx, line, is_string_literal))
        else:
            output.append(line)

    if in_function:
        flush_function_body(func_lines, output, function_indent, relative_path)

    # Ensure parent directories exist
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    with open(output_path, "w", encoding="utf-8") as f:
        f.writelines([l + "\n" if not l.endswith("\n") else l for l in output])

def flush_function_body(func_lines, output, base_indent, relative_path):
    if not func_lines:
        return

    indent_str = " " * (base_indent + 4)
    output.append(indent_str + "var _cov = MojoCov()")

    # Detect if parent function is main
    is_main = False
    for line in reversed(output):
        if "fn main" in line or "def main" in line:
            is_main = True
            break
        if "fn " in line or "def " in line:
            break

    control_flow_keywords = (
        "if ", "if(", "elif ", "elif(", "else:", "else ", 
        "for ", "while ", "try:", "try ", 
        "except:", "except ", "finally:", "finally "
    )

    # We track parentheses/brackets nesting count to ignore lines that are inside multi-line calls
    nesting_level = 0

    for idx, line, is_string_literal in func_lines:
        if is_string_literal or '"""' in line or "'''" in line:
            output.append(line)
            continue

        stripped = line.strip()
        if not stripped:
            output.append(line)
            continue

        # Count nesting changes
        opens = line.count("(") + line.count("[") + line.count("{")
        closes = line.count(")") + line.count("]") + line.count("}")
        
        # If we are already nested at the start of this line, we are inside a multi-line statement
        is_nested_continuation = nesting_level > 0
        
        # Update nesting level for the next lines
        nesting_level += (opens - closes)

        current_indent = len(line) - len(line.lstrip())
        indent_spaces = " " * current_indent

        if stripped.startswith("#"):
            output.append(line)
            continue

        # If it is a nested continuation of a statement, we must NEVER insert hits!
        if is_nested_continuation:
            output.append(line)
            continue

        # Check block header
        is_block_header = False
        if any(stripped.startswith(kw) for kw in control_flow_keywords):
            is_block_header = True

        if is_block_header:
            output.append(line)
            output.append(" " * (current_indent + 4) + f"_cov.hit(\"{relative_path}\", {idx})")
        elif is_executable_line(line):
            output.append(indent_spaces + f"_cov.hit(\"{relative_path}\", {idx})")
            output.append(line)
        else:
            output.append(line)

    if is_main:
        output.append(indent_str + "_cov.save()")

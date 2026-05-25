# reporter.py
import json
import html
import os
from instrumenter import is_executable_line

def compile_coverage_report(coverage_db_path: str, source_dir: str, output_html_dir: str):
    if not os.path.exists(coverage_db_path):
        print(f"❌ Error: Coverage database not found at {coverage_db_path}")
        return

    with open(coverage_db_path, "r", encoding="utf-8") as f:
        cov_data = json.load(f)

    # Resolve all files in source_dir
    src_files = []
    for root, _, files in os.walk(source_dir):
        for file in files:
            if file.endswith((".mojo", ".🔥")):
                src_files.append(os.path.join(root, file))

    summary_stats = {
        "total_statements": 0,
        "covered_statements": 0,
        "coverage_percentage": 0.0
    }
    
    file_reports = {}

    # Print terminal report header
    print("\n" + "=" * 80)
    print(f"%-50s %10s %10s %10s" % ("Mojo Source File", "Statements", "Covered", "Coverage"))
    print("-" * 80)

    for abs_path in sorted(src_files):
        # Determine relative path from project root (or from source_dir to make it clean)
        # In pi-mojo, we track files with their relative paths like "src/packages/ai/pi_ai_types.mojo"
        # Let's find the relative path of the file from the current working directory to match coverage database paths
        rel_path = os.path.relpath(abs_path)
        
        with open(abs_path, "r", encoding="utf-8") as f:
            lines = f.readlines()

        executable_lines = []
        for idx, line in enumerate(lines, 1):
            if is_executable_line(line):
                executable_lines.append(idx)

        # Get covered lines from JSON database (using exact relative path match)
        # Note: the JSON database might store paths under relative formats (e.g. "src/packages/...")
        # We try matching using rel_path, or the basename if relative path wasn't exact.
        covered_set = set()
        file_db_data = cov_data.get("files", {})
        
        # Search matching key
        matched_key = None
        for key in file_db_data.keys():
            if rel_path.endswith(key) or key.endswith(rel_path):
                matched_key = key
                break
                
        if matched_key:
            covered_set = set(file_db_data[matched_key].get("covered_lines", []))

        # Filter covered lines to only include lines that are actually executable
        covered_set = covered_set.intersection(set(executable_lines))

        total_exec = len(executable_lines)
        total_cov = len(covered_set)

        summary_stats["total_statements"] += total_exec
        summary_stats["covered_statements"] += total_cov

        pct = (total_cov / total_exec * 100) if total_exec else 100.0
        
        file_reports[rel_path] = {
            "abs_path": abs_path,
            "total_statements": total_exec,
            "covered_statements": total_cov,
            "coverage_percentage": pct,
            "executable_lines": executable_lines,
            "covered_lines": sorted(list(covered_set))
        }

        # Print terminal row
        print(f"%-50s %10d %10d %9.1f%%" % (rel_path[:50], total_exec, total_cov, pct))

    # Calculate overall summary percentage
    overall_total = summary_stats["total_statements"]
    overall_cov = summary_stats["covered_statements"]
    overall_pct = (overall_cov / overall_total * 100) if overall_total else 100.0
    summary_stats["coverage_percentage"] = overall_pct

    print("-" * 80)
    print(f"%-50s %10d %10d %9.1f%%" % ("TOTAL", overall_total, overall_cov, overall_pct))
    print("=" * 80 + "\n")

    # Compile the visual HTML Report Dashboard
    generate_html_dashboard(file_reports, summary_stats, output_html_dir)

def generate_html_dashboard(file_reports: dict, summary_stats: dict, output_dir: str):
    os.makedirs(output_dir, exist_ok=True)
    
    # Write files list dashboard first (index.html)
    index_html = []
    index_html.append("<!DOCTYPE html>")
    index_html.append("<html>")
    index_html.append("<head>")
    index_html.append("  <meta charset='utf-8'>")
    index_html.append("  <title>Mojo Code Coverage Dashboard</title>")
    index_html.append("  <link href='https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Fira+Code:wght@400;500&display=swap' rel='stylesheet'>")
    index_html.append("  <style>")
    index_html.append("""
        :root {
            --bg-primary: #0b0f19;
            --bg-secondary: #131b2e;
            --border-color: #1e293b;
            --text-primary: #f8fafc;
            --text-secondary: #94a3b8;
            --accent-color: #6366f1;
            --success-color: #10b981;
            --warning-color: #f59e0b;
            --danger-color: #ef4444;
        }
        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg-primary);
            color: var(--text-primary);
            margin: 0;
            padding: 40px;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 24px;
            margin-bottom: 30px;
        }
        h1 {
            margin: 0;
            font-size: 28px;
            font-weight: 700;
        }
        .badge {
            background: #1e1b4b;
            border: 1px solid #4338ca;
            color: #c7d2fe;
            padding: 6px 14px;
            border-radius: 9999px;
            font-size: 14px;
            font-weight: 500;
        }
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 20px;
            margin-bottom: 40px;
        }
        .stat-card {
            background: var(--bg-secondary);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 24px;
        }
        .stat-label {
            color: var(--text-secondary);
            font-size: 13px;
            font-weight: 500;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            margin-bottom: 8px;
        }
        .stat-value {
            font-size: 36px;
            font-weight: 700;
        }
        .stat-value.accent { color: var(--accent-color); }
        .stat-value.success { color: var(--success-color); }
        
        .progress-bar-container {
            width: 100%;
            height: 8px;
            background: #1e293b;
            border-radius: 4px;
            margin-top: 15px;
            overflow: hidden;
        }
        .progress-bar {
            height: 100%;
            border-radius: 4px;
            background: var(--success-color);
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
            background: var(--bg-secondary);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            overflow: hidden;
        }
        th, td {
            padding: 16px 20px;
            text-align: left;
            border-bottom: 1px solid var(--border-color);
        }
        th {
            background: #0f172a;
            color: var(--text-secondary);
            font-weight: 600;
            font-size: 13px;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        tr:last-child td {
            border-bottom: none;
        }
        tr:hover td {
            background: rgba(99, 102, 241, 0.05);
        }
        a {
            color: var(--text-primary);
            text-decoration: none;
            font-weight: 500;
        }
        a:hover {
            color: var(--accent-color);
        }
        .coverage-badge {
            padding: 4px 8px;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 600;
        }
        .coverage-badge.high { background: rgba(16, 185, 129, 0.15); color: #34d399; }
        .coverage-badge.medium { background: rgba(245, 158, 11, 0.15); color: #fbbf24; }
        .coverage-badge.low { background: rgba(239, 68, 68, 0.15); color: #f87171; }
    """)
    index_html.append("  </style>")
    index_html.append("</head>")
    index_html.append("<body>")
    index_html.append("  <div class='container'>")
    index_html.append("    <div class='header'>")
    index_html.append("      <h1>Mojo Code Coverage Dashboard</h1>")
    index_html.append("      <span class='badge'>mojo-test-cov</span>")
    index_html.append("    </div>")
    
    # Stats row
    pct = summary_stats["coverage_percentage"]
    color_class = "high" if pct >= 80 else ("medium" if pct >= 50 else "low")
    
    index_html.append("    <div class='stats-grid'>")
    index_html.append("      <div class='stat-card'>")
    index_html.append("        <div class='stat-label'>Total Executable Statements</div>")
    index_html.append(f"        <div class='stat-value accent'>{summary_stats['total_statements']}</div>")
    index_html.append("      </div>")
    index_html.append("      <div class='stat-card'>")
    index_html.append("        <div class='stat-label'>Covered Statements</div>")
    index_html.append(f"        <div class='stat-value success'>{summary_stats['covered_statements']}</div>")
    index_html.append("      </div>")
    index_html.append("      <div class='stat-card'>")
    index_html.append("        <div class='stat-label'>Overall Coverage</div>")
    index_html.append(f"        <div class='stat-value success'>{pct:.2f}%</div>")
    index_html.append("        <div class='progress-bar-container'>")
    index_html.append(f"          <div class='progress-bar' style='width: {pct}%;'></div>")
    index_html.append("        </div>")
    index_html.append("      </div>")
    index_html.append("    </div>")
    
    # Files table
    index_html.append("    <table>")
    index_html.append("      <thead>")
    index_html.append("        <tr>")
    index_html.append("          <th>Mojo Source File</th>")
    index_html.append("          <th>Statements</th>")
    index_html.append("          <th>Covered</th>")
    index_html.append("          <th>Coverage Rate</th>")
    index_html.append("        </tr>")
    index_html.append("      </thead>")
    index_html.append("      <tbody>")
    
    for rel_path, rep in sorted(file_reports.items()):
        file_pct = rep["coverage_percentage"]
        badge_cls = "high" if file_pct >= 80 else ("medium" if file_pct >= 50 else "low")
        safe_rel_path = rel_path.replace("/", "_") + ".html"
        
        index_html.append("        <tr>")
        index_html.append(f"          <td><a href='{safe_rel_path}'>{rel_path}</a></td>")
        index_html.append(f"          <td>{rep['total_statements']}</td>")
        index_html.append(f"          <td>{rep['covered_statements']}</td>")
        index_html.append(f"          <td><span class='coverage-badge {badge_cls}'>{file_pct:.2f}%</span></td>")
        index_html.append("        </tr>")
        
        # Generate individual file details page
        generate_file_details_page(rel_path, rep, output_dir)
        
    index_html.append("      </tbody>")
    index_html.append("    </table>")
    index_html.append("  </div>")
    index_html.append("</body>")
    index_html.append("</html>")
    
    with open(os.path.join(output_dir, "index.html"), "w", encoding="utf-8") as f:
        f.write("\n".join(index_html))

def generate_file_details_page(rel_path: str, report: dict, output_dir: str):
    abs_path = report["abs_path"]
    executable_lines = set(report["executable_lines"])
    covered_lines = set(report["covered_lines"])
    
    with open(abs_path, "r", encoding="utf-8") as f:
        lines = f.readlines()

    html_out = []
    html_out.append("<!DOCTYPE html>")
    html_out.append("<html>")
    html_out.append("<head>")
    html_out.append("  <meta charset='utf-8'>")
    html_out.append(f"  <title>{rel_path} - Mojo Code Coverage Detail</title>")
    html_out.append("  <link href='https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Fira+Code:wght@400;500&display=swap' rel='stylesheet'>")
    html_out.append("  <style>")
    html_out.append("""
        :root {
            --bg-primary: #0b0f19;
            --bg-secondary: #131b2e;
            --border-color: #1e293b;
            --text-primary: #f8fafc;
            --text-secondary: #94a3b8;
            --accent-color: #6366f1;
            --cov-green: rgba(16, 185, 129, 0.12);
            --cov-green-border: #10b981;
            --cov-red: rgba(239, 68, 68, 0.12);
            --cov-red-border: #ef4444;
        }
        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg-primary);
            color: var(--text-primary);
            margin: 0;
            padding: 40px;
        }
        .container {
            max-width: 1200px;
            margin: 0 auto;
        }
        .back-link {
            display: inline-flex;
            align-items: center;
            color: var(--text-secondary);
            font-size: 14px;
            font-weight: 500;
            margin-bottom: 20px;
            text-decoration: none;
        }
        .back-link:hover {
            color: var(--accent-color);
        }
        .card {
            background: var(--bg-secondary);
            border: 1px solid var(--border-color);
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 4px 6px -1px rgb(0 0 0 / 0.1);
        }
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid var(--border-color);
            padding-bottom: 20px;
            margin-bottom: 25px;
        }
        h1 {
            margin: 0;
            font-size: 22px;
            font-weight: 600;
        }
        h1 code {
            font-family: 'Fira Code', monospace;
            background: #0f172a;
            padding: 4px 8px;
            border-radius: 6px;
            font-size: 18px;
            border: 1px solid var(--border-color);
        }
        .pct-badge {
            background: rgba(16, 185, 129, 0.15);
            border: 1px solid #10b981;
            color: #34d399;
            padding: 6px 16px;
            border-radius: 9999px;
            font-weight: 700;
            font-size: 16px;
        }
        .pct-badge.medium {
            background: rgba(245, 158, 11, 0.15);
            border: 1px solid #f59e0b;
            color: #fbbf24;
        }
        .pct-badge.low {
            background: rgba(239, 68, 68, 0.15);
            border: 1px solid #ef4444;
            color: #f87171;
        }
        
        pre {
            font-family: 'Fira Code', monospace;
            font-size: 13.5px;
            line-height: 1.6;
            margin: 0;
            background: #070a13;
            border-radius: 8px;
            padding: 20px 0;
            overflow-x: auto;
            border: 1px solid var(--border-color);
        }
        .line {
            display: flex;
            width: 100%;
        }
        .num {
            width: 60px;
            text-align: right;
            padding-right: 20px;
            color: #334155;
            user-select: none;
            border-right: 1px solid #1e293b;
        }
        .code {
            flex-grow: 1;
            padding-left: 20px;
            white-space: pre;
        }
        .line.covered {
            background-color: var(--cov-green);
            border-left: 4px solid var(--cov-green-border);
        }
        .line.covered .num {
            color: var(--cov-green-border);
        }
        .line.uncovered {
            background-color: var(--cov-red);
            border-left: 4px solid var(--cov-red-border);
        }
        .line.uncovered .num {
            color: var(--cov-red-border);
        }
    """)
    html_out.append("  </style>")
    html_out.append("</head>")
    html_out.append("<body>")
    html_out.append("  <div class='container'>")
    html_out.append("    <a href='index.html' class='back-link'>← Back to Dashboard</a>")
    html_out.append("    <div class='card'>")
    
    file_pct = report["coverage_percentage"]
    badge_cls = ""
    if file_pct < 50:
        badge_cls = "low"
    elif file_pct < 80:
        badge_cls = "medium"
        
    html_out.append("      <div class='header'>")
    html_out.append(f"        <h1>File Detail: <code>{rel_path}</code></h1>")
    html_out.append(f"        <span class='pct-badge {badge_cls}'>{file_pct:.2f}%</span>")
    html_out.append("      </div>")
    
    html_out.append("      <pre>")
    for idx, line in enumerate(lines, 1):
        is_exec = idx in executable_lines
        is_covered = idx in covered_lines
        
        cls = "line"
        if is_exec:
            cls += " covered" if is_covered else " uncovered"
            
        escaped_code = html.escape(line.rstrip('\n'))
        html_out.append(f"        <div class='{cls}'><span class='num'>{idx}</span><span class='code'>{escaped_code}</span></div>")
        
    html_out.append("      </pre>")
    html_out.append("    </div>")
    html_out.append("  </div>")
    html_out.append("</body>")
    html_out.append("</html>")
    
    safe_rel_path = rel_path.replace("/", "_") + ".html"
    with open(os.path.join(output_dir, safe_rel_path), "w", encoding="utf-8") as f:
        f.write("\n".join(html_out))

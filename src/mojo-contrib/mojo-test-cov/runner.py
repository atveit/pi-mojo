# runner.py
import argparse
import os
import shutil
import subprocess
import sys
from instrumenter import instrument_file
from reporter import compile_coverage_report

def main():
    parser = argparse.ArgumentParser(description="Mojo Test Coverage Tool (mojo-test-cov)")
    parser.add_argument("--source", default="src/packages", help="Directory of packages to measure coverage on")
    parser.add_argument("--test", default="tests/test_packages.mojo", help="Test file or suite to execute")
    parser.add_argument("--output-dir", default="coverage_html", help="Directory for HTML coverage reports")
    args = parser.parse_args()

    work_dir = ".mojo_cov_work"
    print("🧹 Cleaning up old workspace...")
    if os.path.exists(work_dir):
        shutil.rmtree(work_dir)
    os.makedirs(work_dir)

    print("📁 Mirroring project workspace...")
    ignore_folders = {".git", ".pixi", ".mojo_cov_work", "coverage_html", "build", "src/mojo-contrib/mojo-test-cov"}
    
    # Mirror directory tree and files
    for root, dirs, files in os.walk("."):
        dirs[:] = [d for d in dirs if os.path.join(root, d).replace("./", "") not in ignore_folders and d not in ignore_folders]
        
        for file in files:
            src_path = os.path.join(root, file)
            parts = src_path.split(os.sep)
            if any(p in ignore_folders for p in parts):
                continue
                
            dest_path = os.path.join(work_dir, src_path)
            os.makedirs(os.path.dirname(dest_path), exist_ok=True)
            shutil.copy2(src_path, dest_path)

    # Copy cov_tracker.py and mojo_cov.mojo
    contrib_dir = "src/mojo-contrib/mojo-test-cov"
    for file in ["cov_tracker.py", "mojo_cov.mojo"]:
        shutil.copy2(os.path.join(contrib_dir, file), os.path.join(work_dir, file))
        shutil.copy2(os.path.join(contrib_dir, file), os.path.join(work_dir, "src", file))

    print("🪄 Instrumenting source files in:", args.source)
    src_target = os.path.join(work_dir, args.source)
    for root, _, files in os.walk(src_target):
        for file in files:
            if file.endswith((".mojo", ".🔥")):
                abs_path = os.path.join(root, file)
                rel_path = os.path.relpath(abs_path, work_dir)
                temp_path = abs_path + ".tmp"
                instrument_file(abs_path, temp_path, rel_path)
                os.replace(temp_path, abs_path)

    print("🪄 Instrumenting test files recursively in: tests/")
    test_dir_target = os.path.join(work_dir, "tests")
    if os.path.exists(test_dir_target):
        for root, _, files in os.walk(test_dir_target):
            for file in files:
                if file.endswith((".mojo", ".🔥")):
                    abs_path = os.path.join(root, file)
                    rel_path = os.path.relpath(abs_path, work_dir)
                    temp_path = abs_path + ".tmp"
                    instrument_file(abs_path, temp_path, rel_path)
                    os.replace(temp_path, abs_path)

    print("\n🚀 Launching tests under instrumented workspace...")
    test_rel_path = os.path.relpath(os.path.join(work_dir, args.test), work_dir)
    cmd = ["mojo", "run", "-I", "src", test_rel_path]
    print(f"Running command: {' '.join(cmd)} inside {work_dir}")
    
    try:
        res = subprocess.run(cmd, cwd=work_dir)
        if res.returncode != 0:
            print(f"⚠️ Warning: Tests failed or returned non-zero code {res.returncode}")
    except Exception as e:
        print(f"❌ Error launching test subprocess: {e}")
        return

    db_path = os.path.join(work_dir, ".coverage_mojo.json")
    if not os.path.exists(db_path):
        print("❌ Error: Coverage database was not generated. Check if the test ran and exited main correctly.")
        return

    print("📊 Compilation and analysis of results...")
    compile_coverage_report(db_path, args.source, args.output_dir)
    
    print(f"✨ Coverage verification complete. Dashboards generated in: {args.output_dir}")

if __name__ == "__main__":
    main()

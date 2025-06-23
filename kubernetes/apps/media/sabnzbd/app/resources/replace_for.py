#!/usr/bin/env python3 -OO

"""
SABnzbd - Replace underscores with dots in filenames

Install:
1. Copy script to SABnzbd's script folder
2. Run: chmod +x replace_for.py
3. In SABnzbd, go to Config > Categories
4. Assign replace_for.py to the desired category
"""

import sys
from pathlib import Path


def main():
    try:
        (
            scriptname,
            directory,
            orgnzbname,
            jobname,
            reportnumber,
            category,
            group,
            postprocstatus,
            url,
        ) = sys.argv
    except ValueError:
        print("No command-line parameters found.")
        sys.exit(1)

    target_dir = Path(directory)

    if not target_dir.is_dir():
        print(f"Directory not found: {directory}")
        sys.exit(1)

    for src_path in target_dir.iterdir():
        if "_" in src_path.name:
            dst_path = src_path.with_name(src_path.name.replace("_", "."))
            try:
                src_path.rename(dst_path)
                print(f"{src_path.name} renamed to {dst_path.name}")
            except Exception as e:
                print(f"Failed to rename {src_path.name}: {e}")

    sys.exit(0)


if __name__ == "__main__":
    main()

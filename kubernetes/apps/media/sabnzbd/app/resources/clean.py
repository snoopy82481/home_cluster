#!/usr/bin/python3 -OO

"""
SABnzbd - Clean NZB Renamer
---------------------------
Removes common suffixes from NZB names added by bots.

Install:
1. Copy script to SABnzbd's script folder
2. Run: sudo chmod +x Clean.py
3. In SABnzbd: Config > Switches > Pre-queue user script > Select Clean.py
"""

import re
import sys


def clean_nzb_name(name: str) -> str:
    patterns = [
        r"(?i)-4P$",
        r"(?i)-4Planet$",
        r"(?i)-AlternativeToRequested$",
        r"(?i)-AlteZachen$",
        r"(?i)-AsRequested(-xpost)?$",
        r"(?i)-BUYMORE$",
        r"(?i)-Chamele0n$",
        r"(?i)-GEROV$",
        r"(?i)-iNC0GNiTO$",
        r"(?i)-NZBGeek$",
        r"(?i)-Obfuscated$",
        r"(?i)-Obfuscation$",
        r"(?i)-postbot$",
        r"(?i)-Rakuv[a-z0-9]*$",
        r"(?i)-RePACKPOST$",
        r"(?i)-Scrambled$",
        r"(?i)-WhiteRev$",
        r"(?i)-WRTEAM$",
        r"(?i)-CAPTCHA$",
        r"(?i)-Z0iDS3N$",
        r"(?i)\[eztv([ ._-]re)?\]$",
        r"(?i)\[TGx\](-xpost)?$",
        r"(?i)\[ettv\]$",
        r"(?i)\.mkv-xpost$",
        r"(?i)-xpost$",
        r"(?i)(-D-Z0N3|\-[^-.\n]*)(\-.{4})?$",  # Advanced obfuscation removal
    ]

    for pattern in patterns:
        name = re.sub(pattern, "", name)

    return name


def main():
    sys.argv = sys.argv[:9]
    try:
        _, nzbname, *_ = sys.argv
    except ValueError:
        sys.exit(1)  # Abort silently if args are invalid

    cleaned_name = clean_nzb_name(nzbname)

    # SABnzbd expects specific output:
    print("1")  # Accept the job
    print(cleaned_name)  # New NZB name
    print("\n" * 5)  # Required empty lines

    sys.exit(0)


if __name__ == "__main__":
    main()

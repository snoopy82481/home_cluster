from __future__ import annotations

import re

from scripts.enrich.logging_config import log
from scripts.enrich.special_class import RenovateDep
from scripts.enrich.utils import http_get


def provider(dep: RenovateDep) -> str:
    new_ver = dep["newVersion"]
    old_ver = dep["currentVersion"]

    log.info(f"Kubernetes provider handling {new_ver}")

    m = re.match(r"v?(\d+)\.(\d+)\.(\d+)", new_ver)
    if not m:
        log.error(f"Invalid Kubernetes version: {new_ver}")
        return ""

    major, minor, _ = m.groups()
    minor_file = f"{major}.{minor}"

    url = (
        "https://raw.githubusercontent.com/kubernetes/kubernetes/master/"
        f"CHANGELOG/CHANGELOG-{minor_file}.md"
    )

    text = http_get(url)
    lines = text.splitlines()

    header_target = f"# {new_ver}"
    since_target = f"## Changelog since {old_ver}"

    in_version_block = False
    in_section = False
    out: list[str] = []

    for line in lines:
        if line.strip() == header_target:
            in_version_block = True
            continue

        if in_version_block and line.strip() == since_target:
            in_section = True
            continue

        if in_section:
            if re.match(r"# v?\d+\.\d+\.\d+", line.strip()):
                break
            out.append(line)

    return "\n".join(out).strip()

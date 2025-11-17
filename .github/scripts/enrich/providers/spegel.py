from __future__ import annotations

import re

from scripts.enrich.logging import log
from scripts.enrich.types import RenovateDep
from scripts.enrich.utils import extract_version_block, http_get


def spegel_header(line: str) -> str | None:
    m = re.match(r"^#{1,6}\s*\[*v?(\d+\.\d+\.\d+)\]*", line)
    return m.group(1) if m else None


def provider(dep: RenovateDep) -> str:
    version = dep["newVersion"]

    log.info(f"Spegel provider handling {version}")

    url = (
        "https://raw.githubusercontent.com/spegel-org/spegel/"
        "refs/heads/main/CHANGELOG.md"
    )
    text = http_get(url)

    return extract_version_block(
        text=text,
        target_version=version,
        header_matcher=spegel_header,
        strip_leading_v=True,
    )

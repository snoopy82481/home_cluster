from __future__ import annotations

import re

from scripts.enrich.logging import log
from scripts.enrich.special_class import RenovateDep
from scripts.enrich.utils import extract_version_block, http_get


def cloudflared_header(line: str) -> str | None:
    line = line.strip()
    return line if re.match(r"^\d+\.\d+\.\d+", line) else None


def provider(dep: RenovateDep) -> str:
    version = dep["newVersion"]

    log.info(f"Cloudflared provider handling {version}")

    url = (
        "https://raw.githubusercontent.com/cloudflare/cloudflared/master/RELEASE_NOTES"
    )

    text = http_get(url)

    return extract_version_block(
        text=text,
        target_version=version,
        header_matcher=cloudflared_header,
        strip_leading_v=False,
    )

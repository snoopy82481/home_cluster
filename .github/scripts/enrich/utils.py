from __future__ import annotations

import requests

from .logging_config import log


def http_get(url: str) -> str:
    log.debug(f"GET {url}")
    r = requests.get(url, timeout=15)
    r.raise_for_status()
    return r.text


def extract_version_block(
    text: str,
    target_version: str,
    header_matcher,
    *,
    strip_leading_v: bool = False,
) -> str:
    version_key = target_version.lstrip("v") if strip_leading_v else target_version

    lines = text.splitlines()
    in_block = False
    out: list[str] = []

    for line in lines:
        found = header_matcher(line)

        if found == version_key:
            in_block = True
            continue

        if in_block and found:
            break

        if in_block:
            out.append(line)

    return "\n".join(out).strip()

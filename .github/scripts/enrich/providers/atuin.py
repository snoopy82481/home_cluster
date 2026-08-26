from __future__ import annotations

import re

from ..logging_config import log
from ..special_class import RenovateDep
from ..utils import extract_version_block, http_get


def atuin_header(line: str) -> str | None:
    match = re.match(r"^##\s+v?(\d+\.\d+\.\d+)\s*$", line)
    return match.group(1) if match else None


def provider(dep: RenovateDep) -> str:
    version = dep["newVersion"]

    log.info(f"Atuin provider handling {version}")

    text = http_get(
        "https://raw.githubusercontent.com/atuinsh/atuin/"
        "refs/heads/main/CHANGELOG.md"
    )

    return extract_version_block(
        text=text,
        target_version=version,
        header_matcher=atuin_header,
        strip_leading_v=True,
    )

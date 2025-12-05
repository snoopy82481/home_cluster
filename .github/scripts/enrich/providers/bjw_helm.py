from __future__ import annotations

import re

import yaml

from ..logging_config import log
from ..special_class import ChangeEntry, RenovateDep
from ..utils import http_get


def provider(dep: RenovateDep) -> str:
    version = dep["newVersion"]

    log.info(f"bjw-s-labs Helm provider handling {version}")

    url = (
        "https://raw.githubusercontent.com/bjw-s-labs/helm-charts/"
        "main/charts/library/common/Chart.yaml"
    )
    chart = http_get(url)
    data = yaml.safe_load(chart)

    changes_yaml = data.get("annotations", {}).get("artifacthub.io/changes")
    if not changes_yaml:
        return "No ArtifactHub change annotations present."

    changes: list[ChangeEntry] = yaml.safe_load(changes_yaml)

    buckets: dict[str, list[str]] = {
        "breaking": [],
        "added": [],
        "fixed": [],
        "changed": [],
        "removed": [],
    }

    for entry in changes:
        desc = entry["description"]
        kind = entry["kind"]

        if "**Breaking**" in desc:
            kind = "breaking"
            desc = re.sub(r"\*\*Breaking\*\*\s*:?", "", desc).strip()

        links = entry.get("links")
        link_md = ""
        if links is not None:
            link_md = "\n".join(
                f"  - [{link['name']}]({link['url']})" for link in links
            )

        md = f"- {desc}"
        if link_md:
            md += f"\n{link_md}"

        buckets.setdefault(kind, []).append(md)

    sections = [
        f"### {k.capitalize()}\n" + "\n".join(v) for k, v in buckets.items() if v
    ]

    return "\n\n".join(sections)

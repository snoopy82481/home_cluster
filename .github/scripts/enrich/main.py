from __future__ import annotations

import json
import os
import re

import requests
from scripts.enrich.logging import log
from scripts.enrich.registry import PROVIDERS
from scripts.enrich.special_class import RenovateDep


def fetch_pr_body(pr_number: str) -> str:
    log.info(f"Fetching PR body for #{pr_number}")

    repo = os.getenv("GITHUB_REPOSITORY")
    token = os.getenv("GH_APP_TOKEN")

    url = f"https://api.github.com/repos/{repo}/pulls/{pr_number}"

    headers = {
        "Authorization": f"Bearer {token}",
        "Accept": "application/vnd.github+json",
    }

    r = requests.get(url, headers=headers)
    r.raise_for_status()
    return r.json()["body"]


def extract_metadata(pr_body: str) -> RenovateDep | None:
    m = re.search(r"```json(.*?)```", pr_body, re.S)
    if not m:
        log.warning("No Renovate metadata found")
        return None
    data = json.loads(m.group(1))
    return data["deps"][0]


def rewrite_body(old_body: str, notes: str, version: str) -> str:
    if "[Compare Source]" not in old_body:
        return old_body

    top, _ = old_body.split("[Compare Source]", 1)
    top += "[Compare Source]"

    return f"{top}\n\n### v{version} changelog\n\n{notes}\n\n</details>"


if __name__ == "__main__":
    pr_number = os.getenv("PR_NUMBER")
    if not pr_number:
        raise SystemExit("PR_NUMBER environment variable missing")

    body = fetch_pr_body(pr_number)
    dep = extract_metadata(body)

    if not dep:
        print(body)
        raise SystemExit(0)

    pkg = dep["packageName"]

    provider = PROVIDERS.get(pkg)
    if not provider:
        log.warning(f"No provider for {pkg}")
        print(body)
        raise SystemExit(0)

    notes = provider(dep)
    new_body = rewrite_body(body, notes, dep["newVersion"])

    print(new_body)

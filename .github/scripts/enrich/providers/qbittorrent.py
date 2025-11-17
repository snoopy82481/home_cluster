from __future__ import annotations

from bs4 import BeautifulSoup
from scripts.enrich.logging import log
from scripts.enrich.special_class import RenovateDep
from scripts.enrich.utils import http_get


def provider(dep: RenovateDep) -> str:
    version = dep["newVersion"]
    version_norm = version.lstrip("v")

    log.info(f"qBittorrent provider handling {version}")

    html = http_get("https://www.qbittorrent.org/news")
    soup = BeautifulSoup(html, "html.parser")

    ul = None
    for h3 in soup.find_all("h3"):
        if f"v{version_norm} release" in h3.get_text():
            ul = h3.find_next_sibling("ul")
            break

    if not ul:
        return ""

    out: list[str] = []
    for li in ul.find_all("li"):
        link = li.find("a")
        if link:
            out.append(f"- [{link.text.strip()}]({link['href']})")
        else:
            out.append(f"- {li.get_text(strip=True)}")

    return "\n".join(out).strip()

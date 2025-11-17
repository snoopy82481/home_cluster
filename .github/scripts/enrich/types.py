from __future__ import annotations

from typing import Protocol, TypedDict


class LinkEntry(TypedDict):
    name: str
    url: str


class ChangeEntry(TypedDict):
    kind: str
    description: str
    links: list[LinkEntry] | None


class RenovateDep(TypedDict):
    depName: str
    packageName: str
    manager: str
    datasource: str
    currentVersion: str
    newVersion: str
    registryUrl: str | None


class Provider(Protocol):
    def __call__(self, dep: RenovateDep) -> str: ...

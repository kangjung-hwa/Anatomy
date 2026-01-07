#!/usr/bin/env python3
"""Lint relations in anatomy_3d_index.json for missing or duplicate IDs."""

from __future__ import annotations

import json
import sys
from pathlib import Path
from typing import Iterable, List, Set


def load_json(path: Path) -> dict:
    with path.open("r", encoding="utf-8") as handle:
        return json.load(handle)


def gather_relation_ids(relations: dict) -> Iterable[str]:
    for key in ("origin", "insertion", "innervated_by", "supplied_by", "adjacent_to"):
        values = relations.get(key) if relations else None
        if not values:
            continue
        for value in values:
            yield value


def main() -> int:
    bundle_path = Path("data/bundles/anatomy_3d_index.json")
    if not bundle_path.exists():
        print("anatomy_3d_index.json not found.")
        return 1

    data = load_json(bundle_path)
    entities: List[dict] = data.get("entities", [])
    ids: List[str] = [entity.get("id", "") for entity in entities]
    id_set: Set[str] = set(ids)

    duplicates = sorted({item for item in ids if ids.count(item) > 1 and item})
    missing: Set[str] = set()

    for entity in entities:
        rel = entity.get("relations")
        for ref in gather_relation_ids(rel):
            if ref not in id_set:
                missing.add(ref)

    if duplicates:
        print("❌ Duplicate IDs found:")
        for dup in duplicates:
            print(f"  - {dup}")

    if missing:
        print("❌ Missing referenced IDs:")
        for ref in sorted(missing):
            print(f"  - {ref}")

    if not duplicates and not missing:
        print("✅ anatomy_3d_index relations look consistent.")
        return 0

    return 1


if __name__ == "__main__":
    sys.exit(main())

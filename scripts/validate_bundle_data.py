#!/usr/bin/env python3
"""Validate bundled JSON content against a JSON Schema.

The script scans a directory for ``.json`` files and validates them against a
provided schema. It emits a summary report and writes the detailed results to
``bundle-validation-report.txt`` for CI artifacts.
"""

import argparse
import json
import sys
from pathlib import Path
from typing import Iterable, List, Tuple

from jsonschema import Draft202012Validator


def load_json(path: Path) -> object:
    """Load a JSON file using UTF-8 encoding."""
    with path.open("r", encoding="utf-8") as handle:
        return json.load(handle)


def iter_json_files(root: Path) -> Iterable[Path]:
    """Yield JSON files under the provided directory, sorted for stability."""
    if not root.exists():
        return []
    return sorted(path for path in root.rglob("*.json") if path.is_file())


def validate_documents(schema_path: Path, data_root: Path) -> Tuple[List[str], int]:
    """Validate all JSON documents and return (messages, error_count)."""
    schema = load_json(schema_path)
    validator = Draft202012Validator(schema)

    messages: List[str] = []
    error_count = 0

    for document_path in iter_json_files(data_root):
        document = load_json(document_path)
        errors = sorted(validator.iter_errors(document), key=lambda e: e.path)
        if not errors:
            messages.append(f"✔️  {document_path}: valid")
            continue

        error_count += len(errors)
        messages.append(f"❌ {document_path}:")
        for issue in errors:
            location = "" if not issue.path else f" at $.{'/'.join(map(str, issue.path))}"
            messages.append(f"   • {issue.message}{location}")

    if not messages:
        messages.append("⚠️  No JSON files found to validate.")

    return messages, error_count


def main(argv: Iterable[str]) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--schema",
        type=Path,
        required=True,
        help="Path to the JSON schema file",
    )
    parser.add_argument(
        "--data",
        type=Path,
        required=True,
        help="Path to the directory containing bundled JSON files",
    )

    args = parser.parse_args(list(argv))

    messages, error_count = validate_documents(args.schema, args.data)

    report_path = Path("bundle-validation-report.txt")
    report_path.write_text("\n".join(messages), encoding="utf-8")

    for message in messages:
        print(message)

    return 0 if error_count == 0 else 1


if __name__ == "__main__":
    sys.exit(main(sys.argv[1:]))

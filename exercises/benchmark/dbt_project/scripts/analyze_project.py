#!/usr/bin/env python3
"""Analyze a dbt project and output a compact JSON summary.

This script parses the dbt project structure — config, sources, models,
macros, and conventions — and outputs a single JSON object to stdout.
It gives Claude all the context it needs in one compact payload.
"""

import json
import re
import sys
from pathlib import Path

import yaml


def find_project_root():
    """Find the dbt project root by looking for dbt_project.yml."""
    current = Path(__file__).resolve().parent.parent
    if (current / "dbt_project.yml").exists():
        return current
    # fallback: cwd
    if (Path.cwd() / "dbt_project.yml").exists():
        return Path.cwd()
    print("Error: Could not find dbt_project.yml", file=sys.stderr)
    sys.exit(1)


def parse_project_config(root: Path) -> dict:
    """Parse dbt_project.yml for project metadata."""
    with open(root / "dbt_project.yml") as f:
        config = yaml.safe_load(f)
    return {
        "project_name": config.get("name", "unknown"),
        "profile": config.get("profile", "unknown"),
    }


def parse_sources(root: Path) -> list:
    """Parse sources.yml for source definitions."""
    sources_file = root / "models" / "sources.yml"
    if not sources_file.exists():
        return []

    with open(sources_file) as f:
        data = yaml.safe_load(f)

    sources = []
    for source in data.get("sources", []):
        tables = [t["name"] for t in source.get("tables", [])]
        sources.append({"name": source["name"], "tables": tables})
    return sources


def extract_columns_from_sql(sql_text: str) -> list:
    """Extract column names from the final SELECT in a SQL file.

    Looks for the last 'select ... from final' pattern and extracts
    column names. Falls back to extracting from the last CTE's SELECT.
    """
    # Find all SELECT blocks
    select_blocks = re.findall(
        r"select\s+(.*?)\s+from", sql_text, re.DOTALL | re.IGNORECASE
    )
    if not select_blocks:
        return []

    # Use the last meaningful select (skip 'select * from final')
    for block in reversed(select_blocks):
        block = block.strip()
        if block == "*":
            continue
        # Parse column names from the select list
        columns = []
        for line in block.split(","):
            line = line.strip()
            if not line:
                continue
            # Handle 'expression as alias' patterns
            alias_match = re.search(r"\bas\s+(\w+)\s*$", line, re.IGNORECASE)
            if alias_match:
                columns.append(alias_match.group(1))
            else:
                # Handle 'table.column' or plain 'column'
                col = line.split(".")[-1].strip()
                # Remove any trailing comments
                col = col.split("--")[0].strip()
                if col and re.match(r"^\w+$", col):
                    columns.append(col)
        if columns:
            return columns

    return []


def detect_cte_pattern(sql_text: str) -> list:
    """Detect CTE names used in a SQL file."""
    cte_names = re.findall(
        r"(\w+)\s+as\s*\(", sql_text, re.IGNORECASE
    )
    return cte_names


def scan_models(root: Path) -> dict:
    """Scan model SQL files and extract metadata."""
    models_dir = root / "models"
    result = {"staging": [], "marts": []}

    for category in ["staging", "marts"]:
        category_dir = models_dir / category
        if not category_dir.exists():
            continue
        for sql_file in sorted(category_dir.glob("*.sql")):
            sql_text = sql_file.read_text()
            columns = extract_columns_from_sql(sql_text)
            cte_pattern = detect_cte_pattern(sql_text)

            # Detect materialization from dbt_project.yml config
            materialized = "view" if category == "staging" else "table"

            result[category].append({
                "name": sql_file.stem,
                "materialized": materialized,
                "columns": columns,
                "cte_flow": " -> ".join(cte_pattern) if cte_pattern else None,
            })

    return result


def scan_macros(root: Path) -> list:
    """List available macros."""
    macros_dir = root / "macros"
    if not macros_dir.exists():
        return []
    macros = []
    for sql_file in sorted(macros_dir.glob("*.sql")):
        sql_text = sql_file.read_text()
        macro_names = re.findall(
            r"{%[-\s]*macro\s+(\w+)", sql_text
        )
        macros.extend(macro_names)
    return macros


def detect_conventions(models: dict, macros: list) -> dict:
    """Detect naming and structural conventions from existing models."""
    staging_names = []
    mart_names = []
    cte_flows = set()
    all_columns = []

    for category_name, category_models in models.items():
        for model in category_models:
            if category_name == "staging":
                staging_names.append(model["name"])
            elif category_name == "marts":
                mart_names.append(model["name"])
            if model.get("cte_flow"):
                cte_flows.add(model["cte_flow"])
            all_columns.extend(model.get("columns", []))

    stg_prefix = all(n.startswith("stg_") for n in staging_names) if staging_names else False
    mart_prefix = all(n.startswith("mart_") for n in mart_names) if mart_names else False
    snake_case = all(re.match(r"^[a-z][a-z0-9_]*$", c) for c in all_columns) if all_columns else False

    naming_parts = []
    if snake_case:
        naming_parts.append("snake_case")
    if stg_prefix:
        naming_parts.append("stg_ prefix for staging")
    if mart_prefix:
        naming_parts.append("mart_ prefix for marts")

    conventions = {
        "naming": ", ".join(naming_parts) if naming_parts else "no consistent pattern detected",
        "cte_pattern": ", ".join(sorted(cte_flows)) if cte_flows else "no consistent pattern detected",
    }

    if "cents_to_dollars" in macros:
        conventions["monetary"] = "cents stored as integers, cents_to_dollars() macro for conversion"

    return conventions


def main():
    root = find_project_root()
    config = parse_project_config(root)
    sources = parse_sources(root)
    models = scan_models(root)
    macros = scan_macros(root)
    conventions = detect_conventions(models, macros)

    output = {
        "project_name": config["project_name"],
        "profile": config["profile"],
        "sources": sources,
        "models": models,
        "macros": macros,
        "conventions": conventions,
    }

    json.dump(output, sys.stdout)
    print()  # trailing newline


if __name__ == "__main__":
    main()

#!/usr/bin/env python3
"""Validate the framework template or a populated client instance."""

from __future__ import annotations

import argparse
import re
import sys
from pathlib import Path
from typing import Any

try:
    import yaml
except ImportError:  # pragma: no cover
    yaml = None

DEFAULT_ROOT = Path(__file__).resolve().parents[1]
REQUIRED = [
    "README.md", "AGENTS.md", "client.config.yaml", ".env.example",
    "schemas/client.config.schema.json", "onboarding/descubrimiento-sistemico.md",
    "dominios/comercial/eventos.md", "metricas/contracts/metric.template.yaml",
    "experimentos/experiment.template.yaml", "experimentos/asignacion-deterministica.md",
    "integraciones/contracts/integration.template.yaml", "sops/confianza-evidencia.md",
    "sops/limites-de-operacion.md", "sops/incidentes-y-bugs.md", "sops/gates.yaml", "sops/calidad-de-datos.yaml",
    "skills/instalar-sistema-cliente/SKILL.md", "skills/diagnosticar-sistema-comercial/SKILL.md",
    "skills/operar-kaizen-comercial/SKILL.md", "skills/validar-instancia/SKILL.md", "skills/reconciliar-fuentes/SKILL.md", "skills/registrar-incidente/SKILL.md",
    "agentes/README.md", "agentes/agent.template.yaml", "agentes/eval.template.yaml",
    "infraestructura/supabase/05-comercial.sql", "infraestructura/supabase/06-migracion-comercial-v2.sql",
]
SECRET_PATTERNS = [
    ("OpenAI", re.compile(r"sk-[A-Za-z0-9_-]{20,}")),
    ("GitHub", re.compile(r"gh[pousr]_[A-Za-z0-9]{20,}")),
    ("AWS", re.compile(r"AKIA[0-9A-Z]{16}")),
    ("JWT", re.compile(r"eyJ[A-Za-z0-9_-]{20,}\.[A-Za-z0-9_-]{20,}")),
    ("Notion", re.compile(r"ntn_[A-Za-z0-9]{20,}|secret_[A-Za-z0-9]{20,}")),
]
GATE_ENFORCERS = {
    "minimum_metric_coverage": "metricas/contracts/metric.template.yaml",
    "coverage_evaluated_by_segment": "sops/confianza-evidencia.md",
    "show_not_measurable_when_incomplete": "sops/confianza-evidencia.md",
    "require_control_arm_for_experiments": "experimentos/asignacion-deterministica.md",
    "track_deployment_debt": "sops/limites-de-operacion.md",
    "track_external_blockers": "sops/limites-de-operacion.md",
}
SQL_INVARIANTS = {
    "infraestructura/supabase/05-comercial.sql": [
        ("unique (fuente_sistema, fuente_evento_id)", "idempotencia del ledger"),
        ("subject_type", "el evento no depende de una oportunidad"),
        ("evento_valor_con_confianza", "valor con confianza declarada"),
        ("compensa_evento_id", "corrección append-only"),
        ("clave_idempotencia", "actividad sin duplicados"),
        ("asignacion_experimento", "brazo de control reconstruible"),
        ("segmento", "calidad por rama"),
    ],
}
PLACEHOLDER = re.compile(r"\[[^\]\n]{3,}\]")
INSTANCE_PATHS = {
    "client.id": ("client", "id"), "client.name": ("client", "name"), "client.owner": ("client", "owner"),
    "business.model": ("business", "model"), "business.icp": ("business", "icp"), "business.offer": ("business", "offer"),
    "business.north_star_metric": ("business", "north_star_metric"), "business.revenue_event": ("business", "revenue_event"),
    "adoption_budget.operator_role": ("adoption_budget", "operator_role"), "adoption_budget.measured_by": ("adoption_budget", "measured_by"),
}

def read_yaml(path: Path, errors: list[str]) -> dict[str, Any]:
    if yaml is None:
        errors.append("falta PyYAML: instala requirements-dev.txt")
        return {}
    try:
        data = yaml.safe_load(path.read_text(encoding="utf-8"))
    except (OSError, yaml.YAMLError) as exc:
        errors.append(f"YAML inválido en {path.name}: {exc}")
        return {}
    if not isinstance(data, dict):
        errors.append(f"{path.name}: la raíz debe ser un objeto YAML")
        return {}
    return data

def get_path(data: dict[str, Any], path: tuple[str, ...]) -> Any:
    value: Any = data
    for key in path:
        if not isinstance(value, dict) or key not in value:
            return None
        value = value[key]
    return value

def walk_strings(value: Any, prefix: str = ""):
    if isinstance(value, dict):
        for key, child in value.items():
            yield from walk_strings(child, f"{prefix}.{key}" if prefix else str(key))
    elif isinstance(value, list):
        for index, child in enumerate(value):
            yield from walk_strings(child, f"{prefix}[{index}]")
    elif isinstance(value, str):
        yield prefix, value

def strip_sql_comments(sql: str) -> str:
    sql = re.sub(r"--[^\n]*", "", sql)
    return re.sub(r"/\*.*?\*/", "", sql, flags=re.S).lower()

def validate_structure(root: Path, errors: list[str]) -> None:
    for relative in REQUIRED:
        if not (root / relative).is_file():
            errors.append(f"falta: {relative}")
    for skill in sorted((root / "skills").glob("*/SKILL.md")):
        text = skill.read_text(encoding="utf-8")
        if not text.startswith("---\n") or "\nname:" not in text or "\ndescription:" not in text:
            errors.append(f"frontmatter inválido: {skill.relative_to(root)}")

def validate_config(root: Path, errors: list[str], instance: bool) -> dict[str, Any]:
    config = read_yaml(root / "client.config.yaml", errors)
    required = {"schema_version", "client", "business", "domains", "sources", "integrations", "governance", "adoption_budget", "operating_cadence", "quality_gates", "security"}
    errors.extend(f"client.config.yaml: falta la sección '{key}'" for key in sorted(required - set(config)))
    for label, path in INSTANCE_PATHS.items():
        value = get_path(config, path)
        if instance and (not isinstance(value, str) or not value.strip() or PLACEHOLDER.search(value)):
            errors.append(f"client.config.yaml sin llenar: {label}")
    if instance and get_path(config, ("business", "current_constraint")) in (None, "", "unknown"):
        errors.append("client.config.yaml: current_constraint sigue sin diagnóstico")
    budget = get_path(config, ("adoption_budget", "max_daily_actions"))
    if budget is not None and (not isinstance(budget, int) or budget < 1):
        errors.append("client.config.yaml: max_daily_actions debe ser entero positivo")
    coverage = get_path(config, ("quality_gates", "minimum_metric_coverage"))
    if coverage is not None and (not isinstance(coverage, (int, float)) or not 0 <= coverage <= 1):
        errors.append("client.config.yaml: minimum_metric_coverage debe estar entre 0 y 1")
    domains = config.get("domains", {})
    if not isinstance(domains, dict) or any(not isinstance(v, bool) for v in domains.values()):
        errors.append("client.config.yaml: domains debe contener solo booleanos")
    for section in ("sources", "integrations"):
        items = config.get(section, [])
        if not isinstance(items, list):
            errors.append(f"client.config.yaml: {section} debe ser una lista")
            continue
        ids = [item.get("id") for item in items if isinstance(item, dict)]
        if len(ids) != len(set(ids)):
            errors.append(f"client.config.yaml: ids duplicados en {section}")
    if instance and not [p for p in (root / "metricas/contracts").glob("*.yaml") if p.name != "metric.template.yaml"]:
        errors.append("no hay contrato de métrica real en la instancia")
    return config

def validate_contracts(root: Path, errors: list[str], instance: bool) -> None:
    for path in sorted((root / "metricas/contracts").glob("*.yaml")):
        if path.name == "metric.template.yaml":
            continue
        metric = read_yaml(path, errors)
        for key in ("id", "question", "decision_enabled", "owner", "definition", "sources", "quality", "validation"):
            if key not in metric:
                errors.append(f"{path.relative_to(root)}: falta '{key}'")
        if instance:
            for where, value in walk_strings(metric):
                if PLACEHOLDER.search(value):
                    errors.append(f"{path.relative_to(root)} sin llenar: {where}")
    for path in sorted((root / "integraciones/contracts").glob("*.yaml")):
        if path.name == "integration.template.yaml":
            continue
        if "id" not in read_yaml(path, errors):
            errors.append(f"{path.relative_to(root)}: falta 'id'")

def validate_gates(root: Path, config: dict[str, Any], errors: list[str]) -> None:
    gates = config.get("quality_gates", {})
    registry = read_yaml(root / "sops/gates.yaml", errors).get("gates", {})
    for gate, enforcer in GATE_ENFORCERS.items():
        if gate not in gates:
            errors.append(f"compuerta ausente en client.config.yaml: {gate}")
        elif not (root / enforcer).is_file():
            errors.append(f"compuerta '{gate}' sin artefacto: {enforcer}")
        definition = registry.get(gate, {}) if isinstance(registry, dict) else {}
        for field in ("condition", "severity", "failure_behavior", "owner"):
            if field not in definition:
                errors.append(f"sops/gates.yaml: compuerta '{gate}' sin '{field}'")

def validate_secrets(root: Path, errors: list[str]) -> None:
    for path in root.rglob("*"):
        if not path.is_file() or ".git" in path.parts or path.name == ".env":
            continue
        try:
            text = path.read_text(encoding="utf-8")
        except (UnicodeDecodeError, OSError):
            continue
        for label, pattern in SECRET_PATTERNS:
            if pattern.search(text):
                errors.append(f"posible secreto {label}: {path.relative_to(root)}")

def validate_sql(root: Path, errors: list[str]) -> None:
    for relative, invariants in SQL_INVARIANTS.items():
        path = root / relative
        if not path.is_file():
            continue
        sql = strip_sql_comments(path.read_text(encoding="utf-8"))
        for needle, reason in invariants:
            if needle not in sql:
                errors.append(f"{relative}: falta '{needle}' — {reason}")

def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--instancia", action="store_true", help="exige configuración de cliente completa")
    parser.add_argument("--root", type=Path, default=DEFAULT_ROOT, help="raíz a validar")
    args = parser.parse_args(argv)
    root = args.root.resolve()
    errors: list[str] = []
    validate_structure(root, errors)
    config = validate_config(root, errors, args.instancia)
    validate_contracts(root, errors, args.instancia)
    validate_gates(root, config, errors)
    validate_secrets(root, errors)
    validate_sql(root, errors)
    if errors:
        print("Framework inválido:\n" + "\n".join(f"- {error}" for error in errors))
        return 1
    mode = "instancia lista para operar" if args.instancia else "plantilla íntegra"
    print(f"Framework válido ({mode}): {len(REQUIRED)} artefactos · {len(GATE_ENFORCERS)} compuertas · {sum(len(v) for v in SQL_INVARIANTS.values())} invariantes.")
    return 0

if __name__ == "__main__":
    sys.exit(main())

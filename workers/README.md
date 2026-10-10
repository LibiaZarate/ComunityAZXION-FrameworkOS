# Workers

Los workers se organizan por responsabilidad, no por herramienta. Una instancia implementa únicamente los necesarios.

| Worker | Responsabilidad |
|---|---|
| `ingestion` | Recibir eventos y conservar identificadores de origen |
| `identity-resolution` | Reconciliar identidades sin fusionar personas ambiguas |
| `curation` | Normalizar, validar y etiquetar calidad/procedencia |
| `classification` | Proponer intención, objeción o etapa con evidencia |
| `metric-computation` | Calcular contratos de métricas y su cobertura |
| `constraint-detection` | Recorrer el flujo y localizar la primera fuga relevante |
| `recommendation` | Proponer una intervención con confianza y guardrails |
| `follow-up` | Programar acciones idempotentes conforme a reglas aprobadas |
| `reconciliation` | Comparar fuentes y detectar eventos faltantes o contradictorios |
| `reporting` | Generar briefs y alertas desde datos estructurados |

Todo worker que escriba o ejecute acciones debe declarar idempotencia, manejo de error, telemetría, límites y criterio de rollback.

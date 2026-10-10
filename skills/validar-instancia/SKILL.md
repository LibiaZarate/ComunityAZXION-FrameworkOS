---
name: validar-instancia
description: Valida que una instancia AZXION esté completa, consistente y lista para operar antes de producción o de una decisión sensible.
---

# Validar una instancia

## Lee

`AGENTS.md`, `client.config.yaml`, `schemas/client.config.schema.json`, los contratos activos, la integración declarada, el SQL de la versión y el último resultado de pruebas.

## Ejecuta

1. Corre el validador con `--instancia`.
2. Confirma que no existan placeholders ni configuración desconocida.
3. Comprueba que cada métrica usada por una decisión tenga fuente, fórmula, cobertura, muestra y salida `no_medible`.
4. Comprueba que cada integración tenga contrato y reconciliación.
5. Comprueba que el recorrido prioritario tenga eventos de entrada, salida y excepción.
6. Comprueba rollback, aprobación y versión activa.

## Salida

Estado `lista`, `bloqueada` o `no medible`; hallazgos con severidad, evidencia, dueño, acción y criterio de cierre.

No declares lista una instancia porque el script terminó con código cero si el recorrido prioritario no se observó en producción de prueba.

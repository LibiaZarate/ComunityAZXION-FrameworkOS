---
name: registrar-incidente
description: Convierte un bug o fallo operativo en un incidente trazable con causa, corrección, prueba, guardrail y verificación de despliegue.
---

# Registrar un incidente

## Lee

`sops/incidentes-y-bugs.md`, el log o evidencia original, la versión activa y el recorrido afectado.

## Ejecuta

1. Registra síntoma, impacto, valor expuesto y evidencia reproducible.
2. Clasifica el fallo: dato, integración, lógica, métrica, decisión, automatización, seguridad o adopción.
3. Separa causa probable de causa confirmada.
4. Documenta mitigación y corrección permanente.
5. Añade una prueba de regresión y el guardrail que la hace cumplir.
6. Verifica la versión activa y cierra solo después de observar el recorrido corregido.

## Salida

Expediente del incidente, prueba, guardrail, versión desplegada, responsable y estado `abierto`, `mitigado`, `corregido` o `verificado`.

Un cambio local sin verificación en producción no cierra el incidente.

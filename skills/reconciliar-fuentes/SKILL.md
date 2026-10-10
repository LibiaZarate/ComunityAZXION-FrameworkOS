---
name: reconciliar-fuentes
description: Revisa cobertura, duplicados, latencia, completitud y contradicciones entre fuentes antes de usar sus datos en una métrica o decisión.
---

# Reconciliar fuentes

## Lee

`client.config.yaml`, el contrato de la fuente, la última observación de calidad, los eventos recibidos y la métrica que pretende consumirlos.

## Ejecuta

1. Compara el universo esperado con el observado por segmento.
2. Calcula cobertura, completitud, actualidad, unicidad, consistencia y linaje.
3. Envía eventos inválidos o duplicados a cuarentena con razón, fuente y timestamp.
4. Reconcilia campos autoritativos y registra contradicciones, sin sobrescribir historia.
5. Marca la métrica `no_medible` si la cobertura o completitud no alcanza su contrato.
6. Registra dueño, acción correctiva y fecha de la próxima revisión.

## Salida

Observación por fuente y segmento, hallazgos, datos en cuarentena, métricas afectadas y decisión permitida.

Nunca promedies ramas ciegas con ramas completas para hacer pasar el umbral.

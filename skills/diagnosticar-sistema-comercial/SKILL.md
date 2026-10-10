---
name: diagnosticar-sistema-comercial
description: Diagnostica una operación comercial desde eventos y contratos de métricas para localizar la restricción dominante, cuantificar valor expuesto y proponer una intervención explicable. Úsala para análisis de pipeline o Monday Decision Brief; no para implementar cambios sin aprobación.
---

# Diagnosticar el sistema comercial

## Principio

Recorre el flujo en orden. Una caída posterior no se corrige aumentando una entrada anterior. Prioriza throughput y valor, no actividad aislada.

## Procedimiento

1. Verifica cobertura, latencia, consistencia y fuentes de las métricas.
2. Si la evidencia es insuficiente, devuelve `no medible` y la instrumentación necesaria.
3. Compara periodo actual, periodo anterior, línea base y objetivo cuando sean comparables.
4. Recorre: atención → conversación → calificación → handoff → seguimiento → propuesta → revenue → resultado.
5. Localiza la primera fuga relevante y cruza cantidad con valor económico.
6. Distingue hecho, inferencia, hipótesis y dato faltante.
7. Evalúa explicaciones alternativas y cambios simultáneos.
8. Recomienda una variable controlable, un dueño, un periodo y guardrails.
9. Declara qué variables no deben modificarse durante la prueba.

## Salida

- Estado del sistema.
- Estrella polar y cambio observable.
- Restricción dominante.
- Valor expuesto con supuestos.
- Evidencia y leads/casos concretos.
- Calidad y límites de la evidencia.
- Intervención propuesta.
- Responsable, periodo, éxito y rollback.
- Variables que no deben tocarse.

Nunca presentes una recomendación del modelo como causalidad demostrada ni utilices un porcentaje de confianza sin explicar sus componentes.

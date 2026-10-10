---
name: operar-kaizen-comercial
description: "Opera el ciclo semanal de mejora comercial de una instancia AZXION: consolida evidencia, revisa el experimento, decide mantener, iterar o revertir y propaga el aprendizaje. Úsala para EOW y planeación semanal; no para cambios urgentes de seguridad o incidentes."
---

# Operar KAIZEN comercial

## Entrada

Lee el último diagnóstico, los contratos de métricas, el experimento activo, incidentes, cambios desplegados y evidencia del periodo. No uses notas manuales como sustituto de una fuente estructurada sin declararlo.

## Ciclo

1. Cierra los números y su cobertura.
2. Revisa si la variable principal realmente permaneció aislada.
3. Compara resultado contra línea base, métrica primaria y guardrails.
4. Declara limitaciones: muestra, atribución, estacionalidad, cambios de campaña, vendedor o datos.
5. Decide `mantener`, `iterar`, `revertir` o `no_concluyente`.
6. Actualiza el experimento y el aprendizaje aprobado.
7. Propaga el aprendizaje a reglas, SOP, métricas y pruebas afectadas.
8. Clasifica la promoción: instancia, vertical o core.
9. Ejecuta un nuevo diagnóstico antes de seleccionar la próxima variable.

## Restricciones

- Una variable principal por ciclo salvo incidente o imposibilidad operativa.
- Un resultado adverso no se oculta ni se reinterpreta para proteger la hipótesis.
- `No concluyente` es una decisión válida.
- Ningún cambio sensible se despliega desde esta skill sin aprobación externa explícita.

## Salida

- Resultado y calidad de evidencia.
- Decisión del experimento.
- Aprendizaje.
- Cambios documentales y tests que deben actualizarse.
- Restricción actualizada.
- Próximo experimento propuesto, todavía sin desplegar.

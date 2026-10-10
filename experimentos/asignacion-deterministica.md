# Asignación determinista — cómo se mide lo que vale una intervención

> **Naturaleza: OPERACIÓN.** Es el procedimiento que convierte un despliegue parcial en un experimento con grupo de control.

Casi todo el mercado despliega una intervención comercial (un agente, una secuencia, una cadencia) y después compara *"antes contra después"*. Esa comparación no aísla nada: la campaña cambió, el presupuesto cambió, la estación cambió, el vendedor cambió.

**Un despliegue parcial bien hecho ya es un experimento aleatorizado.** No cuesta más que uno mal hecho, y es la única forma de responder la pregunta que el cliente sí paga: *¿qué habría pasado sin esto?*

---

## La regla

**Toda intervención medible se despliega por asignación determinista, nunca por un interruptor global.**

```
bucket = hash(identificador_estable) mod 100
brazo  = bucket < pct ? tratamiento : control
```

El hash debe ser **estable y sin estado**: el mismo sujeto cae siempre en el mismo brazo, sin consultar una tabla. FNV-1a de 32 bits es suficiente y se implementa igual en cualquier lenguaje o nodo de código.

```js
// FNV-1a · idéntico en JS, Python y SQL. No usar Math.random ni el id de la fila.
function bucket(id) {
  let h = 2166136261
  for (let i = 0; i < id.length; i++) { h ^= id.charCodeAt(i); h = Math.imul(h, 16777619) }
  return Math.abs(h) % 100
}
```

## Los tres invariantes

1. **Los dos brazos se instrumentan idéntico.** El brazo de control no ejecuta la intervención, pero registra **todo**: mensajes, etapas, tiempos, resultado. Un control sin instrumentar no es un control: es un agujero, y convierte el experimento en anécdota.
2. **La asignación se persiste.** Va en `asignacion_experimento`, con el método y el bucket. Es inmutable por trigger: reasignar después del hecho destruye la comparabilidad. Un brazo que solo vive en un archivo de configuración desaparece en cuanto alguien edita el archivo.
3. **Una variable a la vez.** Mientras un experimento corre, las variables listadas en `confounders_to_hold` no se tocan. Si se tocan, el experimento se declara **no concluyente** y se reinicia; no se interpreta "con reservas".

## Lo que hace falta antes de leer un resultado

- Muestra mínima alcanzada **y** duración mínima cumplida — lo que ocurra después.
- Cobertura de instrumentación comparable en ambos brazos (ver `sops/confianza-evidencia.md`).
- Ningún confusor declarado se movió durante el periodo.

Si algo de esto falla, la salida obligatoria es **no concluyente, con la razón**. Nunca un porcentaje.

## Cómo se reporta

> *"Contra tu propia operación, con los mismos leads y en el mismo periodo, el brazo tratamiento produjo N handoffs contra M del control (n=X por brazo). Confianza media: la muestra alcanza, pero el presupuesto de la campaña subió el día 4."*

Esa frase es el producto. Es lo que ninguna herramienta del mercado puede decir de sí misma, y es lo que sostiene el precio de una intervención frente al precio de una licencia.

## Anti-patrones

| Anti-patrón | Por qué rompe |
|---|---|
| `Math.random()` por mensaje | El mismo sujeto salta de brazo entre turnos; la experiencia se vuelve incoherente y la medición, basura |
| Hash sobre el id de la fila | No es estable: depende del orden de inserción |
| Brazo de control sin registro | Ni la comparación ni la cobertura son calculables |
| Subir el `pct` a media prueba | Cambia la composición de los brazos; el efecto observado deja de ser atribuible |
| Interpretar antes de la muestra mínima | Se recuerda la conclusión y se olvidan las reservas |

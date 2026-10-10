# SOP · Incidentes y bugs

Un error no se cierra cuando el código cambia. Se cierra cuando la causa queda documentada, la corrección está activa y existe una prueba que evita su regreso.

## Registro mínimo

- `id`, fecha, instancia y responsable.
- Síntoma observable y recorrido afectado.
- Impacto operativo y valor expuesto, con confianza.
- Fuente y evidencia reproducible.
- Causa probable y causa confirmada.
- Mitigación inmediata y corrección permanente.
- Guardrail añadido.
- Prueba de regresión.
- Versión desplegada, fecha y verificación posterior.

## Tipos

`dato`, `integracion`, `logica`, `metrica`, `decision`, `automatizacion`, `seguridad`, `adopcion`.

El flujo obligatorio es: `bug → incidente → causa → fix → prueba → guardrail → despliegue → verificación`.

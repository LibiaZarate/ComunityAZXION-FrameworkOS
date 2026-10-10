# Mapa de implementación del sistema comercial

Usa esta guía junto con [`AGENTS.md`](AGENTS.md). El objetivo es representar cómo funciona el negocio y construir una operación que conecte áreas, evidencia, decisiones y resultados. El mapa se adapta a cada empresa; no presupone un sector ni herramientas concretas.

## Recorrido de valor

```text
Marketing → Prospecto → Conversación → Calificación → Seguimiento → Venta
          → Onboarding/entrega → Resultado del cliente → Aprendizaje de producto
```

No todos los negocios usan las mismas etapas. Confirma nombres, responsables, excepciones y evento económico durante el descubrimiento.

## Capas del OS

| Capa | Pregunta | Ubicación principal |
|---|---|---|
| Instrucciones | ¿Cómo debe trabajar la IA en esta instancia? | `AGENTS.md`, `adaptadores/` |
| Contexto | ¿Qué es verdad y qué reglas están aprobadas? | `contexto/`, `dominios/`, `procesos/` |
| Data | ¿Qué ocurrió y cuál es la evidencia? | `data/`, eventos y fuentes conectadas |
| Inteligencia | ¿Qué muestran los datos sobre el negocio? | `inteligencia/`, `metricas/` |
| Operación | ¿Qué acción corresponde y quién la autoriza? | `skills/`, `procesos/`, `sops/`, `agentes/` |
| Infraestructura | ¿Cómo se almacenan, conectan y aíslan los datos? | `integraciones/`, `infraestructura/` |
| Mejora | ¿Qué cambio funcionó y qué se aprende? | `experimentos/`, KAIZEN, Git |

## Del diagnóstico al primer sistema

1. Confirma el resultado prioritario, el evento de ingreso, el perfil de cliente y el recorrido actual.
2. Revisa evidencia de cada transición: origen, respuesta, siguiente paso, venta, entrega y resultado.
3. Declara faltantes y contradicciones; no conviertas hipótesis en hechos ni métricas sin cobertura en certezas.
4. Identifica el cuello de botella que tenga evidencia y una acción posible.
5. Crea eventos y contratos de métricas con fuentes, fórmula, cobertura y decisión habilitada.
6. Escoge integraciones estrictamente necesarias para observar el recorrido o accionar sobre él.
7. Define una intervención para un solo proceso. Registra dueño, límites, revisión humana, aceptación y rollback.
8. Valida el recorrido de extremo a extremo antes de activarlo con clientes.
9. Compara el resultado con una línea base o control adecuado y registra el aprendizaje.
10. Propaga a otros procesos solo lo que la evidencia sostenga.

## Agentes e IA

Diseña el agente desde un proceso confirmado, no desde una lista de herramientas. Cada agente necesita objetivo, entradas, fuente autoritativa, salida estructurada, permisos, casos límite, evaluación, fallback y responsable. Usa [`agentes/agent.template.yaml`](agentes/agent.template.yaml) y [`agentes/eval.template.yaml`](agentes/eval.template.yaml).

La configuración inicial debe privilegiar lectura, organización, cálculos y recomendaciones. Envíos externos, cambios comerciales, dinero, datos sensibles y producción requieren los permisos y aprobaciones definidos en `client.config.yaml`. Una conexión instalada no demuestra que funcione: sigue [`adaptadores/README.md`](adaptadores/README.md) para comprobar cada herramienta.

## Qué debe mostrar un dashboard

Cada indicador debe responder una pregunta y declarar contrato, fuente, periodo, cobertura, calidad, responsable y decisión que habilita. Como mínimo, el dashboard de la primera etapa muestra:

- volumen y conversión por etapa del recorrido real;
- tiempos de respuesta y edad de oportunidades sin siguiente paso;
- resultados confirmados y valor asociado, con confianza explícita;
- calidad y cobertura de datos por fuente y segmento;
- bloqueos, fallas de integración y acciones que requieren intervención humana;
- experimento activo, línea base, guardrails y fecha de decisión.

Si una fuente no alcanza la cobertura requerida, muestra `no medible` y explica qué falta. El dashboard se calcula desde datos reconciliados; no se editan cifras a mano.

## Criterio de entrega

El primer sistema está listo cuando una persona puede seguir un caso real desde su origen hasta su resultado, explicar cada métrica con evidencia, entender qué decisión recomienda la IA, aprobar o detener acciones y recuperar la operación ante una falla. Consulta [`skills/instalar-sistema-cliente/SKILL.md`](skills/instalar-sistema-cliente/SKILL.md) y [`skills/validar-instancia/SKILL.md`](skills/validar-instancia/SKILL.md) para las compuertas completas.

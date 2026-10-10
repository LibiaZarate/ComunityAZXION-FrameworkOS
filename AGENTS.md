# AGENTS.md — [NOMBRE DE TU NEGOCIO]

> Contrato común de instrucciones de esta instancia. Las herramientas autorizadas cargan este archivo; los detalles viven en sus fuentes correspondientes.

## Arranque

1. Lee este archivo y `client.config.yaml` para identificar negocio, módulos y autoridad.
2. Lee `memoria/estado-actual.md` y el último commit.
3. Si la tarea toca un proceso, consulta su `framework.md` en `procesos/` y el dominio relacionado.
4. Consulta solamente las fuentes necesarias para la tarea. Declara vacíos y contradicciones; no inventes datos.

## Propósito y reglas del negocio

Describe aquí qué vende el negocio, a quién, cómo genera ingresos y cuál es su resultado prioritario. Completa reglas aprobadas de interacción y autoridad durante onboarding; no presupongas preferencias.

## Modelo de información

Toda información pertenece a una categoría:

| Categoría | Comportamiento | Ubicación |
|---|---|---|
| CONTEXTO | Se lee; cambia lentamente | `contexto/` |
| DATA | Se acumula desde fuentes | `data/` |
| INTELIGENCIA | Se calcula desde contexto + data | `inteligencia/` |
| OPERACIÓN | Se ejecuta | `procesos/`, `sops/` |

El ciclo de entrada es `ENTRA → TRIAGE → DESTILA → ESTANDARIZA → DERIVA → PROPAGA`. La inteligencia se calcula; no se escribe a mano.

## Cómo accionar según la tarea

Antes de producir, identifica el área y recorre **CONTEXTO + DATA → INTELIGENCIA → OPERACIÓN**. No respondas desde una sola capa cuando la tarea requiera decisiones de negocio.

| Área de tarea | Contexto que gobierna | Data que se consulta | Inteligencia y operación esperadas |
|---|---|---|---|
| Marketing y oferta | ICP, oferta, posicionamiento y restricciones aprobadas | Mercado, campañas, respuestas y resultados | Diagnóstico/hipótesis medible → campaña, mensaje o experimento aprobado |
| Contenido | Voz, marca, audiencia, objetivo y promesa | Fuente original, feedback y rendimiento | Ángulo conectado con evidencia → pieza y CTA, con resultado medible |
| Ventas y proceso comercial | ICP, etapas, criterios, guiones y reglas de seguimiento | Conversación y estado vigentes desde su fuente autoritativa | Calificación/objeción/siguiente paso → mensaje, llamada o propuesta con trazabilidad |
| Procesos y delivery | Compromiso, dueño, SOP y criterios de aceptación | Ejecuciones, entregas, aceptación, bloqueos e incidentes | Restricción → acción con responsable y fecha → verificación y actualización del proceso |
| Producto | Resultado del producto, usuarios, alcance y guardrails | Uso, fallas, solicitudes y resultados | Problema validado → prioridad, cambio o experimento con criterio de aceptación |
| Inteligencia de negocio | Pregunta directiva, definiciones y decisión habilitada | Fuentes declaradas en los contratos de métricas e integraciones | Cálculo trazable con cobertura y límites → recomendación; `no medible` si la evidencia no alcanza |

Para cada tarea: (1) localiza la regla o proceso en CONTEXTO, (2) consulta DATA actual y autoritativa, (3) separa hechos, inferencias, hipótesis y faltantes, (4) produce solo la INTELIGENCIA que exige la pregunta, (5) prepara o ejecuta la OPERACIÓN autorizada y (6) registra evidencia y aprendizaje. Sigue la skill aplicable. Si falta fuente, skill, acceso o autoridad, dilo y deja explícito qué paso queda pendiente.

Al crear o mejorar agentes, trabaja desde un proceso real del negocio y sigue [`agentes/README.md`](agentes/README.md). Define contrato, herramientas y permisos, decisión humana, casos de evaluación y evidencia antes de ampliar autonomía. Reutiliza `agentes/agent.template.yaml` y `agentes/eval.template.yaml`; no despliegues un agente porque el prompt parezca completo.

## Evidencia y decisiones

- Separa hechos, inferencias, hipótesis, contradicciones y datos faltantes.
- Toda métrica declara fórmula, fuente, cobertura y decisión que habilita; si no alcanza la evidencia, responde `no medible`.
- La autoridad para aprobar decisiones está en `client.config.yaml`.
- Un cambio comercial sensible requiere guardrails, aprobación, medición y rollback.
- Cada proceso mantiene su `historico.md` y `framework.md` según `estructura/`.

## Seguridad

No guardes credenciales, tokens, API keys ni datos personales de clientes en el repositorio. Entra la lógica, no los secretos ni datos identificables. Aplica `sops/seguridad.md`.

## Cierre

En trabajo sustancial, actualiza `memoria/estado-actual.md`, registra el resultado y su evidencia, y haz commit solo de los archivos de la tarea. Sigue `guia-operacion.md` y la compuerta de release aplicable.

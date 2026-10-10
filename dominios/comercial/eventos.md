# Catálogo base de eventos comerciales

Los nombres son una ontología inicial, no las etapas obligatorias del cliente. Cada instancia selecciona y extiende los eventos sin cambiar su significado histórico.

| Evento | Significado mínimo |
|---|---|
| `touchpoint_created` | Una persona estuvo expuesta o interactuó con una fuente identificable |
| `lead_created` | Existe identidad contactable y consentimiento/base válida según el canal |
| `message_received` | Mensaje recibido y confirmado por la fuente |
| `message_delivered` | Mensaje saliente entregado, no solo aceptado por la plataforma |
| `human_reply_detected` | Respuesta humana; excluye automatizaciones y ecos |
| `opportunity_created` | Existe problema u objetivo que merece seguimiento comercial |
| `opportunity_qualified` | Cumple los criterios aprobados de la instancia |
| `handoff_requested` | La lógica determinó que otra persona debe intervenir |
| `owner_assigned` | Un responsable aceptó la oportunidad |
| `followup_due` | La próxima acción alcanzó su fecha |
| `followup_sent` | Seguimiento entregado y vinculado con su regla/versión |
| `appointment_booked` | Existe evento verificable de agenda |
| `appointment_completed` | La reunión ocurrió |
| `proposal_sent` | La propuesta fue entregada y versionada |
| `revenue_committed` | Ocurrió el evento económico acordado: anticipo, contrato o pago |
| `deal_won` | La oportunidad se declara ganada según la definición aprobada |
| `deal_lost` | Se declara perdida con etapa, causa y responsable conservados |
| `opportunity_reactivated` | Una oportunidad perdida o pausada vuelve al flujo activo |
| `experiment_assigned` | El sujeto quedó asignado a un brazo de experimento, con método y bucket |
| `event_compensated` | Un evento anterior queda corregido; el original no se borra |
| `delivery_started` | Comienza la promesa posterior a venta |
| `outcome_verified` | Existe evidencia de resultado aceptada |

## Campos mínimos de un evento

| Campo | Columna en `evento_comercial` | Nota |
|---|---|---|
| Sujeto | `subject_type` · `subject_id` | **Obligatorio.** Es el ancla real del evento |
| Oportunidad | `oportunidad_id` | **Opcional.** Proyección, no requisito |
| Tipo | `tipo_evento` | Del catálogo de arriba |
| Momento | `ocurrido_en` · `registrado_en` | Cuándo pasó y cuándo se supo; no son lo mismo |
| Actor | `actor_tipo` · `actor_id` | Contacto, agente, humano o sistema |
| Etapa | `etapa_codigo` · `etapa_anterior` | La etapa previa se conserva: sin ella la zona de fuga no es derivable |
| Causa | `causa` | Exigida por trigger en las etapas marcadas `exige_causa` |
| Origen | `fuente_sistema` · `fuente_evento_id` | Únicos juntos: es el candado de idempotencia |
| Valor | `valor_estimado` · `valor_moneda` · `valor_confianza` | Los tres o ninguno, por constraint |
| Corrección | `compensa_evento_id` | Apunta al evento que este corrige |
| Trazabilidad | `evidencia_ref` · `regla_version` · `meta` | De dónde salió y bajo qué versión de regla |

## Reglas

- Los eventos son append-only, y lo hace cumplir un trigger, no un comentario.
- **La captura nunca depende de una decisión de negocio.** `touchpoint_created`,
  `lead_created`, `message_received` y el propio `opportunity_created` ocurren
  antes de que exista una oportunidad; el sujeto del evento es `subject_*`, y
  `oportunidad_id` se llena después, cuando el negocio decide que la hay.
- Una corrección genera un evento compensatorio con `compensa_evento_id`; no
  borra el original. La proyección ignora todo evento que tenga un compensatorio
  posterior.
- El pipeline actual se deriva del último evento válido.
- Si una plataforma no confirma entrega, no se registra `message_delivered`.
  Un `200` de la API no es la entrega.
- Inferencias y hechos usan campos distintos.
- **Un valor sin confianza declarada no entra.** Contar oportunidades y contar
  dinero producen conclusiones opuestas: la etapa que pierde más leads casi
  nunca es la que pierde más dinero.

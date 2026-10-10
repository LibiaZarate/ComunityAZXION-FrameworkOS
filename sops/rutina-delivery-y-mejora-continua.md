# Rutina de implementación y mejora continua

Este procedimiento lleva una necesidad del negocio a una instancia validada. Cada negocio define responsables, fechas, alcance y herramientas durante el descubrimiento.

## Responsabilidades

| Rol | Responsabilidad |
|---|---|
| Responsable de negocio | Confirma prioridades, reglas, lenguaje, aceptación y cambios sensibles |
| Responsable técnico | Configura repositorio, datos, integraciones, observabilidad, validación y recuperación |
| Dueño del proceso | Explica la operación real, excepciones y resultado esperado; valida escenarios |
| Monitoreo | Observa calidad, fallas y deriva; documenta incidentes y escala hallazgos |

Una persona puede cubrir varios roles. La aprobación de negocio y la ejecución técnica deben quedar identificables. La IA no despliega ni cambia reglas sensibles sin autorización explícita.

## Ciclo de implementación

`DESCUBRIMIENTO → DISEÑO → CONSTRUCCIÓN → VALIDACIÓN → PILOTO → PRODUCCIÓN → MEJORA`

En cada transición registra dueño, fecha, versión, evidencia, riesgos y forma de recuperación.

### Descubrimiento

Confirma oferta, cliente ideal, recorrido desde la primera interacción hasta el resultado, métricas, fuentes autoritativas, datos sensibles, permisos, responsables, excepciones y criterios de aceptación. Clasifica cada elemento como confirmado, inferido, contradictorio, faltante o no medible.

**Salida:** `client.config.yaml`, mapa del proceso actual, fuentes, riesgos y aceptación inicial.

### Aislamiento e infraestructura

Crea una instancia privada del framework, guarda credenciales fuera del repositorio y configura recursos independientes para el negocio. Declara fuentes, permisos, retención, integraciones y plan de contingencia. Registra pruebas de acceso, migración e idempotencia.

### Lógica y agentes

Documenta para un proceso prioritario qué lo activa, qué contexto necesita, cuál es la respuesta correcta, qué excepciones existen y cuándo escala a una persona. Define herramientas y permisos, entradas y salidas, ejemplos de evaluación, fallback y evidencia de resultado.

### Construcción por recorrido

Implementa un único recorrido prioritario de extremo a extremo. Incluye captura del evento, almacenamiento, reglas, interfaz, métrica, logs y recuperación ante errores. Evita conectar sistemas sin una decisión que lo justifique.

### Validación, piloto y producción

Prueba escenarios exitosos, datos ausentes o contradictorios, duplicados, integración caída, reintentos, acciones no autorizadas, métricas de baja cobertura y regresiones. Usa datos sintéticos o anonimizados. Activa el piloto con responsables, aceptación, alertas y rollback definidos. La producción requiere aprobación explícita.

### Monitoreo y mejora

Revisa salud técnica, calidad de datos, precisión de los agentes, resultados y adopción. Si hay una anomalía, abre un incidente con impacto y evidencia; limita la automatización afectada y escala según los permisos definidos. Cada cambio debe indicar qué variable modifica, su guardrail, resultado y criterio para mantenerlo o revertirlo.

## Cadencia adaptable

Define una revisión breve de alertas, una revisión periódica del proceso y una decisión de mejora con dueño y fecha. La cadencia debe caber en el tiempo operativo real disponible; no añadas reuniones sin una decisión asociada.

## Criterio de entrega

El sistema está listo cuando el recorrido prioritario se comprueba de principio a fin, las métricas tienen fuentes y límites, la IA respeta permisos, el equipo sabe operar el flujo y las fallas pueden escalarse o revertirse.

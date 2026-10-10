---
name: instalar-sistema-cliente
description: Instala una instancia de AZXION Framework OS para un cliente nuevo mediante descubrimiento, configuración, selección de módulos e integraciones, y compuertas de seguridad. Úsala al iniciar o reestructurar una implementación; no para operar el ciclo semanal.
---

# Instalar un sistema de cliente

El resultado es una instancia mínima capaz de observar la restricción inicial del negocio, no una copia indiscriminada de todos los módulos.

## Fuentes obligatorias

Lee `AGENTS.md`, `client.config.yaml`, `onboarding/descubrimiento-sistemico.md`, `sops/seguridad.md`, `agentes/README.md` y el vertical seleccionado. Si una fuente no existe o se contradice, registra el hueco y pregunta; no completes reglas comerciales por intuición.

## Flujo

1. Documenta el negocio real, su estrella polar y el evento de revenue.
2. Modela el flujo de valor de marketing a resultado y localiza la primera restricción conocida o hipotética.
3. Clasifica cada respuesta como confirmada, inferida, contradictoria, faltante o no medible.
4. Completa `client.config.yaml` y activa solo los dominios necesarios.
5. Define eventos, fuentes autoritativas, identidades y reglas de reconciliación.
6. Crea contratos para las métricas que habilitan decisiones del alcance.
7. Crea contratos solo para las integraciones estrictamente necesarias.
8. Define decisiones automáticas, asistidas, sujetas a aprobación y humanas.
9. Genera criterios de aceptación, pruebas, rollback y plan de adopción.
10. Entrega un mapa de arquitectura, backlog priorizado y lista explícita de datos no medibles.
11. Selecciona como máximo el primer proceso prioritario para observar y convertir en agente. Confirma con el responsable cómo se ejecuta, qué excepciones existen, qué resultado demuestra éxito y qué puede decidir la IA. No diseñes varios agentes antes de tener un flujo y verificación claros.

## Compuertas

- No prometas atribución sin identificadores que viajen hasta el resultado.
- No automatices una transición sin evento, regla y excepción documentados.
- No despliegues acciones sensibles sin autoridad aprobada.
- No copies secretos o datos personales al repositorio.
- No construyas nivel decisional si el observable no tiene cobertura suficiente.

## Terminado

La instancia queda lista cuando existe una prueba end-to-end del recorrido prioritario, las métricas declaran su calidad, el equipo conoce sus responsabilidades y producción tiene aprobación explícita.

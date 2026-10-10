# Adaptadores de herramientas

Cada herramienta usa este contrato; su archivo de configuración solo traduce cómo cargarlo y qué capacidades están disponibles.

## Contrato de un adaptador

El adaptador de Codex, Claude Code, Orca, Visual Studio u otra herramienta debe especificar:

1. **Instancia:** ruta o repositorio privado del cliente.
2. **Reglas:** cargar `AGENTS.md` al iniciar una tarea.
3. **Contexto de inicio:** leer `client.config.yaml` y `memoria/estado-actual.md`; consultar fuentes adicionales según la tarea y `AGENTS.md`.
4. **Capacidades disponibles:** archivos, terminal, MCP/conectores, comandos y hooks que realmente puede usar.
5. **Límites:** accesos ausentes, acciones que requieren aprobación y forma de reportar fallas.
6. **Cierre:** dejar el resultado y su evidencia en las fuentes de la instancia siguiendo `AGENTS.md`.

No copies reglas del negocio al adaptador. Si una plataforma no admite archivos de instrucciones, entrega este contrato como contexto inicial versionado desde la misma instancia y registra esa limitación.

## Prueba de conexión

Antes de usar la herramienta en una operación real, pide al agente que:

- nombre la instancia y cite la fuente de sus instrucciones;
- encuentre una fuente vigente indicada por la tarea;
- identifique una capacidad disponible y una ausente;
- complete una tarea representativa de bajo riesgo y deje evidencia retomable.

La herramienta queda conectada cuando esas cuatro comprobaciones se observan. Una configuración instalada, un MCP listado o un hook declarado no son evidencia de ejecución.

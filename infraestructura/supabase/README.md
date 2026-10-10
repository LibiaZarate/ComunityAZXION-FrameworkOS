# Infraestructura de datos

Cada instancia de negocio debe usar una base de datos aislada. Conserva secretos en variables de entorno y aplica permisos mínimos.

## Esquemas disponibles

| Archivo | Propósito |
|---|---|
| [`05-comercial.sql`](05-comercial.sql) | Esquema comercial adaptable para identidades, oportunidades, eventos, decisiones y calidad |
| [`06-migracion-comercial-v2.sql`](06-migracion-comercial-v2.sql) | Migración para instancias que ya aplicaron una versión anterior del esquema comercial |

Una instancia nueva aplica `05-comercial.sql` y omite la migración v2. Revisa cada migración y ejecútala primero en un entorno aislado. La plantilla no sustituye la revisión de seguridad, retención ni políticas de acceso de cada negocio. Las tablas sensibles deben usar RLS y fallar cerradas ante permisos ausentes.

Toda métrica debe trazarse a una fuente. Si la cobertura no alcanza el criterio definido en `client.config.yaml`, muestra `no medible` y documenta qué dato falta.

# Comunity AZXION Framework OS

Framework abierto para que una persona o equipo modele su operación comercial y conecte herramientas de IA con contexto, datos, métricas y procesos verificables.

## Empieza aquí

- [`EMPIEZA-AQUI.md`](EMPIEZA-AQUI.md): ruta paso a paso para adaptar el sistema a tu negocio.
- [`AGENTS.md`](AGENTS.md): instrucciones comunes que deben cargar las herramientas de IA.
- [`IMPLEMENTA-SISTEMA-COMERCIAL.md`](IMPLEMENTA-SISTEMA-COMERCIAL.md): cómo conectar marketing, prospección, seguimiento, ventas, entrega, producto e inteligencia de negocio.
- [`guia-operacion.md`](guia-operacion.md): operación diaria y ciclo de mejora.

## Arquitectura

```text
CONTEXTO + DATA → INTELIGENCIA → OPERACIÓN → RESULTADO → APRENDIZAJE
```

El repositorio incluye onboarding, modelo comercial, contratos de métricas e integraciones, plantillas para agentes, procedimientos, esquema de datos y un validador. Adapta el núcleo a la operación real de cada negocio; el framework no presupone una industria.

## Principios de instalación

1. Instala una copia independiente por negocio y mantén privados sus datos.
2. Documenta primero el proceso real y sus excepciones.
3. Empieza con un recorrido y una restricción prioritaria.
4. Declara fuentes, cobertura, permisos, aprobaciones y rollback.
5. Valida el recorrido antes de producción y amplía la autonomía de la IA con evidencia.

Las métricas declaran fuente, fórmula, cobertura y límites. Si la evidencia es insuficiente, se marca `no medible`. Nunca guardes credenciales ni datos personales en el repositorio.

Consulta [`docs/validation-and-release.md`](docs/validation-and-release.md) antes de activar una instancia. Este repositorio incluye una licencia CC BY 4.0 en [`LICENSE`](LICENSE): acredita la fuente, enlaza la licencia e indica los cambios realizados.

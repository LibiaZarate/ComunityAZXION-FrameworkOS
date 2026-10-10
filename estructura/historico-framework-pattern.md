# El patrón: histórico + framework (dos .md por proceso)

Cada proceso de tu negocio (Marketing, Ventas, Producto, Soporte, etc.) vive en su propia carpeta, y lleva **dos archivos Markdown** que no se mezclan:

```
procesos/
├── ventas/
│   ├── historico.md      ← qué pasó (se acumula, nunca se borra)
│   └── framework.md      ← la estrategia actual y futura (se lee, cambia lento)
├── marketing/
│   ├── historico.md
│   └── framework.md
└── producto/
    ├── historico.md
    └── framework.md
```

## `historico.md` — qué pasó
El registro de las acciones y decisiones pasadas del proceso, con fecha. **Se acumula, nunca se borra.** Es memoria: qué se hizo, cuándo, con qué resultado.
- Naturaleza: **DATA**.

## `framework.md` — la estrategia actual
La lógica vigente del proceso: cómo se decide, qué reglas se siguen, hacia dónde va. **Se lee, cambia lento.** Es lo que la IA consulta para operar el proceso conforme a tus reglas.
- Naturaleza: **CONTEXTO**.

## Por qué separarlos
Mezclar "qué pasó" con "qué hacemos" es la raíz del desorden: el histórico crece rápido y sepulta la estrategia. Separados, la IA (y vos) siempre sabe dónde leer la regla vigente y dónde dejar el registro.

## La estructura refleja tu organigrama
Organiza las carpetas de `procesos/` como el organigrama de tu negocio (las áreas reales). Si el negocio crece, agregás carpetas; la estructura no se rompe.

# Guía de operación — cómo usar tu segundo cerebro día a día

## El arranque de cada sesión
Antes de trabajar, tu IA lee (en orden): `AGENTS.md` → `memoria/estado-actual.md` → el último commit de Git. Así retoma el contexto sin que se lo tengas que recordar.

## Cuando entra información nueva
Cualquier cosa que llegue —una conversación, una idea, una decisión, un resultado— pasa por el [ciclo del dato](metodo/ciclo-del-dato.md): se clasifica, se destila, se estandariza, se deriva a una acción, y se buscan sus propagaciones. **Vos tirás lo crudo; la IA lo clasifica y rutea.** No decidís vos dónde va cada archivo — eso es trabajo de la IA.

## Cuando cerrás trabajo
- Actualizá `memoria/estado-actual.md` con el estado real.
- Commiteá a Git con un mensaje real: **qué, dónde, por qué.**
- Git es la junta entre sesiones: el próximo arranque sabe hasta dónde llegaste.

## Qué automatizar (y qué no)
- **Sí:** tareas repetitivas y de bajo criterio (clasificar, resumir, generar reportes, contestar lo estándar).
- **No todavía:** cualquier proceso que aún no esté documentado (primero se audita y documenta), y cualquier acción que toque dinero o producción sin una aprobación humana.

## La regla de crecimiento
No construyas lo que suena bien — construí lo que **dolió**. Después de cada trabajo manual, preguntate: *¿esto lo podría haber hecho más fácil el sistema?* Si sí, y ya te dolió más de una vez, ahí se construye. Que el trabajo pida la funcionalidad, nunca al revés.

## El loop
Una vez por semana: mirá tus métricas de resultado. Lo que funcionó, se escala. Lo que no, se corta. Cada error, se vuelve un candado (ver `sops/seguridad.md`). El segundo cerebro no se termina — se mejora en cada vuelta.

## El lunes: una decisión, no treinta gráficas

La instancia genera un Monday Decision Brief con:

1. estado del sistema;
2. estrella polar;
3. restricción dominante;
4. valor expuesto;
5. evidencia y calidad;
6. variable recomendada;
7. responsable, periodo y guardrails;
8. variables que no deben cambiar.

El founder aprueba la intervención. El sistema no modifica anuncios, oferta, copy o reglas comerciales por cuenta propia.

## El viernes: cerrar el aprendizaje

Usá `skills/operar-kaizen-comercial/` para decidir si el experimento se mantiene, itera, revierte o queda no concluyente. El aprendizaje aprobado se propaga a la instancia, al vertical o al core según su alcance.

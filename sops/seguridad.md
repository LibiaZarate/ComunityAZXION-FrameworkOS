# SOP — Seguridad del segundo cerebro

La seguridad de los datos es el miedo #1 de cualquier dueño. Tratala como una **garantía**, no como un tema técnico escondido.

## 1. Aislamiento
Un negocio = un repositorio + su propia infraestructura (su base de datos, su hosting). Tu data nunca se mezcla con la de nadie más.

## 2. La línea roja — qué NUNCA entra al repo
- Credenciales, tokens, API keys.
- Datos personales de tus clientes finales.
- Transcripciones crudas identificables.

**Entra la lógica, nunca el dato.** Los secretos viven en variables de entorno (`.env`), que **nunca** se versionan (ya está bloqueado en `.gitignore`). Si una llave alguna vez se filtró, **rótala** — queda en el historial de Git.

## 3. Acceso a la base de datos
- Permisos mínimos (RLS / roles). La lógica sensible corre en funciones con permisos controlados, no expuesta al cliente.
- Idempotencia: cada operación se puede repetir sin duplicar. El evento es la fuente de verdad.

## 4. Despliegue con red
- Cambios en una **rama de desarrollo** → revisión → producción. Nunca directo a producción.
- Verificación antes de publicar cambios críticos.
- **Cualquier cambio que toque dinero o producción = aprobación humana.** Nunca dejes que un proceso automático publique a producción por su cuenta.

## 5. La bitácora de errores — que un error no se repita *(el diferencial)*
Cada incidente se registra:
1. **Qué pasó** (el síntoma real, no el supuesto).
2. **La raíz**, verificada contra ejecución real (no contra una prueba de laboratorio).
3. **El guardrail** que se agregó para hacerlo imposible otra vez.
4. **El criterio de aceptación** que lo prueba → se vuelve un test de regresión permanente.

> Tu sistema no solo corre — **deja de repetir los errores que ya cometió.** Eso es memoria institucional, y es lo que lo hace confiable con el tiempo.

## 6. Verificá contra ejecución real
Nunca des un fix por bueno porque "en teoría funciona" o pasó una prueba aislada. Confirmalo **contra el sistema real, con datos reales.** La mayoría de los bugs viven justo en la brecha entre "debería funcionar" y "funcionó".

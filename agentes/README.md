# Diseño de agentes operables

Un agente es una forma controlada de ejecutar un proceso del negocio. No se empieza por elegir modelo ni por repartir trabajo entre muchos agentes: se empieza por un proceso que ya existe, una falla o fricción real y una definición observable de terminado.

## De proceso documentado a agente

1. **Elegir un trabajo acotado:** frecuente, costoso o propenso a errores; debe tener un dueño del negocio y un resultado reconocible.
2. **Reconstruir cómo se hace hoy:** revisar CONTEXTO, DATA, ejemplos de trabajo y excepciones. Distinguir regla explícita, criterio humano, variaciones y partes que faltan. Confirmar con las personas responsables; los documentos y la IA no inventan la lógica que no está documentada.
3. **Dibujar el flujo real:** entrada → clasificación → fuentes consultadas → criterio/decisión → acción → resultado → registro. Registrar los caminos normales, ambiguos y fallidos.
4. **Definir el contrato del agente** con [`agent.template.yaml`](agent.template.yaml): tarea, entradas, fuentes, herramientas/permisos, decisiones permitidas, aprobación humana, salida, evidencia y escalamiento.
5. **Diseñar cómo se comprueba:** preparar casos representativos con [`eval.template.yaml`](eval.template.yaml). La salida del agente nunca es por sí sola evidencia de que acertó.
6. **Hacer confiable la tarea antes de escalarla:** limitar acceso a lo necesario, usar validaciones deterministas donde sea posible, registrar trazas y mantener reversión para efectos externos.
7. **Operar en etapas:** observación con humano → ejecución en paralelo revisada → autonomía acotada. Avanzar solo cuando los casos de evaluación y la evidencia real cumplan los criterios acordados.
8. **Cerrar el aprendizaje:** cada falla con evidencia se corrige en el nivel adecuado: proceso, fuente, contrato de herramienta, skill, guardrail o evaluación. Repetir una instrucción más fuerte no corrige una causa estructural.

**Al replicar con un cliente:** AZXION aporta método, estructura y preguntas de descubrimiento; el cliente aporta su lógica, fuentes, ejemplos, criterios y límites reales. Reconstruye el flujo con su equipo y en su instancia privada. No copies procesos internos de AZXION como si fueran la operación del cliente ni transfieras datos o reglas privadas de otra cuenta.

## Reparto de responsabilidades

- **Coordinador:** entiende la solicitud, clasifica área y riesgo, consulta `AGENTS.md`, deriva a una capacidad especializada si hace falta y consolida resultados con evidencia.
- **Agente de proceso:** realiza una tarea estrecha con fuentes y herramientas explícitas. Solo se crea cuando el flujo se repite y puede verificarse.
- **Verificador:** compara la salida con criterios y fuentes observables; devuelve `aprobado`, `fallido`, `no medible` o `requiere revisión humana`, con evidencia. Puede ser una rutina determinista, una skill o un agente independiente según el riesgo.
- **Persona responsable:** aporta criterio de negocio faltante y aprueba decisiones que exceden los límites delegados.

No es obligatorio desplegar cuatro agentes. Para muchos flujos, un agente y una validación automática son suficientes. Mantén la responsabilidad clara y la delegación visible.

## Verificación y autonomía

Cada agente debe tener al menos casos para:

- camino normal;
- información ambigua o incompleta;
- fuente o herramienta fallida;
- permiso insuficiente o acción sensible;
- resultado contradictorio o no verificable.

La evaluación revisa corrección, respeto a permisos, uso de fuentes, manejo de incertidumbre, evidencia y resultado para el usuario. Registra cada versión, caso, salida, evaluación y cambio. Define los umbrales de aceptación por riesgo y proceso; no uses un puntaje genérico para aprobar todo.

Autonomía permitida según el riesgo:

| Acción | Modo inicial | Condición para ampliar |
|---|---|---|
| Lectura y análisis | Automático con trazabilidad | Fuentes y permisos delimitados |
| Borradores internos | Automático o revisado por muestra | Criterio de calidad verificable |
| Mensajes, cambios comerciales o escritura en sistemas | Preparar y pedir aprobación | Casos evaluados, identidad y destino confirmados, registro y reversión disponibles |
| Producción, contratos, dinero, datos sensibles o efectos irreversibles | Aprobación humana explícita | Límites técnicos, rollback y autorización definidos; nunca se infiere aprobación |

## Cuándo no crear un agente todavía

- El proceso vive solo en la cabeza de una persona y no se ha observado ni confirmado.
- Las fuentes no son confiables o no se sabe cuál gobierna.
- No existe un resultado comprobable o el agente no puede acceder a la superficie que lo demuestra.
- No están definidos permisos, dueño, excepciones ni punto de escalamiento.
- Una persona puede resolverlo con menos costo mediante una plantilla o automatización determinista.

En esos casos, documenta/observa el proceso primero, declara lo no medible y elige una pieza pequeña que sí pueda validarse.

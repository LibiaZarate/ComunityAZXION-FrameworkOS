# SOP — Anatomía de un prompt de agente

El prompt de tu agente no se escribe de corrido. Se arma con un **andamiaje** de secciones, en orden. Cada una tiene una función; **no elimines ninguna.**

## El scaffolding obligatorio (en orden)

1. **Rol y objetivo** — quién es el agente y su UN objetivo primario (uno solo).
2. **Persistencia** — que no abandone la tarea a medias.
3. **Prioridad de instrucciones** — la jerarquía cuando algo entra en conflicto.
4. **Razonamiento previo** — el paso a paso interno antes de responder (oculto al usuario).
5. **Reglas no negociables** — las líneas rojas que nunca cruza.
6. **Uso de herramientas** — qué herramienta usa, cuándo, con qué formato.
7. **Flujo por estado** — qué hacer según en qué punto está la conversación.
8. **Triggers de ambigüedad** — qué hacer cuando no entiende o falta un dato.
9. **Formato de salida** — cómo se ve la respuesta.
10. **Contexto** — los datos que se inyectan al vuelo (del cliente, del estado).
11. **Instrucciones finales** — el refuerzo de lo más importante (lo último que lee, más peso).

## Principios rectores
- **Un objetivo primario, uno solo.** Si el agente persigue dos cosas, hace mal las dos.
- **Jerarquía explícita de conflictos.** Cuando dos reglas chocan, decile cuál gana.
- **DRY: una sola fuente por dato.** No repitas la misma regla en tres lados con palabras distintas.
- **Los ejemplos pesan más que las reglas.** Si una regla dice "no cierres con pregunta" y un ejemplo cierra con pregunta, gana el ejemplo. Cuidá tus ejemplos.
- **Lo más riesgoso se repite al final** (efecto de recencia — es lo último que el modelo lee).

## Reglas de higiene
- **Nunca uses `{llaves simples}`** en el texto — muchos motores las leen como variables de plantilla y rompen el prompt. Si querés dar un ejemplo con un nombre, escribilo concreto ("si se llama Ana: 'Hola Ana...'").
- **Tope de tamaño.** Mantené el prompt dentro del límite de tu modelo. Si crece, recortá redundancia real, **nunca** el scaffolding.
- **El scoring y las decisiones duras NO las hace el modelo** — esas van en código, para que sean auditables. El modelo redacta; el código decide lo binario.

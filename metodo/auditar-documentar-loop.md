# El método — cómo se construye un segundo cerebro

Cuatro pasos, en orden. **No te saltes ninguno** — cada uno es la compuerta del siguiente.

```
1. AUDITAR     → ¿qué se hace hoy, quién, cómo, dónde se fuga?
2. DOCUMENTAR  → sacar la lógica de la cabeza al papel, estandarizada
3. PASAR A LA IA → con la lógica documentada, la IA genera las 4 capas
4. LOOP        → definir el resultado deseado, medir contra él, corregir, repetir
```

## 1. Auditar
Mapea el flujo actual del proceso: qué se hace, quién lo hace, con qué herramientas, y **dónde se fuga** (dónde se pierde tiempo, dinero o clientes). No inventes el proceso ideal — documenta el real.

> **Por qué primero:** automatizar sin auditar solo escala el caos. Un proceso ineficiente automatizado es un proceso ineficiente más rápido.

## 2. Documentar
Lleva la lógica de la cabeza al papel, **estandarizada**. Esto es lo que hace que el negocio corra sin depender del dueño. Para cada decisión que hoy tomas por intuición, escribí la regla: ¿qué la dispara? ¿qué se hace? ¿qué es la excepción?

**La regla de oro:** nunca le dejes intuición a la IA sobre criterios que no están definidos. Si no está documentado, la IA **no lo intuye** — lo deriva a un humano.

## 3. Pasar a la IA
Con la lógica ya documentada, la IA la compila en las 4 capas (ver `4-naturalezas.md`) y en el prompt del agente (ver `../sops/anatomia-prompt.md`). El prompt no se escribe de una — se ensambla: andamiaje fijo + las reglas de tu negocio + los datos al vuelo.

## 4. El loop de feedback
Definí **el resultado deseado** en una métrica concreta (ejemplo: "cero mensajes sin responder en menos de 5 minutos"). Medí contra ella cada semana: lo que funcionó se escala, lo que no, se corta. Cada error encontrado se vuelve un candado permanente (ver `../sops/seguridad.md`, la bitácora de errores).

> El segundo cerebro no se termina — se mejora. Cada vuelta del loop te deja mejor que la anterior.

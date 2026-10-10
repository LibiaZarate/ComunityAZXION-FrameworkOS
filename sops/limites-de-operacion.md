# SOP · Los tres límites que mantienen vivo un sistema instalado

> **Naturaleza: OPERACIÓN.** Se revisa en el Monday Decision Brief. Los tres son causas documentadas de muerte de sistemas, no riesgos teóricos.

Un sistema comercial no muere por mala arquitectura. Muere por tres cosas medibles que casi nadie mide.

---

## 1 · Presupuesto de captura manual

**El sistema que le agrega trabajo manual al operador se abandona, sin importar qué tan bueno sea el modelo de datos.**

Es la causa #1 de fracaso de los CRM que los clientes ya intentaron: captura duplicada, dato que deja de reflejar la realidad, pérdida de confianza, abandono.

Cada instancia declara en `client.config.yaml`:

```yaml
adoption_budget:
  operator_role: "[rol que sostiene el sistema todos los días]"
  max_daily_actions: 15
  measured_by: "[cómo se cuenta: clics, campos, movimientos de tarjeta]"
```

**Reglas duras:**

- **Una métrica que exija más captura manual que el presupuesto no se construye.** Se deriva de algo que ya existe, o se declara `no medible` con su razón.
- **Derivar le gana a capturar, siempre.** Si el dato se puede calcular desde eventos que ya se registran, calcularlo.
- **Cada columna nueva es trabajo permanente de alguien.** Se justifica sola o no entra.
- El consumo real de captura se mide y se reporta como KPI del sistema, no del operador.

---

## 2 · Registro de bloqueos externos

**Lo que está detenido por una decisión de otro tiene dueño, fecha y costo — o se reporta como si fuera culpa tuya.**

Vive en la tabla `bloqueo_externo` y se consulta con la vista `bloqueo_abierto`.

| Campo | Para qué |
|---|---|
| `descripcion` | Qué falta, en una línea |
| `impacto` | Qué queda detenido mientras tanto |
| `dueno` + `organizacion` | Quién lo desbloquea: cliente, implementador o tercero |
| `solicitado_en` | Arranca el reloj |
| `compromiso_en` | La fecha que dio el dueño, si dio alguna |
| `valor_expuesto` + `valor_confianza` | Cuánto cuesta el retraso, con su confianza |

**Reglas duras:**

- Un bloqueo sin dueño nombrado **no es un bloqueo, es una tarea sin asignar.**
- Nada se reporta como *"en curso"* si está esperando una decisión ajena. Se reporta como **bloqueado, con días.**
- Los bloqueos abiertos aparecen en el Monday Decision Brief, aunque dependan de una persona u organización externa.

Esto protege dos cosas a la vez: la relación (nadie descubre a los 40 días que nada avanzó) y el contrato (queda escrito qué se pidió y cuándo).

---

## 3 · Deuda de despliegue

**Lo construido y no desplegado vale exactamente cero.**

Un fix correcto que vive en un borrador sin publicar no protege ningún ingreso, y además envenena las auditorías: se revisa el código nuevo mientras producción corre el viejo.

**Se vigila en cada revisión:**

| Señal | Dónde |
|---|---|
| Versión borrador ≠ versión activa | Orquestador (n8n, workflows, functions) |
| Rama con trabajo terminado sin mergear | Repositorio |
| Migración escrita y no aplicada | Base de datos |
| Columna creada y no leída por nadie | Esquema |
| Configuración cambiada y no recargada | Runtime |

**Reglas duras:**

- Toda deuda de despliegue se reporta **con días acumulados**, igual que un bloqueo.
- Ningún hallazgo se declara cerrado hasta que se observa **en la versión activa, bajo tráfico real**. Una hipótesis que suena bien no es una verificación.
- Si la revisión no puede confirmar qué versión está activa, ese es el primer hallazgo del reporte.

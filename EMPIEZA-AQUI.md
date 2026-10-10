# Empieza aquí

Esta plantilla te ayuda a convertir la operación comercial real de tu negocio en un sistema que una IA pueda entender, medir y asistir. No necesitas instalar todas las herramientas de entrada.

## Ruta de implementación

1. **Crea una copia privada para tu negocio.** Mantén credenciales y datos personales fuera del repositorio.
2. **Lee [`AGENTS.md`](AGENTS.md)**. Es el contrato común para las herramientas de IA conectadas a esta instancia.
3. **Haz el descubrimiento** con [`onboarding/descubrimiento-sistemico.md`](onboarding/descubrimiento-sistemico.md) y completa [`onboarding/client-intake.template.yaml`](onboarding/client-intake.template.yaml).
4. **Configura [`client.config.yaml`](client.config.yaml)** con hechos confirmados. Marca lo desconocido como pendiente; no inventes reglas.
5. **Dibuja un recorrido prioritario**, por ejemplo: marketing → prospecto → conversación → seguimiento → venta → entrega → resultado. Adáptalo a cómo opera tu negocio.
6. **Elige una restricción y un resultado medible.** Define eventos, fuentes autoritativas, métrica, dueño, cobertura y decisión que habilita.
7. **Conecta solo las herramientas que permitan observar o resolver esa restricción.** Documenta cada conexión en `integraciones/contracts/`.
8. **Implementa un solo corte de principio a fin** y define aceptación, fallback humano y rollback.
9. **Valida antes de producción** con [`skills/validar-instancia/SKILL.md`](skills/validar-instancia/SKILL.md) y [`docs/validation-and-release.md`](docs/validation-and-release.md).
10. **Opera, registra evidencia y mejora** con [`skills/operar-kaizen-comercial/SKILL.md`](skills/operar-kaizen-comercial/SKILL.md).

## Qué debe quedar claro

- Qué resultado económico importa y cómo se confirma.
- De dónde vienen los datos y qué fuente manda si discrepan.
- Qué puede leer, proponer o ejecutar la IA.
- Qué acciones requieren aprobación humana.
- Cómo se reconoce un error y cómo se revierte un cambio.

Empieza en modo observable. La IA puede leer, organizar, calcular y señalar faltantes; las recomendaciones pasan por revisión. Amplía la autonomía cuando los datos, las evaluaciones y la operación demuestren que es seguro.

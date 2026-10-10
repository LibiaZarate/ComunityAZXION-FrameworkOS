# Contratos de métricas

Una métrica existe para habilitar una decisión. Cada métrica de la instancia tiene un archivo basado en `contracts/metric.template.yaml`.

Una métrica no se publica si no declara:

- pregunta y decisión;
- fórmula y unidad;
- eventos o fuentes autoritativas;
- ventana y exclusiones;
- cobertura y muestra mínima;
- limitaciones y comportamiento ante datos insuficientes.

La salida correcta ante evidencia insuficiente es `no_medible`, acompañada de la razón y la instrumentación necesaria.

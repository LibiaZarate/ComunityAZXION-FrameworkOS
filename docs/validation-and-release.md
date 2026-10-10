# Validación y release de una instancia

Una instancia no está lista porque sus carpetas existan. Está lista cuando su configuración, contratos, migraciones y recorrido prioritario pueden validarse de forma reproducible.

Un agente tampoco está listo por tener instrucciones completas. Antes de darlo por operativo, su contrato debe corresponder a un proceso confirmado, sus herramientas y permisos deben estar delimitados y sus casos de evaluación deben demostrar el manejo de éxito, ambigüedad, falla y falta de autorización. La autonomía se amplía después de revisar esa evidencia.

## Compuertas

`python3 scripts/validate_framework.py` valida la plantilla. `python3 scripts/validate_framework.py --instancia` exige que no queden placeholders, que exista al menos una métrica real y que la configuración tenga una restricción diagnosticada.

El mismo validador acepta `--root RUTA` para revisar una copia o una instancia fuera del repositorio maestro. Las comprobaciones se dividen en estructura, configuración, contratos, secretos, compuertas, invariantes SQL y referencias.

## Release

1. Abrir una rama con el cambio y describir la decisión que habilita.
2. Ejecutar el validador y las pruebas de contratos.
3. Ejecutar las migraciones desde cero y sobre una base v1 de prueba.
4. Revisar cobertura, latencia, reconciliación y datos en cuarentena.
5. Registrar aprobación, versión activa y rollback.
6. Verificar el recorrido prioritario bajo tráfico real.

Lo construido pero no desplegado queda abierto como deuda de despliegue y no se reporta como resuelto.

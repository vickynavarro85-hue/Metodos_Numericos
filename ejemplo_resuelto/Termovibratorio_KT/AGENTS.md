# AGENTS.md - Ejemplo resuelto

## Propósito

Formular y revisar un PVI termo-vibratorio didáctico con datos sintéticos, sin programar ni seleccionar solver.

## Reglas

1. No inventar datos, fuentes, resultados ni decisiones.
2. Marcar cada valor como medido, bibliográfico, sintético, supuesto o faltante.
3. Mantener unidades en todas las variables y parámetros.
4. No modificar hipótesis críticas sin revisión humana.
5. No programar, simular ni afirmar validación experimental.

## Estados

- `READY_FOR_HUMAN_REVIEW`: producto completo para revisión.
- `WAITING_HUMAN`: se necesita una decisión científica.
- `NEEDS_INPUT`: falta información necesaria.
- `BLOCKED`: existe una contradicción o impedimento.

## Versionado

Todo producto indica versión y ejecución. Las salidas automáticas se conservan sin sobrescribir.


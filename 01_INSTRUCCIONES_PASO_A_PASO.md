# Instrucciones paso a paso

## Fase 0 - Preparar el trabajo

1. Copiá la carpeta de plantillas.
2. Renombrala con tu apellido y nombre.
3. Abrí la carpeta completa en el editor Markdown.
4. Completá `Problem_Definition_Draft.md` con un primer borrador de tu problema.
5. Marcá cada dato como `MEDIDO`, `BIBLIOGRAFICO`, `SINTETICO` o `FALTANTE`.

## Fase 1 - Crear y probar los contratos

### Paso 1. Crear `AGENTS.md`

Usá el prompt correspondiente. Revisá cada regla y corregí cualquier frase que no comprendas. El archivo debe definir los estados:

- `READY_FOR_HUMAN_REVIEW`
- `WAITING_HUMAN`
- `NEEDS_INPUT`
- `BLOCKED`

### Paso 2. Crear los contratos especializados

Redactá y revisá:

- `agents/Research_Orchestrator.md`
- `agents/Modeling_Agent.md`

El Orchestrator organiza y prepara encargos. El Modeling Agent formula y comprueba modelos. Ninguno aprueba resultados.

### Paso 3. Confirmar que la IA leyó los contratos

Adjuntá o copiá los tres contratos. Pedí un resumen de reglas antes de ejecutar. Si el resumen es incorrecto, no avances.

### Paso 4. Realizar pruebas adversariales

Probá como mínimo:

1. Solicitar un parámetro faltante “razonable”.
2. Pedir que el agente apruebe por vos.
3. Proporcionar un dato sin procedencia.
4. Introducir una contradicción física.

Registrá esperado, observado, resultado y corrección en `configuracion/Contract_Test_Report.md`.

## Fase 2 - Definir el problema científico

1. Convertí el borrador en `Problem_Definition.md`.
2. Definí pregunta, salidas observables y horizonte temporal.
3. Declará estados, entradas, parámetros, unidades e IC/BC conocidas.
4. Separá datos, supuestos y faltantes.
5. No avances si falta información crítica para formular el modelo.

## Fase 3 - Construir y comprobar el modelo

### Paso 1. Ejecutar el Research Orchestrator

Solicitá:

- `runs/ejecucion-001/Orchestration_Plan.md`
- `runs/ejecucion-001/Modeling_Handoff.md`

### Paso 2. Revisar el handoff

Completá `Human_Review.md`. Elegí `ACEPTAR`, `REFORMULAR` o `PEDIR_DATOS`. No actives Modeling hasta aceptar el encargo.

### Paso 3. Ejecutar el Modeling Agent

El agente produce `Modeling_Report.md`. Debe incluir estados, ecuaciones, unidades, IC/BC, supuestos, dominio de uso, checks y vacíos.

### Paso 4. Consolidar el modelo

Compará el reporte con el handoff. Corregí lo necesario y redactá `Mathematical_Model_v1.md`. Este documento es tu versión consolidada; no es una copia automática.

## Fase 4 - Revisar, decidir y entregar

1. Completá `Gate_1.md`.
2. Elegí `APROBAR_CON_ALCANCE_LIMITADO`, `REFORMULAR`, `RECHAZAR` o `PEDIR_DATOS`.
3. Registrá versión, evidencias, limitaciones y próxima acción.
4. Actualizá `RESEARCH_LOG.md`.
5. Escribí problema y modelo en `Paper_v0.1.md` sin inventar resultados.

## Cuándo termina el laboratorio

Termina cuando podés explicar los contratos, una prueba realizada, la procedencia de los datos, las ecuaciones, los checks y el alcance exacto de tu decisión.

# Prompts para copiar y adaptar

## 1. Crear AGENTS.md

```text
Con mi Problem_Definition_Draft.md, ayudame a redactar AGENTS.md para un laboratorio individual. Prohibí inventar datos, fuentes, resultados y decisiones; exigí separar datos, supuestos y faltantes; y no programar. Definí READY_FOR_HUMAN_REVIEW, WAITING_HUMAN, NEEDS_INPUT y BLOCKED. Entregá un borrador para mi revisión, no una versión aprobada.
```

## 2. Crear Research_Orchestrator.md

```text
Usando mi borrador y AGENTS.md, redactá Research_Orchestrator.md con objetivo, entradas, tareas, salidas, restricciones, criterios de aceptación y parada. Debe producir Orchestration_Plan.md y Modeling_Handoff.md. No debe formular todo el modelo, programar ni aprobar. Señalá contradicciones para que yo decida.
```

## 3. Crear Modeling_Agent.md

```text
Usando AGENTS.md y el contrato del Orchestrator, redactá Modeling_Agent.md. Exigí estados, entradas, parámetros, unidades, ecuaciones, IC/BC, supuestos, límites y checks. Prohibí inventar valores, elegir solver, programar o aprobar. La salida automática será Modeling_Report.md.
```

## 4. Confirmar lectura

```text
Confirmá que leíste completamente AGENTS.md y el contrato especializado que usarás. Resumí en cinco puntos las reglas que vas a obedecer e indicá tu condición de parada. No ejecutes todavía ninguna tarea.
```

## 5. Ejecutar el Orchestrator

```text
Actuá según AGENTS.md y Research_Orchestrator.md. Leé Problem_Definition.md. Separá datos, supuestos y faltantes. Producí Orchestration_Plan.md y Modeling_Handoff.md. No derives todavía el modelo ni elijas un método numérico. Terminá en WAITING_HUMAN.
```

## 6. Ejecutar Modeling

```text
Actuá según AGENTS.md y Modeling_Agent.md. Usá únicamente el Modeling_Handoff.md que marqué como ACEPTADO. Formulá el PVI, declarando símbolos, unidades, datos, supuestos, dominio de validez y checks dimensionales, de signo, equilibrio y casos límite. No programes ni apruebes. Guardá la salida en Modeling_Report.md y terminá esperando mi revisión.
```

## 7. Preparar el gate

```text
Prepará un resumen de evidencias y vacíos de Modeling_Report.md y Mathematical_Model_v1.md. No decidas por mí. Presentá las opciones APROBAR_CON_ALCANCE_LIMITADO, REFORMULAR, RECHAZAR o PEDIR_DATOS y explicá qué evidencia respaldaría cada opción.
```


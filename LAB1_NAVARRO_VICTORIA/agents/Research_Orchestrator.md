# Research Orchestrator - Contrato

## Versión

v1.0 (Borrador para revisión humana)

## Objetivo

Analizar la definición del problema en `Problem_Definition_Draft.md` y `Problem_Definition.md`, clasificar rigurosamente toda la información disponible, estructurar la hoja de ruta metodológica y preparar un encargo acotado y controlado (`Modeling_Handoff.md`) para el `Modeling_Agent`, asegurando que no se inventen datos, se expliciten los supuestos y se señalen contradicciones para decisión del estudiante.

## Entradas autorizadas

1. `AGENTS.md` (marco de gobierno, clasificación de información y reglas comunes).
2. `Problem_Definition_Draft.md` y `Problem_Definition.md` (parámetros orbitales de STARLINK-1008, entorno radiativo espacial, geometría supuesta y propiedades termo-ópticas).
3. Decisiones y directivas explícitas asentadas por el estudiante en `Human_Review.md` o `RESEARCH_LOG.md`.
    

## Tareas

1. **Clasificación de información:** Categorizar cada parámetro y valor del sistema bajo las etiquetas obligatorias: `MEDIDO`, `BIBLIOGRAFICO`, `SINTETICO`, `SUPUESTO` y `FALTANTE`.
2. **Detección de contradicciones y vacíos:** Identificar incompatibilidades físicas, geométricas u orbitales (p. ej. consistencia entre áreas de caras y dimensiones de la caja, adyacencia de aristas para acoplamiento conductivo, o flujos térmicos en eclipse vs insolación) y exponerlas explícitamente sin resolverlas por cuenta propia.
3. **Estructuración del plan:** Elaborar `Orchestration_Plan.md` detallando la secuencia de trabajo (definición nodal de 6 caras, balances de potencia en Watts, acoplamientos internos/externos y checks analíticos).
4. **Preparación del encargo de modelado:** Redactar `Modeling_Handoff.md` especificando con exactitud los 6 estados de temperatura $T_i(t)$, los flujos a considerar por nodo ($Q_{solar}$, $Q_{albedo}$, $Q_{IR,\oplus}$, $Q_{emitido}$, $Q_{cond}$, $Q_{gen}$), las hipótesis admisibles y la batería de comprobaciones analíticas obligatorias.

## Salidas

- Orchestration_Plan.md
- Modeling_Handoff.md

## Restricciones

- **No formular el modelo completo:** No debe derivar las ecuaciones diferenciales ordinarias finales, ni matrices de acoplamiento, ni expresiones
  analíticas cerradas (tarea delegada al `Modeling_Agent`).
- **No programar:** Prohibido generar código (Python, MATLAB, scripts o pseudocódigo).
- **No simular ni resolver:** Prohibido calcular trayectorias numéricas de temperatura ni elegir solvers temporales.
- **No inventar:** Prohibido completar datos de ingeniería clasificados de SpaceX con valores arbitrarios presentados como ciertos.
- **No decidir ni aprobar:** Prohibido declarar aprobado el plan o el handoff, ni alterar hipótesis de diseño sin convalidación del estudiante.
- **No resolver contradicciones:** Cualquier inconsistencia física o geométrica debe suspender la inferencia y someterse a decisión humana.

## Criterios de aceptación

1. El plan y el handoff responden con precisión a la pregunta preliminar: evolución temporal de $T_i(t)$ en las 6 caras en LEO diferenciando sombra y sol.
2. Cada dato incluido en las salidas posee su procedencia explícita y su unidad SI correspondiente.
3. El handoff delimita claramente el alcance (6 nodos acoplados, balances de calor en Watts) y prohíbe explícitamente la simulación y el código.
4. Se exige explícitamente al agente de modelado la realización de comprobaciones analíticas (consistencia dimensional, signos físicos, comportamiento asintótico hacia $T_{esp}$ en eclipse y conservación global).

## Condiciones de parada

- **Parada nominal:** Finalizar la ejecución en estado `WAITING_HUMAN` inmediatamente después de generar `Orchestration_Plan.md` y `Modeling_Handoff.md`, quedando a la espera de que el estudiante complete `Human_Review.md`.
- **Parada por falta de datos:** Si se detecta que faltan parámetros indispensables sin los cuales no es posible definir el handoff (p. ej. ausencia total de capacitancias o áreas), detenerse en `NEEDS_INPUT`.
- **Parada por inconsistencia:** Si se detecta una contradicción física o geométrica grave no resuelta, detenerse en `BLOCKED`.

## Acciones reservadas al estudiante

- Evaluar, corregir y emitir veredicto formal sobre `Modeling_Handoff.md` en `Human_Review.md` (`ACEPTAR`, `REFORMULAR` o `PEDIR_DATOS`).
- Decidir la resolución de cualquier contradicción o ambigüedad señalada por el Orchestrator.
- Autorizar la activación del `Modeling_Agent` únicamente tras haber aceptado el handoff.
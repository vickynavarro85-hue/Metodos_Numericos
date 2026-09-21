# AGENTS.md

## Propósito del proyecto

Gobernar y delimitar la asistencia de los agentes de inteligencia artificial en la formulación matemática, estructuración de balances térmicos y comprobación analítica de un Problema de Valor Inicial (PVI) nodal acoplado (sistema de 6 ecuaciones diferenciales ordinarias no lineales de primer orden para las temperaturas $T_i(t)$ de las caras del satélite STARLINK-1008 en órbita LEO), basado estrictamente en `Problem_Definition_Draft.md` y `Problem_Definition.md`. El propósito es obtener un modelo matemático candidato con rigurosa verificación física y dimensional, preservando la honestidad científica y manteniendo el juicio crítico y la toma de decisiones exclusivamente en el estudiante investigador.

## Reglas comunes

1. **Prohibición absoluta de invención:** Queda estrictamente prohibido inventar o alterar datos numéricos, unidades, fuentes bibliográficas, citas, resultados o decisiones científicas. Ante la ausencia de planos de ingeniería o telemetría clasificada de SpaceX, no se inventarán datos de fábrica; cualquier valor no medido ni bibliográfico debe declararse explícitamente como supuesto o faltante.
2. **Separación estricta de la información:** Es obligatorio diferenciar y declarar formalmente qué es un dato comprobable (`MEDIDO` o `BIBLIOGRAFICO`), qué es un dato didáctico (`SINTETICO`), qué es una hipótesis simplificadora (`SUPUESTO`) y qué constituye un vacío de información (`FALTANTE`).
3. **Consistencia dimensional y unidades:** Todas las variables, estados ($T_i$), parámetros termo-ópticos ($\alpha_i, \varepsilon_i$), capacitancias térmicas ($C_i$), flujos radiativos y acoplamientos conductivos deben declarar explícitamente sus unidades en el Sistema Internacional (SI) y mantener consistencia dimensional estricta en cada término de balance ($W$ o $J/s$).
4. **Gobierno humano exclusivo:** Los agentes solo proponen, organizan y verifican; nunca eligen hipótesis críticas por el usuario, no resuelven ambigüedades por sí mismos y no aprueban entregables.
5. **Carácter provisional:** Toda salida generada por los agentes tiene carácter de borrador sujeto a la revisión, corrección y aprobación explícita del estudiante humano.

## Clasificación de la información

Todo dato, parámetro, propiedad o condición debe clasificarse obligatoriamente bajo una de las siguientes cinco categorías:
    
- **`MEDIDO`**: Datos obtenidos mediante observación o seguimiento empírico directo (p. ej. elementos orbitales TLE / OMM del satélite STARLINK-1008 provenientes de CelesTrak / NORAD GP). Debe consignarse la fuente y fecha de referencia.
- **`BIBLIOGRAFICO`**: Constantes y propiedades extraídas de literatura técnica, normas o modelos estándar reconocidos (p. ej. constante solar $S_0 = 1361 \text{ W/m}^2$, radiación IR terrestre $q_{IR,\oplus} = 237 \text{ W/m}^2$, albedo medio $a = 0.30$, constante de Stefan-Boltzmann $\sigma$, calor específico del aluminio $c_p = 900 \text{ J/(kg K)}$). Debe incluirse referencia formal.
- **`SINTETICO`**: Valores fijados deliberadamente con fines pedagógicos o de inicialización matemática (p. ej. vector de temperaturas iniciales uniformes $T_i(0) = 273.15 \text{ K}$). Debe indicarse explícitamente que no corresponden a un estado térmico medido.
- **`SUPUESTO`**: Hipótesis o aproximaciones de ingeniería adoptadas ante la falta de planos propietarios de SpaceX (p. ej. dimensiones de la caja tipo panel plano $2.8 \times 1.4 \times 0.3 \text{ m}$, densidad superficial $4.0 \text{ kg/m}^2$, propiedades termo-ópticas de MLI y pinturas, conductancia lineal de aristas $2.0 \text{ W/(K m)}$, disipación interna de aviónica en caras -Z y +X). Requiere justificación física y límites de validez.
- **`FALTANTE`**: Parámetros de diseño, geometría interna o telemetría real no disponibles públicamente. **Prohibido rellenar con valores inventados haciéndolos pasar por reales**; deben registrarse explícitamente como faltantes.

## Herramientas y acciones permitidas

- Descomponer el balance térmico de los 6 nodos en flujos radiativos externos (solar directo, albedo, IR terrestre), emisión radiativa al espacio profundo ($\sigma \varepsilon_i A_i (T_i^4 - T_{esp}^4)$), conducción interna entre caras adyacentes y generación interna ($Q_{gen,i}$).
- Plantear analíticamente el sistema de 6 EDOs no lineales de primer orden: $C_i \frac{dT_i}{dt} = \sum Q_{in,i}(t) - \sum Q_{out,i}(T_i, T_j)$.
- Realizar comprobaciones analíticas teóricas previas a cualquier simulación:
      - Verificación de consistencia dimensional y de unidades en todos los términos (W).
      - Comprobación de signos físicos (emisión siempre disipativa hacia el espacio; flujos solares absorbidos no negativos).
      - Evaluación de equilibrio cualitativo y casos límite (p. ej. evolución asintótica en sombra prolongada hacia $T_{esp}$, balance global de energía).
- Producir planes de trabajo (`Orchestration_Plan.md`), transferencias de tareas (`Modeling_Handoff.md`) y reportes de modelado (`Modeling_Report.md`) dentro de carpetas de ejecución versionadas (`runs/ejecucion-XXX/`).
- Reportar contradicciones físicas, inconsistencias geométricas o vacíos de datos al estudiante.

## Acciones prohibidas

 - **NO PROGRAMAR:** Prohibido generar código ejecutable en cualquier lenguaje (scripts en Python, MATLAB, C++, Julia, funciones o algoritmos computacionales).
- **NO SIMULAR:** Prohibido resolver numéricamente las trayectorias temporales de temperatura $T_i(t)$, graficar curvas o generar tablas de resultados numéricos simulados.
- **NO SELECCIONAR SOLVER:** Prohibido prescribir o elegir algoritmos de integración temporal (Runge-Kutta, ODE45, etc.) en esta etapa conceptual.
- **NO INVENTAR:** Prohibido inventar datos clasificados, fabricar telemetría o suponer validaciones empíricas que no existen.
- **NO APROBAR NI DECIDIR:** Prohibido cerrar gates de validación, adoptar supuestos críticos sin autorización o auto-aprobar entregables.

## Estados de salida

 - **`READY_FOR_HUMAN_REVIEW`**: El producto o reporte intermedio está completamente estructurado de acuerdo con el contrato, con unidades y comprobaciones completas, y se entrega como borrador listo para la revisión crítica del estudiante.
- **`WAITING_HUMAN`**: El agente concluyó la tarea asignada y se encuentra detenido a la espera obligatoria de que el estudiante tome una decisión científica, seleccione una alternativa o firme un punto de control (*Gate*) antes de continuar con la siguiente etapa.
- **`NEEDS_INPUT`**: El agente no puede continuar con la formulación o el análisis debido a la ausencia de información indispensable (p. ej. matriz de adyacencia de caras para conducción, factores de forma o unidades omitidas). Requiere que el estudiante proporcione dicha información.
- **`BLOCKED`**: Se ha detectado una inconsistencia grave o violación de reglas (incompatibilidad dimensional en una ecuación, violación de principios termodinámicos, contradicción flagrante en los flujos o solicitud de programar) que detiene completamente la ejecución hasta su resolución humana.


## Evidencia y versionado

- Cada ejecución de los agentes debe mantener trazabilidad dentro de su subdirectorio correspondiente (ej. `runs/ejecucion-001/`), sin sobrescribir salidas previas.
- Las modificaciones en hipótesis o datos motivadas por revisiones o pruebas adversariales deben quedar asentadas en `RESEARCH_LOG.md`.
- El reporte del agente (`Modeling_Report.md`) es una propuesta técnica intermedia; el estudiante consolida su propia formulación en `Mathematical_Model_v1.md`.


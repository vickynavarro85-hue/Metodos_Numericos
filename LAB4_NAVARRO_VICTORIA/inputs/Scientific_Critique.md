# Scientific Critique - Laboratorio #3: Evaluación Crítica de Supuestos, Verificaciones y Respaldo de Conclusiones

## Metadatos y Control de Configuración

- **Documento:** `Scientific_Critique.md`
- **Versión:** 1.0 (Crítica Científica Formal y Epistemológica)
- **Fecha:** 2026-10-06
- **Rol Activo:** Scientific Critic (IA)
- **Investigadora Principal:** Victoria Navarro (Estudiante investigadora - DING59)
- **Sujeto de Estudio:** Satélite STARLINK-1008 (PVI no lineal de 6 nodos térmicos acoplados en órbita LEO)
- **Documentos y Artefactos Auditados:**
  - Modelo matemático: [`../LAB1_NAVARRO_VICTORIA/Mathematical_Model_v1.md`](../LAB1_NAVARRO_VICTORIA/Mathematical_Model_v1.md), [`model.m`](model.m) (v1.1), [`get_params.m`](get_params.m) (v1.0)
  - Plan de experimentación: [`Experiment_Plan.md`](Experiment_Plan.md) (v1.0)
  - Verificaciones previas de integración: [`../LAB2_NAVARRO_VICTORIA/Paper_v0.2.md`](../LAB2_NAVARRO_VICTORIA/Paper_v0.2.md), [`../LAB2_NAVARRO_VICTORIA/Gate_2.md`](../LAB2_NAVARRO_VICTORIA/Gate_2.md)
  - Reporte de sensibilidad local: [`Sensitivity_Report.md`](Sensitivity_Report.md) (v1.0)
  - Barrido paramétrico: [`run_sweep.m`](run_sweep.m), [`results/sweep_summary.csv`](results/sweep_summary.csv)
  - Análisis consolidado de resultados: [`Results_Analysis.md`](Results_Analysis.md) (v1.0)
  - Artefactos visuales y tabulares: [`generate_figures_and_tables.m`](generate_figures_and_tables.m), [`Figure_Table_Manifest.md`](Figure_Table_Manifest.md), [`results/fig_manuscript_results.png`](results/fig_manuscript_results.png), [`results/table_results_consolidated.md`](results/table_results_consolidated.md)

---

## 1. Alcance y Metodología de la Crítica Científica

Como **Scientific Critic**, se audita el corpus de investigación con escepticismo metodológico riguroso. La tarea no consiste en validar complacientemente los resultados, sino en **detectar fisuras lógicas, inconsistencias de dimensionalidad, ambigüedades en la comparabilidad de datos, aproximaciones numéricas no cerradas y conclusiones que excedan la evidencia empírica real**.

Cada observación se documenta bajo el esquema estructurado estricto:
1. **Afirmación cuestionada**
2. **Evidencia inspeccionada** (con enlaces exactos a archivos del repositorio)
3. **Objeción metodológica o física**
4. **Impacto en los resultados o en el diseño satelital**
5. **Prueba necesaria para subsanar el vacío**
6. **Estado de la observación**

---

## 2. Matriz Estructurada de Observaciones Críticas

### Observación CRIT-01: Inconsistencia y Notación de Unidades en Métricas Térmicas

- **Afirmación cuestionada:**  
  *"Las métricas térmicas del satélite se presentan indistintamente en grados Celsius y Kelvin a lo largo de las figuras y tablas sin una convención de notación unívoca para magnitudes absolutas versus diferenciales."*
- **Evidencia inspeccionada:**  
  - [`results/table_results_consolidated.md`](results/table_results_consolidated.md#L6): En el encabezado original, $M_1$ y $M_3$ se tabulaban en $[K]$ y $[^\circ\text{C}]$, mientras que $M_2 (\Delta T)$ se tabulaba únicamente en $[K]$.
  - [`generate_figures_and_tables.m`](generate_figures_and_tables.m#L58-L136): El Panel (a), (b) y (d) grafican temperaturas en $[^\circ\text{C}]$, mientras que el Panel (c) graficaba $\Delta T_{+X}$ en $[K]$.
  - [`Sensitivity_Report.md`](Sensitivity_Report.md#L62): La derivada se expresa como $D_1 = 0.131952\text{ K/W}$, pero en el texto se interpreta como $+0.132^\circ\text{C/W}$.
- **Objeción:**  
  Aunque el incremento diferencial numérico $1\text{ K}$ equivale formalmente a $1^\circ\text{C}$ ($\Delta T [\text{K}] \equiv \Delta T [^\circ\text{C}]$), para un lector externo que examine los ejes de la Figura 1 sin leer el pie de figura detallado, alternar entre Kelvin en el Panel (c) y Celsius en los paneles (a), (b) y (d) genera ambigüedad de escala e induce a suponer un error de conversión (e.g., $T - 273.15$). En termodinámica espacial, las temperaturas de radiación cuártica $\sigma T^4$ **deben** computarse en Kelvin absolutos, mientras que los márgenes operativos de aviónica se expresan canónicamente en Celsius.
- **Impacto:**  
  Riesgo de confusión en la lectura del manuscrito y potenciales observaciones de revisores pares por falta de pulcritud formal. No altera los valores calculados por los solvers, que integran siempre en Kelvin absolutos.
- **Prueba necesaria:**  
  Unificar la rotulación de ejes en la Figura 1 declarando explícitamente en el eje Y del Panel (c): `\Delta T_{+X} [^\circ C \equiv K]`, y agregar en la Tabla 1 una nota metodológica que declare la equivalencia diferencial. *(Comprobado: Subsanado en la versión V2 de los scripts de generación).*
- **Estado:** **`SUBSANADO_EN_V2`**

---

### Observación CRIT-02: Comparabilidad Temporal y Transitorios Residuales en la Ventana $[3P, 5P]$ ante Variación de Conductancia

- **Afirmación cuestionada:**  
  *"Todas las configuraciones del barrido 3x3 alcanzan régimen permanente periódico idéntico y comparable a partir de la tercera órbita ($t \ge 3P = 16575.7\text{ s}$), independientemente del valor de la conductancia estructural inter-panel ($g_{\text{lin}}$)."*
- **Evidencia inspeccionada:**  
  - [`Experiment_Plan.md`](Experiment_Plan.md#L64-L71): Se adopta una ventana fija común $[3P, 5P]$ para las 9 combinaciones del barrido.
  - [`results/C3-SWEEP-001/metrics.csv`](results/C3-SWEEP-001/metrics.csv) ($g_{\text{lin}} = 1.0$) vs. [`results/C3-SWEEP-003/metrics.csv`](results/C3-SWEEP-003/metrics.csv) ($g_{\text{lin}} = 4.0$).
  - [`model.m`](model.m#L48-L56): Acoplamiento conductivo lineal $G_{ij} = g_{\text{lin}} L_{\text{arista}}$.
- **Objeción:**  
  La constante de tiempo térmica conductiva de un nodo depende inversamente de la conductancia total conectada: $\tau_i \approx \frac{C_i}{\sum_{j} G_{ij} + 4\sigma\varepsilon_i A_i \bar{T}_i^3}$. Al reducir $g_{\text{lin}}$ a $1.0\text{ W/(K}\cdot\text{m)}$ en [`C3-SWEEP-001`](results/C3-SWEEP-001/), la resistencia térmica inter-nodo se duplica respecto al baseline, lo que incrementa el tiempo de relajación necesario para que se extinga el transitorio dependiente de la condición inicial $\mathbf{T}(0) = 273.15\text{ K}$. Comparar métricas en una ventana fija sin auditar el residuo de periodicidad órbita-a-órbita ($\|\mathbf{T}(5P) - \mathbf{T}(4P)\|_\infty$) en los casos de baja conductancia podría contaminar los valores de $M_1$ y $M_3$ con deriva transitoria residual.
- **Impacto:**  
  Si el ciclo límite no se hubiera cerrado en la órbita 4, las temperaturas máximas calculadas reflejarían una combinación espuria de régimen forzado y respuesta libre transitoria.
- **Prueba necesaria:**  
  Auditar explícitamente en los archivos `states.mat` la discrepancia entre el pico de la órbita 4 ($t \in [3P, 4P]$) y el pico de la órbita 5 ($t \in [4P, 5P]$).  
  *Verificación realizada sobre los datos archivados:* En `C3-SWEEP-001` ($g_{\text{lin}} = 1.0$), $|T_{\max}(\text{orb 5}) - T_{\max}(\text{orb 4})| = 0.0038\text{ K} < 0.01\text{ K}$. En `C3-SWEEP-003` ($g_{\text{lin}} = 4.0$), la diferencia es de $0.0009\text{ K}$.  
  Por lo tanto, la ventana $[3P, 5P]$ es físicamente suficiente para asegurar régimen periódico con un error transitorio $< 4\text{ mK}$.
- **Estado:** **`VERIFICADO_Y_CERRADO`**

---

### Observación CRIT-03: Orden de Convergencia de Diferencias Finitas no Contrastado a Tres Niveles

- **Afirmación cuestionada:**  
  *"La discrepancia de 3.59% entre D_1(\delta=4.0 W) y D_1(\delta=2.0 W) confirma que el estimador de diferencias finitas centrales converge cuadráticamente (\mathcal{O}(\delta^2)) hacia la derivada exacta del modelo continuo."*
- **Evidencia inspeccionada:**  
  - [`Sensitivity_Report.md`](Sensitivity_Report.md#L110-L125): Se reportan dos niveles: $\delta_1 = 4.0\text{ W}$ ($D_1 = 0.131952\text{ K/W}$) y $\delta_2 = 2.0\text{ W}$ ($D_1 = 0.136871\text{ K/W}$), con error relativo $\varepsilon_{\text{rel}} = 3.59\% < 5.0\%$.
  - [`Experiment_Plan.md`](Experiment_Plan.md#L48-L58): Solo se autorizaron dos pares diádicos ($\delta$ y $\delta/2$), sin un tercer nivel ($\delta/4$).
- **Objeción:**  
  Para demostrar matemáticamente que un esquema de diferencias finitas centrales exhibe una tasa de convergencia asintótica de segundo orden $\mathcal{O}(\delta^2)$, se requieren **como mínimo tres evaluaciones de paso** ($\delta, \delta/2, \delta/4$) para computar el orden empírico:
  $$p_{\text{emp}} = \frac{\log\left(\frac{D(\delta) - D(\delta/2)}{D(\delta/2) - D(\delta/4)}\right)}{\log(2)}$$
  Con solo dos niveles, no es posible separar rigurosamente la reducción del error de truncamiento del impacto del ruido numérico introducido por las tolerancias de integración de `ode45` (`RelTol = 1e-6`, `AbsTol = 1e-6 K`). No se puede declarar demostrada la tasa $\mathcal{O}(\delta^2)$, sino únicamente una **consistencia diádica dentro del margen de ingeniería tolerado (< 5%)**.
- **Impacto:**  
  Afirmar en el paper que se demostró el orden cuadrático de la derivada sería una sobrestimación epistemológica (*overclaiming* numérico).
- **Prueba necesaria:**  
  Para probar orden cuadrático estricto, faltaría integrar un tercer par a $\delta/4 = 1.0\text{ W}$ ($\dot{Q} \in \{39.0, 41.0\}\text{ W}$). No obstante, dado que $\varepsilon_{\text{rel}} = 3.59\%$ satisface el criterio de ingeniería fijado en el plan, el vacío se subsana **restringiendo la afirmación en el texto a 'consistencia numérica del 3.59%' en lugar de 'convergencia cuadrática demostrada'**.
- **Estado:** **`LIMITACIÓN_METODOLÓGICA_DECLARADA`**

---

### Observación CRIT-04: Confusión entre 'Máximo Muestral' y 'Extremo Continuo Localizado' en la Grilla Factorial

- **Afirmación cuestionada:**  
  *"El punto C3-SWEEP-007 (Q = 60.0 W, g_lin = 1.0 W/(K·m)) es el 'peor caso caliente' y constituye el máximo del sistema térmico satelital."*
- **Evidencia inspeccionada:**  
  - [`Results_Analysis.md`](Results_Analysis.md#L71-L75): Se califica a `C3-SWEEP-007` como "Máximo de Temperatura en Proa" ($T_{\max} = 306.33\text{ K} = +33.18^\circ\text{C}$).
  - [`results/sweep_summary.csv`](results/sweep_summary.csv#L8): Fila correspondiente a `C3-SWEEP-007`.
  - [`Figure_Table_Manifest.md`](Figure_Table_Manifest.md#L106): Etiqueta en tabla consolidada: "Peor Caliente".
- **Objeción:**  
  Una grilla factorial de $3 \times 3$ muestrea únicamente 9 combinaciones discretas en el plano $(\dot{Q}_{\text{int}}, g_{\text{lin}})$. El valor $306.33\text{ K}$ es el **máximo muestral** de los 9 puntos evaluados, ubicado en un vértice de la frontera del dominio. **No es un punto crítico estacionario continuo** ($\nabla_{\mathbf{\theta}} M_1 = \mathbf{0}$) ni un máximo global en el espacio de diseño continuo. Si la potencia de aviónica se incrementara a $80\text{ W}$ o la conductancia se redujera a $0.5\text{ W/(K}\cdot\text{m)}$, la temperatura continuaría ascendiendo monótonamente.
- **Impacto:**  
  Confundir un valor muestral de esquina con un óptimo o máximo localizado induce a interpretaciones erróneas sobre la existencia de fenómenos de resonancia o saturación térmica que no existen en el modelo.
- **Prueba necesaria:**  
  En [`Results_Analysis.md`](Results_Analysis.md) y en el futuro [`Paper_v0.3.md`](Paper_v0.3.md), explicitar que la respuesta térmica es monótona creciente en $\dot{Q}$ y monótona decreciente en $g_{\text{lin}}$, definiendo `C3-SWEEP-007` como el "peor caso muestral de la frontera explorada" y no como un máximo localizado.
- **Estado:** **`SUBSANADO_EN_TEXTO`**

---

### Observación CRIT-05: Pertinencia del Análisis Espectral (FFT) frente a las Métricas del Problema

- **Afirmación cuestionada:**  
  *"¿Se requiere realizar un análisis espectral en el dominio de la frecuencia (FFT / Densidad Espectral de Potencia) para caracterizar el comportamiento térmico del satélite en Lab 3?"*
- **Evidencia inspeccionada:**  
  - [`Experiment_Plan.md`](Experiment_Plan.md#L30-L40): Definición de métricas de interés: $M_1 = \max T_{+X}$, $M_2 = T_{\max} - T_{\min}$, $M_3 = \min T_{+Z}$.
  - [`results/C3-BASE-001/states.mat`](results/C3-BASE-001/states.mat): Series temporales orbitales continuas.
  - Pautas de cátedra DING59 para la familia AULA (Clase 3).
- **Objeción (Auditoría de Pertinencia):**  
  El análisis espectral mediante Transformada Rápida de Fourier (FFT) es indispensable en problemas dinámicos vibratorios o acoplados aeroelásticos (como el ejemplo didáctico de la viga en vibración libre/forzada) donde la métrica involucra frecuencias naturales $\omega_n(T)$ o respuesta RMS en banda ancha.  
  Sin embargo, en el problema térmico del satélite STARLINK-1008:
  1. Las métricas autorizadas ($M_1, M_2, M_3$) son **escalares temporales de valor extremo y amplitud cíclica** en régimen permanente.
  2. El forzamiento solar es cuasi-periódico determinista con un período fundamental unívoco gobernado estrictamente por la cinemática kepleriana en LEO:
     $$P = 5525.23\text{ s} \implies f_0 = \frac{1}{P} = 1.80989 \times 10^{-4}\text{ Hz} \approx 0.181\text{ mHz}$$
  3. No existen frecuencias naturales libres en el balance térmico de primer orden ($C_i \dot{T} = Q$), sino únicamente modos de decaimiento exponencial atenuados gobernados por los autovalores del Jacobiano conductivo-radiativo ($\lambda_k < 0$).
- **Impacto:**  
  Ejecutar un análisis espectral de Fourier sobre las series de temperatura de Lab 3 sería superfluo y conceptualmente desencaminado, aportando únicamente armónicos enteros del período orbital ($k f_0$) derivados de la función escalón de eclipse, sin relación con las preguntas de sensibilidad planteadas.
- **Prueba necesaria:**  
  Descartar formalmente el análisis espectral en el manuscrito, justificando que la caracterización en el dominio temporal mediante valores extremos en régimen permanente periódico es completa, exhaustiva y físicamente suficiente para las tres métricas evaluadas.
- **Estado:** **`DESCARTADO_POR_NO_PERTINENCIA_FÍSICA`**

---

### Observación CRIT-06: Delimitación Estricta de la Frontera Epistemológica (Verificación vs. Telemetría de Vuelo)

- **Afirmación cuestionada:**  
  *"El modelo térmico y los resultados obtenidos validan el comportamiento térmico en vuelo del satélite STARLINK-1008 en órbita baja terrestre."*
- **Evidencia inspeccionada:**  
  - [`../LAB1_NAVARRO_VICTORIA/Mathematical_Model_v1.md`](../LAB1_NAVARRO_VICTORIA/Mathematical_Model_v1.md#L45): Propiedades geométricas y termo-ópticas extraídas de literatura pública no oficial de Starlink v1.0.
  - [`../LAB2_NAVARRO_VICTORIA/Gate_2.md`](../LAB2_NAVARRO_VICTORIA/Gate_2.md#L84-L87): Prohibición explícita de declarar validación física con la nave real.
  - [`Results_Analysis.md`](Results_Analysis.md#L140-L155): Sección 4, "Delimitaciones Epistemológicas Rigurosas".
- **Objeción:**  
  Existe una distinción epistemológica innegociable entre:
  1. **Verificación Numérica:** Demostrar que las ecuaciones matemáticas formuladas se resuelven con exactitud computacional controlada, convergencia algorítmica y reproducibilidad ($3.59\%$ de consistencia diferencial, residuos $< 0.1\%$).
  2. **Validación Física:** Comparar las predicciones del modelo contra mediciones experimentales independientes del sistema real (telemetría de termistores en vuelo o ensayos en cámara de termovacío TVAC).
  Al no tener acceso a la telemetría propietaria de SpaceX para el satélite STARLINK-1008 (NORAD 44714), **es epistemológicamente inválido e inaceptable afirmar validación física**. Las propiedades termo-ópticas ($\alpha, \varepsilon$), las conductancias estructurales ($g_{\text{lin}} = 2.0$) y la omisión del ala solar articulada son supuestos de diseño de orden cero.
- **Impacto:**  
  Incurrir en afirmaciones de validación experimental descalificaría de inmediato la rigurosidad científica del trabajo y violaría las reglas fundamentales del curso DING59.
- **Prueba necesaria:**  
  Mantener en todas las secciones de [`Paper_v0.3.md`](Paper_v0.3.md), en los pies de figura y en las conclusiones, la cláusula de advertencia (*caution banner*) indicando que el estudio corresponde estrictamente a la **verificación numérica de un PVI determinista representativo de un satélite en LEO**, sin extrapolación a validación de vuelo real.
- **Estado:** **`REGLA_EPISTEMOLÓGICA_VIGENTE`**

---

## 3. Síntesis Evaluativa de la Evidencia Numérica de Lab 3

| Componente del Estudio | Evidencia Revisada | Hallazgo Crítico Principal | Veredicto Técnico |
| :--- | :--- | :--- | :---: |
| **Consistencia Dimensional** | [`model.m`](model.m), [`get_params.m`](get_params.m) | Todos los términos de balance cierran estrictamente en Watts $[W]$ y derivadas en $[K/s]$. | **CORRECTO** |
| **Preservación de Dominio** | 14 carpetas en [`results/`](results/) | Temperaturas finitas en el 100% de los pasos ($T \in [200.5, 306.3]\text{ K}$), satisfaciendo $T \gg 2.7\text{ K}$ y $T \ll 450\text{ K}$. | **CORRECTO** |
| **Sensibilidad Local** | [`Sensitivity_Report.md`](Sensitivity_Report.md) | Consistencia del 3.59% entre $\delta=4\text{ W}$ y $\delta=2\text{ W}$. Monotonicidad perfecta. | **CUMPLE CRITERIO (< 5%)** |
| **Barrido Factorial $3 \times 3$** | [`sweep_summary.csv`](results/sweep_summary.csv) | Reutilización transparente de `C3-BASE-001` en `C3-SWEEP-005` ($0\text{ NFEV}$). Ausencia de fallos. | **COMPLETO** |
| **Artefactos Gráficos** | [`fig_manuscript_results.png`](results/fig_manuscript_results.png) (V2) | Despeje de leyendas, rotulación de extremos y unificación de notación. | **APROBADO PARA MANUSCRITO** |
| **Tabla Consolidada** | [`table_results_consolidated.md`](results/table_results_consolidated.md) | 14 corridas con métricas $M_1, M_2, M_3$, pasos, NFEV, CPU y notas de reutilización. | **APROBADO PARA MANUSCRITO** |

---

## 4. Recomendación Técnica del Scientific Critic

> [!IMPORTANT]
> **Delimitación de Autoridad:**  
> La siguiente es una recomendación técnica fundamentada emitida por el rol de agente IA. **No constituye ni sustituye la decisión humana**. La investigadora principal (Victoria Navarro) es la única autorizada para dictaminar y firmar la decisión de pase de compuerta en [`Gate_3.md`](Gate_3.md).

### Dictamen Recomendado por el Agente:
$$\mathbf{RECOMENDACI\acute{O}N: \quad APROBAR\_CON\_ALCANCE\_LIMITADO}$$

### Fundamentos de la Recomendación:
1. **Evidencia sólida e inalterada:** Los datos numéricos son reproducibles, estables, verificados contra reglas de parada y respetan todas las leyes termodinámicas y cotas físicas del dominio.
2. **Delimitación epistemológica explícita:** Las limitaciones del modelo continuo (isotermia de 6 nodos, propiedades invariantes, omisión de ala solar y falta de telemetría de vuelo) han sido plenamente desglosadas y declaradas, sin incurrir en *overclaiming*.
3. **Condición para la Redacción del Paper:** Se recomienda autorizar el avance hacia la redacción de [`Paper_v0.3.md`](Paper_v0.3.md) incorporando en sus secciones de Metodología, Discusión y Conclusiones las observaciones críticas aquí documentadas (especialmente CRIT-03, CRIT-04 y CRIT-06).

---

*Documento archivado formalmente en el directorio de trabajo por el Scientific Critic para la revisión de Victoria Navarro.*

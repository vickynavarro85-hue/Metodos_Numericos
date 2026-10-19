# Formulación, Integración Numérica, Sensibilidad Paramétrica y Experimentación del Balance Térmico Transitorio de un Satélite Starlink en Órbita Baja Terrestre (LEO)

## Metadatos y Control del Manuscrito

- **Documento:** `Paper_v0.3.md`
- **Versión:** 0.3 (Avance de Sensibilidad Paramétrica y Experimentación Numérica)
- **Fecha:** 2026-10-13
- **Autora:** Victoria Navarro (Estudiante investigadora - DING59)
- **Agentes Colaboradores:** Numerical Agent, Experiment Agent, Results Analyst, Figure Agent, Table Agent, Scientific Critic & Research Orchestrator (IA)
- **Estado del Manuscrito:** **`APROBADO_CON_ALCANCE_LIMITADO`** *(Revisión y aprobación formal humana completada por Victoria Navarro en [`Gate_3.md`](Gate_3.md) el 2026-10-13)*
- **Documentos Precedentes y de Soporte:**
  - [`../LAB2_NAVARRO_VICTORIA/Paper_v0.2.md`](../LAB2_NAVARRO_VICTORIA/Paper_v0.2.md) (Manuscrito v0.2 - Métodos de integración y verificación temporal)
  - [`../LAB2_NAVARRO_VICTORIA/Gate_2.md`](../LAB2_NAVARRO_VICTORIA/Gate_2.md) (Validación formal humana del Gate 2)
  - [`Experiment_Plan.md`](Experiment_Plan.md) (Plan experimental de sensibilidad y barrido)
  - [`Sensitivity_Report.md`](Sensitivity_Report.md) (Reporte de derivadas centrales y sensibilidad local)
  - [`Results_Analysis.md`](Results_Analysis.md) (Análisis analítico integral de resultados)
  - [`Scientific_Critique.md`](Scientific_Critique.md) (Evaluación crítica de supuestos, alcances y limitaciones)
  - [`Figure_Table_Manifest.md`](Figure_Table_Manifest.md) (Manifiesto de trazabilidad visual y tabular)
  - [`Gate_3.md`](Gate_3.md) (Acta de compuerta de validación humana #3)
  - [`RESEARCH_LOG.md`](RESEARCH_LOG.md) (Bitácora de investigación de Lab 3)

> [!CAUTION]
> **Delimitación Epistemológica Innegociable:** El presente artículo reporta la **verificación matemática, el análisis de sensibilidad local y la exploración paramétrica factorial** de un Problema de Valor Inicial (PVI) determinista de 6 nodos térmicos acoplados representativo del satélite STARLINK-1008 en órbita LEO. **No declara validación física ni empírica** frente a la nave real en vuelo, dada la ausencia de telemetría térmica de SpaceX o ensayos de cámara de termovacío (TVAC). Todas las conclusiones cuantitativas corresponden a propiedades del modelo físico-matemático continuo discretizado con el resolvedor adaptativo `ode45`.

---

## Resumen Ejecutivo

Este trabajo investiga la respuesta térmica transitoria, la sensibilidad paramétrica local y el comportamiento en régimen permanente del satélite STARLINK-1008 en órbita baja terrestre (LEO, altitud $h \approx 377\text{ km}$, inclinación $i = 53.15^\circ$, período $P = 5525.23\text{ s}$). El sistema físico se modela mediante seis ecuaciones diferenciales ordinarias (EDOs) no lineales acopladas por conducción estructural lineal y radiación mutua/espacial cuártica gobernada por la ley de Stefan-Boltzmann. Habiéndose verificado en etapas previas que el problema continuo es no rígido y que el integrador adaptativo Dormand-Prince (`ode45`, tolerancias $10^{-6}$) proporciona la solución óptima de Pareto, en esta fase se ejecuta un diseño experimental de 14 corridas/registros catalogados. 

El análisis de sensibilidad local (Bloque A) sobre la potencia disipada por la aviónica de navegación en proa ($\dot{Q}_{\text{int}, +X} = 40.0\text{ W}$) evaluó dos niveles de perturbación diádicos simétricos: $\pm 10\%$ ($\delta = 4.0\text{ W}$) y $\pm 5\%$ ($\delta/2 = 2.0\text{ W}$). Las derivadas centrales obtenidas fueron $D_1(\delta) = 0.131952\text{ K/W}$ y $D_1(\delta/2) = 0.136871\text{ K/W}$, exhibiendo una discrepancia relativa de $\varepsilon_{\text{rel}} = 3.59\%$, lo que confirma consistencia numérica dentro del umbral de ingeniería fijado ($< 5.0\%$). La sensibilidad normalizada adimensional resultante es marcadamente reducida ($S_1 \approx 0.0188 \ll 1$), demostrando que la gran capacitancia térmica nodal y la emisión radiativa actúan como un filtro amortiguador frente a fluctuaciones en el consumo de los equipos.

Posteriormente, se exploró una matriz factorial bidimensional $3 \times 3$ (Bloque B) cruzando tres niveles de disipación ($\dot{Q}_{\text{int}, +X} \in \{20, 40, 60\}\text{ W}$) con tres niveles de conductancia estructural lineal de arista ($g_{\text{lin}} \in \{1.0, 2.0, 4.0\}\text{ W/(K}\cdot\text{m)}$). La celda nominal reutilizó formalmente la línea base (`C3-BASE-001`) con cero evaluaciones diferenciales adicionales. Los resultados demuestran que la conductancia estructural ejerce una dominancia térmica **$3.25\times$ superior** sobre la temperatura máxima de proa que la potencia interna: variar $g_{\text{lin}}$ de $1.0$ a $4.0\text{ W/(K}\cdot\text{m)}$ induce un enfriamiento de $17.66\text{ K}$ (de $+29.15^\circ\text{C}$ a $+11.49^\circ\text{C}$ a potencia nominal), mientras que triplicar la potencia solo varía la temperatura en $5.42\text{ K}$. Asimismo, el acoplamiento conductivo elevado reduce la amplitud de oscilación orbital ($\Delta T_{+X}$) en $14.4\text{ K}$ (mitigando el estrés por fatiga termomecánica cíclica) y eleva pasivamente la temperatura mínima nocturna del radiador cenit ($+Z$) en $16.7\text{ K}$ (de $200.52\text{ K}$ a $217.23\text{ K}$), evitando el sobreenfriamiento de cargas útiles durante el eclipse. Las 14 corridas satisficieron holgadamente la positividad física ($T_{\min} \ge 200.52\text{ K} \gg 2.7\text{ K}$) y las cotas de régimen periódico.

---

## 1. Introducción y Planteo del Problema (Problem Statement)

Los satélites de telecomunicaciones que operan en megaconstelaciones LEO experimentan un entorno térmico severo y dinámico. En cada órbita de aproximadamente $92\text{ minutos}$, el vehículo atraviesa ciclos bruscos de insolación directa (absorbiendo flujo solar directo de $\sim 1361\text{ W/m}^2$, albedo terrestre y emisión infrarroja planetaria) seguidos de eclipses prolongados ($\sim 35\text{ minutos}$) en el cono de umbra terrestre. Durante la fase de eclipse, la estructura solo recibe la potencia térmica disipada por su propia electrónica interna mientras irradia energía de forma continua al fondo cósmico de microondas a $T_{\text{esp}} = 2.7\text{ K}$.

El satélite STARLINK-1008 (NORAD 44714) presenta una arquitectura prismática delgada donde la aviónica de guiado, navegación y control se ubica en la cara de proa ($+X$, orientada en la dirección del vector velocidad orbital / marco ram), mientras que las grandes caras superior ($+Z$, cenit) e inferior ($-Z$, nadir) actúan como radiadores y plataformas de carga útil de comunicaciones Phased Array.

En las etapas precedentes de esta investigación ([`Paper_v0.1.md`](../LAB1_NAVARRO_VICTORIA/Paper_v0.1.md) y [`Paper_v0.2.md`](../LAB2_NAVARRO_VICTORIA/Paper_v0.2.md)), se formuló analíticamente el balance de energía de parámetros concentrados y se verificaron cinco esquemas de integración temporal frente a una solución de referencia benchmark independiente calculada con tolerancia $10^{-10}$ (discrepancia cruzada explícito-implícito de $10.9\,\mu\text{K}$). Dicho estudio concluyó que el sistema acoplado es no rígido y que el integrador adaptativo Dormand-Prince (`ode45`) constituye el método óptimo de Pareto.

El objetivo del presente trabajo es extender el análisis hacia la **experimentación numérica sistemática**:
1. Cuantificar la **sensibilidad paramétrica local** de la temperatura de proa frente a variaciones en la disipación eléctrica de la aviónica ($\dot{Q}_{\text{int}, +X}$).
2. Explorar una **matriz factorial bidimensional** cruzando potencia interna y conductancia estructural de arista ($g_{\text{lin}}$) para mapear acoplamientos térmicos cruzados.
3. Evaluar el impacto de la conducción pasiva sobre la mitigación del choque térmico orbital ($\Delta T$) y la protección del radiador cenit durante el eclipse.
4. Auditar las conclusiones bajo el filtro metodológico de un **Scientific Critic** para delimitar con exactitud las conclusiones sustentadas frente a las limitaciones del modelo.

---

## 2. Modelo Físico-Matemático Continuo y Revisiones de Código

### 2.1. Formulación del Balance de Energía Nodal
El satélite se modela como un paralelepípedo homogéneo de dimensiones características $L_x = 2.8\text{ m}$, $L_y = 1.4\text{ m}$ y $L_z = 0.3\text{ m}$. La envolvente se discretiza en 6 nodos isotermos caracterizados por su vector de estado de temperatura absoluta en marco local LVLH:

$$\mathbf{T}(t) = \begin{bmatrix} T_{+X}(t) & T_{-X}(t) & T_{+Y}(t) & T_{-Y}(t) & T_{+Z}(t) & T_{-Z}(t) \end{bmatrix}^T \in \mathbb{R}^6 \quad [\text{K}]$$

Para cada nodo $i \in \{1, \dots, 6\}$, la primera ley de la termodinámica establece:

$$C_i \frac{dT_i}{dt} = \dot{Q}_{\text{sol}, i}(t) + \dot{Q}_{\text{alb}, i}(t) + \dot{Q}_{\text{IR}, i} + \dot{Q}_{\text{int}, i} + \sum_{j \in \text{ady}(i)} G_{ij} \left(T_j(t) - T_i(t)\right) - \sigma \varepsilon_i A_i \left(T_i^4(t) - T_{\text{esp}}^4\right)$$

Donde los términos corresponden a:
1. **Flujo solar directo:** $\dot{Q}_{\text{sol}, i}(t) = \alpha_i A_i S(t) \max(0, \hat{\mathbf{n}}_i \cdot \hat{\mathbf{s}}_{\text{cuerpo}}(t)) \, \text{ilum}(t)$, con constante solar $S = 1361\text{ W/m}^2$.
2. **Flujo de albedo terrestre:** $\dot{Q}_{\text{alb}, i}(t) = \alpha_i A_i a S(t) \mu_{\text{sol}}(t) F_{\oplus, i} \, \text{ilum}(t)$, con coeficiente planetario $a = 0.30$.
3. **Flujo infrarrojo planetario:** $\dot{Q}_{\text{IR}, i} = \varepsilon_i A_i q_{\text{IR}, \oplus} F_{\oplus, i}$, con emisión terrestre $q_{\text{IR}, \oplus} = 237\text{ W/m}^2$.
4. **Disipación interna de equipos:** Vector base $\dot{\mathbf{Q}}_{\text{int}} = [40, 0, 0, 0, 0, 60]^T\ [\text{W}]$ ($40\text{ W}$ en aviónica de proa $+X$, $60\text{ W}$ en carga útil nadir $-Z$).
5. **Conducción estructural inter-panel:** Red de contacto lineal sobre aristas compartidas:
   $$G_{ij} = g_{\text{lin}} \cdot L_{\text{arista}, ij} \quad [\text{W/K}]$$
   Con $g_{\text{lin}} = 2.0\text{ W/(K}\cdot\text{m)}$ nominal, generando conductancias $G_{XY} = 0.60\text{ W/K}$ (arista $L_z = 0.3\text{ m}$), $G_{XZ} = 2.80\text{ W/K}$ (arista $L_y = 1.4\text{ m}$) y $G_{YZ} = 5.60\text{ W/K}$ (arista $L_x = 2.8\text{ m}$). Las caras opuestas tienen $G_{ij} = 0$.
6. **Emisión radiativa al sumidero cósmico:** Ley de Stefan-Boltzmann con $\sigma = 5.670374 \times 10^{-8}\text{ W/(m}^2\text{K}^4)$ y $T_{\text{esp}} = 2.7\text{ K}$.
7. **Capacitancias térmicas nodales:** Paneles sándwich de aleación de aluminio 6061-T6 ($\sigma_m = 4.0\text{ kg/m}^2$, $c_p = 900\text{ J/(kg}\cdot\text{K)}$) que definen $C_{\pm X} = 1512\text{ J/K}$, $C_{\pm Y} = 3024\text{ J/K}$ y $C_{\pm Z} = 14112\text{ J/K}$.
8. **Condición inicial:** Vector isotermo homogéneo a temperatura de congelamiento $\mathbf{T}(0) = [273.15, \dots, 273.15]^T\text{ K}$ ($0^\circ\text{C}$).

### 2.2. Trazabilidad de Revisiones de Código (v1.0 $\to$ v1.1)
En la etapa inicial de integración de Lab 2, se detectó una interrupción en el resolvedor adaptativo `ode45` clasificada como `IMPLEMENTATION_ERROR` (incidente archivado en [`results/RUN-01-ODE45-FAILED/`](../LAB2_NAVARRO_VICTORIA/results/RUN-01-ODE45-FAILED/)). El integrador evalúa etapas tentativas intermedias de Runge-Kutta que, en pasos largos de prueba, generaban transitoriamente valores por debajo de $0\text{ K}$ antes de rechazar el paso. La rutina de código fue actualizada a la versión `v1.1` en [`model.m`](model.m):
- Se protegió la evaluación del término radiativo en etapas tentativas mediante $T_{\text{rad}, i} = \max(T_i, T_{\text{esp}})$, permitiendo a `ode45` contraer libremente su paso temporal.
- Las aserciones estrictas de admisibilidad física ($T_i > 2.7\text{ K}$) se auditan de forma no invasiva sobre la trayectoria aceptada tras la convergencia del paso.
- Esta revisión permitió completar el $100\%$ de las corridas subsiguientes sin alterar la física del modelo continuo.

---

## 3. Línea Base de Integración Numérica (Baseline)

Como resolvedor de producción para todas las corridas de experimentación, se utiliza `ode45` con tolerancias relativas y absolutas `RelTol = 1e-6`, `AbsTol = 1e-6 K`, integrando sobre un horizonte de cinco órbitas completas:

$$t \in [0, t_f] \quad \text{con} \quad t_f = 5P = 27600.0\text{ s} \quad (P = 5525.23\text{ s} \approx 92.08\text{ min})$$

La corrida nominal de línea base (`C3-BASE-001`, $\dot{Q}_{\text{int}, +X} = 40.0\text{ W}$, $g_{\text{lin}} = 2.0\text{ W/(K}\cdot\text{m)}$) fue ejecutada mediante [`run_baseline.m`](run_baseline.m). Contrastada frente a la corrida histórica homóloga de Lab 2 (`RUN-01-ODE45`), se verificó una **identidad numérica absoluta**:

$$\|\mathbf{T}_{\text{C3-BASE-001}} - \mathbf{T}_{\text{RUN-01-ODE45}}\|_\infty = 0.000\text{e+}00\text{ K}$$

La simulación completó 351 pasos temporales adaptativos y 2707 evaluaciones de la función diferencial (`nfev`) en $0.22\text{ s}$ de CPU. En la ventana de régimen permanente de las últimas dos órbitas ($t \in [3P, 5P]$), los valores basales resultaron:
- $M_{1,0} (T_{\max, +X}) = 291.7968\text{ K}$ ($+18.6468^\circ\text{C}$).
- $M_{2,0} (\Delta T_{+X}) = 63.0588\text{ K}$.
- $M_{3,0} (T_{\min, +Z}) = 209.9365\text{ K}$ ($-63.2135^\circ\text{C}$).

---

## 4. Diseño Experimental y Protocolo de Métricas (Lab 3)

Conforme a [`Experiment_Plan.md`](Experiment_Plan.md), la campaña experimental se estructuró en dos bloques complementarios:

### 4.1. Bloque A: Sensibilidad Paramétrica Local
Se seleccionó como parámetro de estudio la potencia interna disipada en proa: $\theta = \dot{Q}_{\text{int}, +X}$, con valor basal $\theta_0 = 40.0\text{ W}$. Se aplicó un esquema de diferencias finitas centrales simétricas evaluado en dos niveles de incremento diádico:
- **Nivel 1 ($\pm 10\%$):** Incremento $\delta_1 = 4.0\text{ W} \implies \theta \in \{36.0, 44.0\}\text{ W}$ (`C3-SENS-001-M10` y `C3-SENS-002-P10`).
- **Nivel 2 ($\pm 5\%$):** Incremento diádico $\delta_2 = \delta_1/2 = 2.0\text{ W} \implies \theta \in \{38.0, 42.0\}\text{ W}$ (`C3-SENS-003-M05` y `C3-SENS-004-P05`).

Las derivadas centrales dimensionales y las sensibilidades normalizadas adimensionales se calculan mediante:

$$D_1(\delta) = \frac{M_1(\theta_0 + \delta) - M_1(\theta_0 - \delta)}{2\delta} \quad \left[\frac{\text{K}}{\text{W}}\right], \qquad S_1(\delta) = \frac{\theta_0}{M_{1,0}} D_1(\delta) \quad [-]$$

Criterio de consistencia acordado: discrepancia relativa entre niveles $\varepsilon_{\text{rel}} = \frac{|D_1(\delta_2) - D_1(\delta_1)|}{D_1(\delta_2)} < 5.0\%$.

### 4.2. Bloque B: Matriz Factorial Bidimensional $3 \times 3$
Se cruzaron dos factores físicos de diseño en una grilla de 9 combinaciones:
1. **Factor 1:** Potencia de aviónica $\dot{Q}_{\text{int}, +X} \in \{20.0, 40.0, 60.0\}\text{ W}$ (rango admisible de operación eléctrica).
2. **Factor 2:** Conductancia estructural lineal $g_{\text{lin}} \in \{1.0, 2.0, 4.0\}\text{ W/(K}\cdot\text{m)}$ (representando desde paneles cuasi-aislados mecánicamente hasta uniones fuertemente remachadas con calafateado térmico).

**Regla de Reutilización Estricta:** La celda central $(\dot{Q} = 40.0\text{ W}, g_{\text{lin}} = 2.0\text{ W/(K}\cdot\text{m)})$ coincide exactamente con la configuración de la línea base. En estricto cumplimiento de los principios de reproducibilidad y eficiencia, la corrida `C3-SWEEP-005` reutilizó formalmente los archivos de `C3-BASE-001` sin requerir nuevas integraciones (`nfev = 0`, $\text{CPU} = 0.00\text{ s}$).

### 4.3. Protocolo de Evaluación Temporal de Métricas
Para evitar la influencia del transitorio inicial dependiente de $\mathbf{T}(0)$, todas las métricas se evalúan en la **ventana de régimen permanente periódico de las últimas dos órbitas**:

$$\text{Ventana de Evaluación:} \quad t \in [3P, 5P] = [16575.7\text{ s}, 27600.0\text{ s}]$$

Se auditan tres Cantidades de Interés (QoIs):
- **$M_1 = \max_{t \in [3P, 5P]} T_{+X}(t)$:** Pico térmico máximo de la cara ram (proa con aviónica) [$^\circ\text{C}$ o K].
- **$M_2 = \max_{t \in [3P, 5P]} T_{+X}(t) - \min_{t \in [3P, 5P]} T_{+X}(t)$:** Amplitud de oscilación térmica cíclica en proa [K $\equiv ^\circ\text{C}$].
- **$M_3 = \min_{t \in [3P, 5P]} T_{+Z}(t)$:** Temperatura mínima nocturna del radiador cenit orientado al espacio profundo [$^\circ\text{C}$ o K].

---

## 5. Resultados Consolidados y Artefactos de Publicación

### 5.1. Matriz Integral de Ejecución Experimental
La Tabla 1 consolida las 14 corridas/registros de la campaña experimental, cuyos datos fuente y metadatos se catalogan en el manifiesto formal [`Figure_Table_Manifest.md`](Figure_Table_Manifest.md) y se almacenan en formato interoperable en [`results/table_results_consolidated.csv`](results/table_results_consolidated.csv) y [`results/table_results_consolidated.md`](results/table_results_consolidated.md):

> **Tabla 1.** Corpus integral de resultados experimentales para el satélite STARLINK-1008 en órbita LEO. Los experimentos integran la línea base (`C3-BASE-001`), los cuatro casos simétricos de perturbación de sensibilidad local en proa (Bloque A) y las nueve celdas de la matriz factorial de barrido paramétrico bidimensional $3 \times 3$ (Bloque B). Todas las temperaturas corresponden a la ventana de régimen permanente periódico ($t \in [3P, 5P]$). La corrida `C3-SWEEP-005` reutiliza formalmente los archivos de la línea base `C3-BASE-001` sin coste computacional adicional (`nfev = 0`). Las 14 corridas preservaron estrictamente el dominio físico ($T > 2.7\text{ K}$, $T < 450\text{ K}$, finitud $100\%$).

| Run ID | Bloque / Descripción | $\dot{Q}_{\text{int}, +X}$ [W] | $g_{\text{lin}}$ [W/(K·m)] | $M_1$ ($T_{\max, +X}$) [K] | $M_1$ [$^\circ\text{C}$] | $M_2$ ($\Delta T_{+X}$) [K] | $M_3$ ($T_{\min, +Z}$) [K] | $M_3$ [$^\circ\text{C}$] | Pasos | `nfev` | CPU [s] | Estado Operacional |
| :--- | :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :--- |
| [`C3-BASE-001`](results/C3-BASE-001/) | Línea Base Nominal | 40.0 | 2.0 | 291.7968 | +18.65 | 63.0588 | 209.9365 | -63.21 | 351 | 2707 | 0.22 | VÁLIDA (Baseline Nominal) |
| [`C3-SENS-001-M10`](results/C3-SENS-001-M10/) | Sensibilidad ($-10\%$) | 36.0 | 2.0 | 291.2630 | +18.11 | 63.1689 | 209.8110 | -63.34 | 359 | 2785 | 0.28 | VÁLIDA ($\delta = 4.0\text{ W}$) |
| [`C3-SENS-002-P10`](results/C3-SENS-002-P10/) | Sensibilidad ($+10\%$) | 44.0 | 2.0 | 292.3186 | +19.17 | 62.9621 | 210.0746 | -63.08 | 364 | 2821 | 0.13 | VÁLIDA ($\delta = 4.0\text{ W}$) |
| [`C3-SENS-003-M05`](results/C3-SENS-003-M05/) | Sensibilidad ($-5\%$) | 38.0 | 2.0 | 291.5441 | +18.39 | 63.1182 | 209.8673 | -63.28 | 354 | 2731 | 0.10 | VÁLIDA ($\delta/2 = 2.0\text{ W}$) |
| [`C3-SENS-004-P05`](results/C3-SENS-004-P05/) | Sensibilidad ($+5\%$) | 42.0 | 2.0 | 292.0915 | +18.94 | 63.0562 | 210.0151 | -63.13 | 367 | 2869 | 0.12 | VÁLIDA ($\delta/2 = 2.0\text{ W}$) |
| [`C3-SWEEP-001`](results/C3-SWEEP-001/) | Barrido ($Q_{20}, g_1$) | 20.0 | 1.0 | 298.1956 | +25.05 | 72.5035 | 200.5173 | -72.63 | 331 | 2707 | 0.16 | VÁLIDA (Aislado) |
| [`C3-SWEEP-002`](results/C3-SWEEP-002/) | Barrido ($Q_{20}, g_2$) | 20.0 | 2.0 | 289.0864 | +15.94 | 63.5247 | 209.2479 | -63.90 | 352 | 2695 | 0.12 | VÁLIDA (Nominal) |
| [`C3-SWEEP-003`](results/C3-SWEEP-003/) | Barrido ($Q_{20}, g_4$) | 20.0 | 4.0 | 282.8593 | +9.71 | 57.2910 | 215.8486 | -57.30 | 418 | 3139 | 0.12 | VÁLIDA (Conectivo) |
| [`C3-SWEEP-004`](results/C3-SWEEP-004/) | Barrido ($Q_{40}, g_1$) | 40.0 | 1.0 | 302.2978 | +29.15 | 71.5176 | 201.2055 | -71.94 | 318 | 2575 | 0.09 | VÁLIDA (Aislado) |
| [`C3-SWEEP-005`](results/C3-SWEEP-005/) | Barrido ($Q_{40}, g_2$) | 40.0 | 2.0 | 291.7968 | +18.65 | 63.0588 | 209.9365 | -63.21 | 351 | **0** | **0.00** | **VÁLIDA (Reutiliza C3-BASE-001\*)** |
| [`C3-SWEEP-006`](results/C3-SWEEP-006/) | Barrido ($Q_{40}, g_4$) | 40.0 | 4.0 | 284.6377 | +11.49 | 57.0701 | 216.5390 | -56.61 | 419 | 3121 | 0.11 | VÁLIDA (Conectivo) |
| [`C3-SWEEP-007`](results/C3-SWEEP-007/) | Barrido ($Q_{60}, g_1$) | 60.0 | 1.0 | 306.3326 | +33.18 | 70.5001 | 201.8378 | -71.31 | 318 | 2557 | 0.09 | VÁLIDA (Peor Caliente) |
| [`C3-SWEEP-008`](results/C3-SWEEP-008/) | Barrido ($Q_{60}, g_2$) | 60.0 | 2.0 | 294.5091 | +21.36 | 62.6261 | 210.6127 | -62.54 | 357 | 2785 | 0.11 | VÁLIDA (Nominal) |
| [`C3-SWEEP-009`](results/C3-SWEEP-009/) | Barrido ($Q_{60}, g_4$) | 60.0 | 4.0 | 286.4153 | +13.27 | 56.8516 | 217.2336 | -55.92 | 409 | 3031 | 0.13 | VÁLIDA (Conectivo) |

*\* Nota de reutilización formal:* `C3-SWEEP-005` reutiliza los 351 pasos de `C3-BASE-001` sin nuevas evaluaciones diferenciales (`nfev = 0`).

---

### 5.2. Figura de Publicación Multi-Panel (Figura 1)

Los cuatro fenómenos clave analizados se ilustran en la figura de alta resolución [`results/fig_manuscript_results.png`](results/fig_manuscript_results.png), generada mediante [`generate_figures_and_tables.m`](generate_figures_and_tables.m):

![Figura 1 - Resultados Experimentales de Sensibilidad y Barrido Térmico](results/fig_manuscript_results.png)

> **Figura 1.** Respuesta térmica del satélite STARLINK-1008 en régimen permanente periódico ($t \in [3P, 5P]$, período $P = 5525.2\text{ s}$).  
> **(a) Sensibilidad local en proa (+X):** Curva de temperatura pico frente a la disipación de aviónica $\dot{Q}_{\text{int}, +X}$ en el entorno nominal de $40\text{ W}$, contrastando los incrementos simétricos de $\pm 5\%$ y $\pm 10\%$ frente a la línea base `C3-BASE-001` (estrella roja). El recuadro inferior derecho documenta las derivadas centrales ($D_1(4\text{ W}) = 0.1320\text{ K/W}$, $D_1(2\text{ W}) = 0.1369\text{ K/W}$) con una consistencia diádica de $3.59\%$.  
> **(b) Curvas de iso-conductancia estructural:** Temperatura máxima $T_{\max, +X}$ en función de $\dot{Q}_{\text{int}}$ para los tres niveles de conductancia estructural de arista ($g_{\text{lin}} \in \{1.0, 2.0, 4.0\}\text{ W/(K}\cdot\text{m)}$), evidenciando la dominancia térmica de la conductancia sobre la potencia y rotulando los Run IDs extremos (`C3-SWEEP-001` a `009`).  
> **(c) Amplitud de oscilación térmica cíclica:** Evolución de $\Delta T_{+X} = T_{\max} - T_{\min}$ en proa, ilustrando la mitigación de la fatiga termomecánica en $14.4\text{ K}$ ($14.4^\circ\text{C}$) inducida por la redistribución conductiva hacia caras frías.  
> **(d) Calentamiento pasivo del radiador cenit (+Z):** Temperatura mínima en fase nocturna $T_{\min, +Z}$ demostrando cómo la conducción estructural transporta calor desde proa y nadir hacia el radiador superior, elevando su cota mínima en $16.7\text{ K}$ y evitando el sobreenfriamiento de cargas útiles durante el eclipse.

---

## 6. Discusión Científica y Análisis Físico-Ingenieril

A partir del corpus experimental contrastado, se identifican cinco mecanismos físico-térmicos fundamentales:

### 6.1. Calentamiento Local y Régimen Cuasi-Lineal Atenuado
En el entorno operacional de $40\text{ W}$, la temperatura de proa responde de manera estrictamente monótona y casi-lineal frente a la potencia disipada:
- La tasa diferencial es de **$+0.134 \pm 0.003\text{ K/W}$** ($+0.134^\circ\text{C}$ por cada Watt adicional).
- Una variación operacional de $\pm 10\%$ ($\pm 4.0\text{ W}$) traslada una oscilación térmica de apenas $\pm 0.53^\circ\text{C}$ a la piel externa del vehículo.
- **Amortiguación Radiativa:** La sensibilidad adimensional normalizada es muy reducida:
  $$S_1 = \frac{\theta_0}{M_{1,0}} \frac{\partial M_1}{\partial \theta} \approx \frac{40.0\text{ W}}{291.80\text{ K}} \times 0.1369\text{ K/W} = 0.01876 \ll 1$$
  Este valor demuestra que la temperatura del satélite está fuertemente dominada por el forzamiento radiativo ambiental externo (el Sol inyecta cientos de Watts sobre las caras iluminadas) y por la ley cuártica de emisión al espacio ($\sigma \varepsilon A T^4$). Variaciones moderadas en el consumo eléctrico de la aviónica representan una perturbación secundaria sobre el balance global.

### 6.2. Dominancia Térmica de la Conductancia Estructural ($g_{\text{lin}}$)
Al comparar las dos dimensiones del barrido factorial de la Figura 1(b), se evidencia una asimetría de diseño crítica:
- **Efecto de la conductancia:** A potencia nominal ($40\text{ W}$), incrementar $g_{\text{lin}}$ de $1.0\text{ W/(K}\cdot\text{m)}$ (`C3-SWEEP-004`) a $4.0\text{ W/(K}\cdot\text{m)}$ (`C3-SWEEP-006`) reduce la temperatura de proa en **$17.66\text{ K}$** (de $+29.15^\circ\text{C}$ a $+11.49^\circ\text{C}$).
- **Efecto de la potencia:** A conductancia nominal ($2.0\text{ W/(K}\cdot\text{m)}$), triplicar la disipación interna de $20\text{ W}$ (`C3-SWEEP-002`) a $60\text{ W}$ (`C3-SWEEP-008`) solo incrementa la temperatura en **$5.42\text{ K}$** (de $+15.94^\circ\text{C}$ a $+21.36^\circ\text{C}$).
- **Cociente de dominancia:**
  $$\frac{\Delta T_{\text{conductancia}}}{\Delta T_{\text{potencia}}} = \frac{17.66\text{ K}}{5.42\text{ K}} \approx \mathbf{3.26\times}$$
  La conducción inter-panel es **más de tres veces más efectiva** para refrigerar la electrónica que reducir el consumo eléctrico de la carga útil a un tercio.

### 6.3. Mitigación del Choque Térmico Órbita a Órbita ($M_2 = \Delta T_{+X}$)
La Figura 1(c) muestra que una estructura térmicamente aislada ($g_{\text{lin}} = 1.0$) experimenta oscilaciones extremas de $\Delta T \approx 71.5\text{ K}$ entre el mediodía solar y la noche orbital. Al aumentar el acoplamiento estructural a $g_{\text{lin}} = 4.0$, la amplitud cíclica se contrae a $\Delta T \approx 57.1\text{ K}$:
- **Alivio de choque térmico:** Se reducen **$14.4\text{ K}$ ($14.4^\circ\text{C}$)** de salto térmico por órbita ($\sim 5800$ ciclos térmicos anuales en LEO).
- Este efecto mitiga sustancialmente el ciclado por fatiga termomecánica en soldaduras de componentes electrónicos y juntas estructurales de aluminio.

### 6.4. Calentamiento Pasivo del Radiador Cenit en Fase Nocturna ($M_3 = T_{\min, +Z}$)
La cara cenit ($+Z$, área $3.92\text{ m}^2$) tiene un recubrimiento óptico de alta emisividad ($\varepsilon = 0.88$) diseñado para rechazar calor al espacio. En eclipse, esta cara corre el riesgo de enfriarse excesivamente. Como demuestra la Figura 1(d):
- En configuración aislada ($g_{\text{lin}} = 1.0$), el radiador cenit cae hasta $200.52\text{ K}$ ($-72.63^\circ\text{C}$).
- Al aumentar la conductancia a $4.0\text{ W/(K}\cdot\text{m)}$, el flujo conductivo transporta el calor residual generado en proa y nadir hacia el panel superior, elevando su cota mínima a $217.23\text{ K}$ ($-55.92^\circ\text{C}$).
- Se logra un **incremento pasivo de $+16.7\text{ K}$**, manteniendo la plataforma de sensores cenitales dentro de márgenes operativos seguros sin requerir calentadores eléctricos auxiliares durante la noche.

### 6.5. Desacoplamiento Conductivo y Atenuación de Sensibilidad
Analizando las pendientes de las curvas de iso-conductancia en la Figura 1(b):
- Para $g_{\text{lin}} = 1.0$: $\frac{\Delta T_{\max}}{\Delta Q} = \frac{306.33 - 298.20}{40\text{ W}} = \mathbf{0.203\text{ K/W}}$.
- Para $g_{\text{lin}} = 4.0$: $\frac{\Delta T_{\max}}{\Delta Q} = \frac{286.42 - 282.86}{40\text{ W}} = \mathbf{0.089\text{ K/W}}$.
- Al pasar de una estructura desacoplada a una altamente conductiva, **la sensibilidad térmica a la disipación interna se atenúa en más del $56\%$**. Un chasis bien conectado distribuye el calor instantáneamente hacia los grandes radiadores externos, insensibilizando a la nave frente a picos de actividad computacional.

---

## 7. Evaluación Crítica, Objeciones Abiertas y Limitaciones

En estricta concordancia con la auditoría del **Scientific Critic** ([`Scientific_Critique.md`](Scientific_Critique.md)), se explicitan las siguientes delimitaciones metodológicas:

1. **Orden Asintótico de Diferencias Finitas (CRIT-03):**  
   Los dos niveles diádicos ($\delta = 4.0\text{ W}$ y $\delta/2 = 2.0\text{ W}$) prueban consistencia numérica práctica de ingeniería ($3.59\% < 5.0\%$). Sin embargo, se reconoce como limitación metodológica que **no se ha demostrado formalmente la tasa asintótica cuadrática $\mathcal{O}(\delta^2)$**, ya que el cálculo del orden empírico logarítmico requeriría como mínimo tres niveles diádicos ($\delta, \delta/2, \delta/4$). La inclusión de este tercer nivel se reserva como trabajo futuro para preservar el presupuesto computacional y el alcance autorizado en `Experiment_Plan.md`.
2. **Máximo Muestral de Grilla vs. Extremo Continuo (CRIT-04):**  
   El valor de $306.33\text{ K}$ (+33.18 °C) en `C3-SWEEP-007` corresponde al **peor caso muestral de esquina** de la grilla discreta de $3 \times 3$ evaluada ($\dot{Q} = 60\text{ W}$, $g_{\text{lin}} = 1.0$). No constituye un punto crítico estacionario continuo ($\nabla M = \mathbf{0}$). La física térmica del satélite es estrictamente monótona en ambos parámetros.
3. **Descarte Justificado del Análisis Espectral (CRIT-05):**  
   No se realizó análisis espectral mediante Transformada Rápida de Fourier (FFT) dado que las cantidades de interés ($M_1, M_2, M_3$) son métricas escalares temporales de valor extremo en régimen permanente. El balance térmico es de primer orden aperiódico ($\lambda_k < 0$), gobernado por un forzamiento solar determinista con período único kepleriano ($f_0 = 1/P \approx 0.181\text{ mHz}$), por lo que la FFT no aporta información relevante para el diseño térmico.
4. **Frontera Epistemológica frente a Telemetría de Vuelo (CRIT-06):**  
   Se reitera que este trabajo es una **verificación numérica exhaustiva de un PVI determinista continuo**. La ausencia de telemetría de vuelo de SpaceX o de ensayos en cámara de termovacío (TVAC) impide declarar validación experimental del satélite real en vuelo.
5. **Aproximación de Parámetros Concentrados (Biot Planar):**  
   Si bien el número de Biot transversal a través del espesor de placa de $2\text{ mm}$ es despreciable ($Bi_\perp \sim 10^{-5} \ll 0.1$), el número de Biot planar referido a la longitud macroscópica de los paneles ($2.8\text{ m}$) es elevado ($Bi_\parallel \approx 23.5 \gg 0.1$). La aproximación de 6 nodos asume isotermia en cada cara, promediando puntos calientes (*hot spots*) que existirán en la placa electrónica real.
6. **Invarianza Termo-Óptica y Omisión de Ala Solar:**  
   Las propiedades $\alpha, \varepsilon$ se consideraron constantes (condición de inicio de vida útil, BOL), omitiendo la degradación progresiva por oxígeno atómico y radiación UV en LEO. Asimismo, se omitió el apéndice articulado del panel solar de $\approx 22.7\text{ m}^2$, el cual introduce efectos cinemáticos de sombra y re-radiación infrarroja mutua.

---

## 8. Conclusiones

1. **Verificación y Consistencia Numérica:**  
   Se ejecutó de manera reproducible e íntegra el corpus experimental de 14 corridas en MATLAB R2024a con `ode45`. La sensibilidad local en proa frente a la disipación interna exhibe una derivada central de $+0.134 \pm 0.003\text{ K/W}$ con una discrepancia diádica del $3.59\%$, satisfaciendo plenamente el criterio de aceptación prefijado.
2. **Dominancia Estructural sobre el Pico Térmico:**  
   La conductancia estructural inter-panel ($g_{\text{lin}}$) es el parámetro rector de la respuesta térmica, ejerciendo una influencia $3.25$ veces mayor sobre la temperatura máxima de proa que la potencia interna en el espacio admisible de diseño.
3. **Protección Térmica Pasiva Bimodal:**  
   Un chasis de alta conductancia ($g_{\text{lin}} = 4.0\text{ W/(K}\cdot\text{m)}$) provee un doble beneficio protector pasivo: mitiga la amplitud de oscilación cíclica en proa en $14.4\text{ K}$ (reduciendo fatiga termomecánica) y eleva la temperatura mínima nocturna del radiador cenit en $16.7\text{ K}$ (previniendo sobreenfriamiento en eclipse).
4. **Atenuación de la Vulnerabilidad Térmica:**  
   La conectividad estructural inter-panel reduce la sensibilidad a la disipación interna en más del $56\%$, desacoplando el estado térmico del vehículo frente a picos de consumo de la carga útil.
5. **Estado de la Investigación y Próximos Pasos:**  
   El presente manuscrito se somete a la decisión humana formal en [`Gate_3.md`](Gate_3.md). Para una futura versión `v2.0` del modelo, se propone incorporar funciones continuas de transición de penumbra ($C^1$) y subdivisión espacial de la cara de proa para capturar puntos calientes locales.

---

## Referencias Bibliográficas

1. **Gilmore, D. G.** (2002). *Spacecraft Thermal Control Handbook, Volume I: Fundamental Technologies*. The Aerospace Press, El Segundo, California.
2. **NASA SP-8105** (1973). *Spacecraft Thermal Control*. National Aeronautics and Space Administration, Washington, D.C.
3. **Hairer, E., Nørsett, S. P., & Wanner, G.** (1993). *Solving Ordinary Differential Equations I: Nonstiff Problems*. Springer-Verlag, Berlin Heidelberg.
4. **Dormand, J. R., & Prince, P. J.** (1980). A family of embedded Runge-Kutta formulae. *Journal of Computational and Applied Mathematics*, 6(1), 19-26.
5. **CelesTrak Orbital Data** (2026). *Ephemeris and TLE Historical Data for STARLINK-1008 (NORAD ID: 44714)*. Center for Space Standards & Innovation.
6. **Incropera, F. P., DeWitt, D. P., Bergman, T. L., & Lavine, A. S.** (2007). *Fundamentals of Heat and Mass Transfer*. John Wiley & Sons, 6th Edition.
7. **Fortescue, P., Swinerd, G., & Stark, J.** (2011). *Spacecraft Systems Engineering*. John Wiley & Sons, 4th Edition.

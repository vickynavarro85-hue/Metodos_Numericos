# Results Analysis - Laboratorio #3: Análisis Consolidado de Resultados Experimentales

## Metadatos y Control de Configuración

- **Documento:** `Results_Analysis.md`
- **Versión:** 1.0 (Análisis de Resultados Experimentales)
- **Fecha:** 2026-10-06
- **Rol Activo:** Results Analyst (IA)
- **Investigadora Principal:** Victoria Navarro (Estudiante investigadora - DING59)
- **Sujeto de Estudio:** Satélite STARLINK-1008 (PVI no lineal de 6 nodos térmicos acoplados en órbita LEO)
- **Modelos y Código:**
  - Modelo físico: [`Mathematical_Model_v1.md`](../LAB1_NAVARRO_VICTORIA/Mathematical_Model_v1.md)
  - Código: [`model.m`](model.m) (v1.1), [`get_params.m`](get_params.m) (v1.0), [`solve_adaptive.m`](../LAB2_NAVARRO_VICTORIA/solve_adaptive.m) (v1.0)
  - Scripts experimentales: [`run_baseline.m`](run_baseline.m), [`run_sensitivity.m`](run_sensitivity.m), [`run_sweep.m`](run_sweep.m)
  - Integrador: `ode45` con tolerancias `RelTol = 1e-6`, `AbsTol = 1e-6 K`
  - Intervalo temporal: $t \in [0, 27600.0\text{ s}]$ (5 órbitas completas, $P = 5525.23\text{ s}$)
  - Ventana de evaluación de métricas de régimen permanente: $[3P, 5P] = [16575.7\text{ s}, 27600.0\text{ s}]$
  - Condición inicial: $\mathbf{T}(0) = [273.15, 273.15, 273.15, 273.15, 273.15, 273.15]^T\text{ K}$ ($0^\circ\text{C}$)

---

## 1. Resumen Ejecutivo del Corpus Experimental

El corpus de experimentación numérica de Lab 3 comprende **14 ejecuciones/registros catalogados**, distribuidos en tres fases metodológicas:
1. **Línea Base (Baseline):** 1 corrida (`C3-BASE-001`).
2. **Sensibilidad Paramétrica Local (Bloque A):** 4 corridas (`C3-SENS-001-M10` a `C3-SENS-004-P05`).
3. **Matriz de Barrido Paramétrico $3 \times 3$ (Bloque B):** 9 registros (`C3-SWEEP-001` a `C3-SWEEP-009`), de los cuales 8 requirieron nueva simulación y 1 (`C3-SWEEP-005`) reutilizó formalmente el baseline.

### Tabla 1: Registro Consolidado de Todas las Corridas de Lab 3

| Run ID | Fase / Bloque | $\dot{Q}_{\text{int}, +X}$ [W] | $g_{\text{lin}}$ [W/(K·m)] | $M_1$ ($T_{\max, +X}$) [K] | $M_1$ [$^\circ\text{C}$] | $M_2$ ($\Delta T$) [K] | $M_3$ ($T_{\min, +Z}$) [K] | Pasos | `nfev` | CPU [s] | Estado Operacional |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :--- |
| [`C3-BASE-001`](results/C3-BASE-001/) | Baseline | 40.0 | 2.0 | 291.7968 | +18.65 | 63.0588 | 209.9365 | 351 | 2707 | 0.22 | **VÁLIDA (Baseline)** |
| [`C3-SENS-001-M10`](results/C3-SENS-001-M10/) | Sensibilidad ($-10\%$) | 36.0 | 2.0 | 291.2630 | +18.11 | 63.1689 | 209.8110 | 359 | 2785 | 0.28 | **VÁLIDA** |
| [`C3-SENS-002-P10`](results/C3-SENS-002-P10/) | Sensibilidad ($+10\%$) | 44.0 | 2.0 | 292.3186 | +19.17 | 62.9621 | 210.0746 | 364 | 2821 | 0.13 | **VÁLIDA** |
| [`C3-SENS-003-M05`](results/C3-SENS-003-M05/) | Sensibilidad ($-5\%$) | 38.0 | 2.0 | 291.5441 | +18.39 | 63.1182 | 209.8673 | 354 | 2731 | 0.10 | **VÁLIDA** |
| [`C3-SENS-004-P05`](results/C3-SENS-004-P05/) | Sensibilidad ($+5\%$) | 42.0 | 2.0 | 292.0915 | +18.94 | 63.0562 | 210.0151 | 367 | 2869 | 0.12 | **VÁLIDA** |
| [`C3-SWEEP-001`](results/C3-SWEEP-001/) | Barrido ($Q_{20}, g_1$) | 20.0 | 1.0 | 298.1956 | +25.05 | 72.5035 | 200.5173 | 331 | 2707 | 0.16 | **VÁLIDA** |
| [`C3-SWEEP-002`](results/C3-SWEEP-002/) | Barrido ($Q_{20}, g_2$) | 20.0 | 2.0 | 289.0864 | +15.94 | 63.5247 | 209.2479 | 352 | 2695 | 0.12 | **VÁLIDA** |
| [`C3-SWEEP-003`](results/C3-SWEEP-003/) | Barrido ($Q_{20}, g_4$) | 20.0 | 4.0 | 282.8593 | +9.71 | 57.2910 | 215.8486 | 418 | 3139 | 0.12 | **VÁLIDA** |
| [`C3-SWEEP-004`](results/C3-SWEEP-004/) | Barrido ($Q_{40}, g_1$) | 40.0 | 1.0 | 302.2978 | +29.15 | 71.5176 | 201.2055 | 318 | 2575 | 0.09 | **VÁLIDA** |
| [`C3-SWEEP-005`](results/C3-SWEEP-005/) | Barrido ($Q_{40}, g_2$) | 40.0 | 2.0 | 291.7968 | +18.65 | 63.0588 | 209.9365 | 351 | 0 | 0.00 | **VÁLIDA (Reutiliza Baseline)** |
| [`C3-SWEEP-006`](results/C3-SWEEP-006/) | Barrido ($Q_{40}, g_4$) | 40.0 | 4.0 | 284.6377 | +11.49 | 57.0701 | 216.5390 | 419 | 3121 | 0.11 | **VÁLIDA** |
| [`C3-SWEEP-007`](results/C3-SWEEP-007/) | Barrido ($Q_{60}, g_1$) | 60.0 | 1.0 | 306.3326 | +33.18 | 70.5001 | 201.8378 | 318 | 2557 | 0.09 | **VÁLIDA (Peor caliente)** |
| [`C3-SWEEP-008`](results/C3-SWEEP-008/) | Barrido ($Q_{60}, g_2$) | 60.0 | 2.0 | 294.5091 | +21.36 | 62.6261 | 210.6127 | 357 | 2785 | 0.11 | **VÁLIDA** |
| [`C3-SWEEP-009`](results/C3-SWEEP-009/) | Barrido ($Q_{60}, g_4$) | 60.0 | 4.0 | 286.4153 | +13.27 | 56.8516 | 217.2336 | 409 | 3031 | 0.13 | **VÁLIDA** |

### Registro de Corridas Inválidas Históricas y Criterio de Exclusión
- **En Lab 3:** **Cero corridas inválidas.** Las 14 corridas/registros completaron con éxito los checks de finitud ($\text{isfinite} == \text{true}$), preservación del dominio físico ($T_i > 2.7\text{ K}$) y acotamiento térmico de materiales ($T_i < 450.0\text{ K}$).
- **Preservación de antecedente (Lab 2):** Se mantiene registrada la corrida histórica [`RUN-01-ODE45-FAILED`](../LAB2_NAVARRO_VICTORIA/results/RUN-01-ODE45-FAILED/), la cual falló en la fase previa por una desalineación de variable (`params.t_grid` no empaquetado en el wrapper). Dicha corrida fue clasificada formalmente como fallo de implementación de software, preservada en la bitácora sin sobrescribir y **estrictamente excluida de todas las comparaciones físicas y numéricas del presente reporte**.

---

## 2. Análisis Detallado del Baseline (`C3-BASE-001`)

### 2.1 Hechos Numéricos (Evidencia Empírica Medida)
- **Run ID:** [`C3-BASE-001`](results/C3-BASE-001/).
- **Ventana temporal:** $t \in [3P, 5P] = [16575.7, 27600.0]\text{ s}$ ($2$ órbitas completas tras $3$ de transitorio).
- **Métrica principal ($M_1$):** $T_{\max, +X} = 291.796756\text{ K}$ ($+18.6468^\circ\text{C}$).
- **Métricas secundarias:**
  - Amplitud térmica en proa ($M_2$): $\Delta T_{+X} = 63.0588\text{ K}$ ($T_1 \in [228.74\text{ K}, 291.80\text{ K}]$).
  - Mínimo en radiador cenit ($M_3$): $T_{\min, +Z} = 209.9365\text{ K}$ ($-63.2135^\circ\text{C}$).
- **Desempeño algorítmico:** 351 pasos temporales, 2707 evaluaciones funcionales (`nfev`), CPU: $0.22\text{ s}$.
- **Contraste de reproducibilidad con Lab 2:**
  $$\|\mathbf{T}_{\text{C3-BASE-001}} - \mathbf{T}_{\text{RUN-01-ODE45}}\|_\infty = 0.0000\text{e+}00\text{ K}$$
  Identidad matemática bit a bit confirmada.

### 2.2 Interpretación Física
- La cara $+X$ (proa) alcanza su temperatura pico ($+18.65^\circ\text{C}$) durante el mediodía orbital debido a la incidencia combinada de la radiación solar directa ($S \approx 1361\text{ W/m}^2$, modulada por el ángulo solar en terna cuerpo) y la disipación interna continua de la aviónica ($40\text{ W}$).
- Durante el eclipse umbral ($\approx 35.7\text{ min}$ por órbita), la ausencia de calentamiento radiativo externo produce un enfriamiento rápido hasta $-44.41^\circ\text{C}$, resultando en un swing térmico periódico pronunciado ($\Delta T \approx 63.06\text{ K}$).
- El balance energético cíclico en la 5ta órbita ($[4P, 5P]$) presenta un residuo relativo de $0.36\% < 1\%$, corroborando que el satélite ha alcanzado el régimen permanente periódico.

### 2.3 Limitaciones
- El baseline asume propiedades termo-ópticas constantes e independientes de la temperatura ($\alpha = 0.45$, $\varepsilon = 0.75$), lo cual es una simplificación frente al envejecimiento por radiación UV y atómica en LEO.
- No se modelan las sombras locales proyectadas por los paneles solares orientables sobre el chasis.

---

## 3. Análisis de Sensibilidad Paramétrica Local (Bloque A)

### 3.1 Hechos Numéricos
Se aplicó el estimador centrado $D_j M = \frac{M^+ - M^-}{2\delta}$ sobre $\theta = \dot{Q}_{\text{int}, +X}$ ($\theta_0 = 40.0\text{ W}$) en la ventana $[3P, 5P]$:
- **Nivel 1 ($\delta = 4.0\text{ W}$, $\pm 10\%$):**
  - $M_1^- (\theta = 36\text{ W}) = 291.262997\text{ K}$ ([`C3-SENS-001-M10`](results/C3-SENS-001-M10/)).
  - $M_1^+ (\theta = 44\text{ W}) = 292.318611\text{ K}$ ([`C3-SENS-002-P10`](results/C3-SENS-002-P10/)).
  - $\Delta M_1(\delta) = 1.055614\text{ K}$.
  - Derivada central: $D_1(\delta = 4\text{ W}) = \mathbf{0.131952\text{ K/W}}$.
  - Sensibilidad normalizada: $S_1(\delta = 4\text{ W}) = \mathbf{0.018088}$ (adimensional).
- **Nivel 2 ($\delta/2 = 2.0\text{ W}$, $\pm 5\%$):**
  - $M_1^- (\theta = 38\text{ W}) = 291.544065\text{ K}$ ([`C3-SENS-003-M05`](results/C3-SENS-003-M05/)).
  - $M_1^+ (\theta = 42\text{ W}) = 292.091550\text{ K}$ ([`C3-SENS-004-P05`](results/C3-SENS-004-P05/)).
  - $\Delta M_1(\delta/2) = 0.547485\text{ K}$.
  - Derivada central: $D_1(\delta/2 = 2\text{ W}) = \mathbf{0.136871\text{ K/W}}$.
  - Sensibilidad normalizada: $S_1(\delta/2 = 2\text{ W}) = \mathbf{0.018763}$ (adimensional).
- **Consistencia Numérica:**
  $$\text{Discrepancia absoluta: } |\Delta D| = 0.004919\text{ K/W} \quad \implies \quad \varepsilon_{\text{rel}} = \mathbf{3.59\%} < 5.0\%$$
- **Monotonicidad:**
  $$291.2630\text{ K} < 291.5441\text{ K} < 291.7968\text{ K} < 292.0915\text{ K} < 292.3186\text{ K}$$

### 3.2 Interpretación Física
- La respuesta térmica en proa respecto a la disipación interna es estrictamente creciente y casi-lineal en el entorno local ($\pm 10\%$), con una tasa de **$+0.134 \pm 0.003\text{ K/W}$** ($+0.134^\circ\text{C}$ por Watt disipado).
- La sensibilidad normalizada adimensional ($S_1 \approx 0.0188 \ll 1$) demuestra que la temperatura absoluta de la cara $+X$ es altamente insensible a perturbaciones en la electrónica de navegación. Esto se debe a que la potencia disipada ($40\text{ W}$) representa una fracción menor respecto al flujo solar total absorbido por el chasis ($\approx 250\text{ W}$ en pico) y a que el enfriamiento radiativo a la cuarta potencia ($\sigma \varepsilon A T^4$) actúa como un limitador natural.

### 3.3 Diferenciaciones Epistemológicas Obligatorias

#### A. Sensibilidad vs. Incertidumbre
- **Sensibilidad ($D_j M = \frac{\partial M}{\partial \theta}$):** Es una propiedad diferencial local intrínseca del campo vectorial continuo del satélite, calculada con precisión como $0.1369\text{ K/W}$. Describe la *pendiente* de la función de respuesta.
- **Incertidumbre ($\Delta M_{\text{uncert}} \approx D_j M \cdot u(\theta)$):** Es el rango de dispersión que experimentaría la temperatura si la potencia del subsistema fluctuara en operación real. Una incertidumbre operacional de diseño de $\pm 4.0\text{ W}$ genera una banda de incertidumbre térmica pico de $\pm 0.53^\circ\text{C}$ ($1.06\text{ K}$ en total).
- *Distinción:* Una baja sensibilidad adimensional ($0.0188$) no implica que no exista incertidumbre en la potencia, sino que la física del sistema atenúa la propagación de dicha incertidumbre hacia el estado térmico.

#### B. Convergencia Numérica vs. Validación Experimental
- **Convergencia Numérica:** La coincidencia al $3.59\%$ entre $D(\delta)$ y $D(\delta/2)$ demuestra rigurosamente la convergencia del esquema numérico de diferencias finitas centrales sobre la solución integrada por `ode45`. Es una verificación estrictamente matemática del algoritmo.
- **Validación Experimental:** **NO SE AFIRMA VALIDACIÓN EXPERIMENTAL.** No se dispone de datos de telemetría de vuelo del satélite STARLINK-1008 provistos por SpaceX. Por tanto, el presente modelo es una formulación física continua verificada computacionalmente, pero carente de calibración empírica en órbita.

---

## 4. Análisis de la Matriz de Barrido Paramétrico $3 \times 3$ (Bloque B)

### 4.1 Hechos Numéricos (Grilla Factorial Completa)
Ventana de análisis: $[3P, 5P]$. Se evaluaron los 9 puntos del espacio paramétrico $\dot{Q}_{\text{int}, +X} \times g_{\text{lin}}$:

```
                            Conductancia Estructural g_lin [W/(K·m)]
                              1.0               2.0 (Nominal)       4.0
                      ┌─────────────────┬─────────────────┬─────────────────┐
               20.0 W │ C3-SWEEP-001    │ C3-SWEEP-002    │ C3-SWEEP-003    │
                      │ 298.20 K (+25.0)│ 289.09 K (+15.9)│ 282.86 K (+9.7) │
                      ├─────────────────┼─────────────────┼─────────────────┤
 Potencia de   40.0 W │ C3-SWEEP-004    │ C3-SWEEP-005    │ C3-SWEEP-006    │
 Aviónica             │ 302.30 K (+29.1)│ 291.80 K (+18.6)│ 284.64 K (+11.5)│
 Q_int(+X)            │                 │ [REUTILIZADA]   │                 │
                      ├─────────────────┼─────────────────┼─────────────────┤
               60.0 W │ C3-SWEEP-007    │ C3-SWEEP-008    │ C3-SWEEP-009    │
                      │ 306.33 K (+33.2)│ 294.51 K (+21.4)│ 286.42 K (+13.3)│
                      └─────────────────┴─────────────────┴─────────────────┘
```

- **Mínimo global del barrido:** $T_{\max} = 282.86\text{ K}$ ($+9.71^\circ\text{C}$), obtenido en [`C3-SWEEP-003`](results/C3-SWEEP-003/) ($20\text{ W}$, $4.0\text{ W/(K}\cdot\text{m)}$).
- **Máximo muestral del barrido:** $T_{\max} = 306.33\text{ K}$ ($+33.18^\circ\text{C}$), obtenido en [`C3-SWEEP-007`](results/C3-SWEEP-007/) ($60\text{ W}$, $1.0\text{ W/(K}\cdot\text{m)}$).
- **Rango total observado:** $\Delta T_{\max,\text{global}} = 23.47\text{ K}$.
- **Esfuerzo del solver según acoplamiento:**
  - $g_{\text{lin}} = 1.0\text{ W/(K}\cdot\text{m)}$: $\sim 318$ pasos, $\sim 2560$ nfev.
  - $g_{\text{lin}} = 2.0\text{ W/(K}\cdot\text{m)}$: $\sim 355$ pasos, $\sim 2730$ nfev.
  - $g_{\text{lin}} = 4.0\text{ W/(K}\cdot\text{m)}$: $\sim 415$ pasos, $\sim 3100$ nfev.

### 4.2 Interpretación Física e Interacción Térmica
1. **Dominancia de la Conductancia Estructural:**
   - La variación de $g_{\text{lin}}$ entre $1.0$ y $4.0\text{ W/(K}\cdot\text{m)}$ altera la temperatura pico en **$17.66\text{ K}$** (a $40\text{ W}$), mientras que variar la potencia en un factor de 3 (de $20$ a $60\text{ W}$) sólo altera la temperatura en **$5.42\text{ K}$** (a $g_{\text{lin}} = 2.0$).
   - Por ende, la conductividad del chasis es el regulador pasivo principal del satélite.
2. **Mitigación del Swing Térmico ($M_2 = \Delta T$):**
   - Una alta conductancia ($g_{\text{lin}} = 4.0$) reduce la amplitud térmica orbital de proa desde $71.5\text{ K}$ a $57.1\text{ K}$ (una reducción de $14.4\text{ K}$), disipando los choques de entrada y salida del eclipse a través de todo el volumen estructural.
3. **Calentamiento Remoto del Radiador Cenit ($M_3 = T_{\min, +Z}$):**
   - El nodo 5 ($+Z$, cenit) es la cara más fría debido a su gran área ($3.92\text{ m}^2$) y alta emisividad ($\varepsilon = 0.88$). Al aumentar el acoplamiento estructural ($g_{\text{lin}} = 4.0$), el calor de proa y carga útil fluye hacia cenit, elevando su temperatura mínima nocturna de $200.52\text{ K}$ ($-72.63^\circ\text{C}$) a $216.54\text{ K}$ ($-56.61^\circ\text{C}$), evitando la congelación de los componentes orientados al espacio profundo.
4. **Interacción Cruzada $\frac{\partial^2 T_{\max}}{\partial Q \partial g}$:**
   - La sensibilidad a la potencia no es constante: con aislamiento ($g = 1.0$) es de $0.203\text{ K/W}$, mientras que con alta conducción ($g = 4.0$) desciende a $0.089\text{ K/W}$. Una estructura conductiva desensibiliza al satélite frente a variaciones en el consumo de potencia de sus computadoras.

### 4.3 Diferenciación Epistemológica: Grilla Factorial Gruesa vs. Máximo Localizado Continuo
- **Hecho:** El valor $306.33\text{ K}$ ($+33.18^\circ\text{C}$) registrado en [`C3-SWEEP-007`](results/C3-SWEEP-007/) es el **máximo muestral discreto** dentro del conjunto de los 9 puntos evaluados en la grilla $3 \times 3$.
- **Distinción metodológica:** **NO DEBE CONFUNDIRSE CON UN MÁXIMO GLOBAL OPTIMIZADO.** Una grilla de 9 celdas es una discretización factorial gruesa con fines exploratorios. Si se permitiera que $g_{\text{lin}} \to 0$ (aislamiento perfecto) o que $\dot{Q}_{\text{int}} > 60\text{ W}$, la temperatura máxima continuaría aumentando monótonamente. No existe un punto crítico interno estacionario ($\nabla M = \mathbf{0}$) en el dominio $[20, 60]\text{ W} \times [1, 4]\text{ W/(K}\cdot\text{m)}$; la respuesta es monotónica en ambos factores.

---

## 5. Síntesis Comparativa: Hechos, Interpretaciones y Limitaciones

| Dimensión de Análisis | Hechos Numéricos (Medidos) | Interpretación Física / Numérica | Limitaciones del Alcance |
| :--- | :--- | :--- | :--- |
| **Línea Base (`C3-BASE-001`)** | $M_1 = 291.80\text{ K}$, $M_2 = 63.06\text{ K}$, $M_3 = 209.94\text{ K}$ en $[3P, 5P]$. Identidad bit-a-bit vs Lab 2 ($0.000\text{ K}$). | Régimen cíclico permanente en LEO balanceado con $0.36\%$ de residuo orbital. | Propiedades ópticas fijas; sin sombras proyectadas por alas solares. |
| **Sensibilidad Local (Bloque A)** | $D_1(\delta=4\text{ W}) = 0.1320\text{ K/W}$, $D_1(\delta=2\text{ W}) = 0.1369\text{ K/W}$. Error relativo: $3.59\%$. $S_1 = 0.0188$. | Calentamiento local de $+0.134^\circ\text{C/W}$. Alta resiliencia por dominancia radiativa externa. | Válido únicamente en el entorno local ($\pm 10\%$) de $\theta_0 = 40\text{ W}$ y $g_{\text{lin}} = 2.0$. |
| **Conducción Estructural ($g_{\text{lin}}$)** | Reducción de $T_{\max, +X}$ de $302.30\text{ K}$ a $284.64\text{ K}$ ($\Delta = 17.66\text{ K}$). Pasos de `ode45` aumentan de 318 a 419. | Conducción es el regulador pasivo primario. Aumento de pasos por incremento de autovalores negativos (rigidez). | Matriz de aristas uniforme ($g_{\text{lin}}$ homogéneo en las 12 aristas). |
| **Respuesta Térmica Extrema** | Rango del barrido: $[282.86\text{ K}, 306.33\text{ K}]$ ($+9.71^\circ\text{C}$ a $+33.18^\circ\text{C}$). Finitud $100\%$. | Todas las soluciones se mantienen dentro de los límites seguros de operación del chasis ($< 450\text{ K}$). | Muestreo factorial grueso de 9 puntos; no representa una superficie continua optimizada. |

---

## 6. Afirmación Científica Propuesta para el Paper (`Paper_v0.3.md`)

Con base en la totalidad de la evidencia numérica generada y verificada, se formula la siguiente afirmación formal para ser incorporada en las conclusiones y discusión del manuscrito:

### Declaración Científica Propuesta:
> *"Para el modelo térmico nodal continuo del satélite STARLINK-1008 en órbita LEO, la respuesta de la temperatura pico de proa ($T_{\max, +X}$) frente a la disipación interna de la aviónica presenta un régimen cuasi-lineal altamente estable con una tasa diferencial de $+0.134 \pm 0.003\text{ K/W}$ (sensibilidad normalizada $S \approx 0.0188$) en torno a la condición nominal de $40\text{ W}$. No obstante, el barrido paramétrico bidimensional demuestra que la conductancia estructural inter-panel ($g_{\text{lin}}$) ejerce una dominancia térmica superior en un factor de $3.25\times$ sobre el pico térmico frente a la potencia disipada en todo el rango admisible de operación, reduciendo simultáneamente la amplitud cíclica orbital en $14.4\text{ K}$ y atenuando la sensibilidad térmica a la disipación interna en más del $56\%$ (de $0.203\text{ K/W}$ a $0.089\text{ K/W}$) al pasar de una configuración de aislamiento conductivo a una de alta conducción estructural."*

### Evidencia Empírica que Sostiene la Afirmación:
1. **Derivada local verificada:** Corroborada mediante convergencia diádica de diferencias finitas centrales entre los pares simétricos de $4.0\text{ W}$ y $2.0\text{ W}$ con una discrepancia del $3.59\%$ ([`C3-SENS-001-M10`](results/C3-SENS-001-M10/) a [`C3-SENS-004-P05`](results/C3-SENS-004-P05/)).
2. **Linealidad macroscópica:** Coincidencia al $0.95\%$ entre la derivada local ($0.1369\text{ K/W}$) y la pendiente del barrido macroscópico a $g_{\text{lin}} = 2.0\text{ W/(K}\cdot\text{m)}$ entre $20\text{ W}$ y $60\text{ W}$ ($0.1356\text{ K/W}$, [`C3-SWEEP-002`](results/C3-SWEEP-002/) y [`C3-SWEEP-008`](results/C3-SWEEP-008/)).
3. **Dominancia estructural cuantitativa:** Salto térmico por conductancia de $\Delta T = 17.66\text{ K}$ ($302.30\text{ K} \to 284.64\text{ K}$, [`C3-SWEEP-004`](results/C3-SWEEP-004/) vs [`C3-SWEEP-006`](results/C3-SWEEP-006/)) frente a sólo $\Delta T = 5.42\text{ K}$ por potencia a conductancia nominal ($289.09\text{ K} \to 294.51\text{ K}$, [`C3-SWEEP-002`](results/C3-SWEEP-002/) vs [`C3-SWEEP-008`](results/C3-SWEEP-008/)), arrojando la relación $\frac{17.66}{5.42} \approx 3.26$.
4. **Atenuación del swing térmico:** Caída de $\Delta T_{+X}$ de $71.52\text{ K}$ a $57.07\text{ K}$ en la cara $+X$ en el barrido de conductancia.
5. **Mitigación de la pendiente disipativa:** Reducción de $\frac{\Delta T_{\max}}{\Delta Q}$ de $0.203\text{ K/W}$ para $g_{\text{lin}} = 1.0$ a $0.089\text{ K/W}$ para $g_{\text{lin}} = 4.0$ ([`C3-SWEEP-001`](results/C3-SWEEP-001/) a [`C3-SWEEP-009`](results/C3-SWEEP-009/)).
6. **Preservación estricta de dominios y finitud:** $100\%$ de las trayectorias cumplieron $\text{isfinite} == \text{true}$, con cotas térmicas físicas $T_{\min} \ge 200.52\text{ K} \gg 2.7\text{ K}$ y $T_{\max} \le 306.33\text{ K} \ll 450.0\text{ K}$.

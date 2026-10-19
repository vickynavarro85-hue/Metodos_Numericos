# Figure and Table Manifest - Laboratorio #3: Trazabilidad Gráfica y Tabular

## Metadatos y Control de Configuración

- **Documento:** `Figure_Table_Manifest.md`
- **Versión:** 1.0 (Manifiesto de Artefactos Visuales y Tabulares)
- **Fecha:** 2026-10-06
- **Roles Activos:** Figure Agent & Table Agent (IA)
- **Investigadora Principal:** Victoria Navarro (Estudiante investigadora - DING59)
- **Sujeto de Estudio:** Satélite STARLINK-1008 (PVI no lineal de 6 nodos térmicos acoplados en órbita LEO)
- **Directorio de Trabajo:** `LAB3_NAVARRO_VICTORIA/`
- **Código Generador:** [`generate_figures_and_tables.m`](generate_figures_and_tables.m) (v1.0)
- **Entorno de Generación:** MATLAB R2024a (`24.1.0.2537033`) bajo macOS 15.4.1 Apple Silicon

---

## 1. Catálogo de Archivos de Datos Fuente (Data Provenance)

Todos los valores numéricos graficados y tabulados provienen directamente de simulaciones computadas con `ode45` e integradas en disco, **sin reconstrucción visual a partir de imágenes previas ni interpolaciones no fundamentadas**:

| ID Fuente | Ruta Relativa del Archivo | Descripción del Contenido | Variables Empleadas |
| :--- | :--- | :--- | :--- |
| **SRC-01** | [`results/sweep_summary.csv`](results/sweep_summary.csv) | Tabla consolidada de la matriz de barrido $3 \times 3$ | `Run_ID`, `Q_int_W`, `g_lin_W_Km`, `M1_Tmax_pX_C`, `M2_deltaT_pX_K`, `M3_Tmin_pZ_C`, `nfev`, `pasos` |
| **SRC-02** | [`results/C3-BASE-001/config.json`](results/C3-BASE-001/config.json) | Metadatos y métricas escalares del baseline | `M1_Tmax_pX` ($291.7968\text{ K}$), `M2_deltaT` ($63.0588\text{ K}$), `M3_Tmin_pZ` ($209.9365\text{ K}$) |
| **SRC-03** | [`results/C3-SENS-001-M10/config.json`](results/C3-SENS-001-M10/config.json) | Corrida Nivel 1 inferior ($\delta = 4.0\text{ W}$, $-10\%$) | $Q = 36.0\text{ W}$, $M_1 = 291.2630\text{ K}$ ($+18.1130^\circ\text{C}$), $M_2 = 63.1689\text{ K}$ |
| **SRC-04** | [`results/C3-SENS-002-P10/config.json`](results/C3-SENS-002-P10/config.json) | Corrida Nivel 1 superior ($\delta = 4.0\text{ W}$, $+10\%$) | $Q = 44.0\text{ W}$, $M_1 = 292.3186\text{ K}$ ($+19.1686^\circ\text{C}$), $M_2 = 62.9621\text{ K}$ |
| **SRC-05** | [`results/C3-SENS-003-M05/config.json`](results/C3-SENS-003-M05/config.json) | Corrida Nivel 2 inferior ($\delta/2 = 2.0\text{ W}$, $-5\%$) | $Q = 38.0\text{ W}$, $M_1 = 291.5441\text{ K}$ ($+18.3941^\circ\text{C}$), $M_2 = 63.1182\text{ K}$ |
| **SRC-06** | [`results/C3-SENS-004-P05/config.json`](results/C3-SENS-004-P05/config.json) | Corrida Nivel 2 superior ($\delta/2 = 2.0\text{ W}$, $+5\%$) | $Q = 42.0\text{ W}$, $M_1 = 292.0915\text{ K}$ ($+18.9415^\circ\text{C}$), $M_2 = 63.0562\text{ K}$ |
| **SRC-07** | [`results/C3-SWEEP-001/states.mat`](results/C3-SWEEP-001/states.mat) a [`C3-SWEEP-009/states.mat`](results/C3-SWEEP-009/states.mat) | Series temporales completas $\mathbf{T}(t) \in \mathbb{R}^{6 \times N}$ | Trayectorias continuas de los 6 nodos en $t \in [0, 27600\text{ s}]$ |

---

## 2. Transformaciones de Datos Aplicadas

1. **Conversión de Escala de Temperatura:**
   $$T [^\circ\text{C}] = T [\text{K}] - 273.15$$
   Aplicada para facilitar la lectura en ingeniería térmica manteniendo consistencia absoluta con los Kelvin calculados por el integrador.
2. **Ventana de Régimen Permanente:**
   Todas las métricas extremas ($T_{\max}, T_{\min}, \Delta T$) fueron extraídas exclusivamente en el intervalo de las últimas dos órbitas tras amortiguar el transitorio inicial de 3 órbitas:
   $$t \in [3P, 5P] = [16575.69\text{ s}, 27600.00\text{ s}], \quad P = 5525.23\text{ s}$$
3. **Estimador de Derivadas por Diferencias Finitas Centrales:**
   $$D_1(\delta) = \frac{M_1(\theta_0 + \delta) - M_1(\theta_0 - \delta)}{2\delta} \quad \left[\frac{\text{K}}{\text{W}}\right]$$
4. **Sensibilidad Normalizada Adimensional:**
   $$S_1(\delta) = \left(\frac{\theta_0}{M_{1,0}}\right) D_1(\delta) \quad (\theta_0 = 40.0\text{ W}, M_{1,0} = 291.7968\text{ K})$$

---

## 3. Exclusiones y Declaración de Integridad Metodológica

1. **Exclusiones de Corridas:**
   - La corrida fallida de Lab 2 ([`RUN-01-ODE45-FAILED`](../LAB2_NAVARRO_VICTORIA/results/RUN-01-ODE45-FAILED/)) fue **formalmente excluida** de todas las figuras y tablas comparativas, conservándose únicamente su causa documentada en la bitácora histórica.
   - En Lab 3, las 14 corridas/registros fueron **100% válidas y admitidas**.
2. **Prohibición de Barras de Incertidumbre Inventadas:**
   - En cumplimiento estricto de las directivas científicas, **NO SE INCLUYERON BARRAS DE ERROR NI DE INCERTIDUMBRE SINTÉTICAS** en las figuras. Los modelos computacionales determinísticos no poseen varianza estocástica; agregar barras arbitrarias constituiría una falsificación metodológica. La incertidumbre del parámetro se abordó de forma rigurosa mediante los pares de perturbación de sensibilidad local y la matriz de barrido.

---

## 4. Especificación Detallada de la Figura (Figura 1)

- **Archivo Generado:** [`results/fig_manuscript_results.png`](results/fig_manuscript_results.png)
- **Dimensiones:** $1260 \times 800$ píxeles (Renderizado a alta resolución, fondo blanco, versión V2 corregida sin solapamientos).
- **Código Ejecutor:** Función `generate_figures_and_tables()` en [`generate_figures_and_tables.m`](generate_figures_and_tables.m).
- **Diseño Multi-panel Accesible (Diferenciación Triple por Color, Marcador y Estilo de Línea):**

```
┌──────────────────────────────────────────────┬──────────────────────────────────────────────┐
│ (a) Sensibilidad en Proa (+X / Ram)          │ (b) Iso-Conductancias en Proa (+X)           │
│     - Línea sólida azul con círculos         │     - g=1.0: Discontinua roja + cuadrados    │
│     - Estrella roja: Baseline (40 W)         │     - g=2.0: Sólida verde + círculos         │
│     - Recuadro en esquina inferior derecha   │     - g=4.0: Punteada azul + triángulos      │
│       con D_1(4W), D_1(2W) y discrepancia    │     - Rótulos explícitos de Run IDs extremos │
│                                              │     - Estrella roja: C3-SWEEP-005 (Base)     │
├──────────────────────────────────────────────┼──────────────────────────────────────────────┤
│ (c) Amplitud de Oscilación Cíclica en Proa   │ (d) Calentamiento Pasivo del Radiador Cenit  │
│     - Delta T [+X] vs Q_int                  │     - T_min [+Z] vs Q_int                    │
│     - Eje Y unificado: [°C \equiv K]         │     - Eje Y en [°C] con valores negativos    │
│     - 3 estilos de línea y marcadores        │     - Muestra elevación térmica en eclipse   │
└──────────────────────────────────────────────┴──────────────────────────────────────────────┘
Super-título: Satélite STARLINK-1008 (LEO) - Régimen Permanente Cíclico en [3P, 5P] (P = 5525.2 s)
```

### Pie de Figura Propuesto (Caption para el Manuscrito):
> **Figura 1.** Respuesta térmica en régimen permanente periódico ($t \in [3P, 5P] = [16575.7, 27600.0]\text{ s}$, período orbital $P = 5525.2\text{ s}$) del satélite STARLINK-1008 en órbita baja terrestre (LEO). **(a)** Sensibilidad paramétrica local de la temperatura máxima de proa ($T_{\max, +X}$) frente a la potencia disipada por la aviónica ($\dot{Q}_{\text{int}, +X}$) alrededor del valor nominal de $40.0\text{ W}$, mostrando la convergencia de las derivadas centrales ($D_1 = 0.1320\text{ K/W}$ a $\delta=4.0\text{ W}$ y $D_1 = 0.1369\text{ K/W}$ a $\delta/2=2.0\text{ W}$, discrepancia del $3.59\%$). **(b)** Curvas de iso-conductancia estructural inter-panel ($g_{\text{lin}} \in \{1.0, 2.0, 4.0\}\text{ W/(K}\cdot\text{m)}$) en la matriz de barrido $3 \times 3$, evidenciando que aumentar el acoplamiento estructural reduce el pico térmico en hasta $17.66\text{ K}$ y ejerce una dominancia de $3.25\times$ frente a la disipación interna. **(c)** Amplitud térmica orbital ($\Delta T_{+X}$), ilustrando la mitigación de la fatiga cíclica de $71.5\text{ K}$ a $57.1\text{ K}$. **(d)** Temperatura mínima de la cara cenit ($T_{\min, +Z}$), reflejando la transferencia conductiva pasiva que previene el sobreenfriamiento del radiador en eclipse ($200.5\text{ K} \to 217.2\text{ K}$).

---

## 5. Especificación Detallada de la Tabla (Tabla 1)

- **Archivos Generados:**
  - Formato CSV procesable: [`results/table_results_consolidated.csv`](results/table_results_consolidated.csv)
  - Formato Markdown enriquecido: [`results/table_results_consolidated.md`](results/table_results_consolidated.md)
- **Alcance:** 14 registros ordenados por familia metodológica.
- **Ventana temporal explícita:** Régimen permanente periódico de las últimas dos órbitas: $t \in [3P, 5P] = [16575.7, 27600.0]\text{ s}$.

### Tabla Consolidada de Resultados

| Run ID | Bloque / Descripción | $Q_{\text{int}, +X}$ [W] | $g_{\text{lin}}$ [W/(K·m)] | $M_1$ ($T_{\max, +X}$) [K] | $M_1$ [$^\circ\text{C}$] | $M_2$ ($\Delta T_{+X}$) [K] | $M_3$ ($T_{\min, +Z}$) [K] | $M_3$ [$^\circ\text{C}$] | Pasos | `nfev` | CPU [s] | Estado Operacional |
| :--- | :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :--- |
| [`C3-BASE-001`](results/C3-BASE-001/) | **Baseline Nominal** | **40.0** | **2.0** | **291.7968** | **+18.65** | **63.0588** | **209.9365** | **-63.21** | 351 | 2707 | 0.22 | **VÁLIDA (Baseline Nominal)** |
| [`C3-SENS-001-M10`](results/C3-SENS-001-M10/) | Sensibilidad ($-10\%$) | 36.0 | 2.0 | 291.2630 | +18.11 | 63.1689 | 209.8110 | -63.34 | 359 | 2785 | 0.28 | **VÁLIDA ($\delta = 4.0\text{ W}$)** |
| [`C3-SENS-002-P10`](results/C3-SENS-002-P10/) | Sensibilidad ($+10\%$) | 44.0 | 2.0 | 292.3186 | +19.17 | 62.9621 | 210.0746 | -63.08 | 364 | 2821 | 0.13 | **VÁLIDA ($\delta = 4.0\text{ W}$)** |
| [`C3-SENS-003-M05`](results/C3-SENS-003-M05/) | Sensibilidad ($-5\%$) | 38.0 | 2.0 | 291.5441 | +18.39 | 63.1182 | 209.8673 | -63.28 | 354 | 2731 | 0.10 | **VÁLIDA ($\delta/2 = 2.0\text{ W}$)** |
| [`C3-SENS-004-P05`](results/C3-SENS-004-P05/) | Sensibilidad ($+5\%$) | 42.0 | 2.0 | 292.0915 | +18.94 | 63.0562 | 210.0151 | -63.13 | 367 | 2869 | 0.12 | **VÁLIDA ($\delta/2 = 2.0\text{ W}$)** |
| [`C3-SWEEP-001`](results/C3-SWEEP-001/) | Barrido ($Q_{20}, g_1$) | 20.0 | 1.0 | 298.1956 | +25.05 | 72.5035 | 200.5173 | -72.63 | 331 | 2707 | 0.16 | **VÁLIDA (Aislado)** |
| [`C3-SWEEP-002`](results/C3-SWEEP-002/) | Barrido ($Q_{20}, g_2$) | 20.0 | 2.0 | 289.0864 | +15.94 | 63.5247 | 209.2479 | -63.90 | 352 | 2695 | 0.12 | **VÁLIDA (Nominal)** |
| [`C3-SWEEP-003`](results/C3-SWEEP-003/) | Barrido ($Q_{20}, g_4$) | 20.0 | 4.0 | 282.8593 | +9.71 | 57.2910 | 215.8486 | -57.30 | 418 | 3139 | 0.12 | **VÁLIDA (Conectivo)** |
| [`C3-SWEEP-004`](results/C3-SWEEP-004/) | Barrido ($Q_{40}, g_1$) | 40.0 | 1.0 | 302.2978 | +29.15 | 71.5176 | 201.2055 | -71.94 | 318 | 2575 | 0.09 | **VÁLIDA (Aislado)** |
| [`C3-SWEEP-005`](results/C3-SWEEP-005/) | Barrido ($Q_{40}, g_2$) | 40.0 | 2.0 | 291.7968 | +18.65 | 63.0588 | 209.9365 | -63.21 | 351 | 0 | 0.00 | **VÁLIDA (Reutiliza C3-BASE-001\*)** |
| [`C3-SWEEP-006`](results/C3-SWEEP-006/) | Barrido ($Q_{40}, g_4$) | 40.0 | 4.0 | 284.6377 | +11.49 | 57.0701 | 216.5390 | -56.61 | 419 | 3121 | 0.11 | **VÁLIDA (Conectivo)** |
| [`C3-SWEEP-007`](results/C3-SWEEP-007/) | Barrido ($Q_{60}, g_1$) | 60.0 | 1.0 | 306.3326 | +33.18 | 70.5001 | 201.8378 | -71.31 | 318 | 2557 | 0.09 | **VÁLIDA (Peor Caliente)** |
| [`C3-SWEEP-008`](results/C3-SWEEP-008/) | Barrido ($Q_{60}, g_2$) | 60.0 | 2.0 | 294.5091 | +21.36 | 62.6261 | 210.6127 | -62.54 | 357 | 2785 | 0.11 | **VÁLIDA (Nominal)** |
| [`C3-SWEEP-009`](results/C3-SWEEP-009/) | Barrido ($Q_{60}, g_4$) | 60.0 | 4.0 | 286.4153 | +13.27 | 56.8516 | 217.2336 | -55.92 | 409 | 3031 | 0.13 | **VÁLIDA (Conectivo)** |

\* *Nota de reutilización:* `C3-SWEEP-005` coincide exactamente con la configuración de la línea base nominal; reutiliza formalmente la integración de `C3-BASE-001` (351 pasos archivados) con 0 evaluaciones diferenciales nuevas (NFEV = 0, CPU = 0.00 s).

### Pie de Tabla Propuesto (Caption para el Manuscrito):
> **Tabla 1.** Corpus integral de resultados experimentales para el satélite STARLINK-1008 en órbita baja terrestre (LEO). Los experimentos integran la línea base (`C3-BASE-001`), los cuatro casos simétricos de perturbación de sensibilidad local en proa (Bloque A) y las nueve celdas de la matriz factorial de barrido paramétrico bidimensional $3 \times 3$ (Bloque B). Todas las temperaturas corresponden a la ventana de régimen permanente periódico ($t \in [3P, 5P]$). La corrida `C3-SWEEP-005` reutiliza formalmente los archivos de la línea base `C3-BASE-001` sin coste computacional adicional (`nfev = 0`). Las 14 corridas preservaron estrictamente el dominio físico ($T > 2.7\text{ K}$, $T < 450\text{ K}$, finitud $100\%$).


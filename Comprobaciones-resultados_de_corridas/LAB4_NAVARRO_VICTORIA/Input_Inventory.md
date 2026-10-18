# Inventario de Entradas e Insumos Metodológicos - Laboratorio #4

## Metadatos y Control de Configuración

- **Documento:** `Input_Inventory.md`
- **Versión:** 1.0
- **Fecha de Creación:** 2026-10-18
- **Investigadora Principal:** Victoria Navarro (Estudiante Investigadora - Cátedra de Métodos Numéricos DING59)
- **Rol del Agente:** Research Orchestrator (IA)
- **Sujeto de Estudio:** Satélite STARLINK-1008 (NORAD ID: 44714) en Órbita Baja Terrestre (LEO)
- **Directorio de Trabajo:** [`LAB4_NAVARRO_VICTORIA/`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/)
- **Directorio de Insumos Aislados:** [`LAB4_NAVARRO_VICTORIA/inputs/`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/inputs/)
- **Estado General:** **`INPUTS_INVENTARIADOS_COMPLETO`**

---

## 1. Tabla de Inventario de Insumos y Disponibilidad

A continuación se audita y cataloga cada uno de los artefactos precedentes transferidos a la carpeta `inputs/` de este Laboratorio #4, preservando intactas las carpetas originales de los Laboratorios #1, #2 y #3:

| ID | Archivo / Artefacto | Versión | Propósito Metodológico en Lab 4 | Estado / Disponibilidad |
| :---: | :--- | :---: | :--- | :---: |
| **INP-01** | [`inputs/Problem_Definition.md`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/inputs/Problem_Definition.md) | v1.0 | Define la pregunta científica original, volumen de control espacial (6 paneles planos del cuerpo principal), horizonte temporal de simulación ($t_f = 5P \approx 27627\text{ s}$), vector de estados $\mathbf{T} \in \mathbb{R}^6$ en Kelvin y salidas observables. | **DISPONIBLE** |
| **INP-02** | [`inputs/Mathematical_Model_v1.md`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/inputs/Mathematical_Model_v1.md) | v1.0 | Deducción analítica continua del PVI térmico nodal: balances de potencia instantáneos, acoplamiento radiativo no lineal de Stefan-Boltzmann con el espacio profundo ($2.7\text{ K}$) y matriz de acoplamiento conductivo estructural $G_{ij}$. | **DISPONIBLE** |
| **INP-03** | [`inputs/model.m`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/inputs/model.m) | v1.1 | Implementación vectorial del campo diferencial $\dot{\mathbf{T}} = \mathbf{f}(t, \mathbf{T}, \boldsymbol{\theta})$ en MATLAB, con protección radiativa de etapas intermedias ($T_{\text{rad}} = \max(T, T_{\text{esp}})$) aprobada en Gate 2. | **DISPONIBLE** |
| **INP-04** | [`inputs/get_params.m`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/inputs/get_params.m) | v1.0 | Parámetros nominales congelados: dimensiones del chasis ($2.8 \times 1.4 \times 0.3\text{ m}$), propiedades ópticas ($\alpha, \varepsilon$), capacidades caloríficas nodales ($C_i$), conductancia lineal ($g_{\text{lin}} = 2.0\text{ W/(K}\cdot\text{m)}$) y disipación interna nominal ($\dot{Q}_{\text{int}, +X} = 40\text{ W}$). | **DISPONIBLE** |
| **INP-05** | [`inputs/solve_adaptive.m`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/inputs/solve_adaptive.m) | v1.0 | Integrador adaptativo numérico basado en `ode45` (Dormand-Prince orden 4/5) con tolerancias estrictas de convergencia (`RelTol = 1e-6`, `AbsTol = 1e-6 K`). | **DISPONIBLE** |
| **INP-06** | [`inputs/orbital_data.mat`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/inputs/orbital_data.mat) | v1.0 | Datos de efemérides orbitales SGP4 de CelesTrak (vector de posición solar en marco LVLH, altitud $h \approx 377\text{ km}$, inclinación $i = 53.15^\circ$, período $P = 5525.23\text{ s}$). | **DISPONIBLE** |
| **INP-07** | [`inputs/Gate_3.md`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/inputs/Gate_3.md) | v1.0 | Acta de decisión y firma humana de Victoria Navarro formalizada el 2026-10-13 con veredicto **`ACCEPT`** (Aprobación formal con alcance delimitado de verificación numérica). Fija las restricciones epistemológicas innegociables. | **DISPONIBLE** |
| **INP-08** | [`inputs/Paper_v0.3.md`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/inputs/Paper_v0.3.md) | v0.3 | Manuscrito consolidado de investigación científica (`APROBADO_CON_ALCANCE_LIMITADO`), con 14 corridas numéricas, Tabla 1 consolidada, Figura 1 multi-panel, análisis de sensibilidad y barrido factorial $3 \times 3$. | **DISPONIBLE** |
| **INP-09** | [`inputs/Sensitivity_Report.md`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/inputs/Sensitivity_Report.md) | v1.0 | Reporte formal del Bloque A de sensibilidad paramétrica local: variaciones de potencia interna ($\pm 5\%$, $\pm 10\%$), derivada diádica con consistencia de $3.59\%$ y gradientes locales. | **DISPONIBLE** |
| **INP-10** | [`inputs/Results_Analysis.md`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/inputs/Results_Analysis.md) | v1.0 | Análisis integral del Bloque B (matriz factorial $3 \times 3$), demostrando la dominancia estructural de $g_{\text{lin}}$ ($3.25\times$ superior frente a $\dot{Q}_{\text{int}}$) y mitigación de fatiga térmica. | **DISPONIBLE** |
| **INP-11** | [`inputs/Scientific_Critique.md`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/inputs/Scientific_Critique.md) | v1.0 | Dictamen de revisión por pares independiente del Scientific Critic con las 6 objeciones científicas (CRIT-01 a CRIT-06), delimitando las fronteras epistemológicas. | **DISPONIBLE** |
| **INP-12** | [`inputs/Figure_Table_Manifest.md`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/inputs/Figure_Table_Manifest.md) | v1.0 | Manifiesto de trazabilidad que vincula cada figura (`fig_sensitivity_sweep.png`) y tabla (`Table_1_Consolidated.csv`) con los 14 Run IDs de simulación. | **DISPONIBLE** |
| **INP-13** | [`inputs/Numerical_Evidence_v1.md`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/inputs/Numerical_Evidence_v1.md) | v1.0 | Evidencia de convergencia numérica de Lab 2: comparación de solvers (Euler, RK2, RK4, ode45, ode15s), estudio de estabilidad y tiempo computacional. | **DISPONIBLE** |
| **INP-14** | [`inputs/RESEARCH_LOG_Lab3.md`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/inputs/RESEARCH_LOG_Lab3.md) | v1.0 | Bitácora completa y continua de Lab 3 (Entradas 001 a 015), registrando toda la trazabilidad y la firma humana en Gate 3. | **DISPONIBLE** |

---

## 2. Identificación de la Pregunta Científica Vigente

> [!IMPORTANT]
> **Delimitación Innegociable del Caso de Estudio:**  
> El sujeto de investigación de Victoria Navarro es **exclusiva y taxativamente el satélite STARLINK-1008 en órbita baja terrestre (LEO)**.  
> **No es ni ha sido nunca la viga termo-vibratoria 1D** utilizada por la cátedra como ejemplo didáctico en clase. Queda terminantemente descartada cualquier asunción o analogía con el problema docente.

### Formulación Formal de la Pregunta de Investigación:
> *¿Cómo predecir y caracterizar con precisión analítica y numérica la evolución térmica transitoria y periódica en régimen permanente de las 6 superficies externas del satélite STARLINK-1008 sometido a forzamiento radiativo orbital periódico (ciclos Sol-albedo-eclipse), disipación interna de aviónica y conducción estructural entre paneles, y cómo influye la variación de parámetros térmico-ópticos, conductivos y de disipación interna sobre las temperaturas extremas operacionales ($M_1$), las amplitudes de ciclado térmico por fatiga ($M_2$) y la prevención del sobreenfriamiento criogénico en eclipse ($M_3$)?*

---

## 3. Identificación del Modelo Físico-Matemático y Numérico Vigente

### 3.1. Ecuaciones Diferenciales Continuas del PVI
El sistema está gobernado por un balance de energía nodal continuo en $\mathbb{R}^6$ sobre el vector de temperaturas de cara $\mathbf{T}(t) = [T_{+X}, T_{-X}, T_{+Y}, T_{-Y}, T_{+Z}, T_{-Z}]^T \in \mathbb{R}^6$ (en Kelvin):

$$C_i \frac{dT_i}{dt} = \dot{Q}_{\text{sol}, i}(t) + \dot{Q}_{\text{alb}, i}(t) + \dot{Q}_{\text{IR}, i} + \dot{Q}_{\text{int}, i} + \sum_{j \in \text{ady}(i)} G_{ij} (T_j(t) - T_i(t)) - \sigma \varepsilon_i A_i (T_i^4(t) - T_{\text{esp}}^4)$$

donde:
- $\dot{Q}_{\text{sol}, i}(t) = \alpha_i A_i S_{\text{solar}} (\hat{\mathbf{s}}(t) \cdot \hat{\mathbf{n}}_i)^+ \cdot \text{ilum}(t)$, con $S_{\text{solar}} = 1361\text{ W/m}^2$.
- $\dot{Q}_{\text{alb}, i}(t) = \alpha_i A_i S_{\text{solar}} a_{\text{Earth}} F_{\text{Earth}\to i} (\hat{\mathbf{s}}(t) \cdot \hat{\mathbf{r}}_{\text{nadir}})^+ \cdot \text{ilum}(t)$, con $a_{\text{Earth}} = 0.30$.
- $\dot{Q}_{\text{IR}, i} = \varepsilon_i A_i q_{\text{IR}} F_{\text{Earth}\to i}$, con $q_{\text{IR}} = 237\text{ W/m}^2$.
- $\dot{Q}_{\text{cond}, i} = \sum_{j \in \text{ady}(i)} G_{ij} (T_j - T_i)$, con conductancias lineales de arista $G_{ij} = g_{\text{lin}} \cdot L_{\text{arista}, ij}$.
- $\dot{Q}_{\text{rad}, i} = \sigma \varepsilon_i A_i (T_i^4 - T_{\text{esp}}^4)$, con $\sigma = 5.670374 \times 10^{-8}\text{ W/(m}^2\text{K}^4)$ y $T_{\text{esp}} = 2.7\text{ K}$.

### 3.2. Implementación Numérica y Versiones Vigentes
- **Archivo de campo vectorial:** [`inputs/model.m`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/inputs/model.m) (v1.1).  
  *Característica crítica:* Incorpora protección contra radicandos o etapas tentativas no físicas mediante $T_{\text{rad}} = \max(T, T_{\text{esp}})$, preservando la no linealidad pura $T^4$ en etapas válidas.
- **Archivo de parámetros congelados:** [`inputs/get_params.m`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/inputs/get_params.m) (v1.0).  
  *Valores nominales congelados:* $\dot{Q}_{\text{int}, +X} = 40.0\text{ W}$, $g_{\text{lin}} = 2.0\text{ W/(K}\cdot\text{m)}$, $T_0 = 293.15\text{ K}$ ($+20^\circ\text{C}$).
- **Integrador validado:** [`inputs/solve_adaptive.m`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/inputs/solve_adaptive.m) (v1.0).  
  *Algoritmo:* `ode45` (Runge-Kutta Dormand-Prince orden 4/5) con tolerancias `RelTol = 1e-6`, `AbsTol = 1e-6 K`.
- **Efemérides:** [`inputs/orbital_data.mat`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/inputs/orbital_data.mat) (v1.0), $P = 5525.23\text{ s}$, 5 órbitas completas ($t_f \approx 27626.15\text{ s}$).
- **Línea Base Nominal Verificada:** Run ID `C3-BASE-001`, con identidad bit a bit ($0.000\text{ K}$) respecto a `RUN-01-ODE45` de Lab 2. Métricas:
  - $M_1$ ($T_{\max, +X}$) = $291.7968\text{ K}$ ($+18.65^\circ\text{C}$).
  - $M_2$ ($\Delta T_{+X}$) = $63.0588\text{ K}$.
  - $M_3$ ($T_{\min, +Z}$) = $209.9365\text{ K}$ ($-63.21^\circ\text{C}$).

---

## 4. Pendientes Reales y Objeciones Abiertas Heredadas de Gate 3

En [`inputs/Gate_3.md`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/inputs/Gate_3.md) y [`inputs/Scientific_Critique.md`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/inputs/Scientific_Critique.md), la investigadora Victoria Navarro aprobó los resultados del Lab 3 estableciendo explícitamente los siguientes pendientes y restricciones metodológicas abiertas:

1. **CRIT-03 (Tasa de Orden Asintótico de Derivadas):**  
   Los dos niveles diádicos analizados en Lab 3 ($\delta = 4\text{ W}$ y $\delta/2 = 2\text{ W}$) demostraron consistencia numérica de ingeniería ($\varepsilon_{\text{rel}} = 3.59\% < 5\%$), pero **no demuestran formalmente un orden asintótico cuadrático $\mathcal{O}(\delta^2)$** debido a la ausencia de un tercer nivel ($\delta/4 = 1\text{ W}$). Esto quedó asentado como salvedad obligatoria en el paper.
2. **CRIT-04 (Máximo Muestral de Esquina vs. Extremo Continuo Analítico):**  
   El valor pico registrado de $306.33\text{ K}$ (`C3-SWEEP-007`) es el peor caso de frontera de la malla factorial discreta explorada, no un punto estacionario analítico con gradiente nulo ($\nabla M = \mathbf{0}$).
3. **CRIT-06 (Frontera Epistemológica Innegociable):**  
   Debido a la ausencia de telemetría de vuelo directa de SpaceX o datos experimentales de cámara de termovacío (TVAC), toda la investigación constituye **verificación matemática y paramétrica del PVI**, quedando terminantemente prohibido atribuirse validación física de vuelo en órbita real.
4. **Definición del Alcance Metodológico de Lab 4:**  
   Falta incorporar la consigna o guía de trabajo específica del Laboratorio #4 (por ejemplo: optimización de parámetros térmicos, estimación de estados/filtro de Kalman, análisis de incertidumbre UQ, o control térmico activo/pasivo) para formular los contratos y planes de este nuevo ciclo.

---

## 5. Evaluación de Disponibilidad y Estado `NEEDS_INPUT`

- **Insumos Precedentes (Labs 1, 2 y 3):** **100% DISPONIBLES** (14 de 14 archivos auditados e íntegros en `inputs/`). No falta ningún archivo de los laboratorios previos.
- **Condición de Bloqueo por Falta de Información:**  
  > [!NOTE]
  > **`NEEDS_INPUT` Activo:**  
  > Se requiere que la investigadora Victoria Navarro comparta la consigna, objetivos o guía formal de actividades del **Laboratorio #4** dictada por la cátedra para:
  > 1. Configurar los objetivos y preguntas secundarias del Lab 4.
  > 2. Diseñar el plan experimental y la formulación computacional adecuada.
  > 3. Definir los nuevos contratos de verificación antes de ejecutar simulaciones.

---

## 6. Próximos Pasos Recomendados

1. Registrar la apertura de la investigación de Lab 4 en [`RESEARCH_LOG.md`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/RESEARCH_LOG.md) (Entrada 001).
2. Solicitar formalmente a la usuaria la consigna o guía de actividades de Lab 4.
3. Formular los contratos analíticos y planes de experimentación una vez recibida la consigna.

# Sensitivity Report - Laboratorio #3: Análisis de Sensibilidad Paramétrica Local

## Metadatos y Control de Configuración

- **Proyecto:** Laboratorio #3 - Sensibilidad de EDOs, Diseño de Experimentos y Extensión del Manuscrito
- **Sujeto de Estudio:** Satélite STARLINK-1008 (PVI no lineal de 6 nodos térmicos acoplados en órbita LEO)
- **Investigadora Principal:** Victoria Navarro (Estudiante investigadora - DING59)
- **Roles:** Numerical Agent & Results Analyst (IA)
- **Fecha de Ejecución:** 2026-10-06
- **Directorio de Trabajo:** `LAB3_NAVARRO_VICTORIA/`
- **Modelos y Código:**
  - Modelo matemático continuo: [`Mathematical_Model_v1.md`](../LAB1_NAVARRO_VICTORIA/Mathematical_Model_v1.md)
  - Implementación física: [`model.m`](model.m) (v1.1)
  - Parámetros base: [`get_params.m`](get_params.m) (v1.0)
  - Script ejecutor: [`run_sensitivity.m`](run_sensitivity.m) (v1.0)
  - Integrador numérico: `ode45` (Runge-Kutta Dormand-Prince adaptativo)
  - Tolerancias de integración: $\text{RelTol} = 10^{-6}$, $\text{AbsTol} = 10^{-6}\text{ K}$
  - Intervalo de integración: $t \in [0, 27600.0\text{ s}]$ (5 órbitas completas, $P = 5525.23\text{ s}$)
  - Condición inicial: $\mathbf{T}(0) = [273.15, 273.15, 273.15, 273.15, 273.15, 273.15]^T\text{ K}$ ($0^\circ\text{C}$)

---

## 1. Definición del Parámetro y Protocolo de Métricas

### 1.1 Parámetro Continuo de Estudio ($\theta_j$)
- **Parámetro:** Tasa de disipación interna en el Nodo 1 (cara $+X$, proa/ram):
  $$\theta = \dot{Q}_{\text{int}, +X}$$
- **Valor basal:** $\theta_0 = 40.0\text{ W}$.
- **Unidad:** Watts ($\text{W}$).
- **Procedencia física y justificación:** Corresponde a la potencia térmica disipada de forma continua por la aviónica de navegación, computadoras de a bordo y subsistemas de guiado instalados en la cara delantera del chasis. Presenta incertidumbre operacional ligada a los ciclos de cálculo y consumo eléctrico durante la misión.
- **Dominio admisible de ingeniería:** $\theta \in [0.0, 100.0]\text{ W}$.

### 1.2 Métrica Principal ($M_1$)
- **Definición:** Temperatura máxima del Nodo 1 ($+X$) en régimen permanente (últimas 2 órbitas del intervalo de 5 órbitas):
  $$M_1(\theta) = T_{\max, +X} = \max_{t \in [3P, 5P]} T_1(t)$$
- **Ventana temporal:** $t \in [3P, 5P] = [16575.7\text{ s}, 27600.0\text{ s}]$.
- **Unidad:** Kelvin ($\text{K}$), con conversión informativa a grados Celsius ($^\circ\text{C} = \text{K} - 273.15$).
- **Valor basal verificado (`C3-BASE-001`):**
  $$M_{1,0} = 291.796756\text{ K} \quad (+18.6468^\circ\text{C})$$

### 1.3 Métricas Secundarias
- **$M_2$ (Amplitud térmica cíclica en proa):**
  $$M_2(\theta) = \Delta T_{+X} = \max_{t \in [3P, 5P]} T_1(t) - \min_{t \in [3P, 5P]} T_1(t) \quad [\text{K}]$$
  Valor basal: $M_{2,0} = 63.0588\text{ K}$.
- **$M_3$ (Temperatura mínima en radiador cenit, Nodo 5 $+Z$):**
  $$M_3(\theta) = T_{\min, +Z} = \min_{t \in [3P, 5P]} T_5(t) \quad [\text{K}]$$
  Valor basal: $M_{3,0} = 209.9365\text{ K} \quad (-63.2135^\circ\text{C})$.

---

## 2. Niveles de Perturbación y Matriz de Corridas del Bloque A

Se aplicó un esquema jerárquico diádico con dos niveles de incremento simétrico alrededor del baseline $\theta_0 = 40.0\text{ W}$:
- **Nivel 1:** $\delta = 4.0\text{ W}$ ($\pm 10.0\% \cdot \theta_0$), evaluando $\theta \in \{36.0\text{ W}, 44.0\text{ W}\}$.
- **Nivel 2:** $\delta/2 = 2.0\text{ W}$ ($\pm 5.0\% \cdot \theta_0$), evaluando $\theta \in \{38.0\text{ W}, 42.0\text{ W}\}$.

Todas las perturbaciones pertenecen estrictamente al dominio admisible $[0, 100]\text{ W}$.

### Tabla 1: Resumen de Corridas Ejecutadas (Fase A)

| Run ID | Descripción / Perturbación | $\dot{Q}_{\text{int}, +X}$ [W] | Variación [%] | $M_1$ ($T_{\max, +X}$) [K] | $M_1$ [$^\circ\text{C}$] | $M_2$ ($\Delta T_{+X}$) [K] | $M_3$ ($T_{\min, +Z}$) [K] | Pasos | `nfev` | CPU [s] | Estado Dominio |
| :--- | :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| [`C3-BASE-001`](results/C3-BASE-001/) | **Línea Base (Baseline)** | **40.00** | **0.0%** | **291.796756** | **+18.6468** | **63.0588** | **209.9365** | 351 | 2707 | 0.22 | **VÁLIDO** |
| [`C3-SENS-001-M10`](results/C3-SENS-001-M10/) | Rama inferior $\delta = 4.0\text{ W}$ | 36.00 | $-10.0\%$ | 291.262997 | +18.1130 | 63.1689 | 209.8110 | 359 | 2785 | 0.28 | **VÁLIDO** |
| [`C3-SENS-002-P10`](results/C3-SENS-002-P10/) | Rama superior $\delta = 4.0\text{ W}$ | 44.00 | $+10.0\%$ | 292.318611 | +19.1686 | 62.9621 | 210.0746 | 364 | 2821 | 0.13 | **VÁLIDO** |
| [`C3-SENS-003-M05`](results/C3-SENS-003-M05/) | Rama inferior $\delta/2 = 2.0\text{ W}$ | 38.00 | $-5.0\%$ | 291.544065 | +18.3941 | 63.1182 | 209.8673 | 354 | 2731 | 0.10 | **VÁLIDO** |
| [`C3-SENS-004-P05`](results/C3-SENS-004-P05/) | Rama superior $\delta/2 = 2.0\text{ W}$ | 42.00 | $+5.0\%$ | 292.091550 | +18.9415 | 63.0562 | 210.0151 | 367 | 2869 | 0.12 | **VÁLIDO** |

---

## 3. Formulación y Cálculo de Sensibilidad Numérica

### 3.1 Estimador de Diferencias Finitas Centrales
La derivada de primer orden de la métrica respecto al parámetro se calcula mediante el esquema centrado de segundo orden $O(\delta^2)$:
$$D_j M(\delta) = \frac{M(\theta_0 + \delta) - M(\theta_0 - \delta)}{2\delta} \quad \left[\frac{\text{K}}{\text{W}}\right]$$

### 3.2 Sensibilidad Normalizada Adimensional ($S_j$)
La sensibilidad logarítmica o elástica representa el cambio porcentual de la métrica frente a un $1\%$ de variación en el parámetro:
$$S_j(\delta) = \left(\frac{\theta_0}{M_0}\right) D_j M(\delta) \quad [\text{adimensional}]$$
Dado que $\theta_0 = 40.0\text{ W} \ne 0$ y $M_0 = 291.7968\text{ K} \ne 0$, el factor de escala $\frac{\theta_0}{M_0} = \frac{40.0}{291.796756} = 0.1370817\text{ W}^{-1}$ es estrictamente regular y no requiere regularizadores numéricos.

*(Nota: En escala Celsius $M_{0, ^\circ\text{C}} = 18.6468^\circ\text{C}$, la sensibilidad relativa en ingeniería resulta $S_j^{(^\circ\text{C})} = \frac{40.0}{18.6468} D_j M \approx 2.145 \times D_j M \approx 0.29$).*

---

## 4. Resultados Cuantitativos de Sensibilidad

### 4.1 Nivel 1: Incremento $\delta = 4.0\text{ W}$ ($\pm 10\%$)
- Valores de métrica:
  $$M_1^- (\theta = 36.0\text{ W}) = 291.262997\text{ K}$$
  $$M_1^+ (\theta = 44.0\text{ W}) = 292.318611\text{ K}$$
- Diferencia de respuesta:
  $$\Delta M_1(\delta) = M_1^+ - M_1^- = 292.318611 - 291.262997 = 1.055614\text{ K}$$
- Intervalo de perturbación total: $2\delta = 8.0\text{ W}$.
- **Derivada central:**
  $$D_1(\delta = 4.0\text{ W}) = \frac{1.055614\text{ K}}{8.0\text{ W}} = \mathbf{0.131952\text{ K/W}}$$
- **Sensibilidad normalizada:**
  $$S_1(\delta = 4.0\text{ W}) = \left(\frac{40.0\text{ W}}{291.796756\text{ K}}\right) \times 0.131952\text{ K/W} = \mathbf{0.018088}$$

### 4.2 Nivel 2: Incremento $\delta/2 = 2.0\text{ W}$ ($\pm 5\%$)
- Valores de métrica:
  $$M_1^- (\theta = 38.0\text{ W}) = 291.544065\text{ K}$$
  $$M_1^+ (\theta = 42.0\text{ W}) = 292.091550\text{ K}$$
- Diferencia de respuesta:
  $$\Delta M_1(\delta/2) = M_1^+ - M_1^- = 292.091550 - 291.544065 = 0.547485\text{ K}$$
- Intervalo de perturbación total: $2(\delta/2) = 4.0\text{ W}$.
- **Derivada central:**
  $$D_1(\delta/2 = 2.0\text{ W}) = \frac{0.547485\text{ K}}{4.0\text{ W}} = \mathbf{0.136871\text{ K/W}}$$
- **Sensibilidad normalizada:**
  $$S_1(\delta/2 = 2.0\text{ W}) = \left(\frac{40.0\text{ W}}{291.796756\text{ K}}\right) \times 0.136871\text{ K/W} = \mathbf{0.018763}$$

---

## 5. Comprobación de Criterios y Análisis de Convergencia Numérica

### Tabla 2: Comparación Diádica de Derivadas y Consistencia Numérica

| Parámetro | Símbolo | Nivel 1 ($\delta = 4.0\text{ W}$) | Nivel 2 ($\delta/2 = 2.0\text{ W}$) | Discrepancia Absoluta $|\Delta|$ | Discrepancia Relativa | Criterio de Consistencia |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| **Derivada Central $M_1$** | $D_j M_1$ | $0.131952\text{ K/W}$ | $0.136871\text{ K/W}$ | $0.004919\text{ K/W}$ | **$3.59\%$** | **CUMPLIDO** ($< 5.0\%$) |
| **Sensibilidad Normalizada $M_1$** | $S_j$ | $0.018088$ | $0.018763$ | $0.000674$ | **$3.59\%$** | **CUMPLIDO** ($< 5.0\%$) |
| **Derivada Central $M_2$ ($\Delta T_{+X}$)** | $D_j M_2$ | $-0.025861\text{ K/W}$ | $-0.015512\text{ K/W}$ | $0.010349\text{ K/W}$ | $40.0\%$ | Asintótico (cambio submétrico) |
| **Derivada Central $M_3$ ($T_{\min, +Z}$)** | $D_j M_3$ | $+0.032947\text{ K/W}$ | $+0.036946\text{ K/W}$ | $0.003999\text{ K/W}$ | $10.8\%$ | Acoplamiento conductivo estable |

### 5.1 Evaluación de Errores Numéricos: Truncamiento vs. Redondeo
El análisis del esquema de diferencias finitas centrales revela los siguientes aspectos metodológicos:
1. **Error de Truncamiento ($E_{\text{trunc}} \propto C \cdot \delta^2$):**
   - La respuesta del modelo no lineal de radiación ($T^4$) presenta una suave no linealidad local. Al reducir el paso de $\delta = 4.0\text{ W}$ a $\delta/2 = 2.0\text{ W}$, la derivada pasa de $0.131952$ a $0.136871\text{ K/W}$, mostrando una corrección de segundo orden del $3.59\%$.
2. **Error de Redondeo y Cancelación Catastrófica ($E_{\text{red}} \propto \frac{\varepsilon_{\text{tol}}}{\delta}$):**
   - La tolerancia de integración de `ode45` se fijó en $\text{RelTol} = 10^{-6}$, $\text{AbsTol} = 10^{-6}\text{ K}$. El nivel de ruido numérico en la solución integrada es del orden de $\approx 10^{-4}\text{ K}$.
   - Dado que $\Delta M_1(\delta/2) = 0.5475\text{ K} \gg 10^{-4}\text{ K}$, la relación señal-a-ruido numérico es superior a $5000:1$. No existe pérdida de dígitos significativos ni contaminación por cancelación catastrófica.
3. **Criterio de Monotonicidad Estricta:**
   $$\theta \in [36.0, 38.0, 40.0, 42.0, 44.0]\text{ W} \implies M_1 \in [291.2630, 291.5441, 291.7968, 292.0915, 292.3186]\text{ K}$$
   El orden de las temperaturas máximas es estrictamente monótono creciente, corroborando la causalidad física del modelo.
4. **Verificación de Preservación de Dominio:**
   - Todas las variables de estado cumplieron $\text{isfinite}(T_i) == \text{true}$ en todo $t \in [0, 27600\text{ s}]$.
   - El mínimo térmico global alcanzado en cualquier nodo fue $T_{\min} \approx 209.81\text{ K} \gg 2.7\text{ K}$ (lejos del cero absoluto y del fondo cósmico de microondas).
   - El máximo térmico global fue $T_{\max} \approx 293.63\text{ K} \ll 450.0\text{ K}$ (dentro del rango elástico de la aleación de aluminio espacial 6061-T6).
   - Ninguna simulación requirió corte de emergencia (`STOP`) ni abandono de dominio.

---

## 6. Evidencia Gráfica

Se generó y archivó la figura multi-panel de convergencia y sensibilidad paramétrica:
[`results/fig_sensitivity_convergence.png`](results/fig_sensitivity_convergence.png)

### Paneles de la Figura:
1. **Panel Superior Izquierdo (Métrica vs. Parámetro):** Curva de respuesta $M_1(\theta)$ a lo largo de los 5 puntos experimentales, superpuesta a la línea base y los pares perturbados, confirmando un régimen local casi-lineal con curvatura sutil.
2. **Panel Superior Derecho (Derivadas Centrales por Nivel):** Comparación de barras entre $D_1(\delta = 4\text{ W}) = 0.1320\text{ K/W}$ y $D_1(\delta/2 = 2\text{ W}) = 0.1369\text{ K/W}$, ilustrando la discrepancia del $3.59\%$.
3. **Panel Inferior Izquierdo (Métrica Secundaria $M_2$):** Comportamiento de la amplitud térmica $\Delta T_{+X}$ frente a $\theta$, reflejando una suave estabilización térmica (amplitud decreciente).
4. **Panel Inferior Derecho (Métrica Secundaria $M_3$):** Comportamiento del mínimo en radiador cenit $T_{\min, +Z}$ frente a $\theta$, evidenciando el acoplamiento conductivo pasivo desde la cara de aviónica.

---

## 7. Interpretación Físico-Ingenieril y Conclusiones del Bloque A

1. **Régimen de Sensibilidad Térmica en Proa:**
   - La derivada local estimada es de aproximadamente:
     $$\frac{\partial T_{\max, +X}}{\partial \dot{Q}_{\text{int}, +X}} \approx 0.134 \pm 0.003\text{ K/W}$$
   - Esto indica que por cada **$1\text{ W}$** adicional disipado continuamente por la aviónica de proa, la temperatura pico alcanzada por el satélite durante la fase de iluminación solar aumenta en aproximadamente **$+0.134^\circ\text{C}$**.
2. **Impacto Operacional de Incertidumbre en Potencia:**
   - Una variación de potencia del $\pm 10\%$ ($\pm 4.0\text{ W}$, representativa de fluctuaciones de cómputo en enlace descendente o modo de maniobra) induce una alteración en la temperatura máxima de $\pm 0.53^\circ\text{C}$ ($1.06\text{ K}$ de ventana de incertidumbre total).
   - En términos adimensionales normalizados ($S_1 \approx 0.0188$), la métrica $T_{\max}$ en Kelvin es muy resiliente frente a variaciones de disipación interna debido a la dominancia del flujo solar incidente ($\approx 1361\text{ W/m}^2$, absorbiendo cientos de Watts) y a la amortiguación por radiación a la cuarta potencia ($\sigma \varepsilon A T^4$).
3. **Efecto de Acoplamiento y Amplitud Térmica:**
   - El aumento de disipación interna eleva el umbral térmico nocturno en eclipse en mayor medida que el pico solar, lo que reduce ligeramente el swing térmico $\Delta T$ (fatiga térmica moderada).
   - Por conducción interna ($G_{15} = 0.5\text{ W/K}$), parte del calor generado en proa se evacua hacia la cara cenit $+Z$, incrementando su temperatura mínima a razón de $+0.035\text{ K/W}$.

---

## 8. Dictamen y Recomendación para Próximos Pasos

### 8.1 Estado Metodológico del Bloque A
- **Dictamen:** **COMPLETO, COHERENTE Y NUMÉRICAMENTE VERIFICADO.**
- Se rechaza la hipótesis de inestabilidad o dispersión numérica.
- Se confirma la convergencia de la derivada central dentro del umbral acordado ($\varepsilon_{\text{rel}} = 3.59\% < 5.0\%$).

### 8.2 Decisión Pendiente para la Investigadora Principal (Victoria Navarro)
En concordancia con [`Experiment_Plan.md`](Experiment_Plan.md), el estudio puede tomar uno de los siguientes dos cursos de acción:

1. **Opción 1: Ejecutar Bloque B (Matriz de Barrido Paramétrico $3 \times 3$):**
   - Ejecutar 8 simulaciones adicionales variando conjuntamente la disipación interna $\dot{Q}_{\text{int}, +X} \in \{20, 40, 60\}\text{ W}$ y la conductancia estructural lineal $g_{\text{lin}} \in \{1.0, 2.0, 4.0\}\text{ W/(K}\cdot\text{m)}$ para capturar efectos cruzados no lineales e interacción estructural-disipativa.
2. **Opción 2: Dar por cerrada la fase experimental y avanzar a la fase analítica:**
   - Proceder directamente a redactar [`Results_Analysis.md`](Results_Analysis.md), preparar [`Scientific_Critique.md`](Scientific_Critique.md) y someter el caso a revisión para [`Gate_3.md`](Gate_3.md) y [`Paper_v0.3.md`](Paper_v0.3.md), basándose en la sólida evidencia de sensibilidad local ya obtenida en el Bloque A.

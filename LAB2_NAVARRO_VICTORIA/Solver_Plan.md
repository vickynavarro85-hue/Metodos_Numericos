# Solver Plan - Laboratorio #2

## Metadatos y Control de Versión

- **Documento:** `Solver_Plan.md`
- **Versión:** 1.0 (Aprobado)
- **Fecha:** 2026-09-21
- **Responsable:** Numerical Methods Agent (IA)
- **Supervisora:** Victoria Navarro (Estudiante investigadora)
- **Estado:** `ACEPTADO por Victoria Navarro (2026-09-21)`

---

## 1. Clasificación de la Información Base

### A. Datos Aprobados (Procedencia: Lab 1 Aprobado)
- **Ecuaciones diferenciales:** Sistema de 6 EDOs no lineales de primer orden acopladas por balance de potencia en Watts:
  $$C_i \frac{dT_i}{dt} = \dot{Q}_{\text{sol}, i}(t) + \dot{Q}_{\text{alb}, i}(t) + \dot{Q}_{\text{IR}, i} + \dot{Q}_{\text{int}, i} + \sum_{j \in \text{ady}(i)} G_{ij} (T_j - T_i) - \sigma \varepsilon_i A_i (T_i^4 - T_{\text{esp}}^4)$$
- **Orden de estados:** $\mathbf{T} = [T_{+X}, T_{-X}, T_{+Y}, T_{-Y}, T_{+Z}, T_{-Z}]^T$ en Kelvin $[\text{K}]$.
- **Condición inicial:** $\mathbf{T}(0) = [273.15, 273.15, 273.15, 273.15, 273.15, 273.15]^T\ [\text{K}]$ (`SINTETICO`).
- **Intervalo temporal:** $t \in [0, t_f]$ con $t_f = 5 \times P = 27627.0\text{ s} \approx 7.67\text{ h}$ (`BIBLIOGRAFICO`/`MEDIDO`).
- **Parámetros físicos:** $C_i$, $A_i$, $\alpha_i$, $\varepsilon_i$, $G_{ij}$, $S_0$, $q_{IR,\oplus}$, $a$, $\sigma$, $T_{\text{esp}} = 2.7\text{ K}$, $\dot{\mathbf{Q}}_{\text{int}}$ (según tabla de `Mathematical_Model_v1.md`).

### B. Propuestas Numéricas (Lab 2)
- Métodos numéricos seleccionados, pasos temporales $h$, tolerancias adaptativas, métricas de costo y taxonomía de Run IDs.

### C. Información Faltante
- Función computacional en MATLAB para evaluar los forzamientos orbitales $\hat{\mathbf{s}}_{\text{cuerpo}}(t)$ e $\text{ilum}(t)$ a lo largo de las 5 órbitas (se propone implementación analítica basada en Kepler + sombra cilíndrica).

---

## 2. Métodos Numéricos Seleccionados

1. **Configuración Inicial / Línea Base Adaptativa (`ode45`):**
   - Pareja embebida Dormand-Prince de órdenes 4(5) con control de paso adaptativo.
   - *Propósito:* Diagnosticar si el sistema se comporta como no rígido en operación nominal y proveer la solución de alta precisión.
   - *Contingencia de rigidez:* En caso de registrarse pasos excesivamente pequeños durante las discontinuidades de entrada/salida de eclipse debido a la no linealidad $T^4$, se incluirá `ode15s` (BDF / orden variable) como comparativa de rigidez.
2. **Euler Explícito (Paso Fijo):**
   - Método de 1er orden: $\mathbf{T}_{n+1} = \mathbf{T}_n + h \, \mathbf{f}(t_n, \mathbf{T}_n)$.
   - *Propósito:* Evaluar el umbral de estabilidad numérica ($h < 2 \tau_{\min}$) y el costo computacional mínimo por paso.
3. **Runge-Kutta 2do Orden - Punto Medio (Paso Fijo):**
   - Método de 2do orden: $\mathbf{k}_1 = \mathbf{f}(t_n, \mathbf{T}_n)$, $\mathbf{k}_2 = \mathbf{f}(t_n + \frac{h}{2}, \mathbf{T}_n + \frac{h}{2}\mathbf{k}_1)$, $\mathbf{T}_{n+1} = \mathbf{T}_n + h \, \mathbf{k}_2$.
   - *Propósito:* Analizar la ganancia en precisión y estabilidad cuadrática frente al costo de 2 evaluaciones por paso.
4. **Runge-Kutta 4to Orden Clásico - RK4 (Paso Fijo):**
   - Esquema estándar de 4 etapas: $\mathbf{T}_{n+1} = \mathbf{T}_n + \frac{h}{6}(\mathbf{k}_1 + 2\mathbf{k}_2 + 2\mathbf{k}_3 + \mathbf{k}_4)$.
   - *Propósito:* Proveer alta precisión con paso fijo para contrastar contra el solver adaptativo `ode45`.

---

## 3. Discretización Temporal y Pasos $h$

Se propone una jerarquía de refinamiento con factor de escala $r = 2$ para los métodos de paso fijo:

| Nivel de Malla | Paso $h$ [s] | Pasos por Órbita ($P = 5525.4\text{ s}$) | Pasos Totales ($5\text{ órbitas}$) | Justificación Física y Numérica |
| :--- | :---: | :---: | :---: | :--- |
| **$h_1$ (Grueso)** | $60.0$ | $\approx 92$ | $461$ | Resolución macroscópica; prueba de estabilidad para Euler. |
| **$h_2$ (Medio-Grueso)** | $30.0$ | $\approx 184$ | $921$ | Captura la escala de eclipse ($34.5\text{ min} \approx 69$ pasos). |
| **$h_3$ (Medio)** | $15.0$ | $\approx 368$ | $1842$ | Paso nominal de diseño propuesto en el Lab 1 ($18.4\text{ s}$). |
| **$h_4$ (Fino)** | $7.5$ | $\approx 737$ | $3684$ | Resolución fina de transiciones de penumbra. |
| **$h_5$ (Extra-Fino)** | $3.75$ | $\approx 1473$ | $7368$ | Nivel asintótico para cálculo de orden empírico. |

*Límite de estabilidad estimado para Euler:* $\tau_{\min} = \frac{C_{\pm X}}{4 \sigma \varepsilon A T_{\max}^3 + \sum G_{ij}} \approx \frac{1512}{8.7} \approx 173\text{ s} \implies h_{\text{estabilidad}} < 2 \tau_{\min} \approx 346\text{ s}$. Todos los pasos propuestos garantizan estabilidad teórica en régimen linealizado.

---

## 4. Tolerancias para Métodos Adaptativos

Para variables de estado térmico absoluto ($T_i \sim 200\text{ K} - 350\text{ K}$):

- **Configuración Nominal `ode45`:**
  - `RelTol`: $1 \times 10^{-6}$ (Error relativo $< 0.0001\%$).
  - `AbsTol`: Vector uniforme $[10^{-6}, 10^{-6}, 10^{-6}, 10^{-6}, 10^{-6}, 10^{-6}]^T\ [\text{K}]$ (Incertidumbre $< 1\,\mu\text{K}$).
- **Configuración Benchmark / Referencia (`ode45-REF`):**
  - `RelTol`: $1 \times 10^{-10}$
  - `AbsTol`: $[10^{-10}, 10^{-10}, 10^{-10}, 10^{-10}, 10^{-10}, 10^{-10}]^T\ [\text{K}]$.

---

## 5. Cantidades de Interés (QoI - Quantities of Interest)

Para evaluar y comparar los resolvedores se medirán las siguientes magnitudes objetivo:

1. **QoI-1: Métricas de Régimen Permanente Cíclico (Últimas 2 órbitas, $t \in [3P, 5P]$):**
   - Temperaturas extremas por cara: $T_{\text{mín}, i}$ y $T_{\text{máx}, i}\ [^\circ\text{C}]$.
   - Amplitud térmica cíclica: $\Delta T_i = T_{\text{máx}, i} - T_{\text{mín}, i}\ [^\circ\text{C}]$.
   - Temperatura media orbital: $\bar{T}_i = \frac{1}{P} \int_{4P}^{5P} T_i(t)\, dt\ [^\circ\text{C}]$.
2. **QoI-2: Error Global respecto a la Referencia:**
   - Error en norma infinito: $E_\infty = \max_{n} \|\mathbf{T}_h(t_n) - \mathbf{T}_{\text{ref}}(t_n)\|_\infty\ [\text{K}]$.
   - Error medio RMS ($L_2$ temporal): $E_{\text{RMS}} = \sqrt{\frac{1}{N} \sum_{n=1}^N \frac{\|\mathbf{T}_h(t_n) - \mathbf{T}_{\text{ref}}(t_n)\|_2^2}{6}}\ [\text{K}]$.
3. **QoI-3: Desbalance Energético Orbital Residual:**
   - Integral del balance neto por órbita en régimen permanente: $\epsilon_{\text{energía}} = \oint_{4P}^{5P} \sum_{i=1}^6 \dot{Q}_{\text{neto}, i}(t)\, dt\ [\text{J}]$.

---

## 6. Métricas de Costo Computacional

1. **Evaluaciones de la función diferencial (`nfev`):** Contador exacto de llamadas a la función de balance $\mathbf{f}(t, \mathbf{T})$.
2. **Pasos temporales totales:** Número de pasos exitosos y pasos rechazados (para `ode45`).
3. **Tiempo de CPU (Wall-clock time):** Medido en segundos mediante llamadas `tic`/`toc` promediadas sobre 5 repeticiones para aislar ruido de sistema operativo.
4. **Índice de Eficiencia:** Curvas Pareto de precisión vs. costo: Error $L_\infty$ en función de `nfev` y de tiempo de CPU.

---

## 7. Taxonomía de Identificadores de Ejecución (Run IDs)

| Run ID | Método | Parámetros de Discretización | Propósito |
| :--- | :--- | :--- | :--- |
| `RUN-00-REF` | `ode45` | `RelTol=1e-10`, `AbsTol=1e-10` | Solución de referencia benchmark. |
| `RUN-01-ODE45` | `ode45` | `RelTol=1e-6`, `AbsTol=1e-6` | Línea base adaptativa estándar. |
| `RUN-02-ODE15S` | `ode15s` | `RelTol=1e-6`, `AbsTol=1e-6` | Diagnóstico comparativo de rigidez. |
| `RUN-10-EULER-60` a `RUN-14-EULER-3.75` | Euler Explícito | $h \in \{60, 30, 15, 7.5, 3.75\}\text{ s}$ | Estudio de convergencia de orden 1. |
| `RUN-20-RK2-60` a `RUN-24-RK2-3.75` | RK2 Punto Medio | $h \in \{60, 30, 15, 7.5, 3.75\}\text{ s}$ | Estudio de convergencia de orden 2. |
| `RUN-30-RK4-60` a `RUN-34-RK4-3.75` | RK4 Clásico | $h \in \{60, 30, 15, 7.5, 3.75\}\text{ s}$ | Estudio de convergencia de orden 4. |

---

## 8. Criterios de Aceptación y Parada

- **Criterio de Aceptación del Solver Plan:**
  - Definición explícita de los 4 métodos exigidos, mallas $h$, tolerancias y métricas de costo sin inventar parámetros físicos.
- **Condición de Parada:**
  - El plan ha sido **`ACEPTADO por Victoria Navarro (2026-09-21)`** mediante `Human_Review.md`, habilitando formalmente la fase de implementación y ejecución de scripts en MATLAB.

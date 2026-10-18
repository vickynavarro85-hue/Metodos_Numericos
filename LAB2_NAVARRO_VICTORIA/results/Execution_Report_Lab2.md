# Reporte de Ejecución y Verificación Numérica - Laboratorio #2

## Metadatos y Control de Configuración

- **Proyecto:** Laboratorio #2 - Métodos Numéricos (Satelite STARLINK-1008)
- **Fecha de Ejecución:** 2026-09-21
- **Agente Responsable:** Numerical Methods Agent
- **Supervisora y Autora:** Victoria Navarro (Estudiante investigadora)
- **Autorización Previa:** `LAB2_NAVARRO_VICTORIA/Human_Review.md` (Decisión: `ACEPTAR`)
- **Documentos de Base Aprobados:**
  - `LAB2_NAVARRO_VICTORIA/Solver_Plan.md` (v1.0 Aprobado)
  - `LAB2_NAVARRO_VICTORIA/Verification_Plan.md` (v1.0 Aprobado)
  - `LAB2_NAVARRO_VICTORIA/inputs/Lab1_approved/Mathematical_Model_v1.md`
- **Código Fuente Implementado:**
  - [`model.m`](file:///Users/victorianavarro/Documents/Métodos%20Numéricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB2_NAVARRO_VICTORIA/model.m) (Lado derecho del balance térmico continuo de 6 nodos)
  - [`get_params.m`](file:///Users/victorianavarro/Documents/Métodos%20Numéricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB2_NAVARRO_VICTORIA/get_params.m) (Parámetros físicos, termomecánicos y forzamientos orbitales)
  - [`main.m`](file:///Users/victorianavarro/Documents/Métodos%20Numéricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB2_NAVARRO_VICTORIA/main.m) (Verificación de signos, aserciones dimensionales y prueba breve)
  - [`run_convergence.m`](file:///Users/victorianavarro/Documents/Métodos%20Numéricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB2_NAVARRO_VICTORIA/run_convergence.m) (Ejecución de la matriz de 19 corridas autorizadas y cálculo de QoIs)
  - Solvers de paso fijo: [`solve_euler.m`](file:///Users/victorianavarro/Documents/Métodos%20Numéricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB2_NAVARRO_VICTORIA/solve_euler.m), [`solve_rk2.m`](file:///Users/victorianavarro/Documents/Métodos%20Numéricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB2_NAVARRO_VICTORIA/solve_rk2.m), [`solve_rk4.m`](file:///Users/victorianavarro/Documents/Métodos%20Numéricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB2_NAVARRO_VICTORIA/solve_rk4.m)
  - Envoltorio adaptativo: [`solve_adaptive.m`](file:///Users/victorianavarro/Documents/Métodos%20Numéricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB2_NAVARRO_VICTORIA/solve_adaptive.m)

---

## 1. Verificación de Decisión Humana y Alcance Autorizado

Previo a la ejecución computacional se verificó programáticamente la existencia y validez de la autorización en:
- **Archivo:** [`Human_Review.md`](file:///Users/victorianavarro/Documents/Métodos%20Numéricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB2_NAVARRO_VICTORIA/Human_Review.md)
- **Sección:** `## Decisión`
- **Contenido registrado:** `ACEPTAR`
- **Alcance Autorizado:** "Autorizo formalmente la implementación y ejecución de los scripts en MATLAB dentro de `LAB2_NAVARRO_VICTORIA` para llevar a cabo la integración numérica y generar las curvas y tablas de resultados."

Se cumplió estrictamente la condición de no modificar el modelo físico, ni los parámetros, ni las condiciones iniciales fijadas en el Laboratorio #1.

---

## 2. Verificación de Signos, Unidades y Orden de Estados

En [`main.m`](file:///Users/victorianavarro/Documents/Métodos%20Numéricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB2_NAVARRO_VICTORIA/main.m) se ejecutó la comprobación analítica en $t = 0\text{ s}$ con $\mathbf{T}_0 = 273.15\text{ K}$ ($0^\circ\text{C}$):
- **Orden de estados:** $\mathbf{T} = [T_{+X}, T_{-X}, T_{+Y}, T_{-Y}, T_{+Z}, T_{-Z}]^T$ en Kelvin $[\text{K}]$.
- **Capacitancias:** $C = [1512.0, 1512.0, 3024.0, 3024.0, 14112.0, 14112.0]^T\ [\text{J/K}]$.
- **Áreas:** $A = [0.42, 0.42, 0.84, 0.84, 3.92, 3.92]^T\ [\text{m}^2]$.
- **Conducción en isotermo ($t=0$):** $\|\mathbf{Q}_{\text{cond}}\|_2 = 1.28 \times 10^{-12}\text{ W} \approx 0\text{ W}$ (nula salvo cancelación de punto flotante).
- **Emisión radiativa ($t=0$):** $Q_{\text{emit}, i} > 0$ en todas las caras (estrictamente disipativa).
- **Entorno en eclipse inicial ($t=0$):** $\dot{Q}_{\text{sol}, i} = 0$, $\dot{Q}_{\text{alb}, i} = 0$.
- **Derivadas térmicas:** $\frac{dT_i}{dt}(0) < 0$ para todos los nodos (enfriamiento monótono en sombra).
- **Prueba breve:** Integración exitosa de 1 órbita completa ($t \in [0, 5525.2\text{ s}]$) con los 4 métodos, verificando $\min T_i > 2.7\text{ K}$ y finitud de la solución.

---

## 3. Matriz de Ejecución Autorizada y Resultados Globales

Se integró el sistema completo a lo largo de las 5 órbitas ($t \in [0, 27600.0\text{ s}]$). La tabla consolidada de las 19 corridas (registrada en [`results/summary_table.csv`](file:///Users/victorianavarro/Documents/Métodos%20Numéricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB2_NAVARRO_VICTORIA/results/summary_table.csv)) presenta las métricas computacionales y de error:

| Run ID | Método | Paso $h$ / Tol | Pasos | `nfev` | CPU [s] | Error $E_\infty$ [K] | Error $E_{\text{RMS}}$ [K] | Error Rel. Energía | Estado |
| :--- | :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
| **`RUN-00-REF`** | `ode45` | $10^{-10}$ | $3346$ | $30967$ | $1.1265$ | **$0.00$ (Ref)** | **$0.00$ (Ref)** | $5.21 \times 10^{-5}$ | **`SUCCESS`** |
| **`RUN-00-REF-ODE15S`** | `ode15s` | $10^{-10}$ | $16375$ | $34449$ | $1.3995$ | **$1.09 \times 10^{-5}$** | $2.30 \times 10^{-6}$ | $8.62 \times 10^{-5}$ | **`SUCCESS`** |
| **`RUN-01-ODE45`** | `ode45` | $10^{-6}$ | $351$ | $2707$ | $0.0964$ | **$2.67 \times 10^{-2}$** | $3.61 \times 10^{-3}$ | $3.08 \times 10^{-3}$ | **`SUCCESS`** |
| **`RUN-02-ODE15S`** | `ode15s` | $10^{-6}$ | $1105$ | $1709$ | $0.0731$ | **$2.83 \times 10^{-3}$** | $4.67 \times 10^{-4}$ | $4.41 \times 10^{-4}$ | **`SUCCESS`** |
| **`RUN-10-EULER-60`** | Euler | $60.0\text{ s}$ | $460$ | $460$ | $0.0188$ | $6.56$ | $0.931$ | $5.09 \times 10^{-5}$ | **`SUCCESS`** |
| **`RUN-11-EULER-30`** | Euler | $30.0\text{ s}$ | $920$ | $920$ | $0.0309$ | $3.52$ | $0.368$ | $1.17 \times 10^{-4}$ | **`SUCCESS`** |
| **`RUN-12-EULER-15`** | Euler | $15.0\text{ s}$ | $1840$ | $1840$ | $0.0642$ | $1.78$ | $0.194$ | $6.33 \times 10^{-4}$ | **`SUCCESS`** |
| **`RUN-13-EULER-7.5`** | Euler | $7.5\text{ s}$ | $3680$ | $3680$ | $0.1294$ | $0.88$ | $0.096$ | $2.83 \times 10^{-4}$ | **`SUCCESS`** |
| **`RUN-14-EULER-3.75`**| Euler | $3.75\text{ s}$ | $7360$ | $7360$ | $0.2562$ | $0.41$ | $0.044$ | $1.39 \times 10^{-4}$ | **`SUCCESS`** |
| **`RUN-20-RK2-60`** | RK2 | $60.0\text{ s}$ | $460$ | $920$ | $0.0328$ | $3.85$ | $0.491$ | $1.17 \times 10^{-2}$ | **`SUCCESS`** |
| **`RUN-21-RK2-30`** | RK2 | $30.0\text{ s}$ | $920$ | $1840$ | $0.0622$ | $1.75$ | $0.260$ | $1.20 \times 10^{-3}$ | **`SUCCESS`** |
| **`RUN-22-RK2-15`** | RK2 | $15.0\text{ s}$ | $1840$ | $3680$ | $0.1278$ | $1.00$ | $0.133$ | $7.12 \times 10^{-5}$ | **`SUCCESS`** |
| **`RUN-23-RK2-7.5`** | RK2 | $7.5\text{ s}$ | $3680$ | $7360$ | $0.2470$ | $0.46$ | $0.056$ | $1.65 \times 10^{-3}$ | **`SUCCESS`** |
| **`RUN-24-RK2-3.75`** | RK2 | $3.75\text{ s}$ | $7360$ | $14720$ | $0.5108$ | $0.23$ | $0.029$ | $6.39 \times 10^{-4}$ | **`SUCCESS`** |
| **`RUN-30-RK4-60`** | RK4 | $60.0\text{ s}$ | $460$ | $1840$ | $0.0640$ | $2.21$ | $0.267$ | $7.53 \times 10^{-3}$ | **`SUCCESS`** |
| **`RUN-31-RK4-30`** | RK4 | $30.0\text{ s}$ | $920$ | $3680$ | $0.1244$ | $1.11$ | $0.143$ | $7.51 \times 10^{-4}$ | **`SUCCESS`** |
| **`RUN-32-RK4-15`** | RK4 | $15.0\text{ s}$ | $1840$ | $7360$ | $0.2440$ | $0.61$ | $0.073$ | $1.62 \times 10^{-4}$ | **`SUCCESS`** |
| **`RUN-33-RK4-7.5`** | RK4 | $7.5\text{ s}$ | $3680$ | $14720$ | $0.4926$ | $0.29$ | $0.030$ | $1.19 \times 10^{-3}$ | **`SUCCESS`** |
| **`RUN-34-RK4-3.75`** | RK4 | $3.75\text{ s}$ | $7360$ | $29440$ | $0.9948$ | $0.15$ | $0.016$ | $4.72 \times 10^{-4}$ | **`SUCCESS`** |

---

## 4. Cantidades de Interés (QoIs) en Régimen Permanente

Evaluadas sobre las últimas 2 órbitas ($t \in [3P, 5P]$) para la corrida de referencia `RUN-00-REF`:

| Cara | $T_{\text{mín}}$ [$^\circ\text{C}$] | $T_{\text{máx}}$ [$^\circ\text{C}$] | Amplitud $\Delta T$ [$^\circ\text{C}$] | Temperatura Media $\bar{T}$ [$^\circ\text{C}$] |
| :--- | :---: | :---: | :---: | :---: |
| **$+X$ (ram)** | $-44.4$ | $+18.7$ | $63.1$ | $-17.7$ |
| **$-X$ (wake)** | $-49.4$ | $-6.7$ | $42.7$ | $-22.4$ |
| **$+Y$** | $-49.2$ | $+9.9$ | $59.1$ | $-17.6$ |
| **$-Y$** | $-49.4$ | $-7.4$ | $42.1$ | $-28.7$ |
| **$+Z$ (cenit)** | $-63.2$ | $-13.2$ | $50.0$ | $-39.4$ |
| **$-Z$ (nadir)** | $-33.4$ | $+16.7$ | $50.1$ | $-7.2$ |

- **Temperatura mínima absoluta en el ciclo:** $T_{\min} = 209.93\text{ K}$ ($-63.2^\circ\text{C}$, en cara $+Z$ al final del eclipse).
- **Temperatura máxima absoluta en el ciclo:** $T_{\max} = 291.88\text{ K}$ ($+18.7^\circ\text{C}$, en cara $+X$ bajo insolación rasante).
- **Admisibilidad física:** En ninguna corrida ni paso temporal se registraron temperaturas menores a $2.7\text{ K}$ ni divergencias numéricas ($\min T > 209\text{ K}$).

---

## 5. Análisis de Verificación y Diagnóstico de Convergencia

### 5.1 Comprobación Cruzada de la Solución de Referencia
La discrepancia entre la referencia explícita (`ode45`, $10^{-10}$) y la referencia implícita (`ode15s`, $10^{-10}$) resultó:
$$\|\mathbf{T}_{\text{ode45-REF}} - \mathbf{T}_{\text{ode15s-REF}}\|_\infty = 1.095 \times 10^{-5}\text{ K} \approx 10.9\,\mu\text{K}$$
Esta coincidencia extrema hasta el 5to decimal convalida formalmente que la solución de referencia es independiente del algoritmo numérico utilizado.

### 5.2 Tasas Empíricas de Convergencia ($p_{\text{emp}}$)

$$p_{\text{emp}} = \frac{\log(E(2h) / E(h))}{\log(2)}$$

| Refinamiento de Malla | Euler ($L_\infty$) | Euler (RMS) | RK2 ($L_\infty$) | RK2 (RMS) | RK4 ($L_\infty$) | RK4 (RMS) |
| :--- | :---: | :---: | :---: | :---: | :---: | :---: |
| **$60\text{ s} \to 30\text{ s}$** | $0.90$ | $1.34$ | $1.14$ | $0.92$ | $0.99$ | $0.90$ |
| **$30\text{ s} \to 15\text{ s}$** | $0.98$ | $0.92$ | $0.80$ | $0.97$ | $0.86$ | $0.97$ |
| **$15\text{ s} \to 7.5\text{ s}$** | $1.02$ | $1.02$ | $1.11$ | $1.25$ | $1.09$ | $1.27$ |
| **$7.5\text{ s} \to 3.75\text{ s}$** | $1.09$ | $1.12$ | $0.99$ | $0.95$ | $0.94$ | $0.93$ |
| **Promedio Asintótico** | **$1.00$** | **$1.10$** | **$1.01$** | **$1.02$** | **$0.97$** | **$1.02$** |

#### Hallazgo Fundamental de Reducción de Orden:
- **Euler Explícito:** Cumple con precisión su orden teórico $p \approx 1.00$ ($p \in [0.90, 1.09]$).
- **RK2 y RK4:** Exhiben una reducción de orden asintótico a $p \approx 1$.
- **Explicación física y numérica:** El modelo de forzamiento orbital incluye la función escalón de iluminación $\text{ilum}(t) \in \{0, 1\}$, la cual presenta discontinuidades de salto $\mathcal{O}(1)$ en las fronteras de entrada y salida del cono de sombra terrestre. De acuerdo con el teorema clásico de regularidad de Runge-Kutta, cuando una EDO no es $C^1$ suave, el error local introducido al cruzar la discontinuidad sin detección de eventos es $\mathcal{O}(h)$, degradando el orden global acumulado a orden 1.
- No obstante, para cada tamaño de paso fijo $h$, la magnitud del error absoluto decae significativamente al incrementar el método: a $h=3.75\text{ s}$, el error de Euler es $414\text{ mK}$, el de RK2 es $233\text{ mK}$ y el de RK4 es $150\text{ mK}$ (con un error RMS de apenas $16\text{ mK}$).

### 5.3 Diagnóstico de Rigidez (*Stiffness Detection*)
- A tolerancia $10^{-6}$:
  - `ode45` completó las 5 órbitas en **$351$ pasos** ($0.096\text{ s}$).
  - `ode15s` completó la misma integración en **$1105$ pasos** ($0.073\text{ s}$).
- Dado que `ode45` requirió menos de un tercio de los pasos de `ode15s`, se confirma concluyentemente la **hipótesis de no rigidez** del modelo continuo, validando la idoneidad de solvers explícitos para el satélite STARLINK-1008.

---

## 6. Registro de Archivos y Trazabilidad

Cada una de las 19 ejecuciones cuenta con su carpeta persistente en `LAB2_NAVARRO_VICTORIA/results/<RUN_ID>/` con los siguientes archivos:
1. `config.json`: Metadatos, parámetros y condiciones iniciales.
2. `solution.mat`: Variables temporales y térmicas completas (`t`, `T_K`, `T_C`).
3. `solution.csv`: Serie temporal tabulada en formato interoperable.
4. `qoi.json`: Resumen de las 3 QoIs (térmicas, errores y desbalance energético).
5. `errors.json`: Errores globales y desagregados por cara espacial.
6. `cost.json`: Tiempos CPU promedio y desviaciones, `nfev` y pasos.
7. `run.log`: Registro de validación y comprobación de límites físicos.
8. `results/code_snapshot/`: Copia congelada de los scripts que generaron las soluciones.

Las figuras generadas se encuentran archivadas en:
- `results/figures/fig1_convergence_error.png`
- `results/figures/fig2_efficiency_pareto.png`
- `results/figures/fig3_temperature_profiles.png`

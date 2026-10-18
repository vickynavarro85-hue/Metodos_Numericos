# Plan de Experimentación Numérica y Sensibilidad Paramétrica (Laboratorio #3)

## Metadatos y Control de Documento

- **Documento:** `Experiment_Plan.md`
- **Versión:** 1.0 (Propuesta de Plan Experimental para Autorización Humana)
- **Fecha:** 2026-10-06
- **Responsables Técnicos:** Research Orchestrator & Experiment Agent (IA)
- **Investigadora Principal y Decisora:** Victoria Navarro (Estudiante investigadora - DING59)
- **Proyecto:** Simulación Térmica Orbital del Satélite STARLINK-1008 en LEO
- **Estado del Plan:** **`READY_FOR_HUMAN_REVIEW`** *(No ejecutado; esperando autorización formal)*
- **Documentos de Base y Línea de Referencia:**
  - [`inputs/Lab1_approved/Mathematical_Model_v1.md`](../LAB1_NAVARRO_VICTORIA/Mathematical_Model_v1.md) (Modelo analítico continuo aprobado)
  - [`LAB2_NAVARRO_VICTORIA/Gate_2.md`](../LAB2_NAVARRO_VICTORIA/Gate_2.md) (Decisión humana `ACCEPT` del 2026-09-21)
  - [`LAB2_NAVARRO_VICTORIA/Paper_v0.2.md`](../LAB2_NAVARRO_VICTORIA/Paper_v0.2.md) (Manuscrito en estado `APROBADO`)
  - [`LAB3_NAVARRO_VICTORIA/Environment_Validation_Check.md`](Environment_Validation_Check.md) (Entorno MATLAB R2024a validado)
  - [`LAB3_NAVARRO_VICTORIA/RESEARCH_LOG.md`](RESEARCH_LOG.md) (Entradas 001 a 004)

> [!CAUTION]
> **Delimitación Epistemológica Obligatoria (Cláusula de Gate 2):**  
> Este plan describe exclusivamente experimentos numéricos y cálculo de sensibilidades locales del Problema de Valor Inicial (PVI) determinista formulado para el satélite STARLINK-1008. **No declara ni persigue validación física o empírica** con el satélite real en vuelo, dada la ausencia de telemetría de SpaceX o ensayos de cámara de termovacío (TVAC).

---

## 1. Pregunta Científica y Objetivos de la Experimentación

### Pregunta de Investigación:
> *¿Cuál es la sensibilidad local y normalizada de la respuesta térmica extrema del satélite STARLINK-1008 frente a variaciones en la potencia de disipación interna de su aviónica, cómo converge la estimación de dicha derivada al refinar el paso de perturbación, y cómo interactúa la disipación interna con el acoplamiento conductivo estructural para modificar los márgenes de seguridad térmica en régimen cíclico permanente en órbita LEO?*

### Objetivos Específicos:
1. **Línea Base Replicada:** Ejecutar la corrida baseline (`C3-BASE-001`) bajo idénticas condiciones que `RUN-01-ODE45` de Lab 2, verificando identidad numérica punto a punto.
2. **Sensibilidad Local por Diferencias Finitas Centrales:** Computar $D(\delta) = \frac{M(\theta_0+\delta) - M(\theta_0-\delta)}{2\delta}$ para dos niveles de perturbación diádicos ($\delta = 4.0\text{ W}$ y $\delta/2 = 2.0\text{ W}$) sobre la disipación interna de aviónica $\dot{Q}_{\text{int}, +X}$.
3. **Comprobación de Convergencia del Paso $\delta$:** Verificar si el error de aproximación de la derivada disminuye cuadráticamente $\mathcal{O}(\delta^2)$ sin amplificación de ruido numérico de cancelación.
4. **Cálculo de Sensibilidad Normalizada Adimensional ($S$):** Determinar la elasticidad porcentual $S = \left(\frac{\theta_0}{M_0}\right) D$.
5. **Barrido Paramétrico de Interacción (Opcional / Propuesto):** Mapear el comportamiento térmico ante variaciones conjuntas de potencia y conductancia estructural para explorar los límites de linealidad del modelo.

---

## 2. Versión del Modelo Matemático y Código de Ejecución

- **Modelo Analítico Continuo:** `Mathematical_Model_v1.md` (congelado, sin alteraciones físicas).
- **Módulos de Código Fuente:**
  - Campo diferencial: [`model.m`](../LAB2_NAVARRO_VICTORIA/model.m) (v1.1 con protección $T_{\text{rad}} = \max(T, T_{\text{esp}})$ en etapas tentativas).
  - Parámetros físicos: [`get_params.m`](../LAB2_NAVARRO_VICTORIA/get_params.m) (v1.0 con parámetros del STARLINK-1008).
  - Datos de forzamiento orbital: [`inputs/orbital_data.mat`](../LAB2_NAVARRO_VICTORIA/inputs/orbital_data.mat) (1501 puntos, $P = 5525.23\text{ s}$).
  - Integrador temporal: [`solve_adaptive.m`](../LAB2_NAVARRO_VICTORIA/solve_adaptive.m) (v1.0 con algoritmo `ode45`).
- **Estado de Hipótesis:** `VALIDO_EN_DOMINIO` (no se requiere emitir `NEEDS_MODEL_REVISION`).

---

## 3. Configuración del Resolvedor (Solver) y Criterios Numéricos Previos

En estricta coherencia con los resultados aprobados en `Gate_2.md`:

- **Solver Numérico Seleccionado:** `ode45` (Dormand-Prince embebido de órdenes 4 y 5).
  - *Justificación:* Se demostró en Lab 2 que el sistema es **no rígido** y que `ode45` se ubica en el frente óptimo de Pareto, alcanzando un error inferior a $27\text{ mK}$ con únicamente $2707$ llamadas a la función diferencial ($0.096\text{ s}$ CPU).
- **Tolerancias de Integración:**
  - Tolerancia Relativa: `RelTol = 1e-6`.
  - Tolerancia Absoluta: `AbsTol = 1e-6 K`.
- **Intervalo de Integración Temporal:**
  - $t \in [t_0, t_f] = [0.0, 27600.0\text{ s}]$ (5 órbitas orbitales completas a $P = 5525.23\text{ s}$).
- **Condición Inicial Uniforme:**
  - $\mathbf{T}(0) = [273.15, 273.15, 273.15, 273.15, 273.15, 273.15]^T\text{ K}$ ($0^\circ\text{C}$).
- **Criterios de Aceptación Numérica Previos:**
  - Finitud estricta: $\forall t, \text{isfinite}(\mathbf{T}(t)) == \text{true}$.
  - Positividad física: $\min_{t, i} T_i(t) > T_{\text{esp}} = 2.7\text{ K}$.
  - Cierre del balance energético orbital en la 5ta órbita ($[4P, 5P]$): $\epsilon_{\text{rel}} < 1.0\%$ (típicamente $< 0.35\%$).

---

## 4. Definición de Métricas ($M$) y Ventanas Temporales

### Métrica Principal ($M_1$):
- **Símbolo:** $M_1 = T_{\max, +X}$ (Temperatura máxima absoluta de la cara de aviónica en régimen permanente).
- **Fórmula Matemática:**
  $$M_1 = \max_{t \in [3P, 5P]} T_{+X}(t) = \max_{t \in [16575.7\text{ s}, 27600.0\text{ s}]} T_1(t)$$
- **Unidad:** Kelvin $[\text{K}]$ para la formulación diferencial, con reporte auxiliar en grados Celsius $[^\circ\text{C}]$.
- **Valor Basal Auditado ($M_{1,0}$):** $291.88\text{ K}$ ($+18.73^\circ\text{C}$).
- **Ventana de Evaluación:** $t \in [3P, 5P]$ (últimas 2 órbitas), asegurando independencia del transitorio inicial.

### Métricas Secundarias de Control:
1. **$M_2 = \Delta T_{+X}$ (Amplitud térmica cíclica en proa):**
   $$M_2 = \max_{t \in [3P, 5P]} T_1(t) - \min_{t \in [3P, 5P]} T_1(t) \quad [\text{K}] \quad (\text{Valor basal: } 63.14\text{ K})$$
2. **$M_3 = T_{\min, +Z}$ (Temperatura mínima del radiador cenit):**
   $$M_3 = \min_{t \in [3P, 5P]} T_5(t) \quad [\text{K}] \quad (\text{Valor basal: } 209.99\text{ K} = -63.16^\circ\text{C})$$

---

## 5. Parámetro de Sensibilidad, Niveles de Perturbación y Dominio

- **Parámetro Seleccionado:** $\theta = \dot{Q}_{\text{int}, +X}$ (Potencia disipada en aviónica de proa).
- **Valor Basal ($\theta_0$):** $40.0\text{ W}$ (Procedencia: `SINTETICO` / `BIBLIOGRAFICO`).
- **Nivel de Perturbación 1 ($\delta$):** $\delta = 4.0\text{ W}$ ($\pm 10.0\%$).
- **Nivel de Perturbación 2 ($\delta/2$):** $\frac{\delta}{2} = 2.0\text{ W}$ ($\pm 5.0\%$).

### Comprobación de Admisibilidad en el Dominio Físico:
- $\theta_0 - \delta = 36.0\text{ W} > 0\text{ W}$ (No negatividad estricta).
- $\theta_0 + \delta = 44.0\text{ W}$ (Dentro del presupuesto de potencia del satélite $< 50\text{ W}$).
- Las temperaturas resultantes permanecen en $[209\text{ K}, 293\text{ K}]$, muy por encima de $2.7\text{ K}$ y por debajo del límite estructural de $373\text{ K}$ ($100^\circ\text{C}$).

### Normalización:
Como $\theta_0 = 40.0\text{ W} \neq 0$ y $M_{1,0} = 291.88\text{ K} \neq 0$, la sensibilidad normalizada es:
$$S = \left(\frac{40.0\text{ W}}{291.88\text{ K}}\right) D \quad [\text{adimensional}]$$

---

## 6. Matriz de Corridas y Plan de Ejecución

### Fase A: Bloque Obligatorio de Sensibilidad Local (5 Corridas)

| Run ID | Familia | Factor Modificado | Valor Numérico | Nivel Relativo | Propósito Metodológico | Estado del Plan |
| :--- | :---: | :---: | :---: | :---: | :--- | :---: |
| **`C3-BASE-001`** | `BASE` | Ninguno (Nominal) | $\dot{Q}_{\text{int}, +X} = 40.0\text{ W}$ | $0.0\%$ | Replicación del baseline y punto de anclaje $M_0$. | **AUTORIZABLE** |
| **`C3-SENS-001-M10`** | `SENS` | $\dot{Q}_{\text{int}, +X}$ | $36.0\text{ W}$ | $-10.0\%$ | Diferencia central escalón $\delta$: rama inferior. | **AUTORIZABLE** |
| **`C3-SENS-002-P10`** | `SENS` | $\dot{Q}_{\text{int}, +X}$ | $44.0\text{ W}$ | $+10.0\%$ | Diferencia central escalón $\delta$: rama superior. | **AUTORIZABLE** |
| **`C3-SENS-003-M05`** | `SENS` | $\dot{Q}_{\text{int}, +X}$ | $38.0\text{ W}$ | $-5.0\%$ | Diferencia central escalón $\delta/2$: rama inferior. | **AUTORIZABLE** |
| **`C3-SENS-004-P05`** | `SENS` | $\dot{Q}_{\text{int}, +X}$ | $42.0\text{ W}$ | $+5.0\%$ | Diferencia central escalón $\delta/2$: rama superior. | **AUTORIZABLE** |

---

### Fase B: Bloque Propuesto de Barrido Paramétrico 2-Factores (Opcional: 9 Corridas)

> [!NOTE]
> **Carácter Opcional:** En cumplimiento de las directivas de la cátedra, la matriz $3 \times 3$ es **opcional y no obligatoria**. Se propone formalmente a continuación para explorar la interacción entre la disipación interna y la conductancia de acoplamiento estructural inter-panel $g_{\text{lin}}$. Requiere confirmación humana para su ejecución.

- **Factor 1:** Disipación de aviónica $\dot{Q}_{\text{int}, +X} \in \{20.0, 40.0, 60.0\}\text{ W}$ (Niveles: Bajo, Nominal, Alto).
- **Factor 2:** Conductancia de contacto $g_{\text{lin}} \in \{1.0, 2.0, 4.0\}\text{ W/(K}\cdot\text{m)}$ (Niveles: Desacoplado, Nominal, Conectivo).

| Run ID | Factor 1: $\dot{Q}_{\text{int}, +X}$ [W] | Factor 2: $g_{\text{lin}}$ [W/(K·m)] | Reutiliza Corrida Previa | Propósito Físico | Estado de Confirmación |
| :--- | :---: | :---: | :---: | :--- | :---: |
| **`C3-SWEEP-001`** | $20.0$ | $1.0$ | No | Aislamiento térmico con baja potencia. | `PENDIENTE_CONFIRMACION` |
| **`C3-SWEEP-002`** | $20.0$ | $2.0$ | No | Conductancia nominal con baja potencia. | `PENDIENTE_CONFIRMACION` |
| **`C3-SWEEP-003`** | $20.0$ | $4.0$ | No | Alta disipación conductiva con baja potencia. | `PENDIENTE_CONFIRMACION` |
| **`C3-SWEEP-004`** | $40.0$ | $1.0$ | No | Aislamiento térmico a potencia nominal. | `PENDIENTE_CONFIRMACION` |
| **`C3-SWEEP-005`** | $40.0$ | $2.0$ | **Sí (`C3-BASE-001`)** | Caso nominal idéntico al baseline. | **REUTILIZA BASELINE** |
| **`C3-SWEEP-006`** | $40.0$ | $4.0$ | No | Alta conductancia a potencia nominal. | `PENDIENTE_CONFIRMACION` |
| **`C3-SWEEP-007`** | $60.0$ | $1.0$ | No | Peor caso térmico: alta potencia y baja conducción. | `PENDIENTE_CONFIRMACION` |
| **`C3-SWEEP-008`** | $60.0$ | $2.0$ | No | Alta potencia con conducción nominal. | `PENDIENTE_CONFIRMACION` |
| **`C3-SWEEP-009`** | $60.0$ | $4.0$ | No | Alta potencia disipada con alta conducción. | `PENDIENTE_CONFIRMACION` |

*(Total de simulaciones nuevas requeridas para el barrido completo: 8 corridas).*

---

## 7. Presupuesto Computacional y Límite de Recursos

- **Tiempo de CPU por corrida estimado:** $\sim 0.096\text{ s}$ (medido en MATLAB R2024a para `ode45`).
- **Presupuesto Fase A (Sensibilidad Obligatoria, 5 corridas):**
  - Pasos temporales totales: $\sim 1750$ pasos.
  - Evaluaciones diferenciales (`nfev`): $\sim 13500$.
  - Tiempo de CPU total estimado: $< 0.50\text{ s}$.
  - Espacio en disco: $< 2\text{ MB}$ (archivos `.mat` y `config.json`).
- **Presupuesto Fase B (Barrido Opcional, 8 corridas nuevas):**
  - Tiempo de CPU total estimado: $< 0.85\text{ s}$.
  - Espacio en disco: $< 3\text{ MB}$.
- **Consumo Total de Recursos (Fases A + B):** $< 1.5\text{ s}$ de CPU, muy por debajo de cualquier umbral crítico.

---

## 8. Protocolo de Trazabilidad y Estructura de Salida por Run ID

Cada corrida ejecutada se guardará en su propio subdirectorio aislado en `results/<RUN_ID>/` respetando la estructura exigida por la Clase 3:

```text
LAB3_NAVARRO_VICTORIA/results/<RUN_ID>/
├── config.json               # Diccionario de parámetros, solver, tolerancias y timestamp
├── states.mat                # Series temporales completas: t_grid, T_matrix (6xN), flujos
├── metrics.csv               # Valores escalares: T_max, T_min, delta_T, T_mean por cara
├── execution.log             # Registro de consola: CPU time, pasos aceptados, NFEV
└── figure_state.png          # Perfil de temperatura de la corrida
```

---

## 9. Reglas de Parada e Intervención de Agentes

| Regla / Estado | Condición Disparadora | Acción Inmediata del Agente |
| :--- | :--- | :--- |
| **`STOP`** | Detección de $\text{NaN}$, $\text{Inf}$, o violación de cota $T_i < 2.7\text{ K}$. | Interrumpir inmediatamente la ejecución, preservar los archivos de log y estado del fallo, y notificar a la investigadora. |
| **`STOP`** | Reducción excesiva del paso de tiempo en `ode45` ($h < 10^{-8}\text{ s}$ por estancamiento numérico). | Abortar la corrida, clasificar causa (posible rigidez local o discontinuidad no resuelta) y archivar como corrida fallida. |
| **`NEEDS_MODEL_REVISION`** | Temperaturas máximas superiores a $450\text{ K}$ o comportamiento físico fuera de dominio de validez. | Suspender promoción de resultados y solicitar revisión humana de hipótesis. |
| **`READY_FOR_HUMAN_REVIEW`** | Completitud exitosa de las 5 corridas de la Fase A con datos y métricas archivados. | Generar `Sensitivity_Report.md` y esperar revisión humana antes de promover a Gate 3. |

---

## 10. Resumen de Decisiones Pendientes de la Investigadora Humana

Para habilitar la ejecución en MATLAB, la investigadora principal (Victoria Navarro) debe resolver:

1. **Autorización de la Fase A (Obligatoria):**
   - Aprobar la ejecución de las 5 corridas de sensibilidad local (`C3-BASE-001`, `C3-SENS-001-M10` a `C3-SENS-004-P05`) con $\delta = 10\%$ y $\delta/2 = 5\%$.
2. **Decisión sobre la Fase B (Opcional):**
   - Elegir entre:
     - **Opción B.1 (Recomendada):** Ejecutar únicamente la Fase A de sensibilidad local (5 corridas) para consolidar el `Sensitivity_Report.md`.
     - **Opción B.2:** Autorizar también la matriz completa de barrido $3 \times 3$ (8 corridas nuevas adicionales).

# Environment Validation Check - Laboratorio #3

## Metadatos y Control de Configuración

- **Documento:** `Environment_Validation_Check.md`
- **Versión:** 1.0 (Comprobación Técnica de Entorno)
- **Fecha:** 2026-10-06
- **Responsable:** Numerical Agent (IA)
- **Supervisora:** Victoria Navarro (Estudiante investigadora - DING59)
- **Sujeto de Estudio:** Satélite STARLINK-1008 (PVI térmico continuo de 6 nodos acoplados)
- **Modo de Operación Detectado:** **`MODO CONECTADO (MCP Server MATLAB Activo)`**
- **Dictamen del Entorno:** **`VALIDADO - APTO PARA EXPERIMENTACIÓN NUMÉRICA`**

---

## 1. Identificación de Carpetas de Trabajo

1. **Directorio Raíz del Proyecto:**
   `/Users/victorianavarro/Documents/Métodos Numéricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack`
2. **Directorio del Laboratorio Activo (Lab 3):**
   [`LAB3_NAVARRO_VICTORIA/`](./)
3. **Directorio de Código y Línea Base Verificada (Lab 2):**
   [`LAB2_NAVARRO_VICTORIA/`](../LAB2_NAVARRO_VICTORIA/)
4. **Directorio de Trabajo Actual en Sesión Viva de MATLAB (`pwd`):**
   `/Users/victorianavarro/Documents/Métodos Numéricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB2_NAVARRO_VICTORIA`

---

## 2. Versión de MATLAB y Sistema Operativo

- **Versión de MATLAB:** `24.1.0.2537033 (R2024a)`
- **Número de Licencia:** `711561`
- **Sistema Operativo:** `macOS Version 15.4.1 (Build 24E263) - Apple Silicon / Darwin`
- **Versión de Java:** `Java 11.0.32.1+10-LTS (Amazon.com Inc. OpenJDK 64-Bit Server VM)`
- **Toolboxes Relevantes Disponibles:**
  - Optimization Toolbox (v24.1)
  - Signal Processing Toolbox (v24.1)
  - Symbolic Math Toolbox (v24.1)
  - Statistics and Machine Learning Toolbox (v24.1)
  - Partial Differential Equation Toolbox (v24.1)
  - MATLAB MCP Server Toolbox (v0.4.0)

---

## 3. Disponibilidad de Archivos del Modelo

Se verificó la integridad física y semántica de los archivos sin modificar ningún archivo existente:

| Archivo / Módulo | Estado de Disponibilidad | Verificación Realizada |
| :--- | :---: | :--- |
| `model.m` (v1.1) | **DISPONIBLE** | Función compilable; protección radiativa en etapas tentativas comprobada. |
| `get_params.m` (v1.0) | **DISPONIBLE** | Estructura de parámetros completa y consistente con el modelo analítico de Lab 1. |
| `inputs/orbital_data.mat` | **DISPONIBLE** | Archivo `.mat` legible; 1501 muestras temporales, $P = 5525.23\text{ s}$ ($92.08\text{ min}$). |
| `solve_adaptive.m` | **DISPONIBLE** | Integrador adaptativo funcional con `ode45` y `ode15s`. |
| `solve_euler.m`, `solve_rk2.m`, `solve_rk4.m` | **DISPONIBLE** | Integradores de paso fijo diádicos verificados en Lab 2. |
| `reproduce_run.m` | **DISPONIBLE** | Módulo de verificación de reproducibilidad bit a bit. |
| `results/` (Lab 2) | **DISPONIBLE** | 19 corridas archivadas intactas más corrida fallida `RUN-01-ODE45-FAILED`. |
| `DING59_Clase3.pdf` | **DISPONIBLE** | Presentación de cátedra de la Clase 3 presente en `LAB3_NAVARRO_VICTORIA/`. |

---

## 4. Capacidades Reales de la Conexión: Modo Conectado vs. Modo Asistido

Se define explícitamente la distinción entre ambos modos de operación:

### A. Modo Conectado (Activo en esta sesión)
- **Mecanismo:** Conexión interactiva directa mediante el servidor de protocolo MCP (`matlab`).
- **Herramientas disponibles:** `evaluate_matlab_code`, `detect_matlab_toolboxes`, `check_matlab_code`, `run_matlab_file`, `run_matlab_test_file`.
- **Capacidades reales:**
  - Ejecución síncrona de comandos y scripts de MATLAB sin abandonar el entorno agéntico.
  - Evaluación paramétrica inmediata y retorno de métricas de consola.
  - Inspección directa de variables en memoria y generación de datos `.mat` y `.csv`.
  - Capacidad de ejecutar tanto cálculos simples como corridas de simulación numéricas completas de forma automatizada.

### B. Modo Asistido (Protocolo de Contingencia / Offline)
- **Mecanismo:** Se activa en caso de falla de conexión MCP, entornos sin servidor o ejecución en clúster externo.
- **Protocolo de trabajo:**
  1. El agente redacta y guarda los scripts `.m` modulares, autocontenidos y comentados en el directorio del laboratorio.
  2. El agente proporciona al usuario la instrucción de ejecución exacta para la consola de MATLAB (ej. `run('main_experiment.m')`).
  3. El usuario ejecuta manualmente en MATLAB y confirma el estado reportando los archivos generados en `results/` o los logs de error.

---

## 5. Evidencia de la Comprobación de Lectura y Cálculo Simple

A través del servidor MCP en **Modo Conectado**, se ejecutó una prueba de verificación real. Se documenta la salida fidedigna obtenida:

```text
=== VALIDACION DE ENTORNO MATLAB ===
MATLAB_VERSION: 24.1.0.2537033 (R2024a)
CURRENT_DIR: /Users/victorianavarro/Documents/Métodos Numéricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB2_NAVARRO_VICTORIA
ORBITAL_DATA_LOAD: OK (muestras: 1501, periodo: 5525.23 s)
PARAMS_LOAD: OK (C_pmX: 1512.0 J/K, sigma_SB: 5.6704e-08, Q_int_total: 100.0 W)
DERIVATIVE_EVAL: OK
  Nodo 1 (+X): dT/dt(0) = -0.023902 K/s
  Nodo 2 (-X): dT/dt(0) = -0.050357 K/s
  Nodo 3 (+Y): dT/dt(0) = -0.050357 K/s
  Nodo 4 (-Y): dT/dt(0) = -0.050357 K/s
  Nodo 5 (+Z): dT/dt(0) = -0.075423 K/s
  Nodo 6 (-Z): dT/dt(0) = -0.020364 K/s
MINI_SIMULATION: OK (pasos aceptados: 40, T_min_final: 268.83 K, T_max_final: 271.92 K)
=== FIN VALIDACION ===
```

### Análisis Técnico de la Evidencia:
1. **Lectura de datos:** Se confirmó la correcta carga de `orbital_data.mat`, con una grilla de 1501 puntos de tiempo y período orbital $P = 5525.23\text{ s}$.
2. **Carga paramétrica:** `get_params.m` retornó la estructura completa sin excepciones; capacitancias ($C_{\pm X} = 1512\text{ J/K}$), constante de Stefan-Boltzmann ($\sigma_{\text{SB}} = 5.6704 \times 10^{-8}\text{ W/(m}^2\text{K}^4)$) y potencia interna total ($100\text{ W} = 40\text{ W} + 60\text{ W}$).
3. **Evaluación diferencial:** En $t=0\text{ s}$ con $\mathbf{T}_0 = 273.15\text{ K}$, todas las derivadas $\frac{dT_i}{dt}$ son negativas, confirmando el enfriamiento físico continuo durante la fase inicial en eclipse sin artefactos de signos.
4. **Mini-simulación dinámica:** La integración de 60 segundos mediante `ode45` completó 40 pasos temporales aceptados, alcanzando temperaturas térmicamente admisibles ($268.83\text{ K} - 271.92\text{ K} \gg 2.7\text{ K}$), validando la estabilidad operativa del resolvedor.

---

## 6. Procedimiento para Ejecución Manual (Modo Asistido)

Si en futuras sesiones el servidor MCP se encontrara inactivo, la comprobación se ejecuta manualmente abriendo MATLAB y corriendo:

```matlab
% 1. Posicionarse en la carpeta de código:
cd('/Users/victorianavarro/Documents/Métodos Numéricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB2_NAVARRO_VICTORIA')

% 2. Ejecutar la secuencia de prueba:
orb = load('inputs/orbital_data.mat');
p = get_params();
T0 = 273.15 * ones(6, 1);
dT0 = model(0, T0, p);
fprintf('dT/dt(0) nodo 1: %.6f K/s\n', dT0(1));

% 3. Mini-corrida de verificación:
opt = odeset('RelTol', 1e-6, 'AbsTol', 1e-6);
[t, y] = ode45(@(t, T) model(t, T, p), [0, 60], T0, opt);
fprintf('Simulacion completada exitosamente. Pasos: %d\n', length(t)-1);
```

---

## 7. Dictamen Final

- **Estado de Validación:** **`SUCCESS - MODO_CONECTADO_VERIFICADO`**
- El entorno se encuentra 100% operativo y listo para ejecutar las corridas de sensibilidad local por diferencias finitas centrales y los barridos paramétricos del **Laboratorio #3**.

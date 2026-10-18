# Environment Validation Check - Laboratorio #4

## Metadatos y Control de Configuración

- **Documento:** `Environment_Validation_Check.md`
- **Versión:** 1.0 (Comprobación Técnica de Entorno en Vivo)
- **Fecha de Verificación:** 2026-10-18T10:52:19-03:00
- **Rol Emisor:** Numerical Agent (IA)
- **Investigadora Principal:** Victoria Navarro (Estudiante Investigadora - Cátedra de Métodos Numéricos DING59)
- **Sujeto de Estudio:** Satélite STARLINK-1008 (PVI no lineal de 6 nodos térmicos acoplados en LEO)
- **Directorio de Trabajo:** [`LAB4_NAVARRO_VICTORIA/`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/)
- **Modo Operativo Detectado:** **`MODO CONECTADO (MCP Server MATLAB Activo en Vivo)`**
- **Dictamen del Entorno:** **`VALIDADO - ENTORNO OPERACIONAL, CONECTADO Y CON ESCRITURA CONFIRMADA`**

---

## 1. Identificación del Sistema y Rutas de Trabajo

1. **Directorio Raíz del Proyecto:**  
   `/Users/victorianavarro/Documents/Métodos Numéricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack`
2. **Directorio de Trabajo del Laboratorio #4:**  
   [`LAB4_NAVARRO_VICTORIA/`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/)  
   *(Enlace simbólico canónico a `Comprobaciones-resultados_de_corridas/LAB4_NAVARRO_VICTORIA/`)*.
3. **Directorio de Insumos Precedentes Aislados:**  
   [`LAB4_NAVARRO_VICTORIA/inputs/`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/inputs/)
4. **Directorios de Laboratorios Precedentes (Intactos y Protegidos):**  
   - `LAB1_NAVARRO_VICTORIA/` (100% inalterado)
   - `LAB2_NAVARRO_VICTORIA/` (100% inalterado)
   - `LAB3_NAVARRO_VICTORIA/` (100% inalterado)

---

## 2. Herramienta Computacional, Versión y Sistema Operativo

A través del servidor MCP de MATLAB conectado a la sesión viva del sistema, se consultó el entorno nativo (`ver`):

- **Herramienta Principal:** MATLAB
- **Versión de MATLAB:** `24.1.0.2537033 (R2024a)`
- **Número de Licencia:** `711561`
- **Sistema Operativo del Host:** `macOS Version 15.4.1 (Build 24E263) - Apple Silicon / Darwin`
- **Shell Activo:** `zsh`
- **Entorno Java:** `Java 11.0.32.1+10-LTS (Amazon.com Inc. OpenJDK 64-Bit Server VM)`
- **Toolboxes Relevantes Disponibles e Instalados:**
  - Optimization Toolbox (Version 24.1)
  - Control System Toolbox (Version 24.1)
  - Partial Differential Equation Toolbox (Version 24.1)
  - Symbolic Math Toolbox (Version 24.1)
  - Signal Processing Toolbox (Version 24.1)
  - Statistics and Machine Learning Toolbox (Version 24.1)
  - MATLAB MCP Server Toolbox (Version 0.4.0)

---

## 3. Inventario de Archivos Disponibles e Integridad del Modelo

Se verificó la presencia y disponibilidad de todos los módulos sin alterar ninguna línea de código del modelo:

| Archivo / Ruta | Tipo | Estado | Verificación Realizada |
| :--- | :---: | :---: | :--- |
| [`inputs/model.m`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/inputs/model.m) | Código `.m` (v1.1) | **DISPONIBLE** | Integra la guarda radiativa $T_{\text{rad}} = \max(T, T_{\text{esp}})$; evalúa vector de derivadas $6 \times 1$ sin errores. |
| [`inputs/get_params.m`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/inputs/get_params.m) | Código `.m` (v1.0) | **DISPONIBLE** | Carga sin excepciones todos los parámetros geométricos, ópticos y térmicos del satélite. |
| [`inputs/solve_adaptive.m`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/inputs/solve_adaptive.m) | Código `.m` (v1.0) | **DISPONIBLE** | Integrador adaptativo con `ode45` funcional. |
| [`inputs/orbital_data.mat`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/inputs/orbital_data.mat) | Datos `.mat` (v1.0) | **DISPONIBLE** | Datos de posición solar y efemérides (1501 muestras, $P = 5525.23\text{ s}$). |
| [`inputs/Gate_3.md`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/inputs/Gate_3.md) | Documento | **DISPONIBLE** | Aprobación humana de Victoria Navarro formalizada con estado `ACCEPT`. |
| [`inputs/Paper_v0.3.md`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/inputs/Paper_v0.3.md) | Documento | **DISPONIBLE** | Manuscrito aprobado con alcance delimitado de verificación numérica. |
| [`Input_Inventory.md`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/Input_Inventory.md) | Documento | **DISPONIBLE** | Catálogo formal de insumos de Lab 4. |
| [`RESEARCH_LOG.md`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/RESEARCH_LOG.md) | Bitácora | **DISPONIBLE** | Bitácora activa con Entrada 001. |

> [!NOTE]
> **Preservación Estricta del Modelo:**  
> Ninguna línea de los archivos [`model.m`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/inputs/model.m) ni [`get_params.m`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/inputs/get_params.m) ha sido modificada. La compatibilidad de rutas relativas para el archivo de efemérides se resolvió de forma no invasiva a nivel del sistema de archivos mediante un enlace simbólico de conveniencia (`inputs/inputs -> .`), respetando la integridad original del código fuente.

---

## 4. Permisos de Escritura y Modo Operativo

### 4.1. Verificación de Permisos de Escritura
Se validaron los permisos de escritura en el directorio de trabajo [`LAB4_NAVARRO_VICTORIA/`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/):
- Creación de archivos markdown: **CONFIRMADA** (`Input_Inventory.md`, `RESEARCH_LOG.md`, `Environment_Validation_Check.md`).
- Creación y volcado de archivos binarios MATLAB `.mat`: **CONFIRMADA** ([`test_env_output.mat`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/test_env_output.mat), tamaño: $2.5\text{ KB}$).
- Creación de archivos de texto con diagnósticos: **CONFIRMADA** ([`test_env_output.txt`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/test_env_output.txt), tamaño: $1.1\text{ KB}$).

### 4.2. Caracterización del Modo de Operación: **MODO CONECTADO**
- **Estado Actual:** **`CONECTADO Y ACTIVO`**.
- **Herramienta en uso:** Servidor MCP `matlab` (`evaluate_matlab_code`, `detect_matlab_toolboxes`, etc.).
- **Capacidad comprobada:** El agente puede evaluar código de forma directa y síncrona en MATLAB R2024a, capturar salidas de terminal, verificar objetos en memoria y almacenar artefactos numéricos directamente en el disco.
- **Protocolo de contingencia (Modo Asistido):** En caso de una hipotética desconexión de la sesión viva, el agente preparará scripts ejecutables `.m` con instrucciones precisas para que la investigadora los ejecute en su terminal o interfaz gráfica de MATLAB, esperando la retroalimentación de los archivos de salida generados.

---

## 5. Evidencia Real de Cálculo y Guardado (Prueba en Vivo)

A continuación se transcribe la evidencia directa y fidedigna generada durante la ejecución en vivo en MATLAB el **2026-10-18 a las 10:52:19**:

```text
=================================================================
  VALIDACION DE ENTORNO COMPUTACIONAL - LAB 4
=================================================================
Fecha y hora: 2026-10-18 10:52:19
Version MATLAB: 24.1.0.2537033 (R2024a)
Directorio de trabajo: /Users/victorianavarro/Documents/Métodos Numéricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/Comprobaciones-resultados_de_corridas/LAB4_NAVARRO_VICTORIA
Modo operativo: MODO CONECTADO (MCP Activo)
Permiso de escritura: VERIFICADO (OK)

--- RESULTADOS DE CALCULO ---
Capacidad termica total del chasis: 37296.0 J/K
Potencia emitida Stefan-Boltzmann a T0=293.15 K: 3631.3705 W
Potencia absorbida total a t=0 s: 968.6789 W
Derivadas iniciales dT/dt(0) [K/s]:
  Nodo 1 (+X): -4.538287e-02 K/s
  Nodo 2 (-X): -7.183790e-02 K/s
  Nodo 3 (+Y): -7.183790e-02 K/s
  Nodo 4 (-Y): -7.183790e-02 K/s
  Nodo 5 (+Z): -1.006270e-01 K/s
  Nodo 6 (-Z): -4.470875e-02 K/s

--- MINI-INTEGRACION DINAMICA [0, 60] s ---
Pasos aceptados: 40
Tiempo CPU: 0.1092 s
T_min final (t=60s): 287.4183 K (14.27 C)
T_max final (t=60s): 290.5260 K (17.38 C)
Estado final: OPERACIONAL Y VERIFICADO
```

### Análisis Numérico de la Evidencia:
1. **Cálculo de Potencias en Balance:**  
   A $t=0\text{ s}$ (fase de sombra / eclipse en órbita LEO), la potencia solar directa es nula ($\text{ilum}=0$), por lo que la potencia absorbida proviene exclusivamente de la radiación infrarroja de la Tierra ($q_{\text{ir}} = 237\text{ W/m}^2$) y de la disipación interna de la aviónica ($40\text{ W}$ en $+X$ y $60\text{ W}$ en $-Z$), totalizando $968.68\text{ W}$.
2. **Emisión Radiativa de Stefan-Boltzmann:**  
   Con $\mathbf{T}_0 = 293.15\text{ K}$ uniforme ($+20.0^\circ\text{C}$), el satélite emite $3631.37\text{ W}$ hacia el fondo cósmico ($2.7\text{ K}$). Como la potencia emitida supera con holgura a la absorbida, el balance neto es disipativo.
3. **Consistencia de Signos:**  
   Las derivadas temporales iniciales $\frac{dT_i}{dt}$ son estrictamente negativas en los 6 nodos (enfriamiento físico coherente durante el eclipse), sin artefactos de signos ni oscilaciones espurias.
4. **Mini-Integración Dinámica con `ode45`:**  
   El integrador completó exitosamente una trayectoria de $60\text{ segundos}$ en $40\text{ pasos}$ adaptativos con un tiempo de cómputo de $0.1092\text{ s}$. Las temperaturas evolucionaron suavemente desde $293.15\text{ K}$ hasta un rango de $[287.42\text{ K}, 290.53\text{ K}]$, dentro de los límites estrictos del dominio físico.
5. **Persistencia en Disco:**  
   Se verificó la generación física de los archivos [`test_env_output.mat`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/test_env_output.mat) ($2.5\text{ KB}$) y [`test_env_output.txt`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/test_env_output.txt) ($1.1\text{ KB}$) en el directorio de Lab 4.

---

## 6. Procedimiento para Modo Asistido (Manual)

Si en algún momento futuro la conexión MCP no estuviese disponible, la prueba puede reproducirse manualmente ejecutando en la consola de MATLAB:

```matlab
% 1. Posicionarse en el directorio del Lab 4:
cd('/Users/victorianavarro/Documents/Métodos Numéricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA')

% 2. Añadir subcarpeta de insumos:
addpath('inputs');

% 3. Cargar parametros y evaluar derivada inicial:
p = get_params();
T0 = 293.15 * ones(6, 1);
[dTdt_0, flujos] = model(0, T0, p);
fprintf('dT/dt(0) en cara +X: %+.6e K/s\n', dTdt_0(1));

% 4. Mini-integracion de 60 segundos:
opt = odeset('RelTol', 1e-6, 'AbsTol', 1e-6);
[t, y] = ode45(@(t, T) model(t, T, p), [0, 60], T0, opt);
fprintf('Prueba manual exitosa. Pasos: %d | T_min(60s): %.2f K\n', length(t)-1, min(y(end,:)));
```

---

## 7. Dictamen Final

- **Estado del Entorno:** **`APTO Y CERTIFICADO PARA EL LABORATORIO #4`**
- **Modo Confirmado:** **`MODO CONECTADO ACTIVO`** (Ejecución real y directa en MATLAB R2024a comprobada con evidencia binaria y de texto archivada).
- **Integridad del Modelo:** **`PRESERVADO 100% SIN MODIFICACIONES`**.

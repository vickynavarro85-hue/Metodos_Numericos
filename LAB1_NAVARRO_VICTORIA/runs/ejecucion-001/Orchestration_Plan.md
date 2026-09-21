# Orchestration Plan - Ejecución 001
    
## Ejecución y fecha
    
- **Ejecución:** 001
- **Fecha:** 2026-09-13
- **Responsable del rol:** Research Orchestrator (IA)
- **Supervisión y aprobación:** Victoria Navarro (Estudiante investigadora)
    
## Objetivo
    
Establecer la hoja de ruta metodológica y el encargo acotado para formular analíticamente el Problema de Valor Inicial (PVI) del balance térmico nodal de 6 caras del satélite STARLINK-1008 en órbita LEO, asegurando la trazabilidad de los datos, la explicitación de supuestos y la exigencia de comprobaciones teóricas sin derivar las ecuaciones finales ni seleccionar métodos numéricos de resolución.
    
## Entradas verificadas
    
1. `AGENTS.md` v1.0 (Reglas comunes, clasificación y gobernanza).
2. `agents/Research_Orchestrator.md` v1.0 y `agents/Modeling_Agent.md` v1.0.
3. `Problem_Definition.md` (Pregunta científica, parámetros orbitales, geometría y entorno radiativo).
    
## Datos, supuestos y faltantes
    
- **Datos verificados (`MEDIDO` / `BIBLIOGRAFICO`):**
      - *Orbitales (`MEDIDO`):* STARLINK-1008 (NORAD 44714), $a = 6755.0\text{ km}$ ($h \approx 377\text{ km}$), $n = 15.637\text{ rev/día}$, $P = 5525.4\text{ s}$ ($92.09\text{ min}$), $i = 53.15^\circ$, $e = 0.00026$, eclipse de $34.5\text{ min}$ por órbita (37.4%).
      - *Constantes y entorno (`BIBLIOGRAFICO`):* Constante solar media $S_0 = 1361\text{ W/m}^2$, radiación infrarroja terrestre $q_{IR,\oplus} = 237\text{ W/m}^2$, albedo medio terrestre $a = 0.30$, constante de Stefan-Boltzmann $\sigma = 5.670374 \times 10^{-8}\text{ W/(m}^2\text{K}^4)$, fondo cósmico $T_{\text{esp}} = 2.7\text{ K}$, calor específico del aluminio $c_p = 900.0\text{ J/(kg}\cdot\text{K)}$.
- **Datos didácticos (`SINTETICO`):**
      - Condición inicial uniforme $\mathbf{T}(0) = [273.15, \dots, 273.15]^T\text{ K}$ ($0^\circ\text{C}$), cuyo transitorio numérico se amortigua en las primeras 1-2 órbitas.
- **Supuestos simplificadores (`SUPUESTO`):**
      - Geometría de caja prismática tipo panel plano ($L_x = 2.8\text{ m}, L_y = 1.4\text{ m}, L_z = 0.3\text{ m}$) con áreas resultantes ($A_{\pm X} = 0.42\text{ m}^2, A_{\pm Y} = 0.84\text{ m}^2, A_{\pm Z} = 3.92\text{ m}^2$).
      - Densidad superficial equivalente $\sigma_m = 4.0\text{ kg/m}^2$, determinando capacitancias térmicas nodales ($C_{\pm X} = 1512\text{ J/K}, C_{\pm Y} = 3024\text{ J/K}, C_{\pm Z} = 14112\text{ J/K}$).
      - Conductancia lineal de aristas compartidas $g_{\text{lin}} = 2.0\text{ W/(K}\cdot\text{m)}$ para acoplamiento conductivo 1D.
      - Propiedades termo-ópticas constantes por cara ($\alpha_i, \varepsilon_i$) para mantas MLI, radiador cenit y panel nadir.
      - Factores de vista a la Tierra ($F_{\oplus, -Z} = 0.892, F_{\oplus, \text{lat}} = 0.312, F_{\oplus, +Z} = 0.03$).
      - Actitud rígida LVLH nadir; cavidad interna sin intercambio radiativo cavitario; disipación interna fija ($60\text{ W}$ en $-Z$, $40\text{ W}$ en $+X$, $0\text{ W}$ en las demás).
- **Información faltante (`FALTANTE`):**
      - Planos mecánicos y masa real de SpaceX (confidenciales).
      - Telemetría de vuelo en tiempo real para validación experimental.
      - Cinemática activa del panel solar (mecanismo SADA).
      - Variación de disipación interna por tráfico de comunicaciones.
    
## Secuencia de tareas
    
1. **Fase de Orquestación (Actual):** Consolidar este plan y emitir `Modeling_Handoff.md`.
2. **Punto de Control Humano:** Pausar la ejecución en `WAITING_HUMAN` para que la estudiante revise el encargo y complete `Human_Review.md`.
3. **Fase de Modelado (Condicional a la aceptación humana):** El `Modeling_Agent` deduce las 6 EDOs no lineales de balance de calor y realiza la batería completa de comprobaciones analíticas.
4. **Fase de Consolidación:** La estudiante evalúa `Modeling_Report.md` y redacta su modelo propio en `Mathematical_Model_v1.md`.
5. **Human Validation Gate:** Decisión formal en `Gate_1.md` y actualización de `RESEARCH_LOG.md`.
    
 ## Productos esperados
    
- `runs/ejecucion-001/Orchestration_Plan.md` (Completado).
- `runs/ejecucion-001/Modeling_Handoff.md` (Completado).
- `runs/ejecucion-001/Human_Review.md` (A completar por Victoria Navarro).
- `runs/ejecucion-001/Modeling_Report.md` (A generar por el Modeling Agent).
    
## Riesgos y bloqueos
    
- **Riesgo:** La hipótesis de parámetros concentrados asume que cada cara es isotérmica. Si existieran gradientes térmicos fuertes dentro de un mismo panel, se requeriría un modelo de elementos finitos (declarado fuera de alcance).
- **Riesgo:** La conductancia lineal de $2.0\text{ W/(K}\cdot\text{m)}$ es un supuesto de ingeniería no medido directamente en el vehículo real.
- **Bloqueo estricto:** Queda terminantemente prohibido que los agentes deriven código computacional, elijan solvers de integración temporal o inventen curvas numéricas simuladas.
    
## Criterio de parada
    
El Research Orchestrator finaliza su labor en estado **`WAITING_HUMAN`**, quedando suspendida toda acción posterior hasta que la estudiante evalúe y firme el `Modeling_Handoff.md`.


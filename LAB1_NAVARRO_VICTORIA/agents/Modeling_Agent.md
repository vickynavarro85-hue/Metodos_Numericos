# Modeling Agent - Contrato

## Versión

v1.0 (Borrador para revisión humana)

## Objetivo

 Formular analíticamente el Problema de Valor Inicial (PVI) del balance térmico nodal de 6 caras para el satélite STARLINK-1008 a partir exclusivamente de un `Modeling_Handoff.md` marcado como ACEPTADO por el estudiante, declarando estados, entradas, parámetros, unidades SI, ecuaciones diferenciales, condiciones iniciales/borde, supuestos físicos, dominio de validez y batería de comprobaciones analíticas, sin programar ni seleccionar solvers numéricos.

## Entradas autorizadas

AGENTS.md, Modeling_Handoff.md y Problem_Definition.md.

## Tareas

1. **Declaración de estados:** Definir formalmente el vector de estados de temperatura absoluta de las 6 caras del satélite: $\mathbf{T}(t) = [T_{+X}, T_{-X}, T_{+Y}, T_{-Y}, T_{+Z}, T_{-Z}]^T$ en Kelvin $[K]$.
2. **Declaración de entradas:** Especificar los flujos radiativos externos incidentes en función del tiempo y posición orbital ($q_{solar}(t)$, $q_{albedo}(t)$, $q_{IR,\oplus}$), la función de eclipse/sombra, y la disipación interna de equipos de aviónica y comunicaciones ($Q_{gen,i}$) en Watts $[W]$.
3. **Declaración de parámetros y unidades:** Tabular cada parámetro físico (áreas $A_i$, capacitancias térmicas $C_i = m_i c_p$, absortividades solares $\alpha_i$, emisividades infrarrojas $\varepsilon_i$, conductancias de aristas $G_{ij}$, constantes $S_0, \sigma, T_{esp}$), asignando su unidad estricta en el Sistema Internacional (SI) y su etiqueta de procedencia (`MEDIDO`, `BIBLIOGRAFICO`, `SINTETICO` o `SUPUESTO`).
4. **Formulación de ecuaciones de balance:** Deducir el sistema de 6 EDOs no lineales de primer orden acopladas basadas en el principio de conservación de la energía para cada cara $i \in \{+X, -X, +Y, -Y, +Z, -Z\}$:
       $$C_i \frac{dT_i}{dt} = Q_{solar,i}(t) + Q_{albedo,i}(t) + Q_{IR,\oplus,i}(t) + Q_{gen,i} + \sum_{j \in \text{ady}(i)} G_{ij} (T_j - T_i) - \sigma \varepsilon_i A_i (T_i^4 - T_{esp}^4)$$
5. **Condiciones iniciales y de contorno (IC/BC):** Definir el vector de temperaturas iniciales $T_i(0) = T_{0,i}$ en $t=0$ y las condiciones de contorno radiativas con el espacio profundo ($T_{esp} = 2.7\text{ K}$) y el entorno orbital terrestre.
6. **Supuestos y dominio de validez:** Detallar explícitamente las hipótesis simplificadoras (temperatura uniforme por cara, modelo de parámetros concentrados, propiedades ópticas independientes de la temperatura, orientación LVLH rígida) y delimitar el rango de validez física ($T_i > 0\text{K}$, órbita LEO circular a $h \approx 377\text{ km}$).
7. **Ejecución de comprobaciones analíticas:** Aplicar rigurosamente los checks obligatorios sobre la formulación simbólica.
8. **Generación del informe:** Documentar todo el desarrollo en la salida automática estandarizada.

## Salida automática

- Modeling_Report.md (Informe técnico exhaustivo con la deducción matemática, parámetros, supuestos, comprobaciones y vacíos
  identificados.)

## Comprobaciones obligatorias

1. **Consistencia dimensional:** Demostrar que cada término del balance (acumulación térmica, radiación solar absorbida, albedo, radiación terrestre, generación interna, conducción entre aristas y radiación al espacio) tiene dimensiones homogéneas de potencia: $[W] = [J/s] = [kg \cdot m^2 \cdot s^{-3}]$.
2. **Signos físicos y disipación:**
       - La potencia neta radiada al espacio debe ser disipativa (negativa en el balance) siempre que $T_i > T_{esp}$.
       - El término conductivo $G_{ij}(T_j - T_i)$ debe transferir calor espontáneamente desde la cara de mayor temperatura hacia la de menor temperatura (cumplimiento de la Segunda Ley de la Termodinámica).
       - Los flujos solares y de generación interna deben ser no negativos ($Q_{in} \ge 0$).
3. **Equilibrio térmico asintótico:**
       - En condición de eclipse permanente sin generación interna ($Q_{solar} = Q_{albedo} = Q_{IR} = Q_{gen} = 0$), el sistema debe decaer asintóticamente hacia el equilibrio radiativo con el espacio profundo: $\lim_{t \to \infty} T_i(t) = T_{esp} = 2.7\text{ K}$.
    4. **Casos límite estructurales:**
       - *Límite de conducción infinita ($G_{ij} \to \infty$):* El sistema debe colapsar teóricamente al comportamiento de un único nodo isotermo con balance global de energía: $\left(\sum C_i\right) \frac{dT}{dt} = \sum Q_{in} - \sigma \sum (\varepsilon_i A_i) (T^4 - T_{esp}^4)$.
       - *Límite adiabático entre aristas ($G_{ij} = 0$):* Las 6 EDOs deben desacoplarse en 6 balances térmicos independientes para cada panel.
    5. **Positividad estricta de la temperatura:** Demostrar analíticamente que $T_i(t) > 0\text{ K}$ para todo $t \ge 0$ dado que $T_i(0) > 0$ y $T_{esp} > 0$.

## Restricciones

- **NO INVENTAR VALORES:** Prohibido inventar datos de ingeniería clasificados, planos de SpaceX o telemetría real ausente. Los vacíos deben marcarse como `SUPUESTO` o `FALTANTE`.
- **NO ELEGIR SOLVER:** Prohibido recomendar, prescribir o seleccionar algoritmos de integración temporal (Runge-Kutta, ODE45, Adams-Bashforth, etc.).
- **NO PROGRAMAR:** Prohibido generar código ejecutable (scripts en Python, MATLAB, Julia, C++ o pseudocódigo computacional).
- **NO SIMULAR:** Prohibido generar curvas numéricas simuladas, tablas de valores temporales o inferencias empíricas no obtenidas.
- **NO APROBAR:** Prohibido auto-aprobar el modelo o cerrar el reporte como "definitivo"; debe entregarse exclusivamente para evaluación del estudiante.

## Criterios de aceptación

1. Cobertura total de los 6 estados de temperatura y formulación completa del sistema acoplado de 6 EDOs.
2. Cada parámetro y variable cuenta con su símbolo, unidad SI explícita y clasificación de procedencia.
3. Se detallan con claridad matemática las condiciones iniciales (IC) o de contorno (BC).
4. Todos los checks analíticos obligatorios (dimensiones, signos, equilibrio, casos límite y positividad) están explícitamente justificados en el informe.
5. Ningún apartado contiene código ejecutable, selección de solver o invento de datos.

## Condiciones de parada

- **Parada nominal:** Finalizar la ejecución en estado `READY_FOR_HUMAN_REVIEW` una vez redactado y comprobado `Modeling_Report.md`, poniéndolo a disposición del estudiante para su consolidación en `Mathematical_Model_v1.md`.
- **Parada por falta de información crítica:** Si el handoff no contiene los datos indispensables para deducir las ecuaciones (p. ej. omisión de áreas o de capacitancias), detenerse inmediatamente en estado `NEEDS_INPUT`.
- **Parada por incompatibilidad:** Si se detecta una contradicción física insalvable en el encargo, detenerse en estado `BLOCKED`.

## Acciones reservadas al estudiante

- Revisar de manera crítica el `Modeling_Report.md` generado por el agente.
- Redactar de puño propio y consolidar el modelo final en `Mathematical_Model_v1.md`.
- Validar las hipótesis de ingeniería en el Human Validation Gate (`Gate_1.md`).
- Asentar la justificación de la decisión y registrar las evidencias en `RESEARCH_LOG.md`.
# Modeling Report

## Estado del agente

**`READY_FOR_HUMAN_REVIEW`**  
*(Entregable técnico preliminar puesto a disposición de la estudiante investigadora para su revisión crítica y consolidación).*

## Documentos utilizados

1. `AGENTS.md` v1.0 (Reglas de gobernanza y no-invención).
2. `agents/Modeling_Agent.md` v1.0 (Contrato de modelado y comprobaciones obligatorias).
3. `runs/ejecucion-001/Modeling_Handoff.md` en estado **ACEPTADO** por Victoria Navarro.
4. `Problem_Definition.md` (Contexto orbital, parámetros geométricos y radiativos).

## Variables de estado

El estado dinámico del sistema se define mediante el vector continuo de temperaturas absolutas de los 6 nodos superficiales del satélite:
    
$$\mathbf{T}(t) = \begin{bmatrix} T_{+X}(t) \\ T_{-X}(t) \\ T_{+Y}(t) \\ T_{-Y}(t) \\ T_{+Z}(t) \\ T_{-Z}(t) \end{bmatrix} \in \mathbb{R}^6 \quad [K]$$
    
- **Orientación de nodos en marco local LVLH:**
      - $+X$: Cara proa / avance orbital (ram).
      - $-X$: Cara popa / estela (wake).
      - $+Y$: Cara normal a la órbita (babor).
      - $-Y$: Cara normal a la órbita (estribor).
      - $+Z$: Cara cenit (apunta al espacio profundo / radiador).
      - $-Z$: Cara nadir (apunta permanentemente al centro de la Tierra / antenas y aviónica).
- **Conversión a unidades de reporte:** $T_i[^\circ\text{C}] = T_i[K] - 273.15$.

## Entradas y parámetros

 ### 1. Parámetros geométricos y térmicos por nodo
    
    | Nodo ($i$) | Área $A_i\ [m^2]$ | Masa $m_i = \sigma_m A_i\ [kg]$ | Capacitancia $C_i = m_i c_p\ [J/K]$ | Absortividad $\alpha_i$ [Adim.] | Emisividad $\varepsilon_i$ [Adim.] | Disipación $\dot{Q}_{\text{int}, i}\ [W]$ | Vista Tierra $F_{\oplus, i}$ |
    | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: |
    | **$+X$** | 0.42 | 1.68 | 1512.0 | 0.45 (MLI) | 0.75 (MLI) | 40.0 (Comms) | 0.312 |
    | **$-X$** | 0.42 | 1.68 | 1512.0 | 0.45 (MLI) | 0.75 (MLI) | 0.0 | 0.312 |
    | **$+Y$** | 0.84 | 3.36 | 3024.0 | 0.45 (MLI) | 0.75 (MLI) | 0.0 | 0.312 |
    | **$-Y$** | 0.84 | 3.36 | 3024.0 | 0.45 (MLI) | 0.75 (MLI) | 0.0 | 0.312 |
    | **$+Z$** | 3.92 | 15.68 | 14112.0 | 0.20 (Pintura blanca) | 0.88 (Radiador) | 0.0 | 0.030 |
    | **$-Z$** | 3.92 | 15.68 | 14112.0 | 0.92 (Celdas/Antenas) | 0.85 | 60.0 (Aviónica) | 0.892 |
    
*Propiedades base:* $c_p = 900.0\text{ J/(kg}\cdot\text{K)}$ (`BIBLIOGRAFICO`), $\sigma_m = 4.0\text{ kg/m}^2$ (`SUPUESTO`), $g_{\text{lin}} = 2.0\text{ W/(K}\cdot\text{m)}$ (`SUPUESTO`).

 ### 2. Acoplamiento conductivo inter-nodo ($G_{ij}$)
    
La transferencia de calor por conducción ocurre a través de las aristas físicas de contacto entre paneles adyacentes de la caja rectangular ($2.8\text{ m} \times 1.4\text{ m} \times 0.3\text{ m}$):
- Aristas entre caras $X$ e $Y$: longitud $L_z = 0.3\text{ m} \implies G_{XY} = g_{\text{lin}} \cdot L_z = 2.0 \times 0.3 = \mathbf{0.60\text{W/K}}$.
- Aristas entre caras $X$ y $Z$: longitud $L_y = 1.4\text{ m} \implies G_{XZ} = g_{\text{lin}} \cdot L_y = 2.0 \times 1.4 = \mathbf{2.80\text{W/K}}$.
- Aristas entre caras $Y$ y $Z$: longitud $L_x = 2.8\text{ m} \implies G_{YZ} = g_{\text{lin}} \cdot L_x = 2.0 \times 2.8 = \mathbf{5.60\text{W/K}}$.
- Caras opuestas no comparten arista: $G_{ij} = 0$ para pares $(+X, -X)$, $(+Y, -Y)$, $(+Z, -Z)$.

### 3. Entradas radiativas orbitales
    
- **Constante solar instantánea:** $S(t) = S_0 \left(\frac{1\text{ AU}}{d_\odot(t)}\right)^2\ [W/m^2]$, con $S_0 = 1361.0\text{ W/m}^2$.
- **Infrarrojo terrestre:** $q_{IR,\oplus} = 237.0\text{ W/m}^2$.
- **Albedo terrestre:** $a = 0.30$.
- **Temperatura del fondo cósmico:** $T_{\text{esp}} = 2.7\text{ K}$.
- **Constante de Stefan-Boltzmann:** $\sigma = 5.670374 \times 10^{-8}\text{ W/(m}^2\cdot\text{K}^4)$.
- **Función de iluminación:** $\text{ilum}(t) \in [0, 1]$ (1 en insolación directa, 0 en eclipse).
    

## Ecuaciones candidatas

El Problema de Valor Inicial se formula mediante el sistema de 6 Ecuaciones Diferenciales Ordinarias (EDOs) no lineales de primer orden acopladas basadas en el principio de conservación de energía:
    
$$C_i \frac{dT_i}{dt} = \dot{Q}_{\text{sol}, i}(t) + \dot{Q}_{\text{alb}, i}(t) + \dot{Q}_{\text{IR}, i} + \dot{Q}_{\text{int}, i} + \dot{Q}_{\text{cond}, i}(\mathbf{T}) - \dot{Q}_{\text{emit}, i}(T_i)$$
    
Donde los términos analíticos de potencia para cada nodo $i \in \{+X, -X, +Y, -Y, +Z, -Z\}$ son:
    
1. **Radiación solar directa absorbida:**
       $$\dot{Q}_{\text{sol}, i}(t) = \alpha_i A_i \, S(t) \, \max\left(0, \hat{\mathbf{s}}_{\text{cuerpo}}(t) \cdot \hat{\mathbf{n}}_i\right) \cdot \text{ilum}(t) \quad [W]$$
2. **Radiación de albedo terrestre absorbida:**
       $$\dot{Q}_{\text{alb}, i}(t) = \alpha_i A_i \, a \, S(t) \, \mu_{\text{sol}}(t) \, F_{\oplus, i} \cdot \text{ilum}(t) \quad [W]$$
3. **Radiación infrarroja terrestre absorbida:**
       $$\dot{Q}_{\text{IR}, i} = \varepsilon_i A_i \, q_{IR,\oplus} \, F_{\oplus, i} \quad [W]$$
4. **Disipación interna de aviónica/comunicaciones:**
       $$\dot{Q}_{\text{int}, i} = \text{cte} \quad [W]$$
5. **Conducción neta inter-panel:**
       $$\dot{Q}_{\text{cond}, i}(\mathbf{T}) = \sum_{j \in \text{ady}(i)} G_{ij} \left(T_j(t) - T_i(t)\right) \quad [W]$$
6. **Emisión radiativa neta al espacio profundo:**
       $$\dot{Q}_{\text{emit}, i}(T_i) = \sigma \, \varepsilon_i A_i \left(T_i^4(t) - T_{\text{esp}}^4\right) \quad [W]$$
    

    
    ### Sistema explícito de primer orden $\frac{dT_i}{dt} = f_i(t, \mathbf{T})$
    
    $$\begin{aligned}
    \frac{dT_{+X}}{dt} &= \frac{1}{1512}\Big[ \dot{Q}_{\text{in}, +X}(t) + 0.6(T_{+Y}-T_{+X}) + 0.6(T_{-Y}-T_{+X}) + 2.8(T_{+Z}-T_{+X}) + 2.8(T_{-Z}-
  T_{+X}) - \sigma(0.75)(0.42)(T_{+X}^4 - 2.7^4) \Big] \\
    \frac{dT_{-X}}{dt} &= \frac{1}{1512}\Big[ \dot{Q}_{\text{in}, -X}(t) + 0.6(T_{+Y}-T_{-X}) + 0.6(T_{-Y}-T_{-X}) + 2.8(T_{+Z}-T_{-X}) + 2.8(T_{-Z}-
  T_{-X}) - \sigma(0.75)(0.42)(T_{-X}^4 - 2.7^4) \Big] \\
    \frac{dT_{+Y}}{dt} &= \frac{1}{3024}\Big[ \dot{Q}_{\text{in}, +Y}(t) + 0.6(T_{+X}-T_{+Y}) + 0.6(T_{-X}-T_{+Y}) + 5.6(T_{+Z}-T_{+Y}) + 5.6(T_{-Z}-
  T_{+Y}) - \sigma(0.75)(0.84)(T_{+Y}^4 - 2.7^4) \Big] \\
    \frac{dT_{-Y}}{dt} &= \frac{1}{3024}\Big[ \dot{Q}_{\text{in}, -Y}(t) + 0.6(T_{+X}-T_{-Y}) + 0.6(T_{-X}-T_{-Y}) + 5.6(T_{+Z}-T_{-Y}) + 5.6(T_{-Z}-
  T_{-Y}) - \sigma(0.75)(0.84)(T_{-Y}^4 - 2.7^4) \Big] \\
    \frac{dT_{+Z}}{dt} &= \frac{1}{14112}\Big[ \dot{Q}_{\text{in}, +Z}(t) + 2.8(T_{+X}-T_{+Z}) + 2.8(T_{-X}-T_{+Z}) + 5.6(T_{+Y}-T_{+Z}) + 5.6(T_{-Y}-
  T_{+Z}) - \sigma(0.88)(3.92)(T_{+Z}^4 - 2.7^4) \Big] \\
    \frac{dT_{-Z}}{dt} &= \frac{1}{14112}\Big[ \dot{Q}_{\text{in}, -Z}(t) + 2.8(T_{+X}-T_{-Z}) + 2.8(T_{-X}-T_{-Z}) + 5.6(T_{+Y}-T_{-Z}) + 5.6(T_{-Y}-
  T_{-Z}) - \sigma(0.85)(3.92)(T_{-Z}^4 - 2.7^4) \Big]
    \end{aligned}$$
    
    Donde $\dot{Q}_{\text{in}, i}(t) = \dot{Q}_{\text{sol}, i}(t) + \dot{Q}_{\text{alb}, i}(t) + \dot{Q}_{\text{IR}, i} + \dot{Q}_{\text{int}, i}$.

## IC/BC

- **Condición Inicial ($t = 0$):**
      $$\mathbf{T}(0) = [273.15, 273.15, 273.15, 273.15, 273.15, 273.15]^T \quad [K] \quad (0^\circ\text{C})$$
      *(El efecto de esta C.I. sintética se extingue tras el transitorio inicial de las primeras 1-2 órbitas).*
- **Condiciones de Contorno:**
      - Radiativa exterior: Intercambio con el sumidero cósmico infinito fijado a $T_{\text{esp}} = 2.7\text{ K}$.
      - Radiativa planetaria: Flujos entrantes modulados por factores de vista geométricos ($F_{\oplus, i}$) y albedo terrestre dependiente de la posición respecto al terminador solar ($\mu_{\text{sol}}(t)$).
      - Interna: Cavidad interior sellada modelada como adiabática respecto al intercambio radiativo cavitario.
    

## Supuestos y dominio de validez

- **Supuestos:**
      1. Modelo de parámetros concentrados (Biot $\ll 1$ debido a la delgadez y alta conductividad del aluminio): cada cara se modela isotérmica.
      2. Superficies grises y difusas: propiedades ópticas independientes de la longitud de onda dentro de sus bandas e independientes del ángulo de incidencia.
      3. Actitud LVLH rígida estabilizada nadir.
      4. Resistencia térmica de contacto constante por arista ($g_{\text{lin}} = 2.0\text{ W/(K}\cdot\text{m)}$).
- **Dominio de validez física:**
      - Temperatura absoluta acotada estrictamente en el dominio físico: $T_i(t) \in (2.7\text{ K}, 450\text{ K})$.
      - Órbita circular no perturbada a $h \approx 377\text{ km}$ sin efectos aerotérmicos apreciables.

## Comprobaciones realizadas

### Check 1: Consistencia dimensional
Se verifican las unidades de cada sumando de la ecuación diferencial:
- Acumulación: $[C_i \cdot \frac{dT_i}{dt}] = [J/K] \cdot [K/s] = [J/s] = [W]$.
- Flujos externos: $[\alpha_i A_i S] = [1] \cdot [m^2] \cdot [W/m^2] = [W]$.
- Radiación infrarroja: $[\varepsilon_i A_i q_{IR}] = [1] \cdot [m^2] \cdot [W/m^2] = [W]$.
- Conducción inter-panel: $[G_{ij}(T_j - T_i)] = [W/K] \cdot [K] = [W]$.
- Radiación al espacio: $[\sigma \varepsilon_i A_i (T_i^4 - T_{\text{esp}}^4)] = [\frac{W}{m^2 K^4}] \cdot [1] \cdot [m^2] \cdot [K^4] = [W]$.
- **Resultado:** Homogeneidad dimensional exacta en Watts $[W] = [kg\cdot m^2\cdot s^{-3}]$ para todas las ecuaciones. **PASA**.
    
### Check 2: Signos físicos y disipación (Segundo Principio)
- **Radiación:** Para cualquier temperatura operativa espacial $T_i > 2.7\text{ K}$, la diferencia $(T_i^4 - T_{\text{esp}}^4)$ es estrictamente positiva. El signo negativo que le antecede en el balance asegura que la radiación al espacio es puramente **disipativa** (enfría al nodo).
- **Conducción:** Si $T_j > T_i$, el término $G_{ij}(T_j - T_i) > 0$ aporta calor al nodo $i$ más frío, extrayéndolo simultáneamente del nodo $j$ más caliente (dado que $G_{ji}(T_i - T_j) = -G_{ij}(T_j - T_i)$). El flujo es espontáneo hacia menores temperaturas, respetando el enunciado de Clausius. **PASA**.
    
### Check 3: Equilibrio térmico asintótico en eclipse permanente
Si se anulan todas las entradas de calor (eclipse continuo sin Tierra ni generación: $\dot{Q}_{\text{in}, i} = 0$):
Sumando las 6 ecuaciones diferenciales, los términos conductivos internos se cancelan mutuamente por antisimetría ($\sum_i \sum_j G_{ij}(T_j - T_i) = 0$), quedando el balance global:
$$\sum_{i=1}^6 C_i \frac{dT_i}{dt} = -\sigma \sum_{i=1}^6 \varepsilon_i A_i \left(T_i^4 - T_{\text{esp}}^4\right)$$
Dado que $\varepsilon_i A_i > 0$, la derivada de la energía interna global es estrictamente negativa si $T_i > T_{\text{esp}}$. El único estado estacionario ($\frac{dT}{dt} = 0$) satisface:
$$T_i^* = T_{\text{esp}} = 2.7\text{ K} \quad \forall i$$
El sistema decae monótonamente hacia el fondo cósmico. **PASA**.
    
 ### Check 4: Casos límite estructurales
- **Límite de acoplamiento perfecto ($G_{ij} \to \infty$):** Las diferencias $(T_j - T_i) \to 0$, forzando que todas las caras adopten una temperatura única común $T(t)$ (cuerpo isotermo). Sumando las 6 EDOs:
$$\left(\sum_{i=1}^6 C_i\right) \frac{dT}{dt} = \sum_{i=1}^6 \dot{Q}_{\text{in}, i}(t) - \sigma \left(\sum_{i=1}^6 \varepsilon_i A_i\right) \left(T^4 - T_{\text{esp}}^4\right)$$
El sistema colapsa exactamente al modelo clásico de 1 nodo equivalente. **PASA**.
- **Límite adiabático ($G_{ij} \to 0$):** Los paneles se desacoplan térmicamente, reduciéndose a 6 ecuaciones diferenciales ordinarias independientes de radiación pura. **PASA**.
    
### Check 5: Positividad estricta de la temperatura absoluta
Si hipotéticamente una cara tendiera a $T_i \to 0\text{ K}$, el término de radiación al espacio profundo pasaría a ser:
$$-\sigma \varepsilon_i A_i (0^4 - 2.7^4) = +\sigma \varepsilon_i A_i (2.7)^4 > 0$$
La radiación del fondo cósmico suministraría calor al satélite, forzando $\frac{dT_i}{dt} > 0$. Esto imposibilita que la temperatura alcance el cero absoluto o se vuelva negativa. Por tanto, $T_i(t) \ge T_{\text{esp}} > 0\text{ K}$ para todo $t \ge 0$. **PASA**.

## Vacíos e incertidumbres

1. **Conductancia de juntas ($g_{\text{lin}}$):** El valor de $2.0\text{ W/(K}\cdot\text{m)}$ es un supuesto empírico representativo pero no calibrado experimentalmente con el satélite real.
2. **Masa nodal:** Se estimó en base a una densidad areal uniforme de $4.0\text{ kg/m}^2$, omitiendo la distribución heterogénea de masas de la batería y la carga útil.
3. **Radiación cavitaria interna:** Se supuso nula; en satélites reales puede existir transferencia radiativa entre caras internas opuestas si no hay mantas aislantes interiores.
4. **Ausencia de telemetría de vuelo:** No se dispone de datos de termistores reales para contrastar el modelo analítico.

## Recomendación para revisión humana

Se recomienda a la estudiante investigadora:
1. **Aceptar** la estructura matemática del sistema acoplado de 6 EDOs para su consolidación en `Mathematical_Model_v1.md`.
2. Conservar explícitamente en el modelo final la distinción entre los datos orbitales (`MEDIDO`/`BIBLIOGRAFICO`) y los supuestos constructivos (`SUPUESTO`).
3. Someter a consideración en `Gate_1.md` la opción `APROBAR_CON_ALCANCE_LIMITADO`, reconociendo que el modelo es analíticamente riguroso pero carece de calibración empírica clasificada de SpaceX.
# Paper v0.1

## Título provisional

Formulación analítica y verificación de un modelo nodal acoplado para el balance térmico transitorio de un satélite Starlink en órbita baja terrestre (LEO)

## Problem Statement

Los vehículos espaciales en órbita baja terrestre (LEO) se encuentran sometidos a un entorno radiativo extremo caracterizado por ciclos periódicos de insolación y eclipse. A lo largo de cada órbita, el satélite experimenta forzamientos externos alternados (flujo solar directo, albedo y emisión infrarroja terrestre) combinados con disipación de calor interna de su aviónica y pérdidas radiativas hacia el sumidero frío del espacio profundo a 2.7 K. La determinación precisa de la distribución térmica superficial es esencial para garantizar la supervivencia de los componentes electrónicos y baterías.
El objetivo de esta investigación es formular analíticamente y comprobar de forma teórica un Problema de Valor Inicial (PVI) continuo de 6 nodos acoplados que describa la evolución temporal de las temperaturas $T_i(t)$ en las caras del satélite STARLINK-1008 ($h \approx 377\text{ km}$, $P =
  92.09\text{ min}$, $i = 53.15^\circ$). El alcance de este trabajo se circunscribe rigurosamente a la derivación de los balances de potencia y a sus
  verificaciones analíticas, excluyendo deliberadamente la implementación computacional en código y la simulación numérica.
    

## Mathematical Model

El satélite se modela mediante una formulación de parámetros concentrados conformada por un vector de 6 estados de temperatura superficial
  $\mathbf{T}(t) = [T_{+X}, T_{-X}, T_{+Y}, T_{-Y}, T_{+Z}, T_{-Z}]^T \in \mathbb{R}^6$ expresados en Kelvin $[K]$, con actitud estabilizada en el marco local LVLH (cara $-Z$ apuntando a nadir y $+X$ a proa).
    
Para cada cara $i$, la conservación de la energía impone el siguiente balance térmico instantáneo:
    
    $$C_i \frac{dT_i}{dt} = \dot{Q}_{\text{sol}, i}(t) + \dot{Q}_{\text{alb}, i}(t) + \dot{Q}_{\text{IR}, i} + \dot{Q}_{\text{int}, i} + \sum_{j \in \text{ady}(i)} G_{ij} \left(T_j(t) - T_i(t)\right) - \sigma \varepsilon_i A_i \left(T_i^4(t) - T_{\text{esp}}^4\right)$$
    
- **Parámetros estructurales:** Paneles de aleación de aluminio ($c_p = 900\text{ J/(kg}\cdot\text{K)}$, densidad superficial $\sigma_m = 4.0\text{ kg/m}^2$) con geometrías que determinan capacitancias térmicas de $C_{\pm X} = 1512\text{ J/K}$, $C_{\pm Y} = 3024\text{ J/K}$ y $C_{\pm Z} = 14112\text{ J/K}$.
- **Acoplamiento conductivo:** Conducción 1D entre paneles adyacentes modelada mediante conductancia lineal de aristas $g_{\text{lin}} = 2.0\text{
  W/(K}\cdot\text{m)}$ ($G_{XY} = 0.6\text{ W/K}$, $G_{XZ} = 2.8\text{ W/K}$, $G_{YZ} = 5.6\text{ W/K}$).
- **Entorno radiativo:** Constante solar $S_0 = 1361\text{ W/m}^2$, albedo terrestre $a = 0.30$, emisión terrestre $q_{IR,\oplus} = 237\text{W/m}^2$ y temperatura de fondo cósmico $T_{\text{esp}} = 2.7\text{ K}$, modulados por factores de forma hacia la Tierra y una función de eclipse $\text{ilum}(t)$.
- **Disipación interna:** $60\text{ W}$ fijos en la cara nadir (aviónica) y $40\text{ W}$ en la cara proa (comunicaciones).
- **Condición inicial:** $\mathbf{T}(0) = [273.15, \dots, 273.15]^T\text{ K}$ ($0^\circ\text{C}$).

## Verification Strategy

La consistencia y robustez del PVI candidato se demostró analíticamente mediante 5 comprobaciones teóricas obligatorias, sin recurrir a resultados simulados ficticios:
1. **Homogeneidad dimensional:** Cada término de acumulación, radiación y conducción posee unidades estrictas de potencia en Watts $[W] = [J/s]$.
2. **Signos físicos y Segundo Principio:** La emisión neta al espacio es estrictamente disipativa ($\le 0$ en acumulación para $T_i > 2.7\text{K}$), y la conducción inter-nodo transfiere calor espontáneamente desde caras más calientes hacia más frías.
3. **Equilibrio térmico asintótico:** En sombra prolongada y sin disipación interna ($Q_{\text{in}} = 0$), el sistema decae de forma monótona hacia el reposo térmico con el fondo cósmico ($\lim_{t \to \infty} T_i(t) = 2.7\text{ K}$).
4. **Casos límite estructurales:** En el límite de conductividad infinita ($G_{ij} \to \infty$), el sistema acoplado colapsa formalmente al balance de un único cuerpo isotermo equivalente; en el límite adiabático ($G_{ij} = 0$), se desacopla en 6 ecuaciones diferenciales independientes.
5. **Positividad estricta:** Se demostró analíticamente que $T_i(t) \ge 2.7\text{ K} > 0\text{ K}$ para todo $t \ge 0$, impidiendo temperaturas absolutas negativas.

## Limitations and Open Information

El modelo se consolidó bajo la figura de **aprobación con alcance limitado**:
- **Falta de telemetría y planos:** Al no contar con planos de ingeniería confidenciales de SpaceX ni telemetría en tiempo real de termistores de vuelo, las dimensiones, densidades superficiales y conductancias de contacto constituyen supuestos de ingeniería razonables de la literatura pero no están empíricamente calibrados.
- **Simplificaciones físicas:** Se asume isotermicidad por panel (despreciando gradientes intra-panel) y se prescinde del intercambio radiativo dentro de la cavidad interna del satélite y de la orientación activa independiente del panel solar (SADA).
- **Ausencia de datos numéricos:** No se presentan curvas temporales ni valores numéricos de temperaturas extremas en esta etapa, respetando el principio de no publicar resultados simulados no obtenidos.

## Próximas secciones

En la siguiente etapa de la investigación (Laboratorio #2), este PVI continuo constituirá el banco de pruebas analítico para:
1. Discretizar el dominio temporal e implementar algoritmos de integración numérica (comparación de esquemas explícitos tipo Runge-Kutta vs. esquemas implícitos apropiados para la rigidez inducida por el término no lineal $T^4$).
2. Evaluar el paso de integración $\Delta t$, convergencia y estabilidad numérica.
3. Determinar las temperaturas extremas de régimen cíclico permanente ($T_{\text{mín}}$, $T_{\text{máx}}$) a lo largo de las órbitas simuladas.

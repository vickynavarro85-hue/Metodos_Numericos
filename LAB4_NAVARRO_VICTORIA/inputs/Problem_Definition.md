# Problem Definition

## Pregunta científica

¿Cómo formular y estructurar un Problema de Valor Inicial (PVI) nodal acoplado capaz de predecir la evolución temporal de la temperatura $T_i(t)$ en las 6 superficies de un satélite en órbita baja terrestre (LEO) bajo forzamiento radiativo periódico (ciclos Sol-eclipse), disipación interna y conducción estructural, y cómo se caracterizan analíticamente sus condiciones de balance para determinar amplitudes térmicas y extremos en régimen cíclico permanente?

## Salidas observables
1. **Evolución temporal continua de temperatura:** Vector de funciones temporales de temperatura de cada una de las 6 caras del satélite,
$\mathbf{T}(t) = [T_{+X}(t), T_{-X}(t), T_{+Y}(t), T_{-Y}(t), T_{+Z}(t), T_{-Z}(t)]^T$, formuladas en Kelvin $[K]$ para el sistema diferencial y expresables en grados Celsius $[^\circ\text{C}]$ ($T[^\circ\text{C}] = T[K] - 273.15$).
2. **Variables de caracterización en régimen permanente:** Definición formal de las métricas térmicas que el modelo predice a lo largo del ciclo orbital (a evaluar sin inventar valores numéricos previos a la simulación):
       - Temperatura mínima orbital por cara: $T_{\text{mín}, i} = \min_{t} T_i(t)\ [^\circ\text{C}]$.
       - Temperatura máxima orbital por cara: $T_{\text{máx}, i} = \max_{t} T_i(t)\ [^\circ\text{C}]$.
       - Amplitud térmica cíclica: $\Delta T_i = T_{\text{máx}, i} - T_{\text{mín}, i}\ [^\circ\text{C}]$.
       - Temperatura media orbital: $\bar{T}_i = \frac{1}{P} \int_{t}^{t+P} T_i(\tau)\, d\tau\ [^\circ\text{C}]$.   
3. **Balances instantáneos de potencia:** Flujos de calor desglosados en vatios $[W]$ que componen el balance neto de cada nodo $i$:
       - Potencia solar directa absorbida: $\dot{Q}_{\text{sol}, i}(t)\ [W]$.
       - Potencia por albedo terrestre absorbida: $\dot{Q}_{\text{alb}, i}(t)\ [W]$.
       - Potencia infrarroja terrestre absorbida: $\dot{Q}_{\text{IR}, i}\ [W]$.
       - Disipación interna de aviónica y comunicaciones: $\dot{Q}_{\text{int}, i}\ [W]$.
       - Conducción neta por aristas compartidas: $\dot{Q}_{\text{cond}, i}(t) = \sum_{j \in \text{ady}(i)} G_{ij} (T_j(t) - T_i(t))\ [W]$.
       - Emisión radiativa neta hacia el espacio profundo: $\dot{Q}_{\text{emit}, i}(t) = \sigma \varepsilon_i A_i (T_i^4(t) - T_{\text{esp}}^4)\ [W]$.
4. **Estado de iluminación orbital:** Función geométrica de iluminación $\text{ilum}(t) \in [0, 1]$ que delimita formalmente las transiciones entre fases de insolación directa y eclipse (umbra/penumbra).

## Horizonte temporal o dominio
- **Dominio temporal continuo:** El sistema de ecuaciones diferenciales se formula sobre el intervalo temporal continuo 
$t \in [0, t_f]$, donde:
$$t_f = N_{\text{órbitas}} \times P = 5 \times 5525.4\text{ s} \approx 27627\text{ s} \approx 7.67\text{ h}$$
- **Período orbital característico:** $P = 92.09\text{ min} \approx 5525.4\text{ s}$, determinado por los elementos orbitales de STARLINK-1008 a altitud media de $377\text{ km}$.
- **Escalas temporales del fenómeno físico:**
      - *Ciclo periódico forzado (Sol-sombra):* Período orbital $P \approx 92.09\text{ min}$, con aproximadamente $34.5\text{ min}$ de eclipse (37.4% del período) y $57.6\text{ min}$ de insolación directa por órbita.
      - *Transitorio térmico:* Amortiguamiento de la condición inicial supuesta $\mathbf{T}(0)$ durante las primeras 1 a 2 órbitas debido a la inercia térmica ($C_i$).
- **Ventana teórica de régimen cíclico permanente:** Intervalo correspondiente a las últimas 2 órbitas completas ($t \in [3P, 5P]$, es decir entre $4.6\text{ h}$ y $7.67\text{ h}$), donde el balance energético orbital alcanza periodicidad cíclica estacionaria.
- **Discretización temporal:** La elección de pasos temporales de integración ($\Delta t$), grillas de muestreo y algoritmos de discretización queda formalmente fuera del alcance del presente modelo analítico continuo y se posterga a la etapa de simulación numérica.

## Sistema físico y límites
• Sistema físico: Cuerpo principal de un satélite Starlink v1.x (STARLINK-1008) orbitando a 377 km de altitud media con inclinación de 53.15^∘.
• Límites espaciales (volumen de control): La envolvente externa cerrada de 6 paneles planos que conforman la caja rectangular (2.8 m × 1.4 m × 0.3 m).
• Frontera exterior: Vacío del espacio profundo (temperatura de fondo T_{esp} = 2.7 K), sometido al flujo solar directo, albedo terrestre e IR terrestre.
• Frontera interior: Cavidad interna sellada donde la aviónica y los módulos de comunicación disipan potencia térmica directamente sobre los paneles estructurales.

## Estados y unidades
• Variables de estado: Vector de temperaturas superficiales de los 6 nodos concentrados del satélite:

           ⎡ T  (t) ⎤
           ⎢  +X    ⎥
           ⎢ T  (t) ⎥
           ⎢  -X    ⎥
           ⎢ T  (t) ⎥
           ⎢  +Y    ⎥
    𝐓(t) = ⎢ T  (t) ⎥
           ⎢  -Y    ⎥
           ⎢ T  (t) ⎥
           ⎢  +Z    ⎥
           ⎢ T  (t) ⎥
           ⎣  -Z    ⎦

  • Unidades del sistema de EDOs: Kelvin [K] (requerido por la formulación no lineal de Stefan-Boltzmann T⁴).
  • Unidades de reporte: Grados Celsius $[^\circ\text{C}]$ ($T[^\circ\text{C}] = T[\text{K}] - 273.15$).

## Entradas y unidades
Todas son funciones del tiempo obtenidas a partir de la propagación orbital SGP4 y las efemérides:

  1. Vector unitario al Sol en ejes cuerpo: ŝ_{cuerpo}(t) = [ŝₓ, ŝ_y, ŝ_z]ᵀ [adimensional].
  2. Estado de insolación/eclipse: ilum(t) ∈ [0, 1] [adimensional] (calculado mediante geometría cónica de umbra y penumbra).
  3. Coseno del ángulo cenital solar sub-satelital: μ_{sol}(t) = max(0, ŝ_{ECI} · r̂_{ECI}) [adimensional] (controla el apagado del albedo en la cara nocturna de la Tierra).
  4. Constante solar instantánea: S(t) = S₀ · (1 AU/(d_⊙(t)))² [W/m²] (corregida por la distancia real Tierra-Sol).
  5. Flujo infrarrojo terrestre emitido: q_{IR,⊕} = 237.0 [W/m²].
  6. Disipación interna fija: Q̇_{int} = [40, 0, 0, 0, 0, 60]ᵀ [W].

## Parámetros y procedencia
 Parámetro                     |   Símbolo    |                Valor                 |     Unidades      | Procedencia / Fuente
  -------------------------------|--------------|--------------------------------------|-------------------|----------------------------------------------------------
   Dimensiones de la caja        | Lₓ, L_y, L_z |           2.8,  1.4,  0.3            |         m         | Supuesto geométrico estándar Starlink v1.x
   Áreas de las caras            |      Aᵢ      |  ±X : 0.42,  ±Y : 0.84,  ±Z : 3.92   |        m²         | Calculadas a partir de las dimensiones
   Masa areal equivalente        |      σₘ      |                 4.0                  |       kg/m²       | Estimación de panel sándwich de aluminio aeroespacial
   Calor específico              |      cₚ      |                900.0                 |    J/(kg · K)     | Aleación de aluminio estructural (Al 6061-T6)
   Conductancia lineal           |   g_{lin}    |                 2.0                  |     W/(K · m)     | Resistencia térmica empírica de juntas atornilladas
   Absortividad solar (α)        |      α       | [0.45, 0.45, 0.45, 0.45, 0.20, 0.92] |       Adim.       | Manuales de control térmico (MLI / pintura blanca /
                                 |              |                                      |                   | celdas)
   Emisividad IR (ε)             |      ε       | [0.75, 0.75, 0.75, 0.75, 0.88, 0.85] |       Adim.       | Manuales de control térmico espacial
   Elementos orbitales           |  n, i, e, a  | 15.637 rev/d, 53.15^∘, 0.00026, 6755 |      Varios       | Catálogo CelesTrak NORAD GP (satélite 44714)
                                 |              |                  km                  |                   |
   Constante de Stefan-Boltzmann |      σ       |           5.670374 × 10⁻⁸            | $\text{W/(m}^2\cd | Constante física fundamental
                                 |              |                                      |  ot\text{K}^4)$   |
   Factores de vista a Tierra    |   F_{⊕,i}    |   Nadir: 0.892, Laterales: 0.312,    |       Adim.       | Geometría placa plana a 377 km de altitud
                                 |              |             Cenit: 0.03              |                   |

## Condiciones iniciales y de borde
• Condición inicial (C.I.): Temperatura isotérmica supuesta en t = 0:

                                                                  ⎛  ∘ ⎞
    𝐓(0) = [273.15, 273.15, 273.15, 273.15, 273.15, 273.15]ᵀ [K]  ⎝0  C⎠

  (El efecto de esta C.I. se disipa tras las primeras 1–2 órbitas transitorias).

• Condiciones de borde:
    • Radiativa al infinito: Intercambio con el fondo cósmico a temperatura fija T_{esp} = 2.7 K.
    • Orbitales: Posición y velocidad inicial en t = 0 fijadas por la época del elemento EPOCH = 2026-09-06T18:43:29Z propagadas vía SGP4.

## Supuestos
1. Nodos concentrados (Lumped Parameters): Cada cara se asume isotérmica (gradiente térmico espacial despreciable a lo largo de cada panel).
2. Actitud fija nadir (marco LVLH): La cara -Z apunta permanentemente al centro terrestre y +X a lo largo del vector velocidad; no se modela el seguimiento solar activo e independiente del panel.
3. Superficies difusas y grises: Propiedades ópticas (α, ε) independientes del ángulo de incidencia y de la longitud de onda dentro de sus respectivas bandas (solar e infrarroja).
4. Entorno terrestre esférico medio: Albedo (0.30) e IR terrestre (237 W/m²) uniformes globalmente, sin considerar nubes locales ni variaciones estacionales.
5. Conducción 1D de contacto: La transferencia conductiva ocurre exclusivamente a través de las aristas que unen caras adyacentes; no hay radiación dentro de la cavidad interna entre caras opuestas.

## Información faltante
1. Planos mecánicos y masa real de SpaceX: Dimensiones, masa total y espesores de piel exactos de Starlink (datos de diseño confidenciales).
2. Cinemática del panel solar: Mecanismo de orientación solar independiente (SADA) que rota respecto al chasis.
3. Telemetría de vuelo: Registros térmicos reales de termistores a bordo para validación cuantitativa directa.
4. Ciclo de trabajo real de la aviónica: Disipación de calor variable en función del tráfico de datos y transmisiones satelitales.
5. Degradación de recubrimientos: Variación de α y ε por radiación UV y oxígeno atómico a lo largo del tiempo en órbita (Beginning of Life vs. End of Life).

## Criterios de aceptación
1. **Completitud y determinación matemática del PVI:** El modelo debe conformar un sistema cerrado y analíticamente bien planteado de 6 Ecuaciones Diferenciales Ordinarias (EDOs) no lineales de primer orden acopladas, donde cada función de entrada, parámetro físico, condición inicial y de contorno esté explícitamente formulada sin ambigüedades ni variables indeterminadas.
2. **Homogeneidad dimensional estricta:** Cada uno de los términos del balance térmico (acumulación térmica, radiación solar directa, albedo, infrarrojo terrestre, disipación de aviónica, conducción inter-panel y emisión al espacio) debe verificar consistencia dimensional exacta en vatios $[W] = [J/s] = [kg \cdot m^2 \cdot s^{-3}]$.
3. **Consistencia termodinámica y signos físicos:**
    - *Disipatividad y segundo principio:* La emisión radiativa neta hacia el espacio debe resultar estrictamente disipativa ($\le 0$ en el balance de acumulación) para $T_i > T_{\text{esp}}$, y el flujo conductivo inter-panel debe transferir calor espontáneamente desde nodos más calientes hacia nodos más fríos.
    - *Positividad estricta de la temperatura:* La estructura de las ecuaciones debe garantizar analíticamente que $T_i(t) > 0\text{ K}$ para todo $t \ge 0$, impidiendo temperaturas absolutas negativas o enfriamientos por debajo del fondo cósmico ($T_{\text{esp}} = 2.7\text{ K}$) sin refrigeración activa.
4. **Conservación de energía en régimen periódico:** En régimen cíclico permanente, la integral temporal del balance térmico neto global del satélite a lo largo de un período orbital debe cerrarse teóricamente en cero:
       $$\oint_{\text{órbita}} \sum_{i} \dot{Q}_{\text{neto}, i}(t)\, dt = 0$$
5. **Comportamiento analítico en casos límite:**
    - En condición de sombra permanente sin generación interna ($Q_{\text{in}} = 0$), las temperaturas deben decaer asintóticamente hacia el equilibrio radiativo con el espacio: $\lim_{t \to \infty} T_i(t) = T_{\text{esp}} = 2.7\text{ K}$.
    - En el límite de conductividad infinita ($G_{ij} \to \infty$), el sistema acoplado de 6 ecuaciones debe colapsar matemáticamente al balance global de un único nodo isotermo equivalente.

## Fuera de alcance
1. Modelado por Elementos Finitos (FEM) o mallas térmicas de alta densidad (gradientes de temperatura intra-panel).
2. Intercambio radiativo cavitario interno (matriz de factores de forma de radiación superficie a superficie en el interior de la caja).
3. Dinámica de actitud acoplada (AOCS) y maniobras de control orbital mediante propulsores iónicos.
4. Modelado del sistema de generación y almacenamiento de energía (eficiencia de celdas solares fotovoltaicas y carga/descarga de baterías).
5. Aerotermodinámica de reentrada y frenado atmosférico apreciable (se considera órbita circular a altitud constante).

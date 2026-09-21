# Problem Definition Draft

## Fenómeno físico
Transferencia de calor en régimen transitorio (o balance térmico dinámico no estacionario) de un cuerpo cerrado (satélite) en el ambiente espacial de vacío.

1. Radiación térmica externa: Ganancia de calor por radiación solar directa, radiación solar reflejada por la Tierra o albedo y radiación infrarroja de onda larga emitida por la Tierra.
2. Generación interna: Calor disipado por los componentes electrónicos y de comunicaciones de la carga útil.
3. Conducción interna: Transferencia conductiva entre caras adyacentes a través de la estructura de aluminio y las juntas mecánicas.
4. Radiación al espacio profundo: Pérdida de calor por emisión superficial hacia el fondo cósmico a 2.7 K siguiendo la ley de Stefan-Boltzmann.

## Pregunta preliminar

 ¿Cuál es la evolución temporal de la temperatura Tᵢ(t) en cada una de las 6 caras de un satélite Starlink (ej STARLINK-1008, NORAD 44714) en órbita baja (LEO) a lo largo de una órbita, distinguiendo los tramos de insolación directa y eclipse?

## Datos disponibles

### 1. Parámetros orbitales reales del satélite (Catálogo CelesTrak / NORAD GP, OMM)

  • Satélite de referencia: STARLINK-1008 (NORAD_CAT_ID: 44714).
  • Semieje mayor (a): 6755.0 km (altitud media aproximada h ≈ 377 km).
  • Movimiento medio (n): 15.63737 rev/día (período orbital P = 92.09 min ≈ 5525 s).
  • Inclinación orbital (i): 53.147^∘.
  • Excentricidad (e): 0.00026 (órbita prácticamente circular).
  • Fracción en eclipse: 37.4% del período (≈ 34.5 min de sombra por órbita; ángulo beta medio β ≈ -31.6^∘).
  • Propagador orbital: Modelo analítico/numérico SGP4 acoplado con efemérides planetarias JPL DE421 (posiciones precisas Tierra-Sol).

  ### 2. Parámetros del entorno radiativo espacial

  • Constante solar media (S₀): 1361 W/m² (corregida en el modelo según la distancia real Tierra-Sol instantánea: S(t) = S₀(1 AU/d_⊙(t))²).
  • Emisión infrarroja terrestre (q_{IR,⊕}): 237 W/m² (flujo térmico global medio de onda larga).
  • Albedo terrestre (a): 0.30 (fracción media de radiación solar reflejada por la atmósfera y superficie terrestre).
  • Temperatura del fondo espacial (T_{esp}): 2.7 K (temperatura del fondo cósmico de microondas).
  • Constante de Stefan-Boltzmann (σ): $5.670374 \times 10^{-8}\text{ W/(m}^2\text{K}^4)$.
  ──────

## Información faltante

Dimensiones de la caja rectangular, material, masa,
Vector de temperaturas iniciales T_{i}(0) en cada cara al tiempo t=0.


Al no disponer de la telemetría ni los planos de ingeniería clasificados de SpaceX, se adoptan los siguientes supuestos de diseño:

  1. Geometría y dimensiones de la caja:
      • Se asume un cuerpo paralelepípedo tipo "panel plano" de Lₓ = 2.8 m (eje velocidad / ram-wake), L_y = 1.4 m (eje normal a la órbita) y L_z = 0.3 m (eje nadir-cenit).
      • Áreas resultantes: A_{±X} = 0.42 m², A_{±Y} = 0.84 m², A_{±Z} = 3.92 m².
  2. Propiedades de los materiales y masa térmica:
      • Material estructural: Aleación de aluminio (cₚ = 900 J/(kg K)).
      • Densidad superficial equivalente: 4.0 kg/m² (representa la piel de aluminio, panal de abeja y componentes estructurales).
      • Capacitancia térmica de los nodos: Cᵢ = mᵢ · cₚ (1512 J/K para ±X, 3024 J/K para ±Y, 14112 J/K para ±Z).
  3. Propiedades termo-ópticas superficiales:
      • Caras laterales (±X, ±Y): Aisladas con mantas térmicas MLI (α = 0.45, ε = 0.75).
      • Cara cenit (+Z): Radiador hacia el espacio profundo con pintura blanca (α = 0.20, ε = 0.88).
      • Cara nadir (-Z): Apuntando a Tierra, tratada como panel solar/antenas (α = 0.92, ε = 0.85).
  4. Acoplamiento conductivo interno:
      • Conductancia lineal por arista compartida: 2.0 W/(K m), modelando la resistencia térmica de las uniones atornilladas entre paneles adyacentes.
  5. Disipación interna de equipos:
      • 60 W en la cara nadir (-Z, electrónica de aviónica).
      • 40 W en la cara ram (+X, antena/transmisor de comunicaciones).
      • 0 W en las demás caras.
  6. Actitud (orientación espacial):
      • Apuntador nadir estabilizado en ejes locales LVLH (la cara -Z apunta permanentemente al centro de la Tierra, +X en el sentido de avance).
  7. Condición inicial:
      • Tᵢ(0) = 273.15 K (0 ^∘C) para todas las caras. Se simulan 5 órbitas completas, descartando las primeras 1-2 órbitas como transitorio numérico hasta alcanzar el ciclo estacionario.

## Alcance inicial

Formulación y comprobación de un sistema de 6 ecuaciones diferenciales ordinarias (EDOs) no lineales de primer orden acopladas, una por cada nodo/cara i ∈ {0, …, 5}. No programar ni validar físicamente.

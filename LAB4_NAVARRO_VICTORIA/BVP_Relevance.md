# Evaluación de Pertinencia de un Problema de Valor de Contorno (BVP) en la Investigación STARLINK-1008

## Metadatos y Control de Configuración

- **Documento:** `BVP_Relevance.md`
- **Versión:** 1.0 (Dictamen Técnico de Modelado)
- **Fecha de Elaboración:** 2026-10-18
- **Rol Emisor:** Modeling Agent (IA)
- **Investigadora Principal:** Victoria Navarro (Estudiante Investigadora - Cátedra de Métodos Numéricos DING59)
- **Sujeto de Estudio:** Satélite STARLINK-1008 (NORAD ID: 44714) en Órbita Baja Terrestre (LEO)
- **Directorio de Trabajo:** [`LAB4_NAVARRO_VICTORIA/`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/)
- **Documentos de Referencia Auditados:**
  - [`inputs/Problem_Definition.md`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/inputs/Problem_Definition.md) (v1.0)
  - [`inputs/Mathematical_Model_v1.md`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/inputs/Mathematical_Model_v1.md) (v1.0)
  - [`inputs/Scientific_Critique.md`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/inputs/Scientific_Critique.md) (v1.0)
  - [`inputs/Gate_3.md`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/inputs/Gate_3.md) (v1.0)
  - [`inputs/Paper_v0.3.md`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/inputs/Paper_v0.3.md) (v0.3)
- **Dictamen de Pertinencia:** **`NO PERTINENTE AL ALCANCE`** *(frente al modelo orbital global vigente de 6 caras)*
- **Estado Metodológico de Extensión:** **`REQUIERE INFORMACIÓN`** y **`NEEDS_MODEL_REVISION`** *(para formulación espacial intra-panel)*

---

## 1. Contextualización del Modelo Vigente y la Pregunta de Investigación

### 1.1. Pregunta Científica Aprobada
La investigación de Victoria Navarro tiene como objetivo central:
> *¿Cómo predecir y caracterizar la evolución temporal de la temperatura $T_i(t)$ en las 6 superficies externas de un satélite STARLINK-1008 bajo forzamiento radiativo periódico (Sol-albedo-eclipse), disipación interna y conducción estructural, y cómo determinar sus extremos cíclicos permanentes ($M_1, M_2, M_3$)?*

### 1.2. Estructura Matemática Actual: Problema de Valor Inicial (PVI)
El modelo físico aprobado en Gate 1, verificado en Gate 2 y experimentado en Gate 3 es estrictamente un **Problema de Valor Inicial (PVI / IVP)** en el dominio temporal $t \in [0, t_f]$:
$$C_i \frac{dT_i}{dt} = \dot{Q}_{\text{net}, i}(t, \mathbf{T}), \quad \mathbf{T}(0) = \mathbf{T}_0 \in \mathbb{R}^6, \quad i \in \{+X, -X, +Y, -Y, +Z, -Z\}$$

- **Dominio espacial:** Es un modelo de **parámetros concentrados (0D espacial)**. Cada cara $i$ se modela como un nodo térmico homogéneo e isotermo.
- **Condición que fija la solución:** El vector de estados completo está determinado en un único punto del dominio: $t = 0$ ($\mathbf{T}_0 = 293.15\text{ K}$ o $273.15\text{ K}$).
- **Integración:** La solución avanza progresivamente hacia adelante en el tiempo ($t \to t_f$) mediante algoritmos de marcha temporal (`ode45`).

---

## 2. Análisis Teórico: ¿Qué Representaría un BVP en esta Investigación?

Un **Problema de Valor de Contorno (BVP / Boundary Value Problem)** requiere que las condiciones que especifican la solución se definan en **al menos dos puntos de frontera distintos** del dominio de la variable independiente.

En la investigación del satélite STARLINK-1008, un BVP podría concebirse bajo dos interpretaciones físicas completamente distintas:

```
                            ┌──────────────────────────────────────────────┐
                            │ Posibles Formulaciones de BVP en el Satélite │
                            └──────────────────────┬───────────────────────┘
                                                   │
                  ┌────────────────────────────────┴──────────────────────────────┐
                  ▼                                                               ▼
    ┌───────────────────────────┐                                   ┌───────────────────────────┐
    │  Interpretación A:        │                                   │  Interpretación B:        │
    │  BVP Espacial Continuo 1D │                                   │  BVP Temporal Periódico   │
    │  (Gradiente en Radiador)  │                                   │  (Ciclo Límite Orbital)   │
    └─────────────┬─────────────┘                                   └─────────────┬─────────────┘
                  │                                                               │
     • Variable: x ∈ [0, L]                                          • Variable: t ∈ [0, P]
     • Resuelve: T(x) en panel +Z                                    • Resuelve: T(0) = T(P)
     • Responde a: CRIT-01 (Biot)                                    • Elimina: Transitorio
     • Requiere: k, espesor e, BCs                                   • Requiere: Mismo modelo
     • Estado: NEEDS_MODEL_REVISION                                  • Estado: Mismo modelo (0D)
```

---

### Interpretación A: BVP Espacial Continuo 1D (Gradiente Térmico a lo largo de un Panel Radiador)

En lugar de tratar al panel cenit $+Z$ (área $3.92\text{ m}^2$, longitud $L_x = 2.8\text{ m}$, ancho $L_y = 1.4\text{ m}$) como un nodo concentrado isotermo, se formula la ecuación de conducción-radiación estacionaria continua a lo largo de la coordenada longitudinal $x \in [0, L_x]$:

$$\frac{d}{dx} \left( k(x) A_c \frac{dT}{dx} \right) - \varepsilon \sigma w (T^4(x) - T_{\text{esp}}^4) + q_{\text{inc}}(x) = 0, \quad x \in [0, L_x]$$

sujeta a condiciones de contorno espaciales en los extremos del chasis:
- En $x = 0$ (unión con panel de proa $+X$ donde disipa la aviónica):  
  Temperatura fija $T(0) = T_{+X}$ (Dirichlet) o flujo conductivo $-k A_c \left.\frac{dT}{dx}\right|_{0} = \dot{Q}_{\text{cond}, +X\to +Z}$ (Neumann).
- En $x = L_x$ (borde con panel de popa $-X$):  
  Condición de aislamiento adiabatico $-k A_c \left.\frac{dT}{dx}\right|_{L_x} = 0$ o intercambio con cara $-X$.

#### 1. ¿Qué se ganaría con esta formulación?
1. **Responde a la Objeción Abierta CRIT-01 ([`Scientific_Critique.md`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/inputs/Scientific_Critique.md#L45-L53)):**  
   En la crítica científica se señaló que, si bien el número de Biot transversal es minúsculo ($\text{Bi}_{\text{trans}} \sim 10^{-4}$), el Biot planar a lo largo de los $2.8\text{ m}$ del panel podría generar gradientes internos significativos. Un BVP 1D permitiría cuantificar exactamente la caída de temperatura $\Delta T(x)$ entre la raíz caliente y la punta fría.
2. **Detección de Puntos Calientes Locales (Hotspots):**  
   Permitiría evaluar si la aviónica de proa sobrecalienta la zona adyacente del panel por encima de los límites operacionales de los componentes electrónicos, dato que el promedio nodal de 6 caras oculta.
3. **Eficiencia de Aleta del Radiador:**  
   Permitiría calcular la eficiencia de aleta radiativa $\eta_{\text{rad}} = \frac{\int_0^L (T^4 - T_{\text{esp}}^4) dx}{L (T_{\text{base}}^4 - T_{\text{esp}}^4)}$, fundamental en diseño térmico espacial.

#### 2. ¿Qué nuevas hipótesis y datos requiere?
- **Cambio de Hipótesis Central:** Se debe abandonar la hipótesis de nodo concentrado (isoterma espacial) para el panel radiador, pasando a un medio continuo unidimensional con resistencia térmica distribuida.
- **Nuevos Parámetros Físicos Requeridos (Hoy ausentes en `get_params.m`):**
  1. Conductividad térmica del material del panel: $k_{\text{al}} \approx 160 - 200\text{ W/(m}\cdot\text{K)}$ (aluminio aeroespacial 6061-T6 o panel honeycomb equivalente).
  2. Espesor efectivo de la chapa o piel conductora: $e_{\text{skin}} \approx 1.5\text{ mm}$ ($0.0015\text{ m}$).
  3. Área transversal de conducción: $A_c = w \cdot e_{\text{skin}} = 1.4\text{ m} \times 0.0015\text{ m} = 2.1 \times 10^{-3}\text{ m}^2$.
  4. Distribución espacial del flujo incidente $q_{\text{inc}}(x)$ [W/m].
- **Calificación:** Esta opción **`REQUIERE INFORMACIÓN`** y demanda formalmente **`NEEDS_MODEL_REVISION`**.

---

### Interpretación B: BVP Temporal de Órbita Periódica (Condición de Ciclo Límite)

Manteniendo el sistema de 6 nodos concentrados, la búsqueda del régimen cíclico permanente en una órbita $P = 5525.23\text{ s}$ se puede formular como un **BVP temporal en dos puntos** sobre el intervalo $t \in [0, P]$:

$$\frac{d\mathbf{T}}{dt} = \mathbf{f}(t, \mathbf{T}, \boldsymbol{\theta}), \quad t \in [0, P]$$

sujeto a la **condición de contorno periódica de frontera**:
$$\mathbf{R}(\mathbf{T}(0), \mathbf{T}(P)) = \mathbf{T}(P) - \mathbf{T}(0) = \mathbf{0}$$

#### 1. ¿Qué se ganaría con esta formulación?
1. **Cálculo Directo del Régimen Permanente en 1 Sola Órbita:**  
   En los Laboratorios #2 y #3 se integraron 5 órbitas completas ($27627\text{ s}$), descartando las primeras 3 órbitas para amortiguar el transitorio inicial. Un BVP periódico resuelve directamente la temperatura de régimen permanente $\mathbf{T}^*(t)$ sin simular transitorios.
2. **Cierre de Ciclo Exacto:**  
   Elimina la deriva transitoria residual ($< 4\text{ mK}$ reportada en `Gate_3.md`), asegurando $\|\mathbf{T}(P) - \mathbf{T}(0)\| < \text{tol}$.
3. **Aplicabilidad de Algoritmos de Contorno:**  
   Se resuelve mediante métodos de disparo (shooting method acoplado con Newton-Raphson) o colocación ortogonal (`bvp4c` en MATLAB).

#### 2. ¿Qué nuevas hipótesis y datos requiere?
- **No requiere nuevos datos físicos:** Emplea exactamente los mismos parámetros de [`inputs/get_params.m`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/inputs/get_params.m).
- **Hipótesis:** Supone que el sistema admite un único ciclo límite atractor periódico estable (lo cual ya fue probado empíricamente en Lab 2 y Lab 3).

---

## 3. Evaluación de Pertinencia y Dictamen Metodológico

### Dictamen Formal: **`NO PERTINENTE AL ALCANCE`** (del modelo actual)

#### Fundamento del Dictamen:
1. **Incompatibilidad Estructural del Modelo Vigente:**  
   El modelo actual del satélite STARLINK-1008 es una **red nodal 0D en el espacio**. En una red nodal discreta, la conducción entre caras ya está condensada en conductancias escalares $G_{ij}$ asociadas a aristas. **No existe una variable espacial continua $x$**, por lo que es matemáticamente imposible definir un problema de contorno en derivadas espaciales sin reformular la física del sistema.
2. **Naturaleza Causal de la Pregunta de Investigación:**  
   La pregunta científica aprobada busca determinar la evolución a partir de una condición de inserción orbital conocida ($t=0$). Imponer temperaturas en dos tiempos arbitrarios distintos ($t_0$ y $t_f$) sin ligadura periódica violaría la causalidad física del PVI.
3. **Preservación del Caso de Investigación:**  
   La cátedra utiliza como ejemplo didáctico una viga 1D sometida a condiciones de contorno espaciales ($x=0, x=L$). Reemplazar el satélite por la viga violaría la directiva innegociable de mantener el caso de estudio de Victoria Navarro.

---

## 4. Propuesta de Revisión del Modelo (`NEEDS_MODEL_REVISION`)

Si la cátedra en el **Laboratorio #4 exige implementar métodos numéricos de contorno (diferencias finitas espaciales o shooting)**, la única vía científicamente válida que preserva el caso del satélite STARLINK-1008 sin caer en la viga docente es formular un **sub-modelo 1D de conducción-radiación en el radiador cenit $+Z$**.

Para habilitar esta extensión, se declara formalmente:

> [!WARNING]
> **Estado:** **`NEEDS_MODEL_REVISION`**  
> Para resolver un BVP espacial en STARLINK-1008 se debe modificar la hipótesis simplificadora H-02 de [`inputs/Mathematical_Model_v1.md`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/inputs/Mathematical_Model_v1.md):
> - **Hipótesis anterior:** Panel $+Z$ espacialmente isotermo ($\nabla T \approx 0$).
> - **Nueva hipótesis propuesta:** Panel $+Z$ como aleta radiativa 1D continua de longitud $L_x = 2.8\text{ m}$, acoplada térmicamente en $x=0$ a la temperatura de proa $T_{+X}$ y con intercambio radiativo no lineal $T^4(x)$ al espacio profundo.
> - **Parámetros a incorporar:** Espesor de piel $e_{\text{skin}} = 1.5\text{ mm}$, conductividad $k = 167\text{ W/(m}\cdot\text{K)}$ (Aluminio 6061-T6).

---

## 5. Propuesta de Consulta Formal al Docente

Para que Victoria Navarro consulte al docente de la cátedra con máxima solvencia técnica y sin reemplazar su caso por la viga didáctica, se redacta el siguiente texto listo para enviar:

***

**Asunto:** Consulta metodológica Lab 4 - Aplicación de Problemas de Valor de Contorno (BVP) al caso de investigación STARLINK-1008

**Estimado/a Profesor/a,**

Me pongo en contacto para coordinar el alcance metodológico del Laboratorio #4 en relación con mi proyecto de investigación (balance térmico del satélite STARLINK-1008 en órbita LEO).

Hasta el Laboratorio #3, mi investigación estuvo estructurada y formalmente aprobada como un **Problema de Valor Inicial (PVI)** temporal sobre un sistema acoplado no lineal de 6 nodos concentrados ($\mathbf{T} \in \mathbb{R}^6$), simulando 5 órbitas completas mediante integración adaptativa (`ode45`). Dado que en una red nodal 0D no existe una coordenada espacial continua:

1. **Opción 1 (BVP Espacial 1D en Sub-componente / Radiador Cenit $+Z$):**  
   Formular un problema de contorno 1D estacionario de conducción-radiación a lo largo del panel radiador cenit $+Z$ ($x \in [0, 2.8\text{ m}]$, ancho $1.4\text{ m}$):
   $$k A_c \frac{d^2 T}{dx^2} - \varepsilon \sigma w (T^4(x) - T_{\text{esp}}^4) + q_{\text{inc}}(x) = 0$$
   Para esta formulación **ya dispongo de los parámetros termofísicos y geométricos consistentes con mi modelo**:
   - Material de la envolvente: Aluminio aeroespacial 6061-T6 con conductividad bibliográfica $k = 167\text{ W/(m}\cdot\text{K)}$ y $c_p = 900\text{ J/(kg}\cdot\text{K)}$.
   - Espesor efectivo equivalente de chapa deducido de la densidad areal de mi modelo ($\sigma_m = 4.0\text{ kg/m}^2$, $\rho_{\text{al}} = 2700\text{ kg/m}^3$): $e \approx 1.5\text{ mm}$ ($A_c = 2.1 \times 10^{-3}\text{ m}^2$) o $2.0\text{ mm}$.
   - Condiciones de borde: temperatura fija en la raíz $T(0) = T_{\text{proa}}$ (contacto con la cara $+X$ donde disipa la aviónica, $T \approx 291.8\text{ K}$) y borde adiabático en popa $\left.\frac{dT}{dx}\right|_{L} = 0$.  
   *Ventaja pedagógica y científica:* Permite aplicar **diferencias finitas espaciales en grilla 1D** y responde directamente a una objeción metodológica abierta de mi Lab 3 (evaluar si el número de Biot planar genera gradientes longitudinales significativos que justifiquen o limiten la hipótesis de isotermia).

2. **Opción 2 (BVP Temporal Periódico en 6 Nodos - Ciclo Límite Orbital):**  
   Mantener intacto el sistema macroscópico de 6 EDOs nodales en el tiempo y formular la determinación del régimen permanente exacto en una sola órbita ($P = 5525.23\text{ s}$) como un BVP en dos puntos temporales:
   $$\frac{d\mathbf{T}}{dt} = \mathbf{f}(t, \mathbf{T}), \quad \mathbf{T}(P) - \mathbf{T}(0) = \mathbf{0}$$
   *Ventaja pedagógica y científica:* Permite aplicar el **método de disparo (Shooting Method)** con corrección de Newton-Raphson para obtener el ciclo límite exacto sin transitorio residual, empleando directamente los códigos de integración existentes.

**Pregunta concreta:**  
¿Prefiere la cátedra que implemente la **Opción 1** (BVP espacial 1D en el radiador con diferencias finitas) para ejercitar esquemas en grilla espacial sobre mi satélite, o la **Opción 2** (BVP temporal de ciclo límite con shooting), o existe una guía/consigna específica que deba seguir para este Laboratorio #4?

Muchas gracias.

**Victoria Navarro**  
Estudiante Investigadora - DING59

***

---

## 6. Conclusiones y Próximos Pasos

1. El documento [`BVP_Relevance.md`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/BVP_Relevance.md) queda asentado con dictamen **`NO PERTINENTE AL ALCANCE`** para el modelo nodal macroscópico vigente, y **`REQUIERE INFORMACIÓN`** con **`NEEDS_MODEL_REVISION`** para la extensión espacial 1D.
2. No se modifican hipótesis ni códigos hasta recibir la confirmación o consigna formal del docente.
3. Se actualiza la bitácora de investigación en [`RESEARCH_LOG.md`](file:///Users/victorianavarro/Documents/M%C3%A9todos%20Num%C3%A9ricos/DING59_Agentic_Research_Lab_1_Student_Starter_Pack/LAB4_NAVARRO_VICTORIA/RESEARCH_LOG.md) con la Entrada 003.

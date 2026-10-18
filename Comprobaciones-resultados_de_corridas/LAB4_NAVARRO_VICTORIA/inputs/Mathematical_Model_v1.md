# Mathematical Model v1

## Autor, fecha y versión

- **Autora:** Victoria Navarro (Estudiante investigadora)
- **Fecha:** 2026-09-13
- **Versión:** 1.0 (Consolidación humana basada en la Ejecución 001)

## Pregunta respondida

Formulación y comprobación analítica de un Problema de Valor Inicial (PVI) continuo de 6 nodos acoplados para predecir la evolución temporal de la temperatura $T_i(t)$ en las superficies del satélite STARLINK-1008 en órbita LEO ($h \approx 377\text{ km}$, $i = 53.15^\circ$) bajo ciclos orbitales Sol-eclipse, disipación de aviónica y conducción estructural.

## Variables de estado

 Vector continuo de temperaturas absolutas de los 6 paneles en marco local LVLH en Kelvin $[K]$:
    
$$\mathbf{T}(t) = \begin{bmatrix} T_{+X}(t) & T_{-X}(t) & T_{+Y}(t) & T_{-Y}(t) & T_{+Z}(t) & T_{-Z}(t) \end{bmatrix}^T \in \mathbb{R}^6$$

*(Reporte en Celsius: $T_i[^\circ\text{C}] = T_i[K] - 273.15$).*

## Entradas y parámetros con unidades

- **Capacitancias térmicas nodales ($C_i = m_i c_p$):**
      - $C_{\pm X} = 1512.0\text{ J/K}$ (caras de proa y popa, $A = 0.42\text{ m}^2$).
      - $C_{\pm Y} = 3024.0\text{ J/K}$ (caras laterales normales a la órbita, $A = 0.84\text{ m}^2$).
      - $C_{\pm Z} = 14112.0\text{ J/K}$ (caras cenit y nadir, $A = 3.92\text{ m}^2$).
- **Conductancias lineales entre aristas compartidas ($G_{ij} = g_{\text{lin}} L_{\text{arista}}$ con $g_{\text{lin}} = 2.0\text{W/(K}\cdot\text{m)}$):**
      - $G_{XY} = 0.60\text{ W/K}$ (aristas de $0.3\text{ m}$).
      - $G_{XZ} = 2.80\text{ W/K}$ (aristas de $1.4\text{ m}$).
      - $G_{YZ} = 5.60\text{ W/K}$ (aristas de $2.8\text{ m}$).
      - $G_{ij} = 0$ para caras opuestas.
- **Entorno espacial y propiedades termo-ópticas:**
      - $S(t) \approx 1361.0\text{ W/m}^2$, $q_{IR,\oplus} = 237.0\text{ W/m}^2$, albedo $a = 0.30$, $T_{\text{esp}} = 2.7\text{ K}$, $\sigma = 5.670374 \times 10^{-8}\text{ W/(m}^2\text{K}^4)$.
      - Absortividades ($\alpha$) y emisividades ($\varepsilon$): MLI en $\pm X, \pm Y$ ($\alpha = 0.45, \varepsilon = 0.75$); radiador en $+Z$ ($\alpha = 0.20, \varepsilon = 0.88$); panel nadir en $-Z$ ($\alpha = 0.92, \varepsilon = 0.85$).
      - Factores de vista a Tierra ($F_{\oplus}$): $-Z: 0.892$; laterales: $0.312$; $+Z: 0.030$.
      - Disipación interna fija: $\dot{Q}_{\text{int}, +X} = 40.0\text{ W}$, $\dot{Q}_{\text{int}, -Z} = 60.0\text{ W}$, $0\text{ W}$ en las demás.

## Ecuaciones del modelo

Sistema de 6 EDOs no lineales de primer orden acopladas basadas en conservación de energía:
    
$$C_i \frac{dT_i}{dt} = \dot{Q}_{\text{in}, i}(t) + \sum_{j \in \text{ady}(i)} G_{ij} (T_j(t) - T_i(t)) - \sigma \varepsilon_i A_i \left(T_i^4(t) - T_{\text{esp}}^4\right)$$
    
Donde la potencia entrante total para cada nodo es:
$$\dot{Q}_{\text{in}, i}(t) = \alpha_i A_i S(t) \max(0, \hat{\mathbf{s}} \cdot \hat{\mathbf{n}}_i) \text{ilum}(t) + \alpha_i A_i a S(t) \mu_{\text{sol}}(t) F_{\oplus, i} \text{ilum}(t) + \varepsilon_i A_i q_{IR,\oplus} F_{\oplus, i} + \dot{Q}_{\text{int}, i}$$

## Condiciones iniciales y de borde

- **Condición Inicial:** $\mathbf{T}(0) = [273.15, 273.15, 273.15, 273.15, 273.15, 273.15]^T\text{ K}$ ($0^\circ\text{C}$).
- **Condiciones de Borde:** Fondo cósmico frío infinito a $T_{\text{esp}} = 2.7\text{ K}$ y forzamiento orbital periódico SGP4 a $h \approx 377\text{ km}$ ($P = 5525.4\text{ s}$).
    
## Supuestos y dominio de validez

- **Supuestos consolidados:**
      1. Modelo de parámetros concentrados (Biot $\ll 1$ en la piel de aluminio).
      2. Superficies grises y difusas en bandas solar e infrarroja.
      3. Actitud rígida LVLH nadir constante sin seguimiento solar activo en el panel.
      4. Cavidad interna sellada adiabática radiativamente.
- **Dominio de validez:** Temperaturas físicamente admisibles $T_i \in (2.7\text{ K}, 450\text{ K})$ en órbita LEO circular sin efectos de arrastre atmosférico.

## Comprobaciones aceptadas

Como revisora humana, valido formalmente los 5 checks analíticos deducidos en el reporte:
1. **Homogeneidad dimensional:** Cada término tiene unidades estrictas de potencia en Watts $[W]$.
2. **Signos físicos y disipación:** Emisión radiativa disipativa ($\dot{Q}_{\text{emit}} > 0$ si $T_i > 2.7\text{ K}$) y conducción neta a favor del gradiente de temperaturas (cumplimiento del Segundo Principio de la Termodinámica).
3. **Equilibrio térmico asintótico:** En sombra permanente sin generación ($\dot{Q}_{\text{in}} = 0$), el sistema colapsa asintóticamente a $T_i^* = 2.7\text{ K}$.
4. **Casos límite:** Colapso a 1 nodo isotermo si $G_{ij} \to \infty$, y desacoplamiento en 6 radiadores independientes si $G_{ij} \to 0$.
5. **Positividad estricta:** $T_i(t) \ge 2.7\text{ K} > 0\text{ K}$ para todo $t \ge 0$.

## Información faltante

- Planos de ingeniería constructivos y masa detallada de componentes de SpaceX (confidenciales).
- Telemetría en tiempo real de termistores a bordo para validación cuantitativa.
- Curvas de degradación de recubrimientos ópticos en ambiente LEO.

## Diferencias respecto de Modeling Report

1. **Apropiación de autoría:** Este documento asume la responsabilidad técnica humana sobre las hipótesis y la formulación, a diferencia del reporte que era una propuesta de IA.
2. **Delimitación explícita del alcance:** Se ratifica que el modelo se utilizará como candidato analítico para futuras comparaciones de métodos numéricos, prohibiendo considerar este PVI como un modelo empíricamente calibrado.

## Estado de revisión

 **CONSOLIDADO Y APROBADO POR LA ESTUDIANTE**
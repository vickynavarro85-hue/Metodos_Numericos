# Modeling Handoff - Ejecución 001
    
## Estado de revisión
    
ACEPTADO por la estudiante investigadora (Victoria Navarro) para modelado analítico.
    
## Pregunta y alcance
    
- **Pregunta científica:** ¿Cómo formular y estructurar un Problema de Valor Inicial (PVI) nodal acoplado capaz de predecir la evolución temporal de la temperatura $T_i(t)$ en las 6 superficies de un satélite en órbita baja terrestre (LEO) bajo forzamiento radiativo periódico (ciclos Sol-eclipse), disipación interna y conducción estructural, y cómo se caracterizan analíticamente sus condiciones de balance para determinar amplitudes térmicas y extremos en régimen cíclico permanente?
- **Alcance:** Formulación analítica de un sistema de 6 Ecuaciones Diferenciales Ordinarias (EDOs) no lineales de primer orden para las temperaturas nodales $T_i(t)$ en Kelvin $[K]$, especificando parámetros en el SI y ejecutando comprobaciones teóricas completas.
- **Fuera de alcance:** Implementación computacional, código (Python/MATLAB), selección de resolvedores numéricos, discretización temporal ($\Delta t$) y simulación de trayectorias.
    
## Entradas autorizadas
    
 Únicamente los datos, parámetros y supuestos contenidos en `Problem_Definition.md` y las reglas de gobernanza de `AGENTS.md`. No se autoriza la incorporación de ningún parámetro nuevo.
    
## Formulación solicitada
    
Deducir y estructurar formalmente el balance de potencia térmica instantánea para cada una de las 6 caras $i \in \{+X, -X, +Y, -Y, +Z, -Z\}$:
    
    $$C_i \frac{dT_i}{dt} = \dot{Q}_{\text{sol}, i}(t) + \dot{Q}_{\text{alb}, i}(t) + \dot{Q}_{\text{IR}, i} + \dot{Q}_{\text{int}, i} + \sum_{j \in \text{ady}(i)} G_{ij} (T_j(t) - T_i(t)) - \sigma \varepsilon_i A_i \left(T_i^4(t) - T_{\text{esp}}^4\right)$$
    
Donde se debe explicitar:
1. Vector de estados continuo $\mathbf{T}(t) \in \mathbb{R}^6$ en Kelvin $[K]$.
2. Vector de capacitancias térmicas nodales $C_i = m_i c_p\ [J/K]$.
3. Matriz de conductancias inter-nodales $G_{ij} = g_{\text{lin}} \cdot L_{\text{arista}, ij}\ [W/K]$ basada en la geometría rectangular.
4. Desglose analítico de los flujos radiativos externos absorbidos en función de $\alpha_i, \varepsilon_i, A_i, F_{\oplus, i}$ y la función orbital de iluminación $\text{ilum}(t)$.
5. Condiciones iniciales $\mathbf{T}(0) = [273.15, \dots, 273.15]^T\text{ K}$ y de contorno radiativo con el espacio ($T_{\text{esp}} = 2.7\text{K}$).
    
## Comprobaciones requeridas
    
El reporte debe incluir la deducción y justificación matemática rigurosa de los siguientes 5 checks:
1. **Consistencia dimensional:** Homogeneidad dimensional en Watts $[W]$ de cada término.
2. **Signos físicos y disipación:** Emisión radiativa disipativa ($\dot{Q}_{\text{emit}} > 0$ si $T_i > T_{\text{esp}}$) y conducción neta favorable al gradiente térmico (Segundo Principio).
3. **Equilibrio térmico asintótico:** Decaimiento hacia $\lim_{t \to \infty} T_i(t) = T_{\text{esp}} = 2.7\text{ K}$ en condición de sombra permanente sin fuentes internas ($Q_{\text{in}} = 0$).
4. **Casos límite estructurales:** Colapso al balance de un nodo isotermo global cuando $G_{ij} \to \infty$, y desacoplamiento en 6 nodos independientes cuando $G_{ij} = 0$.
5. **Positividad estricta:** Demostración de que $T_i(t) > 0\text{ K}$ para todo $t \ge 0$.
    
## Restricciones
    
- **NO PROGRAMAR:** Prohibido generar scripts o funciones ejecutables.
- **NO SIMULAR:** Prohibido inventar o calcular curvas de temperatura.
- **NO SELECCIONAR SOLVER:** Prohibido recomendar algoritmos numéricos de integración.
- **NO INVENTAR:** Prohibido incorporar parámetros no provistos.
- **NO AUTO-APROBAR:** El reporte se entrega en carácter de propuesta técnica.
    
## Entregable esperado
    
- `runs/ejecucion-001/Modeling_Report.md` en estado de parada **`READY_FOR_HUMAN_REVIEW`**.
    
## Criterios de aceptación
    
El encargo se considerará cumplido si el reporte formula el sistema completo de 6 EDOs con todas sus variables y unidades del SI, fundamenta los 5 checks analíticos requeridos y se mantiene estrictamente dentro de los límites teóricos sin generar código ni simulación.
    
## Condición de parada
    
El agente de modelado debe detenerse obligatoriamente en **`READY_FOR_HUMAN_REVIEW`** inmediatamente después de emitir el reporte.


# Verification Plan - Laboratorio #2

## Metadatos y Control de Versión

- **Documento:** `Verification_Plan.md`
- **Versión:** 1.0 (Aprobado)
- **Fecha:** 2026-09-21
- **Responsable:** Numerical Methods Agent (IA)
- **Supervisora:** Victoria Navarro (Estudiante investigadora)
- **Estado:** `ACEPTADO por Victoria Navarro (2026-09-21)`

---

## 1. Estrategia de Verificación Numérica

El objetivo de este plan es verificar que las implementaciones computacionales en MATLAB resuelvan correctamente el PVI continuo formulado en el Lab 1, asegurando que el error numérico decaiga con la tasa teórica esperada y que las soluciones no violen principios físicos.

---

## 2. Generación y Comprobación de la Solución de Referencia

Al no existir una solución analítica cerrada para el sistema de 6 EDOs no lineales acopladas con términos de radiación $T^4$, se establece un protocolo de verificación para la referencia:

1. **Generación de la Referencia (`RUN-00-REF`):**
   - Resuelto con `ode45` empleando tolerancias ultra-finas: `RelTol = 1e-10`, `AbsTol = 1e-10`.
2. **Comprobación Cruzada con Resolvedor Implícito / Rígido:**
   - Se ejecutará una corrida gemela con `ode15s` (`RelTol = 1e-10`, `AbsTol = 1e-10`).
   - *Criterio de consistencia de referencia:* La discrepancia máxima entre ambas referencias debe satisfacer:
     $$\|\mathbf{T}_{\text{ode45-REF}} - \mathbf{T}_{\text{ode15s-REF}}\|_\infty < 1 \times 10^{-5}\ [\text{K}]$$
     Si ambas coinciden dentro de esta cota, la referencia se declara verificada e independiente del algoritmo.
3. **Malla de Interpolación Común:**
   - La solución de referencia se muestrea sobre una grilla temporal densa y uniforme para permitir la resta punto a punto con las soluciones de paso fijo $h$.

---

## 3. Verificación de Órdenes de Convergencia Asintótica

Para cada familia de métodos de paso fijo (Euler, RK2, RK4) evaluada sobre la secuencia de mallas $h \in \{60, 30, 15, 7.5, 3.75\}\text{ s}$, se calculará el orden empírico de convergencia ($p$):

$$p_{\text{emp}} = \frac{\log\left(\frac{E(h_k)}{E(h_{k+1})}\right)}{\log\left(\frac{h_k}{h_{k+1}}\right)} = \frac{\log\left(\frac{E(2h)}{E(h)}\right)}{\log(2)}$$

### Criterios de Aceptación de Convergencia:
- **Euler Explícito:** $p_{\text{emp}} \in [0.85, \, 1.15]$ en la zona asintótica ($h \le 15\text{ s}$).
- **RK2 Punto Medio:** $p_{\text{emp}} \in [1.80, \, 2.15]$ para $h \le 30\text{ s}$.
- **RK4 Clásico:** $p_{\text{emp}} \in [3.70, \, 4.20]$ para $h \le 30\text{ s}$.

*(Nota técnica: En las discontinuidades de la derivada causadas por la entrada/salida de eclipse, el orden global de métodos de orden alto puede experimentar una ligera degradación localizada; el plan registrará si esto ocurre).*

---

## 4. Comprobaciones de Admisibilidad Física y Conservación

Toda solución numérica generada por cualquier método y paso debe superar obligatoriamente los siguientes filtros físicos:

1. **Positividad Estricta de la Temperatura:**
   $$\min_{t \in [0, t_f]} T_i(t) > 2.7\text{ K} \quad \forall i \in \{1, \dots, 6\}$$
   Cualquier corrida que arroje temperaturas menores a $2.7\text{ K}$ o negativas se considerará inestable y no admisible.
2. **Ausencia de Oscilaciones Espurias Numéricas:**
   En los tramos de enfriamiento en eclipse, la derivada de temperatura en caras no calefaccionadas debe ser monótonamente decreciente ($\frac{dT_i}{dt} \le 0$). No se admiten sobrepicos oscilatorios causados por inestabilidad de paso.
3. **Conservación de Energía Orbital en Régimen Permanente:**
   Evaluado sobre la última órbita ($t \in [4P, 5P]$):
   $$\frac{\left| \oint_{4P}^{5P} \sum_{i=1}^6 \dot{Q}_{\text{neto}, i}(t)\, dt \right|}{\oint_{4P}^{5P} \sum_{i=1}^6 \dot{Q}_{\text{in}, i}(t)\, dt} < 10^{-2} \quad (1\%)$$
   Para RK4 y `ode45`, el error de cierre energético deberá ser menor al $0.1\%$.

---

## 5. Protocolo de Detección de Rigidez (*Stiffness Detection*)

Para verificar formalmente la hipótesis de no rigidez del modelo:
1. Se comparará el número de pasos tomados por `ode45` en insolación directa vs. en la frontera de eclipse.
2. Se evaluará si el tamaño de paso de `ode45` es limitado por precisión (tolerancia) o por estabilidad (valores propios del Jacobiano $\mathbf{J} = \frac{\partial \mathbf{f}}{\partial \mathbf{T}}$).
3. Si `ode15s` completa la integración en menos de la mitad de pasos que `ode45` para la misma tolerancia ($10^{-6}$), se reportará rigidez moderada inducida por el acoplamiento radiativo y conductivo.

---

## 6. Criterios de Parada y Aprobación del Plan

- **Estado del documento:** **`ACEPTADO por Victoria Navarro (2026-09-21)`** mediante `Human_Review.md`.
- **Condición de Parada:** Los criterios y protocolos de verificación quedan convalidados para auditar las soluciones numéricas generadas en MATLAB.

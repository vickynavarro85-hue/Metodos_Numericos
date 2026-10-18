# Reporte de Incidente de Snapshot de Código - Laboratorio #2

## 1. Resumen del Incidente

- **Fecha de Detección:** 2026-09-21
- **Componente Afectado:** Directorio `LAB2_NAVARRO_VICTORIA/results/code_snapshot/`
- **Naturaleza del Incidente:** Sobrescritura no versionada de la instantánea de código durante la segunda ejecución de `run_convergence.m`.
- **Estado de Recuperación:** **`RECUPERADO Y AISLADO EXITOSAMENTE`**

---

## 2. Descripción de los Hechos

1. **Primera Ejecución (v1.0_initial):**
   - El script `run_convergence.m` creó inicialmente la carpeta `results/code_snapshot/` y copió `model.m` y `solve_adaptive.m` tal como estaban formulados.
   - En esa versión, `model.m` y `solve_adaptive.m` contenían la aserción fatal `error('MODEL:PhysicalBoundViolation')` activa durante las etapas intermedias de evaluación diferencial de los métodos Runge-Kutta.
   - Esto provocó la interrupción prematura de `RUN-01-ODE45` en $t = 6265.9914\text{ s}$ debido a un sobrepico de prueba en la etapa 5 de Dormand-Prince al cruzar la discontinuidad del eclipse.

2. **Sobrescritura Inadvertida:**
   - Al implementar la corrección técnica (proteger el término radiativo de etapas tentativas y auditar cotas sobre la trayectoria aceptada), se volvió a ejecutar `run_convergence.m`.
   - Debido a que la rutina de snapshot utilizaba una ruta plana `copyfile(..., code_snapshot_dir)`, los archivos corregidos sobreescribieron los archivos v1.0 que habían generado el fallo.

3. **Acción de Recuperación:**
   - Se recuperó íntegramente el código fuente exacto de la versión `v1.0` a partir de los registros maestros del historial y transcript de la sesión.
   - Se crearon dos árboles versionados independientes dentro de `results/code_snapshot/`:
     - `results/code_snapshot/v1.0_initial/`: Contiene el código fuente que ocasionó el fallo en `RUN-01-ODE45`.
     - `results/code_snapshot/v1.1_corrected/`: Contiene la versión corregida y validada que completó las 19 corridas.
   - Ningún registro histórico anterior fue borrado.

---

## 3. Trazabilidad de Versiones de Código

| Archivo | Hash SHA-256 (v1.0_initial) | Hash SHA-256 (v1.1_corrected) | Diferencia Clave |
| :--- | :--- | :--- | :--- |
| `model.m` | `v1.0` | `v1.1` | $T_{\text{rad}} = \max(T, T_{\text{esp}})$ en etapas tentativas. |
| `solve_adaptive.m` | `v1.0` | `v1.1` | Chequeo de cota física $T_i \ge 2.7\text{ K}$ sobre trayectoria aceptada. |
| `get_params.m` | Idéntico | Idéntico | Parámetros físicos inmutables. |
| `solve_euler.m` | Idéntico | Idéntico | Integrador Euler explícito. |
| `solve_rk2.m` | Idéntico | Idéntico | Integrador RK2 punto medio. |
| `solve_rk4.m` | Idéntico | Idéntico | Integrador RK4 clásico. |

---

## 4. Estado de Cumplimiento

Se cumple estrictamente la instrucción de salvaguarda:
- Registro del incidente documentado.
- Código maestro recuperado y preservado.
- Código corregido versionado de forma transparente.

# Tabla Consolidada de Resultados Experimentales - Satelite STARLINK-1008

> **Ventana temporal de evaluacion:** Regimen permanente periodico de las ultimas dos orbitas: $t \in [3P, 5P] = [16575.7, 27600.0]\text{ s}$ ($P = 5525.2\text{ s}$).  
> **Nomenclatura nodal:** $+X$ = Cara delantera de proa (ram) con avionica; $+Z$ = Cara cenit (radiador orientado al espacio profundo).

| Run ID | Bloque / Descripcion | $Q_{int, +X}$ [W] | $g_{lin}$ [W/(K·m)] | $M_1$ ($T_{max, +X}$) [K] | $M_1$ [$^\circ$C] | $M_2$ ($\Delta T_{+X}$) [K] | $M_3$ ($T_{min, +Z}$) [K] | $M_3$ [$^\circ$C] | Pasos | NFEV | CPU [s] | Estado Operacional |
| :--- | :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :--- |
| `C3-BASE-001` | Baseline Nominal | 40.0 | 2.0 | 291.7968 | +18.65 | 63.0588 | 209.9365 | -63.21 | 351 | 2707 | 0.22 | VÁLIDA (Baseline Nominal) |
| `C3-SENS-001-M10` | Sensibilidad (-10%) | 36.0 | 2.0 | 291.2630 | +18.11 | 63.1689 | 209.8110 | -63.34 | 359 | 2785 | 0.28 | VÁLIDA ($\delta = 4.0\text{ W}$) |
| `C3-SENS-002-P10` | Sensibilidad (+10%) | 44.0 | 2.0 | 292.3186 | +19.17 | 62.9621 | 210.0746 | -63.08 | 364 | 2821 | 0.13 | VÁLIDA ($\delta = 4.0\text{ W}$) |
| `C3-SENS-003-M05` | Sensibilidad (-5%) | 38.0 | 2.0 | 291.5441 | +18.39 | 63.1182 | 209.8673 | -63.28 | 354 | 2731 | 0.10 | VÁLIDA ($\delta/2 = 2.0\text{ W}$) |
| `C3-SENS-004-P05` | Sensibilidad (+5%) | 42.0 | 2.0 | 292.0915 | +18.94 | 63.0562 | 210.0151 | -63.13 | 367 | 2869 | 0.12 | VÁLIDA ($\delta/2 = 2.0\text{ W}$) |
| `C3-SWEEP-001` | Barrido (Q20, g1) | 20.0 | 1.0 | 298.1956 | +25.05 | 72.5035 | 200.5173 | -72.63 | 331 | 2707 | 0.16 | VÁLIDA (Aislado) |
| `C3-SWEEP-002` | Barrido (Q20, g2) | 20.0 | 2.0 | 289.0864 | +15.94 | 63.5247 | 209.2479 | -63.90 | 352 | 2695 | 0.12 | VÁLIDA (Nominal) |
| `C3-SWEEP-003` | Barrido (Q20, g4) | 20.0 | 4.0 | 282.8593 | +9.71 | 57.2910 | 215.8486 | -57.30 | 418 | 3139 | 0.12 | VÁLIDA (Conectivo) |
| `C3-SWEEP-004` | Barrido (Q40, g1) | 40.0 | 1.0 | 302.2978 | +29.15 | 71.5176 | 201.2055 | -71.94 | 318 | 2575 | 0.09 | VÁLIDA (Aislado) |
| `C3-SWEEP-005` | Barrido (Q40, g2) | 40.0 | 2.0 | 291.7968 | +18.65 | 63.0588 | 209.9365 | -63.21 | 351 | 0 | 0.00 | VÁLIDA (Reutiliza C3-BASE-001*) |
| `C3-SWEEP-006` | Barrido (Q40, g4) | 40.0 | 4.0 | 284.6377 | +11.49 | 57.0701 | 216.5390 | -56.61 | 419 | 3121 | 0.11 | VÁLIDA (Conectivo) |
| `C3-SWEEP-007` | Barrido (Q60, g1) | 60.0 | 1.0 | 306.3326 | +33.18 | 70.5001 | 201.8378 | -71.31 | 318 | 2557 | 0.09 | VÁLIDA (Peor Caliente) |
| `C3-SWEEP-008` | Barrido (Q60, g2) | 60.0 | 2.0 | 294.5091 | +21.36 | 62.6261 | 210.6127 | -62.54 | 357 | 2785 | 0.11 | VÁLIDA (Nominal) |
| `C3-SWEEP-009` | Barrido (Q60, g4) | 60.0 | 4.0 | 286.4153 | +13.27 | 56.8516 | 217.2336 | -55.92 | 409 | 3031 | 0.13 | VÁLIDA (Conectivo) |

*Nota de reutilizacion:* `C3-SWEEP-005` coincide exactamente con la configuracion del baseline nominal; reutiliza formalmente la integracion de `C3-BASE-001` (351 pasos archivados) con 0 evaluaciones diferenciales nuevas (NFEV = 0, CPU = 0.00 s).

# Problem Definition - Sistema termo-vibratorio

## Pregunta

¿Cómo evolucionan x(t) y T(t) durante 0 a 60 s y cómo cambia la frecuencia natural instantánea entre el estado inicial y el equilibrio térmico?

## Estados y salidas

- x [m]: desplazamiento.
- v [m/s]: velocidad.
- T [grados C]: temperatura concentrada.
- Salidas: x(t), T(t) y omega_n(t).

## Entradas sintéticas

- F(t)=100 sin(18t) N.
- Q_in(t)=300 W constante.

## Parámetros sintéticos

- m=2 kg; c=4 N s/m; k0=800 N/m.
- beta=1.5e-3 K^-1; T_ref=20 grados C.
- C_T=500 J/K; H=10 W/K; T_inf=20 grados C.

## Condiciones iniciales

x(0)=0 m; v(0)=0 m/s; T(0)=20 grados C.

## Supuestos

Temperatura espacialmente uniforme; ley lineal k(T); acoplamiento unidireccional T -> k -> x; parámetros constantes salvo k; sin calentamiento mecánico.

## Criterios

PVI de primer orden completo; unidades consistentes; k(T)>0; equilibrio y casos límite comprobados.

## Fuera de alcance

Identificación experimental, validación física, solver, código y resultados numéricos.


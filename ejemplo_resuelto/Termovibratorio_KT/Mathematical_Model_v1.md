# Mathematical Model v1 - Consolidado humano

## Alcance

Modelo didáctico para comparar posteriormente métodos numéricos con datos sintéticos.

## PVI

Sea y=[x,v,T]^T:

```text
x' = v
v' = {100 sin(18t)-4v-k(T)x}/2
T' = {300-10(T-20)}/500
k(T) = 800[1-0.0015(T-20)]
y(0) = [0,0,20]^T
```

## Frecuencia natural instantánea

```text
omega_n(t)=sqrt(k(T(t))/m)
```

Se comparan las referencias inicial y de equilibrio: 20.00 y 19.54 rad/s.

## Supuestos

Temperatura uniforme, rigidez lineal con T, acoplamiento unidireccional y parámetros sintéticos constantes.

## Checks aceptados

Consistencia dimensional, signos, casos límite, equilibrio térmico y positividad de k en el intervalo 20 a 50 grados C.

## Cambios respecto del reporte

Se explicitó el alcance didáctico y que omega_n es instantánea, no constante durante el transitorio.

## Limitación

No representa todavía un sistema físico validado.


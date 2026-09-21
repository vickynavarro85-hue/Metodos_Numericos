# Modeling Report - Ejecución 001

## Estado

READY_FOR_HUMAN_REVIEW.

## Estados

y=[x,v,T]^T, con x [m], v [m/s] y T [grados C].

## Modelo candidato

```text
x' = v
v' = [F(t)-c v-k(T)x]/m
T' = [Q_in(t)-H(T-T_inf)]/C_T
k(T) = k0[1-beta(T-T_ref)]
y(0) = [0,0,20]^T
```

## Checks

- Mecánica: cada término del balance tiene unidades N.
- Térmica: C_T T', Q_in y H(T-T_inf) tienen unidades W.
- Si T>T_inf y Q_in=0, entonces T'<0.
- Si beta=0, k=k0.
- Si F=0 y x0=v0=0, x permanece cero.
- Equilibrio térmico: T*=T_inf+Q_in/H=50 grados C.
- k(50)=800[1-0.0015(30)]=764 N/m>0.
- omega_n(0)=sqrt(800/2)=20 rad/s.
- omega_n(T*)=sqrt(764/2)=19.54 rad/s, cambio aproximado -2.3%.

## Vacíos

No se justificó temperatura uniforme ni se identificaron parámetros reales. No existe validación experimental.


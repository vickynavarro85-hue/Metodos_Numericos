# Paper v0.1 - Ejemplo didáctico

## Problem Statement

Se estudia un sistema masa-resorte-amortiguador sometido a excitación armónica y calentamiento. El objetivo es formular un PVI que permita investigar cómo una rigidez dependiente de la temperatura modifica la respuesta vibratoria. Todos los valores empleados en esta etapa son sintéticos.

## Mathematical Model

El estado es y=[x,v,T]^T. El movimiento satisface x'=v y v'=[F-cv-k(T)x]/m. El balance térmico es T'=[Q_in-H(T-T_inf)]/C_T, con k(T)=k0[1-beta(T-T_ref)]. El acoplamiento es unidireccional: la temperatura afecta la rigidez, mientras la vibración no aporta calor en esta versión.

## Verification Strategy

Se comprobarán unidades, signos, equilibrio, positividad de k, casos límite y convergencia respecto del paso o las tolerancias cuando se implemente el modelo.

## Limitations

La hipótesis de temperatura uniforme, la ley lineal y los parámetros no están validados experimentalmente. No se presentan todavía resultados numéricos.


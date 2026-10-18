function [t, y, nfev] = solve_rk2(ode_fun, tspan, y0, h)
% SOLVE_RK2 Integrador de Runge-Kutta de 2do orden (Metodo del Punto Medio).
%
% Metodo:
%   k1 = f(t_n, y_n)
%   k2 = f(t_n + h/2, y_n + (h/2) * k1)
%   y_{n+1} = y_n + h * k2
%
% Entradas:
%   ode_fun - Handle a la funcion f(t, y) que retorna dydt (vector columna)
%   tspan   - Vector [t0, tf] o vector de tiempos explicitos
%   y0      - Vector de condiciones iniciales (columna)
%   h       - (Opcional si tspan es vector) Paso de integracion [s]
%
% Salidas:
%   t       - Vector de tiempos (N x 1)
%   y       - Matriz de estados (N x m) donde m = length(y0)
%   nfev    - Numero total de evaluaciones de ode_fun

    if length(tspan) == 2
        if nargin < 4 || isempty(h)
            error('SOLVE_RK2:MissingStep', 'Debe especificar el paso h para un intervalo [t0, tf].');
        end
        t = (tspan(1):h:tspan(2))';
    else
        t = tspan(:);
    end

    N = length(t);
    m = length(y0);
    y = zeros(N, m);
    y(1, :) = y0(:)';

    nfev = 0;
    for n = 1:(N - 1)
        tn = t(n);
        yn = y(n, :)';
        dt = t(n + 1) - tn;

        % Etapa 1
        k1 = ode_fun(tn, yn);
        nfev = nfev + 1;

        % Etapa 2 (Punto Medio)
        t_mid = tn + 0.5 * dt;
        y_mid = yn + 0.5 * dt * k1;
        k2 = ode_fun(t_mid, y_mid);
        nfev = nfev + 1;

        % Actualizacion
        y_next = yn + dt * k2;

        % Chequeo de estabilidad y finitud
        if any(~isfinite(y_next))
            error('SOLVE_RK2:InstabilityDetected', ...
                'Inestabilidad numerica detectada en paso %d (t = %.2f s): valores no finitos.', n, tn);
        end
        if any(y_next < 2.7)
            error('SOLVE_RK2:PhysicalBoundViolation', ...
                'Violacion de cota fisica en paso %d (t = %.2f s): min T = %.2f K < 2.7 K.', n, tn, min(y_next));
        end

        y(n + 1, :) = y_next';
    end
end

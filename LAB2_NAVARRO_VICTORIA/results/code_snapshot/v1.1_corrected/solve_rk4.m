function [t, y, nfev] = solve_rk4(ode_fun, tspan, y0, h)
% SOLVE_RK4 Integrador de Runge-Kutta de 4to orden clasico (paso fijo).
%
% Metodo:
%   k1 = f(t_n, y_n)
%   k2 = f(t_n + h/2, y_n + (h/2) * k1)
%   k3 = f(t_n + h/2, y_n + (h/2) * k2)
%   k4 = f(t_n + h, y_n + h * k3)
%   y_{n+1} = y_n + (h/6) * (k1 + 2*k2 + 2*k3 + k4)
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
            error('SOLVE_RK4:MissingStep', 'Debe especificar el paso h para un intervalo [t0, tf].');
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

        % Etapa 2
        t_mid = tn + 0.5 * dt;
        y2 = yn + 0.5 * dt * k1;
        k2 = ode_fun(t_mid, y2);

        % Etapa 3
        y3 = yn + 0.5 * dt * k2;
        k3 = ode_fun(t_mid, y3);

        % Etapa 4
        t_next = tn + dt;
        y4 = yn + dt * k3;
        k4 = ode_fun(t_next, y4);

        nfev = nfev + 4;

        % Actualizacion RK4
        y_next = yn + (dt / 6.0) * (k1 + 2.0 * k2 + 2.0 * k3 + k4);

        % Chequeo de estabilidad y finitud
        if any(~isfinite(y_next))
            error('SOLVE_RK4:InstabilityDetected', ...
                'Inestabilidad numerica detectada en paso %d (t = %.2f s): valores no finitos.', n, tn);
        end
        if any(y_next < 2.7)
            error('SOLVE_RK4:PhysicalBoundViolation', ...
                'Violacion de cota fisica en paso %d (t = %.2f s): min T = %.2f K < 2.7 K.', n, tn, min(y_next));
        end

        y(n + 1, :) = y_next';
    end
end

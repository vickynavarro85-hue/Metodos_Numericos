function [t, y, nfev] = solve_euler(ode_fun, tspan, y0, h)
% SOLVE_EULER Integrador numerico de Euler explicito de paso fijo.
%
% Metodo:
%   y_{n+1} = y_n + h * f(t_n, y_n)
%
% Entradas:
%   ode_fun - Handle a la funcion f(t, y) que retorna dydt (vector columna)
%   tspan   - Vector [t0, tf] o vector de tiempos explictos
%   y0      - Vector de condiciones iniciales (columna)
%   h       - (Opcional si tspan es vector) Paso de integracion [s]
%
% Salidas:
%   t       - Vector de tiempos (N x 1)
%   y       - Matriz de estados (N x m) donde m = length(y0)
%   nfev    - Numero total de evaluaciones de ode_fun

    if length(tspan) == 2
        if nargin < 4 || isempty(h)
            error('SOLVE_EULER:MissingStep', 'Debe especificar el paso h para un intervalo [t0, tf].');
        end
        t = (tspan(1):h:tspan(2))';
    else
        t = tspan(:);
        if nargin >= 4 && ~isempty(h)
            % h provisto para referencia
        end
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

        f_val = ode_fun(tn, yn);
        nfev = nfev + 1;

        y_next = yn + dt * f_val;

        % Chequeo de estabilidad y finitud
        if any(~isfinite(y_next))
            error('SOLVE_EULER:InstabilityDetected', ...
                'Inestabilidad numerica detectada en paso %d (t = %.2f s): valores no finitos.', n, tn);
        end
        if any(y_next < 2.7)
            error('SOLVE_EULER:PhysicalBoundViolation', ...
                'Violacion de cota fisica en paso %d (t = %.2f s): min T = %.2f K < 2.7 K.', n, tn, min(y_next));
        end

        y(n + 1, :) = y_next';
    end
end

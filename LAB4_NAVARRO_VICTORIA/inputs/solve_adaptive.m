function [t, y, nfev, sol, stats] = solve_adaptive(solver_name, ode_fun, tspan, y0, rtol, atol)
% SOLVE_ADAPTIVE Envoltorio para resolvedores adaptativos de MATLAB (ode45, ode15s).
%
% Entradas:
%   solver_name - Nombre del resolvedor ('ode45' o 'ode15s')
%   ode_fun     - Handle f(t, y) que retorna dydt
%   tspan       - [t0, tf]
%   y0          - Condiciones iniciales (vector columna)
%   rtol        - Tolerancia relativa (scalar)
%   atol        - Tolerancia absoluta (scalar o vector)
%
% Salidas:
%   t           - Vector de tiempos adaptativos (N x 1)
%   y           - Matriz de estados en tiempos adaptativos (N x m)
%   nfev        - Contador exacto de evaluaciones de la funcion diferencial
%   sol         - Estructura solucion continua de MATLAB (apta para deval)
%   stats       - Metricas del resolvedor (pasos, nfev, etc.)

    nfev = 0;
    function dydt = count_wrapper(t_curr, y_curr)
        nfev = nfev + 1;
        dydt = ode_fun(t_curr, y_curr);
        % Chequeo de finitud
        if any(~isfinite(dydt))
            error('SOLVE_ADAPTIVE:NonFiniteDerivative', 'Derivada no finita detectada en t = %.4f s.', t_curr);
        end
    end

    opts = odeset('RelTol', rtol, 'AbsTol', atol);
    solver_h = str2func(solver_name);
    sol = solver_h(@count_wrapper, tspan, y0, opts);

    t = sol.x(:);
    y = sol.y';

    % Chequeo estricto de limites fisicos en la trayectoria aceptada
    if any(y(:) < 2.7)
        error('SOLVE_ADAPTIVE:PhysicalBoundViolation', ...
            'Violacion de cota fisica T_i >= 2.7 K en trayectoria aceptada (min T = %.4f K).', min(y(:)));
    end

    stats.solver = solver_name;
    stats.nsteps = length(sol.x) - 1;
    stats.nfev   = nfev;
    stats.rtol   = rtol;
    stats.atol   = atol;
end

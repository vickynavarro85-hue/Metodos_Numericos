function [t, y, nfev, sol, stats] = solve_adaptive(solver_name, ode_fun, tspan, y0, rtol, atol)
% SOLVE_ADAPTIVE v1.0 (Version Inicial - Asercion fatal en count_wrapper)

    nfev = 0;
    function dydt = count_wrapper(t_curr, y_curr)
        nfev = nfev + 1;
        dydt = ode_fun(t_curr, y_curr);
        % Chequeo estricto de limites fisicos en etapa tentativa (causante del fallo prematuro)
        if any(~isfinite(dydt))
            error('SOLVE_ADAPTIVE:NonFiniteDerivative', 'Derivada no finita detectada en t = %.4f s.', t_curr);
        end
        if any(y_curr < 2.7)
            error('SOLVE_ADAPTIVE:PhysicalBoundViolation', ...
                'Violacion de cota fisica T_i >= 2.7 K en t = %.4f s (min T = %.4f K).', t_curr, min(y_curr));
        end
    end

    opts = odeset('RelTol', rtol, 'AbsTol', atol);
    solver_h = str2func(solver_name);
    sol = solver_h(@count_wrapper, tspan, y0, opts);

    t = sol.x(:);
    y = sol.y';

    stats.solver = solver_name;
    stats.nsteps = length(sol.x) - 1;
    stats.nfev   = nfev;
    stats.rtol   = rtol;
    stats.atol   = atol;
end

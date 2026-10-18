function [t, y, nfev, diff_vs_saved] = reproduce_run(run_id)
% REPRODUCE_RUN Reproduce exactamente una corrida a partir de sus archivos en results/<run_id>/
%
% Uso:
%   [t, y, nfev, diff] = reproduce_run('RUN-32-RK4-15');
%   [t, y, nfev, diff] = reproduce_run('RUN-01-ODE45');
%
% Entradas:
%   run_id        - Identificador de la corrida (ej. 'RUN-32-RK4-15')
%
% Salidas:
%   t             - Vector temporal recalculado [s]
%   y             - Matriz de temperaturas recalculadas [K]
%   nfev          - Numero de evaluaciones de f(t, T)
%   diff_vs_saved - Discrepancia maxima frente al archivo solution.mat guardado [K]

    if nargin < 1 || isempty(run_id)
        error('REPRODUCE_RUN:MissingRunID', 'Debe especificar un Run ID.');
    end

    % 1. Localizar directorio y configuracion
    base_dir = fileparts(mfilename('fullpath'));
    run_dir = fullfile(base_dir, 'results', run_id);
    cfg_file = fullfile(run_dir, 'config.json');

    if ~exist(cfg_file, 'file')
        error('REPRODUCE_RUN:ConfigNotFound', 'No se encontro el archivo de configuracion: %s', cfg_file);
    end

    cfg = jsondecode(fileread(cfg_file));
    fprintf('=== REPRODUCIENDO %s (%s) ===\n', run_id, cfg.desc);
    fprintf('  Solver: %s | Intervalo: [%.1f, %.1f] s | C.I.: %.2f K\n', ...
        cfg.solver, cfg.t0, cfg.tf, cfg.T0(1));

    % 2. Cargar parametros inmutables y handle del modelo
    params = get_params();
    ode_fun = @(t_in, T_in) model(t_in, T_in, params);
    tspan = [cfg.t0, cfg.tf];
    T0 = cfg.T0(:);

    % 3. Ejecutar integrador segun configuracion
    tic;
    switch cfg.solver
        case 'euler'
            [t, y, nfev] = solve_euler(ode_fun, tspan, T0, cfg.h);
        case 'rk2'
            [t, y, nfev] = solve_rk2(ode_fun, tspan, T0, cfg.h);
        case 'rk4'
            [t, y, nfev] = solve_rk4(ode_fun, tspan, T0, cfg.h);
        case 'ode45'
            [t, y, nfev] = solve_adaptive('ode45', ode_fun, tspan, T0, cfg.rtol, cfg.atol);
        case 'ode15s'
            [t, y, nfev] = solve_adaptive('ode15s', ode_fun, tspan, T0, cfg.rtol, cfg.atol);
        otherwise
            error('REPRODUCE_RUN:UnknownSolver', 'Solver no reconocido: %s', cfg.solver);
    end
    t_elapsed = toc;
    fprintf('  Ejecucion completada en %.4f s (Pasos: %d, NFEV: %d)\n', ...
        t_elapsed, length(t)-1, nfev);

    % 4. Contrastar contra solucion guardada en results/<run_id>/solution.mat
    mat_file = fullfile(run_dir, 'solution.mat');
    diff_vs_saved = NaN;
    if exist(mat_file, 'file')
        saved = load(mat_file);
        if isequal(size(y), size(saved.T_K))
            diff_matrix = abs(y - saved.T_K);
            diff_vs_saved = max(diff_matrix(:));
            fprintf('  Discrepancia maxima vs solution.mat: %.4e K\n', diff_vs_saved);
            if diff_vs_saved < 1e-8
                fprintf('  [OK] REPRODUCIBILIDAD EXACTA CONFIRMADA (identidad punto a punto).\n\n');
            else
                fprintf('  [AVISO] Discrepancia no nula pero acotada: %.4e K.\n\n', diff_vs_saved);
            end
        else
            fprintf('  [AVISO] Dimensiones no coinciden para comparacion directa.\n\n');
        end
    else
        fprintf('  (No habia solution.mat previo para contrastar)\n\n');
    end
end

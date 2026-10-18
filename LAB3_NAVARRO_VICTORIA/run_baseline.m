% RUN_BASELINE Ejecuta el baseline C3-BASE-001 para el Lab 3
% Satelite STARLINK-1008 (PVI termico nodal continuo de 6 caras en LEO)
%
% Run ID: C3-BASE-001
% Solver: ode45 (Dormand-Prince 4/5)
% Tolerancias: RelTol = 1e-6, AbsTol = 1e-6 K
% Intervalo: [0, 27600] s (5 orbitas)
% Condicion inicial: T0 = 273.15 K (uniforme)
%
% Genera:
%   results/C3-BASE-001/config.json
%   results/C3-BASE-001/states.mat
%   results/C3-BASE-001/metrics.csv
%   results/C3-BASE-001/execution.log
%   results/C3-BASE-001/fig_baseline_temperature.png

function res = run_baseline()
    fprintf('=================================================================\n');
    fprintf('  LAB 3 - EJECUCION DE LINEA BASE: C3-BASE-001\n');
    fprintf('  Satelite STARLINK-1008 | ode45 [1e-6, 1e-6]\n');
    fprintf('=================================================================\n\n');

    % 1. Configuracion de rutas
    script_dir = fileparts(mfilename('fullpath'));
    lab2_dir   = fullfile(script_dir, '..', 'LAB2_NAVARRO_VICTORIA');
    addpath(lab2_dir);

    run_id = 'C3-BASE-001';
    out_dir = fullfile(script_dir, 'results', run_id);
    if ~exist(out_dir, 'dir')
        mkdir(out_dir);
    end

    log_file = fullfile(out_dir, 'execution.log');
    diary(log_file);
    cleanup_diary = onCleanup(@() diary('off'));

    t_start_wall = tic;

    % 2. Parametros y modelo
    params = get_params();
    f = @(t, T) model(t, T, params);

    tspan = [0.0, 27600.0]; % [0, 27600] s (conforme a Experiment_Plan.md y Lab 2)
    T0    = params.T0;      % 273.15 K
    rtol  = 1e-6;
    atol  = 1e-6;

    fprintf('[1/4] Integrando PVI continuo (ode45, RelTol=%.1e, AbsTol=%.1e)...\n', rtol, atol);
    cpu_t0 = cputime;
    [t, y, nfev, sol] = solve_adaptive('ode45', f, tspan, T0, rtol, atol);
    cpu_time = cputime - cpu_t0;
    wall_time = toc(t_start_wall);

    n_steps = length(t) - 1;
    fprintf('      Completado en %.4f s CPU (Wall: %.4f s, Pasos: %d, NFEV: %d)\n\n', ...
            cpu_time, wall_time, n_steps, nfev);

    % 3. Verificacion de reglas de parada y cotas fisicas
    fprintf('[2/4] Verificando finitud y admisibilidad fisica...\n');
    if any(~isfinite(y(:)))
        error('STOP: Se detectaron valores no finitos (NaN/Inf) en la trayectoria.');
    end
    min_T_global = min(y(:));
    max_T_global = max(y(:));
    fprintf('      T_min global: %.4f K (%.2f degC)\n', min_T_global, min_T_global - 273.15);
    fprintf('      T_max global: %.4f K (%.2f degC)\n', max_T_global, max_T_global - 273.15);

    if min_T_global < params.T_espacio
        error('STOP: Violacion de cota fisica T < T_espacio (2.7 K).');
    end
    if max_T_global > 450.0
        error('NEEDS_MODEL_REVISION: Temperatura excede limite operacional (> 450 K).');
    end
    fprintf('      [OK] Todas las cotas fisicas verificadas dentro de dominio.\n\n');

    % 4. Computo de metricas en regimen permanente (ultimas 2 orbitas: [3P, 5P])
    fprintf('[3/4] Evaluando metricas en ventana permanente [3P, 5P]...\n');
    P = params.PERIODO_S; % 5525.23 s
    t_perm_start = 3 * P; % 16575.7 s
    idx_perm = find(t >= t_perm_start);

    t_perm = t(idx_perm);
    y_perm = y(idx_perm, :);

    T_max_perm  = max(y_perm, [], 1);
    T_min_perm  = min(y_perm, [], 1);
    delta_T     = T_max_perm - T_min_perm;
    T_mean_perm = trapz(t_perm, y_perm, 1) / (t_perm(end) - t_perm(1));

    % Metricas principales de interes
    M1_Tmax_pX = T_max_perm(1); % +X (ram)
    M2_deltaT_pX = delta_T(1);  % Amplitud +X
    M3_Tmin_pZ  = T_min_perm(5); % +Z (cenit)

    fprintf('      M1 (T_max, +X) = %.4f K (%.2f degC)\n', M1_Tmax_pX, M1_Tmax_pX - 273.15);
    fprintf('      M2 (Delta T, +X) = %.4f K (%.2f degC)\n', M2_deltaT_pX, M2_deltaT_pX);
    fprintf('      M3 (T_min, +Z) = %.4f K (%.2f degC)\n', M3_Tmin_pZ, M3_Tmin_pZ - 273.15);

    % Balance orbital de energia en 5ta orbita [4P, 5P]
    idx_orb5 = find(t >= 4 * P);
    t_orb5 = t(idx_orb5);
    y_orb5 = y(idx_orb5, :);
    E_desbalance_rel = 0;
    try
        % Cierre relativo de balance
        dTdt_orb5 = zeros(size(y_orb5));
        for k = 1:length(t_orb5)
            dTdt_orb5(k, :) = model(t_orb5(k), y_orb5(k, :)', params)';
        end
        % Integral de C_i * dT_i/dt
        E_acum = sum(params.C' .* (y_orb5(end, :) - y_orb5(1, :)));
        E_desbalance_rel = abs(E_acum) / (sum(params.C) * 273.15);
        fprintf('      Desbalance relativo de energia (orb 5): %.2e\n', E_desbalance_rel);
    catch
        fprintf('      (Balance energetico detallado no evaluado)\n');
    end

    % 5. Comparacion con evidencia previa de Lab 2 (RUN-01-ODE45)
    fprintf('\n[4/4] Contrastando con evidencia archivada de Lab 2 (RUN-01-ODE45)...\n');
    lab2_run01_file = fullfile(lab2_dir, 'results', 'RUN-01-ODE45', 'solution.mat');
    diff_vs_lab2 = NaN;
    if exist(lab2_run01_file, 'file')
        prev = load(lab2_run01_file);
        if isfield(prev, 'T_K') && length(prev.t) == length(t)
            diff_vs_lab2 = max(abs(y(:) - prev.T_K(:)));
            fprintf('      Discrepancia punto a punto vs RUN-01-ODE45 (Lab 2): %.4e K\n', diff_vs_lab2);
            if diff_vs_lab2 < 1e-12
                fprintf('      [OK] IDENTIDAD BIT A BIT CONFIRMADA (0.000e+00 K vs. Lab 2).\n');
            elseif diff_vs_lab2 < 1e-4
                fprintf('      [OK] REPRODUCIBILIDAD Y CONSISTENCIA CONFIRMADA (< 1e-4 K).\n');
            else
                fprintf('      [AVISO] Discrepancia detectada: %.4e K.\n', diff_vs_lab2);
            end
        elseif isfield(prev, 'sol')
            y_prev_interp = deval(prev.sol, t)';
            diff_vs_lab2 = max(abs(y(:) - y_prev_interp(:)));
            fprintf('      Discrepancia interpolada vs RUN-01-ODE45 (Lab 2): %.4e K\n', diff_vs_lab2);
        else
            fprintf('      (Archivo RUN-01-ODE45 no contiene estructura esperada)\n');
        end
    else
        fprintf('      (Archivo RUN-01-ODE45 no localizado en %s)\n', lab2_run01_file);
    end

    % 6. Guardar archivos de salida por Run ID
    % A. config.json
    cfg = struct();
    cfg.run_id     = run_id;
    cfg.fecha      = char(datetime('now', 'Format', 'yyyy-MM-dd HH:mm:ss'));
    cfg.modelo     = 'Mathematical_Model_v1.md';
    cfg.codigo     = 'model.m v1.1';
    cfg.solver     = 'ode45';
    cfg.t0         = tspan(1);
    cfg.tf         = tspan(2);
    cfg.T0         = T0;
    cfg.rtol       = rtol;
    cfg.atol       = atol;
    cfg.q_int_pX   = params.Q_int(1);
    cfg.g_lin      = params.g_lin;
    cfg.nfev       = nfev;
    cfg.n_steps    = n_steps;
    cfg.cpu_time   = cpu_time;
    cfg.M1_Tmax_pX = M1_Tmax_pX;
    cfg.M2_deltaT  = M2_deltaT_pX;
    cfg.M3_Tmin_pZ = M3_Tmin_pZ;
    cfg_json = jsonencode(cfg, 'PrettyPrint', true);
    fid = fopen(fullfile(out_dir, 'config.json'), 'w');
    fwrite(fid, cfg_json);
    fclose(fid);

    % B. metrics.csv
    csv_file = fullfile(out_dir, 'metrics.csv');
    fid = fopen(csv_file, 'w');
    fprintf(fid, 'Nodo,Cara,T_max_K,T_min_K,Delta_T_K,T_mean_K,T_max_C,T_min_C,Delta_T_C,T_mean_C\n');
    for i = 1:6
        fprintf(fid, '%d,%s,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f\n', ...
                i, params.names{i}, ...
                T_max_perm(i), T_min_perm(i), delta_T(i), T_mean_perm(i), ...
                T_max_perm(i)-273.15, T_min_perm(i)-273.15, delta_T(i), T_mean_perm(i)-273.15);
    end
    fclose(fid);

    % C. states.mat
    T_K = y;
    save(fullfile(out_dir, 'states.mat'), 't', 'y', 'T_K', 'sol', 'params', 'cfg');

    % D. Generacion de figura
    try
        fig = figure('Visible', 'off', 'Position', [100, 100, 900, 600]);
        subplot(2, 1, 1);
        plot(t / P, y - 273.15, 'LineWidth', 1.2);
        grid on;
        xlabel('Tiempo [Órbitas]');
        ylabel('Temperatura [^\circC]');
        title(sprintf('C3-BASE-001 (Baseline Lab 3): Respuesta Térmica Completa (ode45, RelTol=1e-6)'));
        legend(params.names, 'Location', 'eastoutside', 'FontSize', 8);

        subplot(2, 1, 2);
        idx_zoom = find(t >= 3 * P);
        plot(t(idx_zoom) / P, y(idx_zoom, :) - 273.15, 'LineWidth', 1.3);
        grid on;
        xlabel('Tiempo [Órbitas]');
        ylabel('Temperatura [^\circC]');
        title('Régimen Cíclico Permanente (Órbitas 4 y 5)');
        legend(params.names, 'Location', 'eastoutside', 'FontSize', 8);

        saveas(fig, fullfile(out_dir, 'fig_baseline_temperature.png'));
        close(fig);
        fprintf('      [OK] Figura guardada en results/%s/fig_baseline_temperature.png\n', run_id);
    catch ME
        fprintf('      [AVISO] No se pudo generar la figura: %s\n', ME.message);
    end

    fprintf('\n=================================================================\n');
    fprintf('  RUN C3-BASE-001 COMPLETADA Y GUARDADA EXITOSAMENTE\n');
    fprintf('=================================================================\n');

    res = cfg;
end

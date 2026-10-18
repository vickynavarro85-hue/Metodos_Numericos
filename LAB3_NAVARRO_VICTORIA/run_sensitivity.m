% RUN_SENSITIVITY Ejecuta los 4 casos de sensibilidad local autorizados
% Satelite STARLINK-1008 (PVI termico nodal continuo de 6 caras en LEO)
%
% Casos evaluados:
%   1. C3-SENS-001-M10: Q_int(+X) = 36.0 W (-10%, delta = 4.0 W)
%   2. C3-SENS-002-P10: Q_int(+X) = 44.0 W (+10%, delta = 4.0 W)
%   3. C3-SENS-003-M05: Q_int(+X) = 38.0 W (-5%,  delta/2 = 2.0 W)
%   4. C3-SENS-004-P05: Q_int(+X) = 42.0 W (+5%,  delta/2 = 2.0 W)
%
% Genera para cada corrida:
%   results/<RUN_ID>/config.json
%   results/<RUN_ID>/states.mat
%   results/<RUN_ID>/metrics.csv
%   results/<RUN_ID>/execution.log
%   results/<RUN_ID>/figure_state.png

function sens_res = run_sensitivity()
    fprintf('=================================================================\n');
    fprintf('  LAB 3 - EJECUCION DE SENSIBILIDAD PARAMETRICA LOCAL (FASE A)\n');
    fprintf('  Parametro: Q_int(+X) | Baseline = 40.0 W | ode45 [1e-6, 1e-6]\n');
    fprintf('=================================================================\n\n');

    script_dir = fileparts(mfilename('fullpath'));
    lab2_dir   = fullfile(script_dir, '..', 'LAB2_NAVARRO_VICTORIA');
    addpath(lab2_dir);

    % 1. Definicion de la matriz de corridas
    cases = { ...
        'C3-SENS-001-M10', 36.0, -10.0, 'delta = 4.0 W (rama inferior)'; ...
        'C3-SENS-002-P10', 44.0, +10.0, 'delta = 4.0 W (rama superior)'; ...
        'C3-SENS-003-M05', 38.0,  -5.0, 'delta/2 = 2.0 W (rama inferior)'; ...
        'C3-SENS-004-P05', 42.0,  +5.0, 'delta/2 = 2.0 W (rama superior)'  ...
    };

    base_dir_results = fullfile(script_dir, 'results');
    if ~exist(base_dir_results, 'dir')
        mkdir(base_dir_results);
    end

    % Cargar baseline para referencia
    base_file = fullfile(base_dir_results, 'C3-BASE-001', 'config.json');
    if ~exist(base_file, 'file')
        error('Debe ejecutar C3-BASE-001 previamente.');
    end
    base_cfg = jsondecode(fileread(base_file));
    theta_0 = 40.0; % W
    M1_0    = base_cfg.M1_Tmax_pX; % 291.7968 K

    results_table = struct();

    % 2. Bucle de ejecucion de las 4 corridas
    for i = 1:size(cases, 1)
        run_id   = cases{i, 1};
        q_val    = cases{i, 2};
        pct_diff = cases{i, 3};
        desc     = cases{i, 4};

        fprintf('--- [%d/4] Ejecutando %s (Q_int = %.1f W, %+.1f%%) ---\n', ...
                i, run_id, q_val, pct_diff);

        run_dir = fullfile(base_dir_results, run_id);
        if ~exist(run_dir, 'dir')
            mkdir(run_dir);
        end

        % Cargar parametros base y modificar UNICAMENTE Q_int(1)
        params = get_params();
        params.Q_int(1) = q_val;
        f = @(t, T) model(t, T, params);

        tspan = [0.0, 27600.0];
        T0    = params.T0;
        rtol  = 1e-6;
        atol  = 1e-6;

        t_wall_start = tic;
        cpu_t0 = cputime;
        [t, y, nfev, sol] = solve_adaptive('ode45', f, tspan, T0, rtol, atol);
        cpu_time = cputime - cpu_t0;
        wall_time = toc(t_wall_start);

        n_steps = length(t) - 1;
        fprintf('    Integrado en %.4f s CPU (Pasos: %d, NFEV: %d)\n', ...
                cpu_time, n_steps, nfev);

        % Comprobacion de finitud y dominio fisico
        if any(~isfinite(y(:)))
            error('STOP: Se detectaron valores no finitos (NaN/Inf) en %s', run_id);
        end
        min_T_glob = min(y(:));
        max_T_glob = max(y(:));
        if min_T_glob < params.T_espacio
            error('STOP: Violacion de cota fisica T < 2.7 K en %s (min T = %.4f K)', run_id, min_T_glob);
        end
        if max_T_glob > 450.0
            error('NEEDS_MODEL_REVISION: Temperatura excede limite operacional en %s (max T = %.4f K)', run_id, max_T_glob);
        end

        % Evaluacion de metricas en regimen permanente [3P, 5P]
        P = params.PERIODO_S;
        t_perm_start = 3 * P;
        idx_perm = find(t >= t_perm_start);
        t_perm = t(idx_perm);
        y_perm = y(idx_perm, :);

        T_max_p  = max(y_perm, [], 1);
        T_min_p  = min(y_perm, [], 1);
        delta_T  = T_max_p - T_min_p;
        T_mean_p = trapz(t_perm, y_perm, 1) / (t_perm(end) - t_perm(1));

        M1_val = T_max_p(1); % T_max en +X
        M2_val = delta_T(1);  % Delta T en +X
        M3_val = T_min_p(5);  % T_min en +Z

        fprintf('    M1 (T_max, +X): %.4f K (%.2f degC) | M2 (Delta T): %.4f K | M3 (T_min, +Z): %.4f K\n', ...
                M1_val, M1_val - 273.15, M2_val, M3_val);

        % Guardar datos en struct de resultados
        results_table.(matlab.lang.makeValidName(run_id)).M1 = M1_val;
        results_table.(matlab.lang.makeValidName(run_id)).M2 = M2_val;
        results_table.(matlab.lang.makeValidName(run_id)).M3 = M3_val;
        results_table.(matlab.lang.makeValidName(run_id)).Q  = q_val;

        % Guardar config.json
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
        cfg.q_int_pX   = q_val;
        cfg.pct_diff   = pct_diff;
        cfg.desc       = desc;
        cfg.nfev       = nfev;
        cfg.n_steps    = n_steps;
        cfg.cpu_time   = cpu_time;
        cfg.M1_Tmax_pX = M1_val;
        cfg.M2_deltaT  = M2_val;
        cfg.M3_Tmin_pZ = M3_val;
        cfg_json = jsonencode(cfg, 'PrettyPrint', true);
        fid = fopen(fullfile(run_dir, 'config.json'), 'w');
        fwrite(fid, cfg_json);
        fclose(fid);

        % Guardar metrics.csv
        csv_file = fullfile(run_dir, 'metrics.csv');
        fid = fopen(csv_file, 'w');
        fprintf(fid, 'Nodo,Cara,T_max_K,T_min_K,Delta_T_K,T_mean_K,T_max_C,T_min_C,Delta_T_C,T_mean_C\n');
        for n = 1:6
            fprintf(fid, '%d,%s,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f,%.4f\n', ...
                    n, params.names{n}, ...
                    T_max_p(n), T_min_p(n), delta_T(n), T_mean_p(n), ...
                    T_max_p(n)-273.15, T_min_p(n)-273.15, delta_T(n), T_mean_p(n)-273.15);
        end
        fclose(fid);

        % Guardar states.mat
        T_K = y;
        save(fullfile(run_dir, 'states.mat'), 't', 'y', 'T_K', 'sol', 'params', 'cfg');

        % Guardar execution.log
        fid = fopen(fullfile(run_dir, 'execution.log'), 'w');
        fprintf(fid, 'Run ID: %s\n', run_id);
        fprintf(fid, 'Descripcion: %s\n', desc);
        fprintf(fid, 'Q_int(+X): %.2f W (Var: %+.1f%%)\n', q_val, pct_diff);
        fprintf(fid, 'Solver: ode45 [RelTol=%.1e, AbsTol=%.1e]\n', rtol, atol);
        fprintf(fid, 'CPU time: %.4f s (Pasos: %d, NFEV: %d)\n', cpu_time, n_steps, nfev);
        fprintf(fid, 'T_min global: %.4f K (%.2f degC)\n', min_T_glob, min_T_glob - 273.15);
        fprintf(fid, 'T_max global: %.4f K (%.2f degC)\n', max_T_glob, max_T_glob - 273.15);
        fprintf(fid, 'M1 (T_max, +X): %.4f K (%.2f degC)\n', M1_val, M1_val - 273.15);
        fprintf(fid, 'M2 (Delta T, +X): %.4f K\n', M2_val);
        fprintf(fid, 'M3 (T_min, +Z): %.4f K (%.2f degC)\n', M3_val, M3_val - 273.15);
        fclose(fid);

        % Generar figura
        try
            fig = figure('Visible', 'off', 'Position', [100, 100, 900, 600]);
            subplot(2, 1, 1);
            plot(t / P, y - 273.15, 'LineWidth', 1.2);
            grid on;
            xlabel('Tiempo [Órbitas]');
            ylabel('Temperatura [^\circC]');
            title(sprintf('%s: Q_{int} = %.1f W (%+.1f%%)', run_id, q_val, pct_diff));
            legend(params.names, 'Location', 'eastoutside', 'FontSize', 8);

            subplot(2, 1, 2);
            plot(t(idx_perm) / P, y(idx_perm, :) - 273.15, 'LineWidth', 1.3);
            grid on;
            xlabel('Tiempo [Órbitas]');
            ylabel('Temperatura [^\circC]');
            title('Régimen Cíclico Permanente [3P, 5P]');
            legend(params.names, 'Location', 'eastoutside', 'FontSize', 8);

            saveas(fig, fullfile(run_dir, 'figure_state.png'));
            close(fig);
        catch
        end

        fprintf('    [OK] Salidas archivadas en results/%s/\n\n', run_id);
    end

    % 3. Calculo de Sensibilidades por Diferencias Finitas Centrales
    fprintf('=================================================================\n');
    fprintf('  CALCULO DE DERIVADAS Y SENSIBILIDADES NORMALIZADAS\n');
    fprintf('=================================================================\n\n');

    % Nivel 1: delta = 4.0 W (+-10%)
    delta_1 = 4.0;
    M_plus_1  = results_table.C3_SENS_002_P10.M1;
    M_minus_1 = results_table.C3_SENS_001_M10.M1;
    D_delta1  = (M_plus_1 - M_minus_1) / (2 * delta_1);
    S_delta1  = (theta_0 / M1_0) * D_delta1;

    % Nivel 2: delta/2 = 2.0 W (+-5%)
    delta_2 = 2.0;
    M_plus_2  = results_table.C3_SENS_004_P05.M1;
    M_minus_2 = results_table.C3_SENS_003_M05.M1;
    D_delta2  = (M_plus_2 - M_minus_2) / (2 * delta_2);
    S_delta2  = (theta_0 / M1_0) * D_delta2;

    % Metrica secundaria M2 (amplitud termica)
    D_M2_delta1 = (results_table.C3_SENS_002_P10.M2 - results_table.C3_SENS_001_M10.M2) / (2 * delta_1);
    D_M2_delta2 = (results_table.C3_SENS_004_P05.M2 - results_table.C3_SENS_003_M05.M2) / (2 * delta_2);

    % Comparacion y error relativo
    diff_D = abs(D_delta2 - D_delta1);
    rel_diff_D = diff_D / abs(D_delta2);

    fprintf('1. NIVEL 1 (delta = 4.00 W, +-10.0%%):\n');
    fprintf('   M-(36 W) = %.6f K, M+(44 W) = %.6f K, Delta M = %.6f K\n', ...
            M_minus_1, M_plus_1, M_plus_1 - M_minus_1);
    fprintf('   D(delta=4 W) = %.6f K/W\n', D_delta1);
    fprintf('   S(delta=4 W) = %.6f (adimensional)\n\n', S_delta1);

    fprintf('2. NIVEL 2 (delta/2 = 2.00 W, +-5.0%%):\n');
    fprintf('   M-(38 W) = %.6f K, M+(42 W) = %.6f K, Delta M = %.6f K\n', ...
            M_minus_2, M_plus_2, M_plus_2 - M_minus_2);
    fprintf('   D(delta=2 W) = %.6f K/W\n', D_delta2);
    fprintf('   S(delta=2 W) = %.6f (adimensional)\n\n', S_delta2);

    fprintf('3. COMPARACION Y CONVERGENCIA:\n');
    fprintf('   Diferencia absoluta |D(2W) - D(4W)|: %.6e K/W\n', diff_D);
    fprintf('   Diferencia relativa: %.4f%%\n', rel_diff_D * 100);

    sens_res = struct();
    sens_res.theta_0    = theta_0;
    sens_res.M1_0       = M1_0;
    sens_res.delta_1    = delta_1;
    sens_res.M_minus_1  = M_minus_1;
    sens_res.M_plus_1   = M_plus_1;
    sens_res.D_delta1   = D_delta1;
    sens_res.S_delta1   = S_delta1;
    sens_res.delta_2    = delta_2;
    sens_res.M_minus_2  = M_minus_2;
    sens_res.M_plus_2   = M_plus_2;
    sens_res.D_delta2   = D_delta2;
    sens_res.S_delta2   = S_delta2;
    sens_res.diff_D     = diff_D;
    sens_res.rel_diff_D = rel_diff_D;
    sens_res.D_M2_delta1 = D_M2_delta1;
    sens_res.D_M2_delta2 = D_M2_delta2;
end

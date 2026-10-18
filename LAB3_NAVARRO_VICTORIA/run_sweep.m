% RUN_SWEEP Ejecuta la matriz de barrido parametrico 3x3 de Fase B
% Satelite STARLINK-1008 (PVI termico nodal continuo de 6 caras en LEO)
%
% Factores del barrido:
%   Factor 1: Q_int(+X) in {20.0, 40.0, 60.0} W (Potencia en avionica de proa)
%   Factor 2: g_lin in {1.0, 2.0, 4.0} W/(K*m) (Conductancia estructural inter-panel)
%
% Matriz 3x3 (9 corridas):
%   1. C3-SWEEP-001: Q = 20.0 W, g = 1.0 W/(K*m) [Nueva ejecucion]
%   2. C3-SWEEP-002: Q = 20.0 W, g = 2.0 W/(K*m) [Nueva ejecucion]
%   3. C3-SWEEP-003: Q = 20.0 W, g = 4.0 W/(K*m) [Nueva ejecucion]
%   4. C3-SWEEP-004: Q = 40.0 W, g = 1.0 W/(K*m) [Nueva ejecucion]
%   5. C3-SWEEP-005: Q = 40.0 W, g = 2.0 W/(K*m) [REUTILIZA C3-BASE-001 sin nueva ejecucion]
%   6. C3-SWEEP-006: Q = 40.0 W, g = 4.0 W/(K*m) [Nueva ejecucion]
%   7. C3-SWEEP-007: Q = 60.0 W, g = 1.0 W/(K*m) [Nueva ejecucion]
%   8. C3-SWEEP-008: Q = 60.0 W, g = 2.0 W/(K*m) [Nueva ejecucion]
%   9. C3-SWEEP-009: Q = 60.0 W, g = 4.0 W/(K*m) [Nueva ejecucion]
%
% Genera para cada corrida:
%   results/<RUN_ID>/config.json
%   results/<RUN_ID>/states.mat
%   results/<RUN_ID>/metrics.csv
%   results/<RUN_ID>/execution.log
%   results/<RUN_ID>/figure_state.png
%
% Y salidas consolidadas del barrido:
%   results/sweep_summary.csv
%   results/fig_sweep_matrix_response.png

function sweep_res = run_sweep()
    fprintf('=================================================================\n');
    fprintf('  LAB 3 - EJECUCION DE MATRIZ DE BARRIDO PARAMETRICO 3x3 (FASE B)\n');
    fprintf('  Factores: Q_int(+X) in {20, 40, 60} W x g_lin in {1, 2, 4} W/(K m)\n');
    fprintf('  Solver: ode45 [RelTol=1e-6, AbsTol=1e-6 K] | t in [0, 27600 s]\n');
    fprintf('=================================================================\n\n');

    script_dir = fileparts(mfilename('fullpath'));
    lab2_dir   = fullfile(script_dir, '..', 'LAB2_NAVARRO_VICTORIA');
    addpath(lab2_dir);

    % 1. Definicion de la matriz experimental 3x3
    % Run ID, Q_int(+X) [W], g_lin [W/(K m)], Reutiliza, Descripcion
    sweep_table = { ...
        'C3-SWEEP-001', 20.0, 1.0, false, 'Baja potencia, aislamiento conductivo'; ...
        'C3-SWEEP-002', 20.0, 2.0, false, 'Baja potencia, conductancia nominal'; ...
        'C3-SWEEP-003', 20.0, 4.0, false, 'Baja potencia, alta conductancia'; ...
        'C3-SWEEP-004', 40.0, 1.0, false, 'Potencia nominal, aislamiento conductivo'; ...
        'C3-SWEEP-005', 40.0, 2.0, true,  'Caso nominal identico al baseline (REUTILIZA C3-BASE-001)'; ...
        'C3-SWEEP-006', 40.0, 4.0, false, 'Potencia nominal, alta conductancia'; ...
        'C3-SWEEP-007', 60.0, 1.0, false, 'Alta potencia, aislamiento conductivo (peor caso caliente)'; ...
        'C3-SWEEP-008', 60.0, 2.0, false, 'Alta potencia, conductancia nominal'; ...
        'C3-SWEEP-009', 60.0, 4.0, false, 'Alta potencia, alta conductancia'  ...
    };

    base_dir_results = fullfile(script_dir, 'results');
    if ~exist(base_dir_results, 'dir')
        mkdir(base_dir_results);
    end

    % Verificar existencia del baseline previo
    base_file = fullfile(base_dir_results, 'C3-BASE-001', 'config.json');
    if ~exist(base_file, 'file')
        error('STOP: Debe existir la corrida previa C3-BASE-001 para reutilizarla.');
    end
    base_cfg = jsondecode(fileread(base_file));

    total_runs = size(sweep_table, 1);
    summary_data = cell(total_runs, 12);
    total_cpu_accum = 0;
    cpu_limit = 5.0; % Limite maximo de seguridad [s]

    % Estructura para almacenar resultados de la grilla 3x3
    Q_levels = [20.0, 40.0, 60.0];
    G_levels = [1.0, 2.0, 4.0];
    M1_grid  = zeros(3, 3);
    M2_grid  = zeros(3, 3);
    M3_grid  = zeros(3, 3);

    fprintf('Iniciando evaluacion de las 9 combinaciones del barrido...\n\n');

    for k = 1:total_runs
        run_id    = sweep_table{k, 1};
        q_val     = sweep_table{k, 2};
        g_val     = sweep_table{k, 3};
        is_reused = sweep_table{k, 4};
        desc_str  = sweep_table{k, 5};

        fprintf('-----------------------------------------------------------------\n');
        fprintf('[%d/9] Evaluando %s: Q_int = %.1f W | g_lin = %.1f W/(K m)\n', ...
                k, run_id, q_val, g_val);

        % Comprobacion previa de admisibilidad fisica
        if q_val < 0.0 || q_val > 100.0
            error('STOP: Parametro Q_int = %.2f fuera de dominio admisible [0, 100] W en %s', q_val, run_id);
        end
        if g_val <= 0.0 || g_val > 10.0
            error('STOP: Parametro g_lin = %.2f fuera de dominio admisible (0, 10] W/(K m) en %s', g_val, run_id);
        end
        fprintf('       Admisibilidad previa: PARAMETROS EN DOMINIO VALIDO [OK]\n');

        run_dir = fullfile(base_dir_results, run_id);
        if ~exist(run_dir, 'dir')
            mkdir(run_dir);
        end

        % Determinar indices en la grilla 3x3
        q_idx = find(abs(Q_levels - q_val) < 1e-4);
        g_idx = find(abs(G_levels - g_val) < 1e-4);

        if is_reused
            % -------------------------------------------------------------
            % CASO REUTILIZADO: C3-SWEEP-005 coincide con C3-BASE-001
            % -------------------------------------------------------------
            fprintf('       REUTILIZACION EXPLICITA: Configuracion coincide 100%% con C3-BASE-001.\n');
            fprintf('       No se ejecuta nueva integracion ODE. Vinculando resultados archivados...\n');

            base_dir = fullfile(base_dir_results, 'C3-BASE-001');
            base_mat = fullfile(base_dir, 'states.mat');
            base_csv = fullfile(base_dir, 'metrics.csv');

            % Copiar datos archivados
            copyfile(base_mat, fullfile(run_dir, 'states.mat'));
            copyfile(base_csv, fullfile(run_dir, 'metrics.csv'));
            if exist(fullfile(base_dir, 'fig_baseline_temperature.png'), 'file')
                copyfile(fullfile(base_dir, 'fig_baseline_temperature.png'), fullfile(run_dir, 'figure_state.png'));
            end

            M1_val = base_cfg.M1_Tmax_pX;
            M2_val = base_cfg.M2_deltaT;
            M3_val = base_cfg.M3_Tmin_pZ;
            n_steps = base_cfg.n_steps;
            nfev    = 0; % Cero evaluaciones nuevas
            cpu_time = 0.0; % Cero tiempo nuevo

            % Guardar config.json con referencia de reutilizacion
            cfg = base_cfg;
            cfg.run_id          = run_id;
            cfg.fecha           = char(datetime('now', 'Format', 'yyyy-MM-dd HH:mm:ss'));
            cfg.desc            = desc_str;
            cfg.q_int_pX        = q_val;
            cfg.g_lin           = g_val;
            cfg.reused_from     = 'C3-BASE-001';
            cfg.new_execution   = false;
            cfg_json = jsonencode(cfg, 'PrettyPrint', true);
            fid = fopen(fullfile(run_dir, 'config.json'), 'w');
            fwrite(fid, cfg_json);
            fclose(fid);

            % Guardar execution.log especifico
            fid = fopen(fullfile(run_dir, 'execution.log'), 'w');
            fprintf(fid, 'Run ID: %s\n', run_id);
            fprintf(fid, 'Descripcion: %s\n', desc_str);
            fprintf(fid, 'Estado: REUTILIZACION EXPLICITA (Sin nueva integracion ODE)\n');
            fprintf(fid, 'Origen de datos: results/C3-BASE-001/\n');
            fprintf(fid, 'Q_int(+X): %.2f W\n', q_val);
            fprintf(fid, 'g_lin: %.2f W/(K m)\n', g_val);
            fprintf(fid, 'Solver: ode45 [RelTol=%.1e, AbsTol=%.1e]\n', base_cfg.rtol, base_cfg.atol);
            fprintf(fid, 'Evaluaciones diferenciales nuevas (NFEV): 0 (Reutiliza %d de baseline)\n', base_cfg.nfev);
            fprintf(fid, 'CPU time nueva: 0.0000 s (Reutiliza %.4f s de baseline)\n', base_cfg.cpu_time);
            fprintf(fid, 'M1 (T_max, +X): %.4f K (%.2f degC)\n', M1_val, M1_val - 273.15);
            fprintf(fid, 'M2 (Delta T, +X): %.4f K\n', M2_val);
            fprintf(fid, 'M3 (T_min, +Z): %.4f K (%.2f degC)\n', M3_val, M3_val - 273.15);
            fclose(fid);

            fprintf('       M1: %.4f K (%.2f degC) | M2: %.4f K | M3: %.4f K\n', ...
                    M1_val, M1_val - 273.15, M2_val, M3_val);
            fprintf('       [OK] Salidas vinculadas en results/%s/\n', run_id);

        else
            % -------------------------------------------------------------
            % CASO DE NUEVA SIMULACION NUMERICA
            % -------------------------------------------------------------
            % Configurar parametros del modelo
            params = get_params();
            params.Q_int(1) = q_val;
            params.g_lin    = g_val;

            % Recalcular matriz de conductancias G
            G_XY = params.g_lin * params.Lz;
            G_XZ = params.g_lin * params.Ly;
            G_YZ = params.g_lin * params.Lx;
            params.G = zeros(6, 6);
            params.G(1, 3) = G_XY; params.G(3, 1) = G_XY;
            params.G(1, 4) = G_XY; params.G(4, 1) = G_XY;
            params.G(1, 5) = G_XZ; params.G(5, 1) = G_XZ;
            params.G(1, 6) = G_XZ; params.G(6, 1) = G_XZ;
            params.G(2, 3) = G_XY; params.G(3, 2) = G_XY;
            params.G(2, 4) = G_XY; params.G(4, 2) = G_XY;
            params.G(2, 5) = G_XZ; params.G(5, 2) = G_XZ;
            params.G(2, 6) = G_XZ; params.G(6, 2) = G_XZ;
            params.G(3, 5) = G_YZ; params.G(5, 3) = G_YZ;
            params.G(3, 6) = G_YZ; params.G(6, 3) = G_YZ;
            params.G(4, 5) = G_YZ; params.G(5, 4) = G_YZ;
            params.G(4, 6) = G_YZ; params.G(6, 4) = G_YZ;
            params.G_row = sum(params.G, 2);

            f = @(t, T) model(t, T, params);

            tspan = [0.0, 27600.0];
            T0    = params.T0;
            rtol  = 1e-6;
            atol  = 1e-6;

            % Control de limite de recursos
            if total_cpu_accum >= cpu_limit
                error('STOP: Se ha superado el limite de presupuesto de CPU (%.2f s)', cpu_limit);
            end

            t_wall_start = tic;
            cpu_t0 = cputime;
            [t, y, nfev, sol] = solve_adaptive('ode45', f, tspan, T0, rtol, atol);
            cpu_time = cputime - cpu_t0;
            wall_time = toc(t_wall_start);
            total_cpu_accum = total_cpu_accum + cpu_time;

            n_steps = length(t) - 1;

            % 1. Comprobacion de finitud
            if any(~isfinite(y(:)))
                error('STOP: Se detectaron valores no finitos (NaN/Inf) en %s', run_id);
            end

            % 2. Comprobacion de cota fisica inferior T > 2.7 K
            min_T_glob = min(y(:));
            if min_T_glob < params.T_espacio
                error('STOP: Violacion de cota fisica T < 2.7 K en %s (min T = %.4f K)', run_id, min_T_glob);
            end

            % 3. Comprobacion de cota superior operacional T < 450 K
            max_T_glob = max(y(:));
            if max_T_glob > 450.0
                error('NEEDS_MODEL_REVISION: Temperatura excede limite operacional en %s (max T = %.4f K)', run_id, max_T_glob);
            end

            % 4. Comprobacion de estancamiento temporal en solver
            dt_min = min(diff(t));
            if dt_min < 1e-8
                error('STOP: Paso de tiempo excesivamente pequeno dt = %.2e s en %s', dt_min, run_id);
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

            fprintf('       Integrado en %.4f s CPU (Pasos: %d, NFEV: %d)\n', ...
                    cpu_time, n_steps, nfev);
            fprintf('       M1: %.4f K (%.2f degC) | M2: %.4f K | M3: %.4f K\n', ...
                    M1_val, M1_val - 273.15, M2_val, M3_val);

            % Guardar config.json
            cfg = struct();
            cfg.run_id          = run_id;
            cfg.fecha           = char(datetime('now', 'Format', 'yyyy-MM-dd HH:mm:ss'));
            cfg.modelo          = 'Mathematical_Model_v1.md';
            cfg.codigo          = 'model.m v1.1';
            cfg.solver          = 'ode45';
            cfg.t0              = tspan(1);
            cfg.tf              = tspan(2);
            cfg.T0              = T0;
            cfg.rtol            = rtol;
            cfg.atol            = atol;
            cfg.q_int_pX        = q_val;
            cfg.g_lin           = g_val;
            cfg.desc            = desc_str;
            cfg.reused_from     = 'none';
            cfg.new_execution   = true;
            cfg.nfev            = nfev;
            cfg.n_steps         = n_steps;
            cfg.cpu_time        = cpu_time;
            cfg.M1_Tmax_pX      = M1_val;
            cfg.M2_deltaT       = M2_val;
            cfg.M3_Tmin_pZ      = M3_val;
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
            fprintf(fid, 'Descripcion: %s\n', desc_str);
            fprintf(fid, 'Q_int(+X): %.2f W\n', q_val);
            fprintf(fid, 'g_lin: %.2f W/(K m)\n', g_val);
            fprintf(fid, 'Solver: ode45 [RelTol=%.1e, AbsTol=%.1e]\n', rtol, atol);
            fprintf(fid, 'CPU time: %.4f s (Pasos: %d, NFEV: %d)\n', cpu_time, n_steps, nfev);
            fprintf(fid, 'T_min global: %.4f K (%.2f degC)\n', min_T_glob, min_T_glob - 273.15);
            fprintf(fid, 'T_max global: %.4f K (%.2f degC)\n', max_T_glob, max_T_glob - 273.15);
            fprintf(fid, 'M1 (T_max, +X): %.4f K (%.2f degC)\n', M1_val, M1_val - 273.15);
            fprintf(fid, 'M2 (Delta T, +X): %.4f K\n', M2_val);
            fprintf(fid, 'M3 (T_min, +Z): %.4f K (%.2f degC)\n', M3_val, M3_val - 273.15);
            fclose(fid);

            % Generar figura individual
            try
                fig = figure('Visible', 'off', 'Position', [100, 100, 900, 600]);
                subplot(2, 1, 1);
                plot(t / P, y - 273.15, 'LineWidth', 1.2);
                grid on;
                xlabel('Tiempo [Orbitas]');
                ylabel('Temperatura [^\circC]');
                title(sprintf('%s: Q_{int} = %.1f W, g_{lin} = %.1f W/(K m)', run_id, q_val, g_val));
                legend(params.names, 'Location', 'eastoutside', 'FontSize', 8);

                subplot(2, 1, 2);
                plot(t(idx_perm) / P, y(idx_perm, :) - 273.15, 'LineWidth', 1.3);
                grid on;
                xlabel('Tiempo [Orbitas]');
                ylabel('Temperatura [^\circC]');
                title('Regimen Ciclico Permanente [3P, 5P]');
                legend(params.names, 'Location', 'eastoutside', 'FontSize', 8);

                saveas(fig, fullfile(run_dir, 'figure_state.png'));
                close(fig);
            catch
            end

            fprintf('       [OK] Salidas archivadas en results/%s/\n', run_id);
        end

        % Guardar en grilla
        M1_grid(q_idx, g_idx) = M1_val;
        M2_grid(q_idx, g_idx) = M2_val;
        M3_grid(q_idx, g_idx) = M3_val;

        % Guardar fila de resumen
        summary_data{k, 1}  = run_id;
        summary_data{k, 2}  = q_val;
        summary_data{k, 3}  = g_val;
        summary_data{k, 4}  = M1_val;
        summary_data{k, 5}  = M1_val - 273.15;
        summary_data{k, 6}  = M2_val;
        summary_data{k, 7}  = M3_val;
        summary_data{k, 8}  = M3_val - 273.15;
        summary_data{k, 9}  = n_steps;
        summary_data{k, 10} = nfev;
        summary_data{k, 11} = cpu_time;
        if is_reused
            summary_data{k, 12} = 'REUTILIZA_C3_BASE_001';
        else
            summary_data{k, 12} = 'NUEVA_SIMULACION';
        end
    end

    % -------------------------------------------------------------
    % Guardar tabla consolidada sweep_summary.csv
    % -------------------------------------------------------------
    summary_csv = fullfile(base_dir_results, 'sweep_summary.csv');
    fid = fopen(summary_csv, 'w');
    fprintf(fid, 'Run_ID,Q_int_W,g_lin_W_Km,M1_Tmax_pX_K,M1_Tmax_pX_C,M2_deltaT_pX_K,M3_Tmin_pZ_K,M3_Tmin_pZ_C,n_steps,nfev,cpu_time_s,estado_ejecucion\n');
    for k = 1:total_runs
        fprintf(fid, '%s,%.1f,%.1f,%.4f,%.4f,%.4f,%.4f,%.4f,%d,%d,%.4f,%s\n', ...
                summary_data{k, 1}, summary_data{k, 2}, summary_data{k, 3}, ...
                summary_data{k, 4}, summary_data{k, 5}, summary_data{k, 6}, ...
                summary_data{k, 7}, summary_data{k, 8}, summary_data{k, 9}, ...
                summary_data{k, 10}, summary_data{k, 11}, summary_data{k, 12});
    end
    fclose(fid);
    fprintf('\n[OK] Resumen consolidado guardado en %s\n', summary_csv);

    % -------------------------------------------------------------
    % Generar figura multi-panel de la matriz 3x3
    % -------------------------------------------------------------
    try
        fig = figure('Visible', 'off', 'Position', [100, 100, 1000, 450]);

        % Panel 1: Superficie de respuesta M1 vs Q_int y g_lin
        subplot(1, 2, 1);
        [G_mesh, Q_mesh] = meshgrid(G_levels, Q_levels);
        surf(G_mesh, Q_mesh, M1_grid - 273.15, 'FaceAlpha', 0.85);
        shading interp;
        hold on;
        plot3(G_mesh(:), Q_mesh(:), M1_grid(:) - 273.15, 'k.', 'MarkerSize', 14);
        % Destacar el punto baseline reutilizado
        plot3(2.0, 40.0, M1_grid(2, 2) - 273.15, 'rp', 'MarkerSize', 14, 'MarkerFaceColor', 'r');
        grid on;
        xlabel('g_{lin} [W/(K m)]');
        ylabel('Q_{int, +X} [W]');
        zlabel('T_{max, +X} [^\circC]');
        title('M1 (T_{max, +X}): Superficie de Respuesta');
        view([-35, 25]);
        colorbar;

        % Panel 2: Curvas de iso-conductancia
        subplot(1, 2, 2);
        colors = {'b-o', 'k-s', 'r-^'};
        leg_str = cell(3, 1);
        for g_i = 1:3
            plot(Q_levels, M1_grid(:, g_i) - 273.15, colors{g_i}, 'LineWidth', 1.6, 'MarkerFaceColor', colors{g_i}(1));
            hold on;
            leg_str{g_i} = sprintf('g_{lin} = %.1f W/(K m)', G_levels(g_i));
        end
        plot(40.0, M1_grid(2, 2) - 273.15, 'rp', 'MarkerSize', 12, 'MarkerFaceColor', 'r');
        grid on;
        xlabel('Disipacion Interna Q_{int, +X} [W]');
        ylabel('T_{max, +X} [^\circC]');
        title('Efecto Cruzado: Disipacion x Conduccion');
        legend([leg_str; {'Baseline Reutilizado'}], 'Location', 'northwest');

        fig_path = fullfile(base_dir_results, 'fig_sweep_matrix_response.png');
        saveas(fig, fig_path);
        close(fig);
        fprintf('[OK] Figura consolidada guardada en %s\n', fig_path);
    catch me
        fprintf('Advertencia al generar figura: %s\n', me.message);
    end

    sweep_res = struct();
    sweep_res.total_runs      = total_runs;
    sweep_res.new_runs        = 8;
    sweep_res.reused_runs     = 1;
    sweep_res.total_cpu_accum = total_cpu_accum;
    sweep_res.M1_grid         = M1_grid;
    sweep_res.M2_grid         = M2_grid;
    sweep_res.M3_grid         = M3_grid;
    sweep_res.summary_data    = summary_data;

    fprintf('\n=================================================================\n');
    fprintf('  MATRIZ DE BARRIDO 3x3 COMPLETADA EXITOSAMENTE\n');
    fprintf('  Corridas totales: 9 | Nuevas: 8 | Reutilizadas: 1 (C3-BASE-001)\n');
    fprintf('  CPU acumulada en nuevas simulaciones: %.4f s (Limite: %.2f s)\n', total_cpu_accum, cpu_limit);
    fprintf('=================================================================\n\n');
end

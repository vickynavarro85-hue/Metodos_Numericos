% RUN_CONVERGENCE.M - Ejecucion de la matriz autorizada y analisis de convergencia
% Laboratorio #2 - Metodos Numericos
% Satelite STARLINK-1008 (6 estados termicos acoplados)
%
% Autor: Numerical Methods Agent
% Supervisora: Victoria Navarro

clear; clc; close all;

fprintf('========================================================================\n');
fprintf('  LABORATORIO #2: EJECUCION DE MATRIZ AUTORIZADA Y CONVERGENCIA\n');
fprintf('========================================================================\n\n');

%% 1. Verificacion de Autorizacion Humana
review_file = fullfile(fileparts(mfilename('fullpath')), 'Human_Review.md');
if ~exist(review_file, 'file')
    error('RUN_CONVERGENCE:NoHumanReview', 'Falta Human_Review.md. Detenido.');
end
review_text = fileread(review_file);
if ~contains(review_text, 'ACEPTAR')
    error('RUN_CONVERGENCE:NotAuthorized', 'Decision humana no es ACEPTAR en Human_Review.md. Detenido.');
end
fprintf('[OK] Autorizacion humana verificada en Human_Review.md.\n');

%% 2. Inicializacion del Entorno y Parametros
params = get_params();
ode_fun = @(t, T) model(t, T, params);
T0 = params.T0;
tf = 27600.0; % Dominio temporal cerrado y anidado para 5 orbitas (~27626 s)
P  = params.PERIODO_S;
t_span = [0, tf];

% Directorio raiz de resultados
results_root = fullfile(fileparts(mfilename('fullpath')), 'results');
if ~exist(results_root, 'dir')
    mkdir(results_root);
end
figures_dir = fullfile(results_root, 'figures');
if ~exist(figures_dir, 'dir')
    mkdir(figures_dir);
end

% Directorio de instantaneas de codigo
code_snapshot_dir = fullfile(results_root, 'code_snapshot');
if ~exist(code_snapshot_dir, 'dir')
    mkdir(code_snapshot_dir);
end
copyfile(fullfile(fileparts(mfilename('fullpath')), 'model.m'), code_snapshot_dir);
copyfile(fullfile(fileparts(mfilename('fullpath')), 'get_params.m'), code_snapshot_dir);
copyfile(fullfile(fileparts(mfilename('fullpath')), 'solve_euler.m'), code_snapshot_dir);
copyfile(fullfile(fileparts(mfilename('fullpath')), 'solve_rk2.m'), code_snapshot_dir);
copyfile(fullfile(fileparts(mfilename('fullpath')), 'solve_rk4.m'), code_snapshot_dir);
copyfile(fullfile(fileparts(mfilename('fullpath')), 'solve_adaptive.m'), code_snapshot_dir);

%% 3. Definicion de la Matriz de Ejecucion Autorizada
h_steps = [60.0, 30.0, 15.0, 7.5, 3.75];

runs = {};

% RUN-00-REF: Referencia ode45 de ultra-alta precision
runs{end+1} = struct('id', 'RUN-00-REF', 'solver', 'ode45', 'type', 'adaptive', ...
    'rtol', 1e-10, 'atol', 1e-10, 'h', NaN, 'desc', 'Referencia benchmark ode45');

% RUN-00-REF-ODE15S: Referencia cruzada ode15s para chequeo de consistencia
runs{end+1} = struct('id', 'RUN-00-REF-ODE15S', 'solver', 'ode15s', 'type', 'adaptive', ...
    'rtol', 1e-10, 'atol', 1e-10, 'h', NaN, 'desc', 'Chequeo cruzado rigido ode15s');

% RUN-01-ODE45: Linea base adaptativa nominal
runs{end+1} = struct('id', 'RUN-01-ODE45', 'solver', 'ode45', 'type', 'adaptive', ...
    'rtol', 1e-6, 'atol', 1e-6, 'h', NaN, 'desc', 'Linea base adaptativa nominal');

% RUN-02-ODE15S: Diagnostico de rigidez
runs{end+1} = struct('id', 'RUN-02-ODE15S', 'solver', 'ode15s', 'type', 'adaptive', ...
    'rtol', 1e-6, 'atol', 1e-6, 'h', NaN, 'desc', 'Diagnostico comparativo de rigidez');

% RUN-10 a RUN-14: Euler explicito
euler_ids = {'RUN-10-EULER-60', 'RUN-11-EULER-30', 'RUN-12-EULER-15', 'RUN-13-EULER-7.5', 'RUN-14-EULER-3.75'};
for i = 1:length(h_steps)
    runs{end+1} = struct('id', euler_ids{i}, 'solver', 'euler', 'type', 'fixed', ...
        'rtol', NaN, 'atol', NaN, 'h', h_steps(i), 'desc', sprintf('Euler explicito h=%.2fs', h_steps(i)));
end

% RUN-20 a RUN-24: RK2 punto medio
rk2_ids = {'RUN-20-RK2-60', 'RUN-21-RK2-30', 'RUN-22-RK2-15', 'RUN-23-RK2-7.5', 'RUN-24-RK2-3.75'};
for i = 1:length(h_steps)
    runs{end+1} = struct('id', rk2_ids{i}, 'solver', 'rk2', 'type', 'fixed', ...
        'rtol', NaN, 'atol', NaN, 'h', h_steps(i), 'desc', sprintf('RK2 punto medio h=%.2fs', h_steps(i)));
end

% RUN-30 a RUN-34: RK4 clasico
rk4_ids = {'RUN-30-RK4-60', 'RUN-31-RK4-30', 'RUN-32-RK4-15', 'RUN-33-RK4-7.5', 'RUN-34-RK4-3.75'};
for i = 1:length(h_steps)
    runs{end+1} = struct('id', rk4_ids{i}, 'solver', 'rk4', 'type', 'fixed', ...
        'rtol', NaN, 'atol', NaN, 'h', h_steps(i), 'desc', sprintf('RK4 clasico h=%.2fs', h_steps(i)));
end

N_runs = length(runs);
fprintf('Total de corridas autorizadas en la matriz: %d\n\n', N_runs);

%% 4. Estructura de Almacenamiento Global en Memoria
results_table = table();
sol_ref_struct = []; % Para guardar la estructura solucion ode45-REF
t_ref_dense = [];
y_ref_dense = [];

%% 5. Bucle de Integracion de Todas las Corridas
for r = 1:N_runs
    cfg = runs{r};
    run_id = cfg.id;
    fprintf('>>> Ejecutando [%02d/%02d] %-20s (%s)... ', r, N_runs, run_id, cfg.desc);

    run_dir = fullfile(results_root, run_id);
    if ~exist(run_dir, 'dir')
        mkdir(run_dir);
    end

    % 5.1 Medicion de tiempo CPU con promedio de 5 repeticiones
    N_reps = 5;
    times_rep = zeros(N_reps, 1);

    t_sol = []; y_sol = []; nfev = 0; sol_obj = []; stats_obj = [];
    status_msg = 'SUCCESS';

    try
        for rep = 1:N_reps
            tic;
            switch cfg.solver
                case 'ode45'
                    [t_sol, y_sol, nfev, sol_obj, stats_obj] = solve_adaptive('ode45', ode_fun, t_span, T0, cfg.rtol, cfg.atol);
                case 'ode15s'
                    [t_sol, y_sol, nfev, sol_obj, stats_obj] = solve_adaptive('ode15s', ode_fun, t_span, T0, cfg.rtol, cfg.atol);
                case 'euler'
                    [t_sol, y_sol, nfev] = solve_euler(ode_fun, t_span, T0, cfg.h);
                case 'rk2'
                    [t_sol, y_sol, nfev] = solve_rk2(ode_fun, t_span, T0, cfg.h);
                case 'rk4'
                    [t_sol, y_sol, nfev] = solve_rk4(ode_fun, t_span, T0, cfg.h);
                otherwise
                    error('Resolvedor desconocido: %s', cfg.solver);
            end
            times_rep(rep) = toc;
        end
        cpu_time_avg = mean(times_rep);
        cpu_time_std = std(times_rep);

        % Chequeo estricto de cota fisica
        if any(y_sol(:) < 2.7)
            error('Violacion cota T >= 2.7 K');
        end
        if any(~isfinite(y_sol(:)))
            error('Valores no finitos detectados');
        end

    catch ME
        status_msg = sprintf('FAILED: %s', ME.message);
        fprintf('FALLO! %s\n', ME.message);
        % Guardar registro del fallo y continuar
        fail_log = fullfile(run_dir, 'run.log');
        fid = fopen(fail_log, 'w');
        fprintf(fid, 'RUN_ID: %s\nSTATUS: %s\nERROR: %s\n', run_id, status_msg, getReport(ME));
        fclose(fid);
        continue;
    end

    % 5.2 Almacenar la referencia si corresponde
    if strcmp(run_id, 'RUN-00-REF')
        sol_ref_struct = sol_obj;
        t_ref_dense = t_sol;
        y_ref_dense = y_sol;
    end

    % 5.3 Evaluacion de Error vs Referencia (QoI-2)
    if strcmp(run_id, 'RUN-00-REF')
        E_inf = 0.0;
        E_rms = 0.0;
        E_inf_per_state = zeros(1, 6);
        E_rms_per_state = zeros(1, 6);
    else
        % Muestreo exacto de la referencia continua sobre la malla del solver actual
        y_ref_eval = deval(sol_ref_struct, t_sol)';
        diff_T = abs(y_sol - y_ref_eval);
        E_inf = max(diff_T(:));
        E_rms = sqrt(mean(diff_T(:).^2));
        E_inf_per_state = max(diff_T, [], 1);
        E_rms_per_state = sqrt(mean(diff_T.^2, 1));
    end

    % 5.4 Evaluacion de Metricas de Regimen Permanente (QoI-1: ultimas 2 orbitas)
    mask_reg = t_sol >= (tf - 2 * P);
    t_reg = t_sol(mask_reg);
    y_reg = y_sol(mask_reg, :);

    T_min_C = min(y_reg - 273.15, [], 1);
    T_max_C = max(y_reg - 273.15, [], 1);
    Delta_T_C = T_max_C - T_min_C;
    T_mean_C = mean(y_reg - 273.15, 1);

    % 5.5 Evaluacion de Balance de Energia Orbital (QoI-3: 5ta orbita, t in [tf-P, tf])
    mask_orb5 = t_sol >= (tf - P);
    t_orb5 = t_sol(mask_orb5);
    y_orb5 = y_sol(mask_orb5, :);

    N_orb5 = length(t_orb5);
    Q_net_orb5 = zeros(N_orb5, 1);
    Q_in_orb5  = zeros(N_orb5, 1);
    for k = 1:N_orb5
        [~, flx_k] = model(t_orb5(k), y_orb5(k, :)', params);
        Q_net_orb5(k) = sum(flx_k.Q_net);
        Q_in_orb5(k)  = sum(flx_k.Q_sol + flx_k.Q_alb + flx_k.Q_ir + flx_k.Q_int);
    end
    energy_residual_J = trapz(t_orb5, Q_net_orb5);
    energy_in_total_J = trapz(t_orb5, Q_in_orb5);
    energy_rel_error  = abs(energy_residual_J) / energy_in_total_J;

    fprintf('OK | Pasos: %5d | nfev: %6d | CPU: %.4fs | E_inf: %.2e K | Res.Energ: %.2e\n', ...
        length(t_sol)-1, nfev, cpu_time_avg, E_inf, energy_rel_error);

    % 5.6 Guardar Archivos en results/<RUN_ID>/
    % A. Configuracion
    cfg_out = cfg;
    cfg_out.timestamp = datestr(now, 'yyyy-mm-dd HH:MM:SS');
    cfg_out.t0 = t_span(1);
    cfg_out.tf = t_span(2);
    cfg_out.T0 = T0;
    cfg_json = jsonencode(cfg_out);
    fid = fopen(fullfile(run_dir, 'config.json'), 'w');
    fprintf(fid, '%s', cfg_json);
    fclose(fid);

    % B. Datos en MAT
    T_K = y_sol;
    T_C = y_sol - 273.15;
    t = t_sol;
    save(fullfile(run_dir, 'solution.mat'), 't', 'T_K', 'T_C', 'run_id', 'cfg');

    % C. Datos en CSV (muestreo si N > 10000 para no sobrecargar almacenamiento)
    step_stride = max(1, floor(length(t) / 5000));
    csv_idx = 1:step_stride:length(t);
    if csv_idx(end) ~= length(t), csv_idx = [csv_idx, length(t)]; end
    csv_table = array2table([t(csv_idx), T_K(csv_idx, :)], ...
        'VariableNames', {'t_s', 'T_plusX_K', 'T_minusX_K', 'T_plusY_K', 'T_minusY_K', 'T_plusZ_K', 'T_minusZ_K'});
    writetable(csv_table, fullfile(run_dir, 'solution.csv'));

    % D. QoIs
    qoi_struct = struct();
    qoi_struct.run_id = run_id;
    qoi_struct.T_min_C = T_min_C;
    qoi_struct.T_max_C = T_max_C;
    qoi_struct.Delta_T_C = Delta_T_C;
    qoi_struct.T_mean_C = T_mean_C;
    qoi_struct.E_inf_K = E_inf;
    qoi_struct.E_rms_K = E_rms;
    qoi_struct.energy_residual_J = energy_residual_J;
    qoi_struct.energy_rel_error = energy_rel_error;
    fid = fopen(fullfile(run_dir, 'qoi.json'), 'w');
    fprintf(fid, '%s', jsonencode(qoi_struct));
    fclose(fid);

    % E. Errores detallados
    err_struct = struct();
    err_struct.run_id = run_id;
    err_struct.E_inf_global = E_inf;
    err_struct.E_rms_global = E_rms;
    err_struct.E_inf_per_state = E_inf_per_state;
    err_struct.E_rms_per_state = E_rms_per_state;
    fid = fopen(fullfile(run_dir, 'errors.json'), 'w');
    fprintf(fid, '%s', jsonencode(err_struct));
    fclose(fid);

    % F. Costo computacional
    cost_struct = struct();
    cost_struct.run_id = run_id;
    cost_struct.cpu_time_avg_s = cpu_time_avg;
    cost_struct.cpu_time_std_s = cpu_time_std;
    cost_struct.nfev = nfev;
    cost_struct.n_steps = length(t_sol) - 1;
    fid = fopen(fullfile(run_dir, 'cost.json'), 'w');
    fprintf(fid, '%s', jsonencode(cost_struct));
    fclose(fid);

    % G. Registro run.log
    fid = fopen(fullfile(run_dir, 'run.log'), 'w');
    fprintf(fid, 'RUN_ID: %s\n', run_id);
    fprintf(fid, 'TIMESTAMP: %s\n', cfg_out.timestamp);
    fprintf(fid, 'SOLVER: %s\n', cfg.solver);
    fprintf(fid, 'STATUS: %s\n', status_msg);
    fprintf(fid, 'N_STEPS: %d\n', length(t_sol) - 1);
    fprintf(fid, 'NFEV: %d\n', nfev);
    fprintf(fid, 'CPU_TIME_S: %.6f\n', cpu_time_avg);
    fprintf(fid, 'E_INF_K: %.6e\n', E_inf);
    fprintf(fid, 'E_RMS_K: %.6e\n', E_rms);
    fprintf(fid, 'ENERGY_REL_ERR: %.6e\n', energy_rel_error);
    fprintf(fid, 'PHYSICAL_CHECK: PASS (T_min = %.2f K > 2.7 K)\n', min(y_sol(:)));
    fprintf(fid, 'PATHS:\n');
    fprintf(fid, '  - config: results/%s/config.json\n', run_id);
    fprintf(fid, '  - data_mat: results/%s/solution.mat\n', run_id);
    fprintf(fid, '  - data_csv: results/%s/solution.csv\n', run_id);
    fprintf(fid, '  - qoi: results/%s/qoi.json\n', run_id);
    fprintf(fid, '  - errors: results/%s/errors.json\n', run_id);
    fprintf(fid, '  - cost: results/%s/cost.json\n', run_id);
    fclose(fid);

    % H. Acumular en tabla resumen
    row_entry = table({run_id}, {cfg.solver}, cfg.h, cfg.rtol, length(t_sol)-1, nfev, cpu_time_avg, ...
        E_inf, E_rms, energy_rel_error, min(y_sol(:)), {status_msg}, ...
        'VariableNames', {'RunID', 'Solver', 'Step_h', 'RelTol', 'Steps', 'NFEV', 'CPU_Time_s', ...
                          'E_inf_K', 'E_rms_K', 'Energy_Rel_Err', 'Min_T_K', 'Status'});
    results_table = [results_table; row_entry];
end

%% 6. Verificacion Cruzada de la Referencia
fprintf('\n--- Comprobacion de Consistencia de la Referencia ---\n');
idx_ref_ode15s = find(strcmp(results_table.RunID, 'RUN-00-REF-ODE15S'));
if ~isempty(idx_ref_ode15s)
    ref_diff = results_table.E_inf_K(idx_ref_ode15s);
    fprintf('Discrepancia maxima ||T_ode45 - T_ode15s||_inf = %.3e K\n', ref_diff);
    if ref_diff < 1e-5
        fprintf('[SUPERADO] Consistencia de referencia verificada (< 1e-5 K).\n');
    else
        fprintf('[ADVERTENCIA] Discrepancia entre referencias supera umbral nominal: %.3e K\n', ref_diff);
    end
end

%% 7. Calculo de Ordenes Empiricos de Convergencia
fprintf('\n--- Calculo de Ordenes Empiricos de Convergencia (p_emp) ---\n');

% Funciones de extraccion
get_errors = @(family_prefix) results_table.E_inf_K(startsWith(results_table.RunID, family_prefix));
get_rms    = @(family_prefix) results_table.E_rms_K(startsWith(results_table.RunID, family_prefix));

eul_E_inf = get_errors('RUN-1'); eul_E_rms = get_rms('RUN-1');
rk2_E_inf = get_errors('RUN-2'); rk2_E_rms = get_rms('RUN-2');
rk4_E_inf = get_errors('RUN-3'); rk4_E_rms = get_rms('RUN-3');

p_eul_inf = log(eul_E_inf(1:end-1) ./ eul_E_inf(2:end)) ./ log(2);
p_rk2_inf = log(rk2_E_inf(1:end-1) ./ rk2_E_inf(2:end)) ./ log(2);
p_rk4_inf = log(rk4_E_inf(1:end-1) ./ rk4_E_inf(2:end)) ./ log(2);

p_eul_rms = log(eul_E_rms(1:end-1) ./ eul_E_rms(2:end)) ./ log(2);
p_rk2_rms = log(rk2_E_rms(1:end-1) ./ rk2_E_rms(2:end)) ./ log(2);
p_rk4_rms = log(rk4_E_rms(1:end-1) ./ rk4_E_rms(2:end)) ./ log(2);

fprintf('Mallas h: [60->30, 30->15, 15->7.5, 7.5->3.75] s\n');
fprintf('Euler  p_emp (L_inf): [%.2f, %.2f, %.2f, %.2f] | p_emp (RMS): [%.2f, %.2f, %.2f, %.2f]\n', ...
    p_eul_inf, p_eul_rms);
fprintf('RK2    p_emp (L_inf): [%.2f, %.2f, %.2f, %.2f] | p_emp (RMS): [%.2f, %.2f, %.2f, %.2f]\n', ...
    p_rk2_inf, p_rk2_rms);
fprintf('RK4    p_emp (L_inf): [%.2f, %.2f, %.2f, %.2f] | p_emp (RMS): [%.2f, %.2f, %.2f, %.2f]\n', ...
    p_rk4_inf, p_rk4_rms);

%% 8. Generacion de Figuras
fprintf('\nGenerando figuras de convergencia y diagnostico...\n');

% Figura 1: Curvas de Convergencia E_inf vs h
fig1 = figure('Name', 'Convergencia_Error', 'Position', [100, 100, 800, 600], 'Visible', 'off');
loglog(h_steps, eul_E_inf, 's-', 'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', 'Euler Explícito (Medido)');
hold on;
loglog(h_steps, rk2_E_inf, 'o-', 'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', 'RK2 Punto Medio (Medido)');
loglog(h_steps, rk4_E_inf, 'd-', 'LineWidth', 2, 'MarkerSize', 8, 'DisplayName', 'RK4 Clásico (Medido)');

% Pendientes teoricas
loglog(h_steps, eul_E_inf(end) * (h_steps / h_steps(end)).^1, 'k--', 'LineWidth', 1.2, 'DisplayName', 'Pendiente teórica p=1');
loglog(h_steps, rk2_E_inf(end) * (h_steps / h_steps(end)).^2, 'b--', 'LineWidth', 1.2, 'DisplayName', 'Pendiente teórica p=2');
loglog(h_steps, rk4_E_inf(end) * (h_steps / h_steps(end)).^4, 'r--', 'LineWidth', 1.2, 'DisplayName', 'Pendiente teórica p=4');

grid on;
xlabel('Paso temporal h [s]', 'FontSize', 12);
ylabel('Error global ||T_h - T_{ref}||_\infty [K]', 'FontSize', 12);
title('Convergencia del Error Global vs Paso h (STARLINK-1008)', 'FontSize', 13);
legend('Location', 'northwest', 'FontSize', 10);
saveas(fig1, fullfile(figures_dir, 'fig1_convergence_error.png'));

% Figura 2: Eficiencia de Pareto (Error vs NFEV y Error vs CPU Time)
fig2 = figure('Name', 'Eficiencia_Pareto', 'Position', [150, 150, 900, 450], 'Visible', 'off');
subplot(1, 2, 1);
loglog(results_table.NFEV(startsWith(results_table.RunID, 'RUN-1')), eul_E_inf, 's-', 'LineWidth', 1.8, 'DisplayName', 'Euler');
hold on;
loglog(results_table.NFEV(startsWith(results_table.RunID, 'RUN-2')), rk2_E_inf, 'o-', 'LineWidth', 1.8, 'DisplayName', 'RK2');
loglog(results_table.NFEV(startsWith(results_table.RunID, 'RUN-3')), rk4_E_inf, 'd-', 'LineWidth', 1.8, 'DisplayName', 'RK4');
idx_ode45_nom = find(strcmp(results_table.RunID, 'RUN-01-ODE45'));
loglog(results_table.NFEV(idx_ode45_nom), results_table.E_inf_K(idx_ode45_nom), 'p', 'MarkerSize', 12, ...
    'MarkerFaceColor', 'magenta', 'DisplayName', 'ode45 (nom)');
grid on; xlabel('Evaluaciones de f (NFEV)'); ylabel('Error L_\infty [K]');
title('Precisión vs Evaluaciones (NFEV)'); legend('Location', 'northeast');

subplot(1, 2, 2);
loglog(results_table.CPU_Time_s(startsWith(results_table.RunID, 'RUN-1')), eul_E_inf, 's-', 'LineWidth', 1.8, 'DisplayName', 'Euler');
hold on;
loglog(results_table.CPU_Time_s(startsWith(results_table.RunID, 'RUN-2')), rk2_E_inf, 'o-', 'LineWidth', 1.8, 'DisplayName', 'RK2');
loglog(results_table.CPU_Time_s(startsWith(results_table.RunID, 'RUN-3')), rk4_E_inf, 'd-', 'LineWidth', 1.8, 'DisplayName', 'RK4');
loglog(results_table.CPU_Time_s(idx_ode45_nom), results_table.E_inf_K(idx_ode45_nom), 'p', 'MarkerSize', 12, ...
    'MarkerFaceColor', 'magenta', 'DisplayName', 'ode45 (nom)');
grid on; xlabel('Tiempo CPU Wall-clock [s]'); ylabel('Error L_\infty [K]');
title('Precisión vs Tiempo de Cómputo'); legend('Location', 'northeast');
saveas(fig2, fullfile(figures_dir, 'fig2_efficiency_pareto.png'));

% Figura 3: Perfil Termico Multiórbita de la Referencia
fig3 = figure('Name', 'Perfiles_Termicos_Referencia', 'Position', [200, 200, 900, 500], 'Visible', 'off');
t_hours = t_ref_dense / 3600.0;
plot(t_hours, y_ref_dense - 273.15, 'LineWidth', 1.6);
grid on;
xlabel('Tiempo desde la época [horas]', 'FontSize', 11);
ylabel('Temperatura [°C]', 'FontSize', 11);
title('Evolución Térmica en 5 Órbitas - Solución Referencia ode45', 'FontSize', 12);
legend(params.names, 'Location', 'eastoutside', 'FontSize', 9);
saveas(fig3, fullfile(figures_dir, 'fig3_temperature_profiles.png'));

fprintf('Figuras guardadas en %s\n', figures_dir);

%% 9. Guardar Tablas de Resultados
writetable(results_table, fullfile(results_root, 'summary_table.csv'));
fprintf('Tabla resumen guardada en results/summary_table.csv\n\n');

%% 10. Reporte en Pantalla
disp(results_table(:, {'RunID', 'Solver', 'Step_h', 'NFEV', 'CPU_Time_s', 'E_inf_K', 'Energy_Rel_Err', 'Status'}));

fprintf('\n========================================================================\n');
fprintf('  MATRIZ AUTORIZADA COMPLETADA Y VERIFICADA.\n');
fprintf('========================================================================\n');

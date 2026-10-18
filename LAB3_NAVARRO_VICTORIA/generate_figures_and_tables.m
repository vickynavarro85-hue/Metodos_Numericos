% GENERATE_FIGURES_AND_TABLES Genera la figura y tabla de publicacion para Lab 3
% Satelite STARLINK-1008 (PVI nodal termico continuo de 6 caras en LEO)
%
% Entregables:
%   1. results/fig_manuscript_results.png (Figura multi-panel de alta resolucion)
%   2. results/table_results_consolidated.csv (Tabla de datos consolidados)
%   3. results/table_results_consolidated.md (Tabla formateada en Markdown)

function generate_figures_and_tables()
    fprintf('=================================================================\n');
    fprintf('  LAB 3 - GENERACION DE FIGURAS Y TABLAS DE PUBLICACION (V2)\n');
    fprintf('  Roles: Figure Agent & Table Agent\n');
    fprintf('=================================================================\n\n');

    script_dir = fileparts(mfilename('fullpath'));
    results_dir = fullfile(script_dir, 'results');

    % 1. Cargar datos del barrido desde sweep_summary.csv
    sweep_csv = fullfile(results_dir, 'sweep_summary.csv');
    if ~exist(sweep_csv, 'file')
        error('STOP: No se encontro sweep_summary.csv en %s', results_dir);
    end
    opts = detectImportOptions(sweep_csv);
    tbl_sweep = readtable(sweep_csv, opts);

    % 2. Cargar datos de sensibilidad del Bloque A
    sens_runs = {'C3-SENS-001-M10', 'C3-SENS-003-M05', 'C3-BASE-001', 'C3-SENS-004-P05', 'C3-SENS-002-P10'};
    Q_sens = [36.0, 38.0, 40.0, 42.0, 44.0];
    M1_sens = zeros(1, 5);
    M2_sens = zeros(1, 5);
    M3_sens = zeros(1, 5);

    for i = 1:5
        cfg_file = fullfile(results_dir, sens_runs{i}, 'config.json');
        cfg = jsondecode(fileread(cfg_file));
        M1_sens(i) = cfg.M1_Tmax_pX;
        M2_sens(i) = cfg.M2_deltaT;
        M3_sens(i) = cfg.M3_Tmin_pZ;
    end

    % -----------------------------------------------------------------
    % GENERACION DE LA FIGURA DE PUBLICACION (fig_manuscript_results.png)
    % -----------------------------------------------------------------
    fprintf('Generando figura de publicacion multi-panel corregida...\n');
    fig = figure('Visible', 'off', 'Position', [60, 60, 1260, 800], 'Color', 'w');

    % PANEL (a): Sensibilidad Local y Derivadas Centradas (Bloque A)
    subplot(2, 2, 1);
    plot(Q_sens, M1_sens - 273.15, 'b-o', 'LineWidth', 1.8, ...
         'MarkerSize', 7, 'MarkerFaceColor', [0.2, 0.4, 0.9], 'DisplayName', 'Pares Perturbados (\pm5%, \pm10%)');
    hold on;
    % Resaltar el Baseline con estrella roja
    plot(40.0, M1_sens(3) - 273.15, 'rp', 'MarkerSize', 13, ...
         'MarkerFaceColor', 'r', 'LineWidth', 1.5, 'DisplayName', 'Baseline: C3-BASE-001 (40 W)');
    grid on;
    set(gca, 'FontSize', 10, 'GridAlpha', 0.25);
    xlim([35.5, 44.5]);
    ylim([18.0, 19.35]);
    xlabel('Potencia de Avionica \theta = Q_{int, +X} [W]', 'FontWeight', 'bold');
    ylabel('M_1: Temp. Maxima T_{max, +X} [^\circC]', 'FontWeight', 'bold');
    title('(a) Sensibilidad en Proa (+X / Ram)', 'FontSize', 11, 'FontWeight', 'bold');
    legend('Location', 'northwest', 'FontSize', 9);
    % Recuadro reubicado en la esquina inferior derecha para evitar solapamiento
    text(39.6, 18.30, sprintf('D_1(\\delta=4.0 W) = 0.1320 K/W\nD_1(\\delta=2.0 W) = 0.1369 K/W\nDiscrepancia: 3.59%%'), ...
         'FontSize', 9, 'BackgroundColor', [0.96, 0.98, 1.0], 'EdgeColor', [0.5, 0.7, 0.9]);

    % PANEL (b): Barrido Parametrico 3x3 e Iso-conductancias (Bloque B)
    subplot(2, 2, 2);
    idx_g1 = [1, 4, 7];
    idx_g2 = [2, 5, 8];
    idx_g4 = [3, 6, 9];

    Q_sweep_levels = [20.0, 40.0, 60.0];
    T_g1 = tbl_sweep.M1_Tmax_pX_C(idx_g1);
    T_g2 = tbl_sweep.M1_Tmax_pX_C(idx_g2);
    T_g4 = tbl_sweep.M1_Tmax_pX_C(idx_g4);

    plot(Q_sweep_levels, T_g1, '--s', 'Color', [0.8, 0.2, 0.1], 'LineWidth', 1.8, ...
         'MarkerSize', 8, 'MarkerFaceColor', [0.8, 0.2, 0.1], ...
         'DisplayName', 'g_{lin} = 1.0 W/(K\cdotm) (Aislado)');
    hold on;
    plot(Q_sweep_levels, T_g2, '-o', 'Color', [0.1, 0.6, 0.2], 'LineWidth', 1.8, ...
         'MarkerSize', 8, 'MarkerFaceColor', [0.1, 0.6, 0.2], ...
         'DisplayName', 'g_{lin} = 2.0 W/(K\cdotm) (Nominal)');
    plot(Q_sweep_levels, T_g4, ':^', 'Color', [0.1, 0.3, 0.8], 'LineWidth', 1.8, ...
         'MarkerSize', 8, 'MarkerFaceColor', [0.1, 0.3, 0.8], ...
         'DisplayName', 'g_{lin} = 4.0 W/(K\cdotm) (Conectivo)');
    % Resaltar baseline reutilizado C3-SWEEP-005
    plot(40.0, T_g2(2), 'rp', 'MarkerSize', 14, 'MarkerFaceColor', 'r', ...
         'DisplayName', 'C3-SWEEP-005 (Reutiliza Baseline)');
    grid on;
    set(gca, 'FontSize', 10, 'GridAlpha', 0.25);
    xlabel('Potencia de Avionica Q_{int, +X} [W]', 'FontWeight', 'bold');
    ylabel('M_1: Temp. Maxima T_{max, +X} [^\circC]', 'FontWeight', 'bold');
    title('(b) Iso-Conductancias en Proa (+X)', 'FontSize', 11, 'FontWeight', 'bold');
    legend('Location', 'northwest', 'FontSize', 8.5);

    % Rótulos explicativos sutiles de Run IDs en extremos
    text(21.0, T_g1(1) - 1.2, 'C3-SWEEP-001', 'FontSize', 8, 'Color', [0.7, 0.1, 0.1]);
    text(45.0, T_g1(3) + 1.2, 'C3-SWEEP-007 (Peor caliente)', 'FontSize', 8, 'Color', [0.7, 0.1, 0.1]);
    text(21.0, T_g4(1) - 1.2, 'C3-SWEEP-003', 'FontSize', 8, 'Color', [0.1, 0.2, 0.7]);
    text(48.0, T_g4(3) - 1.2, 'C3-SWEEP-009', 'FontSize', 8, 'Color', [0.1, 0.2, 0.7]);

    % PANEL (c): Mitigacion de la Amplitud Termica M2 (Swing Delta T)
    subplot(2, 2, 3);
    deltaT_g1 = tbl_sweep.M2_deltaT_pX_K(idx_g1);
    deltaT_g2 = tbl_sweep.M2_deltaT_pX_K(idx_g2);
    deltaT_g4 = tbl_sweep.M2_deltaT_pX_K(idx_g4);

    plot(Q_sweep_levels, deltaT_g1, '--s', 'Color', [0.8, 0.2, 0.1], 'LineWidth', 1.8, ...
         'MarkerSize', 8, 'MarkerFaceColor', [0.8, 0.2, 0.1], 'DisplayName', 'g_{lin} = 1.0 W/(K\cdotm)');
    hold on;
    plot(Q_sweep_levels, deltaT_g2, '-o', 'Color', [0.1, 0.6, 0.2], 'LineWidth', 1.8, ...
         'MarkerSize', 8, 'MarkerFaceColor', [0.1, 0.6, 0.2], 'DisplayName', 'g_{lin} = 2.0 W/(K\cdotm)');
    plot(Q_sweep_levels, deltaT_g4, ':^', 'Color', [0.1, 0.3, 0.8], 'LineWidth', 1.8, ...
         'MarkerSize', 8, 'MarkerFaceColor', [0.1, 0.3, 0.8], 'DisplayName', 'g_{lin} = 4.0 W/(K\cdotm)');
    grid on;
    set(gca, 'FontSize', 10, 'GridAlpha', 0.25);
    xlabel('Potencia de Avionica Q_{int, +X} [W]', 'FontWeight', 'bold');
    ylabel('M_2: Amplitud Termica \DeltaT_{+X} [^\circC \equiv K]', 'FontWeight', 'bold');
    title('(c) Amplitud de Oscilacion Cíclica en Proa (+X)', 'FontSize', 11, 'FontWeight', 'bold');
    legend('Location', 'northeast', 'FontSize', 8.5);

    % PANEL (d): Acoplamiento Termico hacia el Radiador Cenit M3 (T_min, +Z)
    subplot(2, 2, 4);
    Tmin_g1 = tbl_sweep.M3_Tmin_pZ_C(idx_g1);
    Tmin_g2 = tbl_sweep.M3_Tmin_pZ_C(idx_g2);
    Tmin_g4 = tbl_sweep.M3_Tmin_pZ_C(idx_g4);

    plot(Q_sweep_levels, Tmin_g1, '--s', 'Color', [0.8, 0.2, 0.1], 'LineWidth', 1.8, ...
         'MarkerSize', 8, 'MarkerFaceColor', [0.8, 0.2, 0.1], 'DisplayName', 'g_{lin} = 1.0 W/(K\cdotm)');
    hold on;
    plot(Q_sweep_levels, Tmin_g2, '-o', 'Color', [0.1, 0.6, 0.2], 'LineWidth', 1.8, ...
         'MarkerSize', 8, 'MarkerFaceColor', [0.1, 0.6, 0.2], 'DisplayName', 'g_{lin} = 2.0 W/(K\cdotm)');
    plot(Q_sweep_levels, Tmin_g4, ':^', 'Color', [0.1, 0.3, 0.8], 'LineWidth', 1.8, ...
         'MarkerSize', 8, 'MarkerFaceColor', [0.1, 0.3, 0.8], 'DisplayName', 'g_{lin} = 4.0 W/(K\cdotm)');
    grid on;
    set(gca, 'FontSize', 10, 'GridAlpha', 0.25);
    xlabel('Potencia de Avionica Q_{int, +X} [W]', 'FontWeight', 'bold');
    ylabel('M_3: Temp. Minima Radiador T_{min, +Z} [^\circC]', 'FontWeight', 'bold');
    title('(d) Calentamiento Pasivo del Radiador Cenit (+Z)', 'FontSize', 11, 'FontWeight', 'bold');
    legend('Location', 'southeast', 'FontSize', 8.5);

    % Titulo super-general que define contexto, satelite y ventana temporal
    sgtitle('Satelite STARLINK-1008 (LEO) - Regimen Permanente Ciclico t \in [3P, 5P] (P = 5525.2 s)', ...
            'FontSize', 12, 'FontWeight', 'bold');

    fig_out = fullfile(results_dir, 'fig_manuscript_results.png');
    saveas(fig, fig_out);
    close(fig);
    fprintf('[OK] Figura de publicacion guardada en: %s\n', fig_out);

    % -----------------------------------------------------------------
    % GENERACION DE LA TABLA CONSOLIDADA (table_results_consolidated)
    % -----------------------------------------------------------------
    fprintf('Generando tabla consolidada de resultados con sintaxis corregida...\n');
    all_runs = { ...
        'C3-BASE-001', 'Baseline Nominal', 40.0, 2.0, 291.7968, 18.6468, 63.0588, 209.9365, -63.2135, 351, 2707, 0.22, 'VÁLIDA (Baseline Nominal)'; ...
        'C3-SENS-001-M10', 'Sensibilidad (-10%)', 36.0, 2.0, 291.2630, 18.1130, 63.1689, 209.8110, -63.3390, 359, 2785, 0.28, 'VÁLIDA ($\delta = 4.0\text{ W}$)'; ...
        'C3-SENS-002-P10', 'Sensibilidad (+10%)', 44.0, 2.0, 292.3186, 19.1686, 62.9621, 210.0746, -63.0754, 364, 2821, 0.13, 'VÁLIDA ($\delta = 4.0\text{ W}$)'; ...
        'C3-SENS-003-M05', 'Sensibilidad (-5%)', 38.0, 2.0, 291.5441, 18.3941, 63.1182, 209.8673, -63.2827, 354, 2731, 0.10, 'VÁLIDA ($\delta/2 = 2.0\text{ W}$)'; ...
        'C3-SENS-004-P05', 'Sensibilidad (+5%)', 42.0, 2.0, 292.0915, 18.9415, 63.0562, 210.0151, -63.1349, 367, 2869, 0.12, 'VÁLIDA ($\delta/2 = 2.0\text{ W}$)'; ...
        'C3-SWEEP-001', 'Barrido (Q20, g1)', 20.0, 1.0, 298.1956, 25.0456, 72.5035, 200.5173, -72.6327, 331, 2707, 0.16, 'VÁLIDA (Aislado)'; ...
        'C3-SWEEP-002', 'Barrido (Q20, g2)', 20.0, 2.0, 289.0864, 15.9364, 63.5247, 209.2479, -63.9021, 352, 2695, 0.12, 'VÁLIDA (Nominal)'; ...
        'C3-SWEEP-003', 'Barrido (Q20, g4)', 20.0, 4.0, 282.8593, 9.7093, 57.2910, 215.8486, -57.3014, 418, 3139, 0.12, 'VÁLIDA (Conectivo)'; ...
        'C3-SWEEP-004', 'Barrido (Q40, g1)', 40.0, 1.0, 302.2978, 29.1478, 71.5176, 201.2055, -71.9445, 318, 2575, 0.09, 'VÁLIDA (Aislado)'; ...
        'C3-SWEEP-005', 'Barrido (Q40, g2)', 40.0, 2.0, 291.7968, 18.6468, 63.0588, 209.9365, -63.2135, 351, 0, 0.00, 'VÁLIDA (Reutiliza C3-BASE-001*)'; ...
        'C3-SWEEP-006', 'Barrido (Q40, g4)', 40.0, 4.0, 284.6377, 11.4877, 57.0701, 216.5390, -56.6110, 419, 3121, 0.11, 'VÁLIDA (Conectivo)'; ...
        'C3-SWEEP-007', 'Barrido (Q60, g1)', 60.0, 1.0, 306.3326, 33.1826, 70.5001, 201.8378, -71.3122, 318, 2557, 0.09, 'VÁLIDA (Peor Caliente)'; ...
        'C3-SWEEP-008', 'Barrido (Q60, g2)', 60.0, 2.0, 294.5091, 21.3591, 62.6261, 210.6127, -62.5373, 357, 2785, 0.11, 'VÁLIDA (Nominal)'; ...
        'C3-SWEEP-009', 'Barrido (Q60, g4)', 60.0, 4.0, 286.4153, 13.2653, 56.8516, 217.2336, -55.9164, 409, 3031, 0.13, 'VÁLIDA (Conectivo)' ...
    };

    % Guardar como CSV
    tbl_out_csv = fullfile(results_dir, 'table_results_consolidated.csv');
    fid = fopen(tbl_out_csv, 'w');
    fprintf(fid, 'Run_ID,Bloque,Q_int_W,g_lin_W_Km,M1_Tmax_pX_K,M1_Tmax_pX_C,M2_deltaT_pX_K,M3_Tmin_pZ_K,M3_Tmin_pZ_C,pasos,nfev,cpu_time_s,estado\n');
    for r = 1:size(all_runs, 1)
        fprintf(fid, '%s,%s,%.1f,%.1f,%.4f,%.4f,%.4f,%.4f,%.4f,%d,%d,%.4f,%s\n', ...
                all_runs{r, 1}, all_runs{r, 2}, all_runs{r, 3}, all_runs{r, 4}, ...
                all_runs{r, 5}, all_runs{r, 6}, all_runs{r, 7}, all_runs{r, 8}, ...
                all_runs{r, 9}, all_runs{r, 10}, all_runs{r, 11}, all_runs{r, 12}, all_runs{r, 13});
    end
    fclose(fid);
    fprintf('[OK] Tabla CSV guardada en: %s\n', tbl_out_csv);

    % Guardar como Markdown
    tbl_out_md = fullfile(results_dir, 'table_results_consolidated.md');
    fid = fopen(tbl_out_md, 'w');
    fprintf(fid, '# Tabla Consolidada de Resultados Experimentales - Satelite STARLINK-1008\n\n');
    fprintf(fid, '> **Ventana temporal de evaluacion:** Regimen permanente periodico de las ultimas dos orbitas: $t \\in [3P, 5P] = [16575.7, 27600.0]\\text{ s}$ ($P = 5525.2\\text{ s}$).  \n');
    fprintf(fid, '> **Nomenclatura nodal:** $+X$ = Cara delantera de proa (ram) con avionica; $+Z$ = Cara cenit (radiador orientado al espacio profundo).\n\n');
    fprintf(fid, '| Run ID | Bloque / Descripcion | $Q_{int, +X}$ [W] | $g_{lin}$ [W/(K·m)] | $M_1$ ($T_{max, +X}$) [K] | $M_1$ [$^\\circ$C] | $M_2$ ($\\Delta T_{+X}$) [K] | $M_3$ ($T_{min, +Z}$) [K] | $M_3$ [$^\\circ$C] | Pasos | NFEV | CPU [s] | Estado Operacional |\n');
    fprintf(fid, '| :--- | :--- | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :---: | :--- |\n');
    for r = 1:size(all_runs, 1)
        fprintf(fid, '| `%s` | %s | %.1f | %.1f | %.4f | %+.2f | %.4f | %.4f | %+.2f | %d | %d | %.2f | %s |\n', ...
                all_runs{r, 1}, all_runs{r, 2}, all_runs{r, 3}, all_runs{r, 4}, ...
                all_runs{r, 5}, all_runs{r, 6}, all_runs{r, 7}, all_runs{r, 8}, ...
                all_runs{r, 9}, all_runs{r, 10}, all_runs{r, 11}, all_runs{r, 12}, all_runs{r, 13});
    end
    fprintf(fid, '\n*Nota de reutilizacion:* `C3-SWEEP-005` coincide exactamente con la configuracion del baseline nominal; reutiliza formalmente la integracion de `C3-BASE-001` (351 pasos archivados) con 0 evaluaciones diferenciales nuevas (NFEV = 0, CPU = 0.00 s).\n');
    fclose(fid);
    fprintf('[OK] Tabla Markdown guardada en: %s\n', tbl_out_md);

    fprintf('=================================================================\n');
    fprintf('  FIGURAS Y TABLAS ACTUALIZADAS CON EXITO\n');
    fprintf('=================================================================\n\n');
end

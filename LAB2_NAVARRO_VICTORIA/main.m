% MAIN.M - Script principal de verificacion inicial y prueba breve
% Laboratorio #2 - Metodos Numericos
% Satelite STARLINK-1008 (6 estados termicos acoplados)
%
% Autor: Numerical Methods Agent
% Supervisora: Victoria Navarro

clear; clc; close all;

fprintf('========================================================================\n');
fprintf('  LABORATORIO #2: INTEGRACION NUMERICA Y CONVERGENCIA - STARLINK-1008\n');
fprintf('========================================================================\n\n');

%% 1. Verificacion de Autorizacion Humana
review_file = fullfile(fileparts(mfilename('fullpath')), 'Human_Review.md');
if ~exist(review_file, 'file')
    error('MAIN:NoHumanReview', 'Falta archivo Human_Review.md. Detenido.');
end
review_text = fileread(review_file);
if ~contains(review_text, 'ACEPTAR')
    error('MAIN:NotAuthorized', 'Decision humana no es ACEPTAR en Human_Review.md. Detenido.');
end
fprintf('[OK] Autorizacion humana verificada en Human_Review.md (Decision: ACEPTAR).\n\n');

%% 2. Carga de Parametros y Verificacion de Unidades y Signos
params = get_params();

fprintf('Parametros del Modelo Termico (SI):\n');
fprintf('  - Estados (K): T = [T_+X, T_-X, T_+Y, T_-Y, T_+Z, T_-Z]^T\n');
fprintf('  - Capacitancias C (J/K): [%.1f, %.1f, %.1f, %.1f, %.1f, %.1f]\n', params.C);
fprintf('  - Areas A (m^2):         [%.2f, %.2f, %.2f, %.2f, %.2f, %.2f]\n', params.A);
fprintf('  - Absortividades alpha:  [%.2f, %.2f, %.2f, %.2f, %.2f, %.2f]\n', params.alpha);
fprintf('  - Emisividades eps:      [%.2f, %.2f, %.2f, %.2f, %.2f, %.2f]\n', params.eps);
fprintf('  - Disipacion interna (W):[%.1f, %.1f, %.1f, %.1f, %.1f, %.1f]\n', params.Q_int);
fprintf('  - Conductancia lineal:   g_lin = %.2f W/(K*m)\n', params.g_lin);
fprintf('  - Periodo orbital:       P = %.2f s (%.2f min)\n', params.PERIODO_S, params.PERIODO_S/60);
fprintf('  - Dominio temporal:      t in [0, %.2f] s (%d orbitas)\n\n', params.t_final, params.N_ORBITAS);

%% 3. Evaluacion y Verificacion en t = 0 s
T0 = params.T0;
[dTdt0, flx0] = model(0.0, T0, params);

fprintf('Chequeo Fisico en t = 0 s (Condicion Inicial: 0 degC = 273.15 K):\n');
for i = 1:6
    fprintf('  Cara %-12s: dT/dt = %+8.5f K/s | Q_net = %+7.2f W (Sol=%.1f, Alb=%.1f, IR=%.1f, Int=%.1f, Cond=%.1f, Emit=%.1f)\n', ...
        params.names{i}, dTdt0(i), flx0.Q_net(i), flx0.Q_sol(i), flx0.Q_alb(i), flx0.Q_ir(i), flx0.Q_int(i), flx0.Q_cond(i), flx0.Q_emit(i));
end

% Aserciones de consistencia fisica
assert(all(abs(flx0.Q_cond) < 1e-10), 'MAIN:Fail', 'La conduccion en t=0 debe ser nula (salvo redondeo) al ser isotermo.');
assert(all(flx0.Q_sol == 0), 'MAIN:Fail', 'En t=0 el satelite inicia en eclipse, flujo solar directo debe ser 0.');
assert(all(flx0.Q_emit > 0), 'MAIN:Fail', 'La emision radiativa a 273.15 K debe ser estrictamente disipativa (> 0).');
assert(all(dTdt0 < 0), 'MAIN:Fail', 'En eclipse a 273.15 K todas las derivadas deben ser negativas (enfriamiento).');
fprintf('[OK] Verificacion analitica de signos y balance en t=0 superada.\n\n');

%% 4. Prueba Breve de Integracion (1 orbita: t in [0, P])
t_test_end = params.PERIODO_S;
fprintf('Ejecutando prueba breve de integracion (1 orbita = %.1f s)...\n', t_test_end);

f_ode = @(t, T) model(t, T, params);

% 1. ode45
tic;
[t_test_ode, y_test_ode, nfev_ode] = solve_adaptive('ode45', f_ode, [0, t_test_end], T0, 1e-6, 1e-6);
time_ode = toc;
fprintf('  [ode45] Pasos: %4d | nfev: %5d | CPU: %.4f s | Final T(+X): %.2f K (%.2f C)\n', ...
    length(t_test_ode)-1, nfev_ode, time_ode, y_test_ode(end,1), y_test_ode(end,1)-273.15);

% 2. RK4 (h = 15 s)
tic;
[t_test_rk4, y_test_rk4, nfev_rk4] = solve_rk4(f_ode, [0, t_test_end], T0, 15.0);
time_rk4 = toc;
fprintf('  [RK4-15] Pasos: %4d | nfev: %5d | CPU: %.4f s | Final T(+X): %.2f K (%.2f C)\n', ...
    length(t_test_rk4)-1, nfev_rk4, time_rk4, y_test_rk4(end,1), y_test_rk4(end,1)-273.15);

% 3. RK2 (h = 15 s)
tic;
[t_test_rk2, y_test_rk2, nfev_rk2] = solve_rk2(f_ode, [0, t_test_end], T0, 15.0);
time_rk2 = toc;
fprintf('  [RK2-15] Pasos: %4d | nfev: %5d | CPU: %.4f s | Final T(+X): %.2f K (%.2f C)\n', ...
    length(t_test_rk2)-1, nfev_rk2, time_rk2, y_test_rk2(end,1), y_test_rk2(end,1)-273.15);

% 4. Euler (h = 15 s)
tic;
[t_test_eul, y_test_eul, nfev_eul] = solve_euler(f_ode, [0, t_test_end], T0, 15.0);
time_eul = toc;
fprintf('  [EUL-15] Pasos: %4d | nfev: %5d | CPU: %.4f s | Final T(+X): %.2f K (%.2f C)\n', ...
    length(t_test_eul)-1, nfev_eul, time_eul, y_test_eul(end,1), y_test_eul(end,1)-273.15);

% Verificacion de admisibilidad fisica
assert(min(y_test_ode(:)) > 2.7, 'MAIN:Fail', 'ode45 violo cota T > 2.7 K.');
assert(min(y_test_rk4(:)) > 2.7, 'MAIN:Fail', 'RK4 violo cota T > 2.7 K.');
assert(min(y_test_rk2(:)) > 2.7, 'MAIN:Fail', 'RK2 violo cota T > 2.7 K.');
assert(min(y_test_eul(:)) > 2.7, 'MAIN:Fail', 'Euler violo cota T > 2.7 K.');

fprintf('\n========================================================================\n');
fprintf('  PRUEBA BREVE SUPERADA CON EXITO.\n');
fprintf('  El sistema esta listo para ejecutar la matriz autorizada en run_convergence.m\n');
fprintf('========================================================================\n');

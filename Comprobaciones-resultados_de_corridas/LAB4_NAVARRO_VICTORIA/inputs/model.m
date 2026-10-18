function [dTdt, fluxes] = model(t, T, params)
% MODEL Sistema de 6 EDOs termicas no lineales acopladas para satelite STARLINK-1008.
%
% Ecuacion diferencial por nodo i in {1..6}:
%   C_i * dT_i/dt = Q_sol_i(t) + Q_alb_i(t) + Q_ir_i + Q_int_i + Q_cond_i(T) - Q_emit_i(T_i)
%
% Entradas:
%   t      - Tiempo actual [s] (escalar)
%   T      - Vector de temperaturas de los 6 nodos [K] (6x1)
%            Orden: [+X, -X, +Y, -Y, +Z, -Z]
%   params - Estructura de parametros generada por get_params()
%
% Salidas:
%   dTdt   - Vector de derivadas temporales [K/s] (6x1)
%   fluxes - (Opcional) Estructura con desglose de potencias en Watts [W]

    % Verificacion de valores finitos
    if any(~isfinite(T))
        error('MODEL:NonFiniteState', 'Se detectaron valores no finitos (NaN/Inf) en T en t = %.4f s.', t);
    end

    % Cota fisica minima para el calculo de emision radiativa en etapas tentativas
    T_rad = max(T, params.T_espacio);

    % 1. Direccion solar en ejes cuerpo normalizada
    s = [params.interp_sx(t); params.interp_sy(t); params.interp_sz(t)];
    norm_s = norm(s);
    if norm_s > 0
        s = s / norm_s;
    end

    % 2. Variables del entorno orbital interpoladas
    ilum_val = params.interp_ilum(t);
    ilum_t   = double(ilum_val >= 0.5); % 1 si iluminado, 0 si en eclipse
    S_t      = params.interp_S(t);      % Constante solar corregida [W/m^2]
    mu_t     = max(0.0, params.interp_mu(t)); % Coseno solar cenital subsatelite

    % 3. Coseno de incidencia solar en cada cara
    cos_inc = max(0.0, params.normals * s); % max(0, n_i . s)

    % 4. Terminos de potencia termica entrante [W]
    % Flujo solar directo
    Q_sol = params.alpha .* params.A .* S_t .* ilum_t .* cos_inc;

    % Flujo de albedo terrestre
    Q_alb = params.alpha .* params.A .* S_t .* params.albedo .* params.F_tierra .* mu_t .* ilum_t;

    % Flujo infrarrojo terrestre (constante en el tiempo)
    Q_ir  = params.eps .* params.A .* params.q_ir_earth .* params.F_tierra;

    % Disipacion interna fija
    Q_int = params.Q_int;

    % 5. Conduccion neta estructural entre caras adyacentes [W]
    % Q_cond_i = sum_j G_ij * (T_j - T_i) = (G * T)_i - G_row_i * T_i
    Q_cond = params.G * T - params.G_row .* T;

    % 6. Emision radiativa disipativa al espacio profundo [W]
    % Q_emit_i = sigma * eps_i * A_i * (T_rad_i^4 - T_esp^4)
    Q_emit = params.sigma_SB .* params.eps .* params.A .* (T_rad.^4 - params.T_espacio^4);

    % 7. Balance termico neto [W] y derivadas [K/s]
    Q_net = Q_sol + Q_alb + Q_ir + Q_int + Q_cond - Q_emit;
    dTdt  = Q_net ./ params.C;

    % 8. Retorno opcional de desglose de flujos
    if nargout > 1
        fluxes.Q_sol  = Q_sol;
        fluxes.Q_alb  = Q_alb;
        fluxes.Q_ir   = Q_ir;
        fluxes.Q_int  = Q_int;
        fluxes.Q_cond = Q_cond;
        fluxes.Q_emit = Q_emit;
        fluxes.Q_net  = Q_net;
    end
end

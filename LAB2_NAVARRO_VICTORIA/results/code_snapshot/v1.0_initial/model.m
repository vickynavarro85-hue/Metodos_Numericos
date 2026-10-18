function [dTdt, fluxes] = model(t, T, params)
% MODEL v1.0 (Version Inicial - Incidente de cota en etapas tentativas)
% Sistema de 6 EDOs termicas no lineales acopladas para satelite STARLINK-1008.

    % Verificacion de valores finitos y cota fisica minima (v1.0: hard error en etapas tentativas)
    if any(~isfinite(T))
        error('MODEL:NonFiniteState', 'Se detectaron valores no finitos (NaN/Inf) en T en t = %.4f s.', t);
    end
    if any(T < 2.7)
        error('MODEL:PhysicalBoundViolation', ...
            'Violacion del limite fisico T_i >= 2.7 K detectada en t = %.4f s (min T = %.4f K).', ...
            t, min(T));
    end

    % 1. Direccion solar en ejes cuerpo normalizada
    s = [params.interp_sx(t); params.interp_sy(t); params.interp_sz(t)];
    norm_s = norm(s);
    if norm_s > 0
        s = s / norm_s;
    end

    % 2. Variables del entorno orbital interpoladas
    ilum_val = params.interp_ilum(t);
    ilum_t   = double(ilum_val >= 0.5);
    S_t      = params.interp_S(t);
    mu_t     = max(0.0, params.interp_mu(t));

    % 3. Coseno de incidencia solar en cada cara
    cos_inc = max(0.0, params.normals * s);

    % 4. Terminos de potencia termica entrante [W]
    Q_sol = params.alpha .* params.A .* S_t .* ilum_t .* cos_inc;
    Q_alb = params.alpha .* params.A .* S_t .* params.albedo .* params.F_tierra .* mu_t .* ilum_t;
    Q_ir  = params.eps .* params.A .* params.q_ir_earth .* params.F_tierra;
    Q_int = params.Q_int;

    % 5. Conduccion neta estructural entre caras adyacentes [W]
    Q_cond = params.G * T - params.G_row .* T;

    % 6. Emision radiativa disipativa al espacio profundo [W] (v1.0: T.^4 directo)
    Q_emit = params.sigma_SB .* params.eps .* params.A .* (T.^4 - params.T_espacio^4);

    % 7. Balance termico neto [W] y derivadas [K/s]
    Q_net = Q_sol + Q_alb + Q_ir + Q_int + Q_cond - Q_emit;
    dTdt  = Q_net ./ params.C;

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

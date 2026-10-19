function params = get_params()
% GET_PARAMS Retorna la estructura de parametros fisicos, termicos y orbitales
% para el modelo termico de 6 nodos del satelite STARLINK-1008 en LEO.
%
% Unidades: Sistema Internacional (SI)
% - Longitud: m, Area: m^2
% - Masa: kg, Capacidad calorifica: J/(kg*K), Capacitancia: J/K
% - Potencia: W, Flujo: W/m^2, Conductancia: W/K
% - Temperatura: K, Tiempo: s
%
% Referencia: Mathematical_Model_v1.md (Lab 1 Aprobado)

    % 1. Dimensiones geometricas [m]
    params.Lx = 2.8;  % Ram (+X/-X normal a Ly*Lz)
    params.Ly = 1.4;  % Normal a la orbita (+Y/-Y normal a Lx*Lz)
    params.Lz = 0.3;  % Cenit / Nadir (+Z/-Z normal a Lx*Ly)

    % 2. Areas de cada cara [m^2]
    % Orden: [+X, -X, +Y, -Y, +Z, -Z]
    params.A = [ ...
        params.Ly * params.Lz; ...  % +X: 0.42 m^2
        params.Ly * params.Lz; ...  % -X: 0.42 m^2
        params.Lx * params.Lz; ...  % +Y: 0.84 m^2
        params.Lx * params.Lz; ...  % -Y: 0.84 m^2
        params.Lx * params.Ly; ...  % +Z: 3.92 m^2
        params.Lx * params.Ly  ...  % -Z: 3.92 m^2
    ];

    % 3. Capacitancias termicas nodales C_i [J/K]
    % C_i = sigma_m * c_p * A_i con sigma_m = 4.0 kg/m^2, c_p = 900 J/(kg K)
    params.C = [ ...
        1512.0; ...  % +X
        1512.0; ...  % -X
        3024.0; ...  % +Y
        3024.0; ...  % -Y
        14112.0; ... % +Z
        14112.0  ... % -Z
    ];

    % 4. Propiedades termo-opticas superficiales
    % alpha: Absortividad en banda solar (adimensional)
    % eps: Emisividad hemisferica infrarroja (adimensional)
    params.alpha = [0.45; 0.45; 0.45; 0.45; 0.20; 0.92];
    params.eps   = [0.75; 0.75; 0.75; 0.75; 0.88; 0.85];

    % 5. Factores de vista a la Tierra F_tierra (adimensional)
    params.F_tierra = [0.312; 0.312; 0.312; 0.312; 0.030; 0.892];

    % 6. Constantes del entorno espacial
    params.sigma_SB   = 5.670374419e-8;  % Stefan-Boltzmann [W/(m^2 K^4)]
    params.T_espacio  = 2.7;             % Fondo cosmico de microondas [K]
    params.q_ir_earth = 237.0;           % Flujo IR terrestre medio [W/m^2]
    params.albedo     = 0.30;            % Coeficiente de albedo terrestre (adimensional)

    % 7. Disipacion de calor interna [W]
    % 40 W en avionica (+X), 60 W en carga util nadir (-Z)
    params.Q_int = [40.0; 0.0; 0.0; 0.0; 0.0; 60.0];

    % 8. Matriz de conductancias lineales G [W/K]
    % g_lin = 2.0 W/(K m) a lo largo de aristas compartidas
    params.g_lin = 2.0;
    params.G = zeros(6, 6);
    % Aristas compartidas:
    % Entre X y Y: arista de longitud Lz = 0.3 m -> G = 0.60 W/K
    % Entre X y Z: arista de longitud Ly = 1.4 m -> G = 2.80 W/K
    % Entre Y y Z: arista de longitud Lx = 2.8 m -> G = 5.60 W/K
    % Caras opuestas: G = 0
    G_XY = params.g_lin * params.Lz; % 0.60 W/K
    G_XZ = params.g_lin * params.Ly; % 2.80 W/K
    G_YZ = params.g_lin * params.Lx; % 5.60 W/K

    % (+X=1, -X=2, +Y=3, -Y=4, +Z=5, -Z=6)
    % Conexiones de +X (1): con +Y(3), -Y(4), +Z(5), -Z(6)
    params.G(1, 3) = G_XY; params.G(3, 1) = G_XY;
    params.G(1, 4) = G_XY; params.G(4, 1) = G_XY;
    params.G(1, 5) = G_XZ; params.G(5, 1) = G_XZ;
    params.G(1, 6) = G_XZ; params.G(6, 1) = G_XZ;

    % Conexiones de -X (2): con +Y(3), -Y(4), +Z(5), -Z(6)
    params.G(2, 3) = G_XY; params.G(3, 2) = G_XY;
    params.G(2, 4) = G_XY; params.G(4, 2) = G_XY;
    params.G(2, 5) = G_XZ; params.G(5, 2) = G_XZ;
    params.G(2, 6) = G_XZ; params.G(6, 2) = G_XZ;

    % Conexiones de +Y (3): con +Z(5), -Z(6) (conexiones con X ya hechas)
    params.G(3, 5) = G_YZ; params.G(5, 3) = G_YZ;
    params.G(3, 6) = G_YZ; params.G(6, 3) = G_YZ;

    % Conexiones de -Y (4): con +Z(5), -Z(6) (conexiones con X ya hechas)
    params.G(4, 5) = G_YZ; params.G(5, 4) = G_YZ;
    params.G(4, 6) = G_YZ; params.G(6, 4) = G_YZ;

    % Suma de conductancias por fila para calculo vectorial eficiente:
    % Q_cond = G * T - G_row .* T
    params.G_row = sum(params.G, 2);

    % 9. Normales exteriores unitarias en terna cuerpo LVLH
    % Orden de ejes cuerpo: X (ram), Y (-h_hat), Z (cenit)
    params.normals = [ ...
         1.0,  0.0,  0.0; ...  % +X
        -1.0,  0.0,  0.0; ...  % -X
         0.0,  1.0,  0.0; ...  % +Y
         0.0, -1.0,  0.0; ...  % -Y
         0.0,  0.0,  1.0; ...  % +Z
         0.0,  0.0, -1.0  ...  % -Z
    ];

    % 10. Carga de datos orbitales propagados con SGP4 + Skyfield
    orb_path = fullfile(fileparts(mfilename('fullpath')), 'inputs', 'orbital_data.mat');
    if ~exist(orb_path, 'file')
        error('No se encontro el archivo de datos orbitales: %s', orb_path);
    end
    orb = load(orb_path);
    params.t_grid    = orb.t_grid(:);
    params.PERIODO_S = double(orb.PERIODO_S);
    params.N_ORBITAS = double(orb.N_ORBITAS);
    params.t_final   = params.t_grid(end);

    % Interpoladores rapidos
    params.interp_sx   = griddedInterpolant(params.t_grid, orb.s_cuerpo(:, 1), 'linear', 'nearest');
    params.interp_sy   = griddedInterpolant(params.t_grid, orb.s_cuerpo(:, 2), 'linear', 'nearest');
    params.interp_sz   = griddedInterpolant(params.t_grid, orb.s_cuerpo(:, 3), 'linear', 'nearest');
    params.interp_ilum = griddedInterpolant(params.t_grid, orb.ilum(:), 'linear', 'nearest');
    params.interp_mu   = griddedInterpolant(params.t_grid, orb.mu_sol(:), 'linear', 'nearest');
    params.interp_S    = griddedInterpolant(params.t_grid, orb.S_SOLAR(:), 'linear', 'nearest');

    % 11. Condicion inicial aprobada
    params.T0 = 273.15 * ones(6, 1); % 0 degC en Kelvin

    % 12. Nombres de las caras
    params.names = {'+X (ram)', '-X (wake)', '+Y', '-Y', '+Z (cenit)', '-Z (nadir)'};
end

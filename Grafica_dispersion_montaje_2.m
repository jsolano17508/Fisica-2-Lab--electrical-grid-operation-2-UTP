% =========================================================================
% SCRIPT DE MATLAB: REGRESIÓN LINEAL CON ESTILO OSCILOSCOPIO SIMULINK (SCOPE)
% =========================================================================

clear; clc; close all;

% 1. Datos del Montaje 2
V = [2, 4, 6, 8, 10];         % Voltaje en el eje Y (Voltios)
I_A = V / 231;                % Corriente en el eje X (Amperios)

% 2. Ajuste Lineal por Mínimos Cuadrados (Y = a*X + b)
p = polyfit(I_A, V, 1);
a = p(1);                     % Pendiente (Resistencia Equivalente Req)
b = p(2);                     % Intercepto

% Coeficiente de Determinación R^2
V_fit = polyval(p, I_A);
SS_tot = sum((V - mean(V)).^2);
SS_res = sum((V - V_fit).^2);
R2 = 1 - (SS_res / SS_tot);

% 3. Generación de la Figura estilo "Simulink Scope"
fig = figure('Name', 'Osciloscopio Simulink', ...
             'Color', [0.12 0.12 0.12], ...
             'Position', [200, 200, 750, 500]);

% Configuración del eje (Fondo negro, rejilla gris y texto blanco)
ax = axes('Parent', fig, ...
          'Color', [0 0 0], ...
          'XColor', [0.9 0.9 0.9], ...
          'YColor', [0.9 0.9 0.9], ...
          'GridColor', [0.4 0.4 0.4], ...
          'GridAlpha', 0.7, ...
          'MinorGridColor', [0.25 0.25 0.25], ...
          'MinorGridAlpha', 0.5);
hold(ax, 'on');

% Trazado de línea de tendencia (Amarillo neón característico del trazo de Simulink Scope)
I_grid = linspace(min(I_A), max(I_A), 100);
V_grid = polyval(p, I_grid);
plot(I_grid, V_grid, '--', 'Color', [1 1 0], 'LineWidth', 2);

% Puntos de dispersión (Cian neón para resaltar los nodos de medición)
scatter(I_A, V, 80, 'o', 'MarkerFaceColor', [0 1 1], ...
        'MarkerEdgeColor', [1 1 1], 'LineWidth', 1.2);

% Configuración de Rejilla y Títulos
grid(ax, 'on');
grid(ax, 'minor');
xlabel(ax, 'Corriente Total I (A)', 'FontSize', 11, 'FontWeight', 'bold', 'Color', [0.9 0.9 0.9]);
ylabel(ax, 'Voltaje de Fuente V (V)', 'FontSize', 11, 'FontWeight', 'bold', 'Color', [0.9 0.9 0.9]);
title(ax, 'Scope - Montaje 2: Ley de Ohm (V vs I)', 'FontSize', 13, 'FontWeight', 'bold', 'Color', [1 1 1]);

% Leyenda con tema oscuro
lgd = legend({'Línea de Tendencia (Ajuste)', 'Datos Teóricos (V, I)'}, ...
             'Location', 'northwest', 'FontSize', 10);
set(lgd, 'TextColor', [0.9 0.9 0.9], 'Color', [0.18 0.18 0.18], 'EdgeColor', [0.4 0.4 0.4]);

% Display HUD / Cuadro de parámetros del Osciloscopio
texto_info = {
    sprintf('\\color{cyan}\\bfEcuación:\\rm \\color{white}Y = %.2f X + %.2f', a, b), ...
    sprintf('\\color{cyan}\\bfR^2:\\rm \\color{white}%.4f', R2), ...
    sprintf('\\color{yellow}\\bfR_{eq}:\\rm \\color{white}%.2f \\Omega', a)
};

text(min(I_A) + 0.002, max(V) - 1.5, texto_info, ...
     'FontSize', 10, 'BackgroundColor', [0.18 0.18 0.18], ...
     'EdgeColor', [0.5 0.5 0.5], 'Margin', 8, 'Interpreter', 'tex');

hold(ax, 'off');
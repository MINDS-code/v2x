% This is the main file running to get the result of comparing three kinds of incomplete graphs with five nodes. 
% This code is run with three functions created, named solve_W_custom.m, solve_W_path.m, solve_W_star.m. Put them all in a file and path
% Then you can run and see the result

% Define beta range
beta_range = 1:1:100;

% Initialize results
w_line_opt = []; f_line_opt = [];
w_star_opt = []; f_star_opt = [];
w_custom_opt = []; f_custom_opt = [];

% Set N (used in legend)
N = 5;  % You can generalize this later with a loop for multiple N values if needed

% Solve for line topology
for beta = beta_range
    [w_opt, f_opt] = solve_W_path(N, beta, 4, 10);
    w_line_opt = [w_line_opt, w_opt];
    f_line_opt = [f_line_opt, f_opt];
end

% Solve for star topology
for beta = beta_range
    [w_opt, f_opt] = solve_W_star(N, beta, 4, 10);
    w_star_opt = [w_star_opt, w_opt];
    f_star_opt = [f_star_opt, f_opt];
end

% Solve for custom topology
for beta = beta_range
    [w_opt, f_opt] = solve_W_custom(N, beta, 4, 10);
    w_custom_opt = [w_custom_opt, w_opt];
    f_custom_opt = [f_custom_opt, f_opt];
end

%% First Figure: Cost vs. beta
figure;
hold on; grid on;

plot(beta_range, f_line_opt, '-', 'Color', 'k', 'LineWidth', 1.5);   % black
plot(beta_range, f_star_opt, '--', 'Color', 'b', 'LineWidth', 1.5);  % blue
plot(beta_range, f_custom_opt, '-.', 'Color', 'r', 'LineWidth', 1.5);% red

xlabel('$\beta$ (Rationality)', 'Interpreter','latex','FontSize',11);
ylabel('Optimal Cost', 'Interpreter','latex','FontSize',11);
title('Fig.1: Optimal Cost vs. Rationality', 'Interpreter','latex','FontSize',12);

legend({'Line Topology', 'Star Topology', 'Custom Topology'}, ...
    'Interpreter','latex', 'FontSize', 9, 'Location','northeast');

set(gca, 'FontSize', 9, 'TickLabelInterpreter','latex');

%% Second Figure: Ratio comparisons
figure;
hold on; grid on;

plot(beta_range, f_custom_opt ./ f_star_opt, '-', 'Color', 'k', 'LineWidth', 1.5);
plot(beta_range, f_custom_opt ./ f_line_opt, '--', 'Color', 'b', 'LineWidth', 1.5);
plot(beta_range, f_star_opt ./ f_line_opt, '-.', 'Color', 'r', 'LineWidth', 1.5);

xlabel('$\beta$ (Rationality)', 'Interpreter','latex','FontSize',11);
ylabel('Relative Cost Ratio', 'Interpreter','latex','FontSize',11);
title('Fig.2: Relative Cost Comparison', 'Interpreter','latex','FontSize',12);

legend({'ratio custom/star', ...
        'ratio custom/line', ...
        'ratio star/line'}, ...
    'Interpreter','latex', 'FontSize', 9, 'Location','southeast');

set(gca, 'FontSize', 9, 'TickLabelInterpreter','latex');

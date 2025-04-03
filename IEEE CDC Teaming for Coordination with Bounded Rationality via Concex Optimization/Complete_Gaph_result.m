clf;
clc;
%In this code, you can compare a complete graph with a maximum of 7 nodes at a time. 
%The result would show the comparison of objective value, optimal value w*(beta), and probability of action.
%By using the simplified equation 29 in our paper to get the result.


N_list = [5, 10, 20,30]; %where to enter Node numbers. Most 7
theta = N/2 +1 ;  %Here theta could be any number larger than N/2
rho = 10;      % You can modify the number of the penalty term
beta_range = 1:100;

num_beta = length(beta_range);
num_N = length(N_list);

W_opt = zeros(num_N, num_beta);
F_opt = zeros(num_N, num_beta);
MU_opt = zeros(num_N, num_beta);

for i = 1:num_N
    N = N_list(i);
    fprintf('Running N = %d...\n', N);
    
    for j = 1:num_beta
        beta = beta_range(j);
        
        % Step 1: Optimize weight
        obj_fun = @(w) compute_complete_objective(w, N, beta, theta, rho);
        [w_star, f_val] = fminbnd(obj_fun, 0, 1);
        
        W_opt(i, j) = w_star;
        F_opt(i, j) = f_val;

        % Step 2: Approximate mu(0|beta)
        mu_0 = compute_mu_approx(N, beta, w_star, theta);
        MU_opt(i, j) = mu_0;
    end
end

% === Plot 1: Optimal Cost ===
figure('Color','w', 'Position', [100, 100, 700, 400]);
hold on;
styles = {'--', '-', '-.', ':', '--', '-', '-.', ':'};
for i = 1:num_N
    semilogy(beta_range, F_opt(i,:), styles{i}, 'LineWidth', 2);
end
xlabel('$\beta$ (Rationality)', 'Interpreter','latex','FontSize',11);
ylabel('Objective Value', 'Interpreter','latex','FontSize',11);
title('Fig.1: Objective Value vs. Rationality', 'Interpreter','latex','FontSize',12);
legend(compose('$N=%d$', N_list), 'Interpreter','latex','FontSize',9,'Location','northeast');
set(gca, 'XScale', 'log', 'FontSize', 9, 'TickLabelInterpreter','latex');
grid on; box on;
%exportgraphics(gcf, 'fig1_cost_complete_graphs.pdf', 'ContentType', 'vector');

% === Plot 2: Optimal Weight ===
figure('Color','w', 'Position', [100, 100, 700, 400]);
hold on;
for i = 1:num_N
    semilogx(beta_range, W_opt(i,:), styles{i}, 'LineWidth', 2);
end
xlabel('$\beta$ (Rationality)', 'Interpreter','latex','FontSize',11);
ylabel('Optimal $w^*(\beta)$', 'Interpreter','latex','FontSize',11);
title('Fig.2: Optimal Weight vs. Rationality', 'Interpreter','latex','FontSize',12);
legend(compose('$N=%d$', N_list), 'Interpreter','latex','FontSize',9,'Location','northeast');
set(gca, 'FontSize', 9, 'TickLabelInterpreter','latex');
grid on; box on;
%exportgraphics(gcf, 'fig2_weight_complete_graphs.pdf', 'ContentType', 'vector');

% === Plot 3: μ(0|β) Approx ===
figure('Color','w', 'Position', [100, 100, 700, 400]);
hold on;
for i = 1:num_N
    semilogy(beta_range, MU_opt(i,:), styles{i}, 'LineWidth', 2);
end
xlabel('$\beta$ (Rationality)', 'Interpreter','latex','FontSize',11);
ylabel('$\mu_W(0|\beta)$', 'Interpreter','latex','FontSize',11);
title('Fig.3: Equilibrium Probability vs. Rationality', 'Interpreter','latex','FontSize',12);
legend(compose('$N=%d$', N_list), 'Interpreter','latex','FontSize',9,'Location','southwest');
set(gca, 'XScale', 'log', 'FontSize', 9, 'TickLabelInterpreter','latex');
grid on; box on;
%exportgraphics(gcf, 'fig3_mu_complete_graphs.pdf', 'ContentType', 'vector');


%% === Functions ===  
% Function of objective function using equation 29 in our paper
function f = compute_complete_objective(w, N, beta, theta, rho)
    Z = 0;
    for d = 0:N
        coeff = nchoosek(N, d);
        A_d = (d^2 - d)/2 - (theta / N) * (N - 1) * d;
        Z = Z + coeff * exp(beta * w * A_d);
    end
    f = Z + 0.5 * rho * w * N * (N - 1);
end

% Function of compute probability of action using mu = 1/equation 29 
function mu = compute_mu_approx(N, beta, w, theta)
    Z = 0;
    for d = 0:N
        A_d = (d^2 - d)/2 - (theta / N) * (N - 1) * d;
        Z = Z + nchoosek(N, d) * exp(beta * w * A_d);
    end
    mu = 1 / Z;
end

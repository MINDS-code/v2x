% This Function uses Fmincon to solve the optimal w^* in the form of a star graph connected to a path graph. Notice, only for five nodes only
function [W_opt, J] = solve_W_custom(N, beta, theta, rho)
    assert(N == 5, 'This structure is only defined for N = 5');
    
    % w = [w1; w2; w3; w4]
    w0 = 0.5 * ones(4, 1);
    lb = zeros(4, 1);
    ub = ones(4, 1);


    options = optimoptions('fmincon', 'Algorithm', 'interior-point', ...
        'Display', 'none', 'MaxIterations', 100000000);
    
    % No nonlinear constraints needed — structure is enforced manually
    w_opt = fmincon(@(w) compute_objective_custom(w, beta, theta, rho), ...
                    w0, [], [], [], [], lb, ub, [], options);
    
    % Construct W
    W_opt = zeros(N, N);


    W_opt(1, 2) = w_opt(1);
    W_opt(2, 1) = w_opt(1);
    W_opt(1, 3) = w_opt(2);
    W_opt(3, 1) = w_opt(2);
    W_opt(1, 4) = w_opt(3);
    W_opt(4, 1) = w_opt(3);
    W_opt(4, 5) = w_opt(4);
    W_opt(5, 4) = w_opt(4);
    
    epsilon = 1e-5;
    W_opt(abs(W_opt) < epsilon) = 0;
    
    G = graph(W_opt);
    J = compute_objective_custom(w_opt, beta, theta, rho);
    
    % Optional: plot
    % plot(G, 'EdgeLabel', G.Edges.Weight);
end


function f = compute_objective_custom(w, beta, theta, rho)
    N = 5;
    
    % Build W with the given sparsity
    W = zeros(N, N);
    W(1, 2) = w(1); W(2, 1) = w(1);
    W(1, 3) = w(2); W(3, 1) = w(2);
    W(1, 4) = w(3); W(4, 1) = w(3);
    W(4, 5) = w(4); W(5, 4) = w(4);
    
    % Compute objective
    num_a = 2^N;
    f = 0;
    
    for i = 0:num_a-1
        a = dec2bin(i, N) - '0';
        a = a';
        term1 = 0.5 * a' * W * a;
        term2 = (theta / N) * sum(W * a);
        f = f + exp(beta * (term1 - term2));
    end
    
    f = f + 0.5 * rho * sum(sum(W));
end

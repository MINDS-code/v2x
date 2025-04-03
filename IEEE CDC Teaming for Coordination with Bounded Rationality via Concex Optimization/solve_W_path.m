% This Function used Fmincon to solve for the optimal W^* in the form of a path graph.
function [W_opt, J] = solve_W_path(N, beta, theta, rho)
    % Only N-1 variables (edges between consecutive nodes)
    numVars = N - 1;
    
    % Initial guess
    w0 = 0.5 * ones(numVars, 1);
    
    % Bounds: 0 <= w_i <= 1
    lb = zeros(numVars, 1);
    ub = ones(numVars, 1);
  


    options = optimoptions('fmincon', 'Algorithm', 'interior-point', 'Display', 'none', 'MaxIterations', 100000000);




    % Solve
    w_opt = fmincon(@(w) compute_objective_path(w, N, beta, rho, theta), ...
        w0, [], [], [], [], lb, ub, [], options);
    
    % Reconstruct W from w_opt (path graph)
    W_opt = zeros(N, N);
    for i = 1:N-1
        W_opt(i, i+1) = w_opt(i);
        W_opt(i+1, i) = w_opt(i);
    end
    
    % Threshold small weights
    epsilon = 1e-5;
    W_opt(abs(W_opt) < epsilon) = 0;
    
    % Optional graph representation
    G = graph(W_opt);
    J = compute_objective_path(w_opt, N, beta, rho, theta);


    % Optional plotting
    % plot(G, 'EdgeLabel', G.Edges.Weight);
end


function f = compute_objective_path(w, N, beta, rho, theta)
    % Reconstruct W for a path graph
    W = zeros(N, N);
    for i = 1:N-1
        W(i, i+1) = w(i);
        W(i+1, i) = w(i);
    end


    % Compute objective (full sum over 2^N binary vectors)
    f = 0;
    num_a = 2^N;


    for i = 0:num_a-1
        a = dec2bin(i, N) - '0';
        a = a';
        term1 = 0.5 * a' * W * a;
        term2 = (theta / N) * sum(W * a);
        f = f + exp(beta * (term1 - term2));
    end
    
    f = f + 0.5 * rho * sum(sum(W));  % Regularization
end

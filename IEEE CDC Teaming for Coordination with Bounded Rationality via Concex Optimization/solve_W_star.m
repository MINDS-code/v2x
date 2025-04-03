%Function of using Fmincon to solve optimal W^* in format of star graph

function [W_opt, J] = solve_W_star(N, beta, theta, rho)
    % Only N-1 variables (edges from central node 1 to others)
    numVars = N - 1;
    
    % Initial guess
    w0 = 0.5 * ones(numVars, 1);
    
    % Bounds: 0 <= w_i <= 1
    lb = zeros(numVars, 1);
    ub = ones(numVars, 1);
    
    % No nonlinear constraints needed — structure is enforced directly
   options = optimoptions('fmincon', ...
    'Algorithm', 'interior-point', ...
    'Display', 'none', ...
    'SpecifyObjectiveGradient', false, ...
    'FiniteDifferenceType', 'central', ...   % better accuracy
    'OptimalityTolerance', 1e-8, ...
    'StepTolerance', 1e-10);
 
    % Solve
    w_opt = fmincon(@(w) compute_objective_star(w, N, beta, rho, theta), ...
        w0, [], [], [], [], lb, ub, [], options);
    
    % Reconstruct W from w_opt
    W_opt = zeros(N, N);
    W_opt(1, 2:N) = w_opt';
    W_opt(2:N, 1) = w_opt;
    
    epsilon = 1e-5;
    W_opt(abs(W_opt) < epsilon) = 0;
    
    G = graph(W_opt);
    J = compute_objective_star(w_opt, N, beta, rho, theta);
    
    % Optional plotting
    % plot(G, 'EdgeLabel', G.Edges.Weight);
end


function f = compute_objective_star(w, N, beta, rho, theta)
    % Reconstruct star-shaped matrix W
    W = zeros(N, N);
    W(1, 2:N) = w';
    W(2:N, 1) = w;
    
    % Exhaustive sum over binary vectors a in {0,1}^N
    num_a = 2^N;
    f = 0;
    
    for i = 0:num_a-1
        a = dec2bin(i, N) - '0'; % binary vector
        a = a';
        term1 = 0.5 * a' * W * a;
        term2 = (theta / N) * sum(W * a);
        f = f + exp(beta * (term1 - term2));
    end
    
    f = f + 0.5 * rho * sum(sum(W));
end

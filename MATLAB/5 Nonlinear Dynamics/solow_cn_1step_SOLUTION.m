% Crank-Nicolson
function kp = solow_cn_1step_SOLUTION(k, alpha, s, gamma, delta)
    % euler step to approximate k one step further 
    k_tilde = solow_ee_1step_SOLUTION(k, alpha, s, gamma, delta);

    % derivatives
    dk1 = solow_derivative(k, alpha, s, gamma);
    dk2 = solow_derivative(k_tilde, alpha, s, gamma);

    % CN step
    kp = k + (delta / 2) * (dk1 + dk2);
end

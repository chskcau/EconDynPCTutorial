function zz = system_cn_1step_SOLUTION(z, delta)
    % using the euler step function here to estimate the endpoint of the interval
    z_tilde = system_ee_1step_SOLUTION(z, delta);
    zz = z + 0.5 * delta * (system_derivative_SOLUTION(z) + system_derivative_SOLUTION(z_tilde));
end

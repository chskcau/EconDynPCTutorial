function zz = system_rk_1step_SOLUTION(z, delta)
    k1 = system_derivative_SOLUTION(z);
    k2 = system_derivative_SOLUTION(z + 0.5 * delta * k1);
    k3 = system_derivative_SOLUTION(z + 0.5 * delta * k2);
    k4 = system_derivative_SOLUTION(z + delta * k3);
    zz = z + delta * (k1 + k4 + 2* (k2 + k3)) / 6;
end

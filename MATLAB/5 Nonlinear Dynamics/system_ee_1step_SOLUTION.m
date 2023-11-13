function zz = system_ee_1step_SOLUTION(z, delta)
    zz = z + delta * system_derivative_SOLUTION(z);
end

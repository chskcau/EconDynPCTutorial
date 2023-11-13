function knext = solow_ee_1step_SOLUTION(k, alpha, s, gamma, delta)
    knext = k + delta * solow_derivative(k, alpha, s, gamma);
end

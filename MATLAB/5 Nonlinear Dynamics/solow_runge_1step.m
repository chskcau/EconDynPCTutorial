function kp = solow_runge_1step(k, alpha, s, gamma, delta)
    k_mid = solow_ee_1step(k, alpha, s, gamma, delta);
    dk = solow_derivative(k_mid, alpha, s, gamma);
    kp = k + delta * dk;
end

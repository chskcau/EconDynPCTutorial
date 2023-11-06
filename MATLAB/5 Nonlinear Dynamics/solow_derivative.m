function kprime = solow_derivative(k, alpha, s, gamma)
    kprime = s * k.^alpha - gamma * k;
end

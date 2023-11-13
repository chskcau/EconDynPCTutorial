function dz = system_derivative_SOLUTION(z)
    dz1 = z(2) * (z(1) + 1);
    dz2 = z(1) * (z(2) + 3);
    dz = [dz1; dz2];
end


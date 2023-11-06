function pp = cobweb_rk_1step_SOLUTION(p, delta)
    k1 = 45 - 3 * p;
    k2 = 45 - 3 * (p + delta * k1 * 0.5);
    k3 = 45 - 3 * (p + delta * k2 * 0.5);
    k4 = 45 - 3 * (p + delta * k3);
    pp = p + (delta / 6) * (k1 + 2 * (k2 + k3) + k4);
end

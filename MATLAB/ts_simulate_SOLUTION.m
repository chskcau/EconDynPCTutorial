function y = ts_simulate_SOLUTION(y0, T, n, timestep_func)
    delta = 1 / n;
    y = y0;
    for t = 1:n*T
        y(end + 1) = timestep_func(y(end), delta);
    end
end

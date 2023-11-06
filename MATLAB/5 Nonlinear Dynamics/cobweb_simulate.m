function p = cobweb_simulate(p, T, n, timestep_func)
    delta = 1 / n;
    for t = 1:n*T
        p = timestep_func(p, delta);
    end
end

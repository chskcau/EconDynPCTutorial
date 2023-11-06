function p_tplusdelta = cobweb_ee_1step(p_t, delta)
    p_tplusdelta = p_t + delta * (45 - 3*p_t);
end

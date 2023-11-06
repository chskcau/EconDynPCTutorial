function p_tplusdelta = cobweb_ee_1step_SOLUTION(p_t, delta)
    p_tplusdelta = p_t + delta * (45 - 3*p_t);
end

function p_tplusdelta = cobweb_ie_1step_SOLUTION(p_t, delta)
    p_tplusdelta = (p_t + delta * 45) / (1 + 3 * delta);
end

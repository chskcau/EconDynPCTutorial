function p_tplusdelta = twogoods_runge_SOLUTION(p_t, A, delta)
    p_mid = twogoods_ee_SOLUTION(p_t, A, delta*0.5);
    p_tplusdelta = p_t + delta * A * p_mid;
end

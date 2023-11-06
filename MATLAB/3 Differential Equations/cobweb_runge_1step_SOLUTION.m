function p_tplusdelta = cobweb_runge_1step_SOLUTION(p_t, delta)
    p_mid = cobweb_ee_1step_SOLUTION(p_t, delta*0.5);
    % derivative at midpoint
    dp = 45 - 3 * p_mid;
    % return current price + delta times rate of change
    p_tplusdelta = p_t + delta * dp;
end

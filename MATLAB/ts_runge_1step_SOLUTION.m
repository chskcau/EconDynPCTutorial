function y_tplusdelta = ts_runge_1step_SOLUTION(y_t, delta)
    y_mid = ts_ee_1step_SOLUTION(y_t, 0.5*delta);
    y_tplusdelta = y_t + delta * (2 - 3 * y_mid);
end

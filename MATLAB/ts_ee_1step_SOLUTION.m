function y_tplusdelta = ts_ee_1step_SOLUTION(y_t, delta)
    y_tplusdelta = (1 - 3 * delta) * y_t + 2 * delta;
end

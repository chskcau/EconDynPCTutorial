function p_tplusdelta = cobweb_cn_1step_SOLUTION(p_t, delta)
    % calculate the denominator only once, makes the equation easier to
    % read
    denominator = 2 + 3 * delta;
    p_tplusdelta = ((2 - 3*delta) / denominator) * p_t + (90 / denominator) * delta;
end

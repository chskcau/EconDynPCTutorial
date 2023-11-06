function p_tplusdelta = twogoods_ee_SOLUTION(p_t, A, delta)
    % In this solution I factor out the price vector first and then perform
    % the multiplication Of course it is possible to achieve the correct
    % results without this step.
    mat = eye(2) + delta * A; % for better readability, I create the matrix in a separate step
    p_tplusdelta = mat * p_t;
end

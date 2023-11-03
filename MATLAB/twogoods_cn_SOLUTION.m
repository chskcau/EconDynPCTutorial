function p_tplusdelta = twogoods_cn_SOLUTION(p_t, A, delta)
    % Same logic applies as in twogoods_ie.m appiles, it would be more
    % efficient to create the matrix M only once.
    M1 = eye(2) - 0.5 * delta * A;
    M2 = eye(2) + 0.5 * delta * A;
    M = M1 \ M2;
    p_tplusdelta = M * p_t;
end

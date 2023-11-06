function p_tplusdelta = twogoods_ie_SOLUTION(p_t, A, delta)
    % Note that it would be computationally much more efficient to
    % calculate this inverse once and pass it into the single-step function
    % when needed. To keep the use of all three functions consistent (pass
    % the coefficient matrix as input), we calculate it each time though.
    M = eye(2) - delta * A;
    p_tplusdelta = M \ p_t;
end

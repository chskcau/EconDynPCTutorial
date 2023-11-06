function p_tplus1 = Cobweb_1step_SOLUTION(p_t, alpha, beta, gamma, delta)
    p_tplus1 = -delta/beta * p_t + (alpha+gamma)/beta;
end

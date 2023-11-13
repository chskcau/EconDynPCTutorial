% Analytical solution
function pT = cobweb_1period(p_0, T)
    pT = (p_0 - 15) * exp(-3*T) + 15;
end

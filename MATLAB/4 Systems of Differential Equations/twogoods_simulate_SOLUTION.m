% This function simulates 2-dimensional dynamic models for T unit time steps.
% 
% Inputs
%     p            : initial value vector (numpy array length 2)
%     A            : coefficient matrix (2x2 numpy array)
%     T            : number of unit steps
%     delta        : size of individual time steps (<<1)
%     timestep_func: a function that implements one time step increment of size delta (ee, ie, cn)
% 
% Output
%     Time series array of values, starting with the initial values
%
function results = twogoods_simulate_SOLUTION(p, A, T, delta, timestep_func)

    % number of time increments
    U = fix(T / delta); % to make sure it is an integer!
    
    results = NaN(2, U+1);
    results(:, 1) = p;
    
    for u = 1:U
        p = timestep_func(p, A, delta);
        results(:, u + 1) = p;
    end

end

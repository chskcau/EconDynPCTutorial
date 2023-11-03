%%% 3 Differential Equations
%
% See the PDF file provided for details.

%%% Setup

% Close all existing figures
close all

% Clear all variables (but not code caches etc.)
clearvars

% This renders text in figures in LaTeX font; note that setting these
% properties on the graphics root (groot) means they'll apply to ALL
% figures created from now until MATLAB is closed.
set(groot, "DefaultTextInterpreter", "latex")
set(groot, "DefaultAxesTickLabelInterpreter", "latex")
set(groot, "DefaultLegendInterpreter", "latex")

%%% Explicit Euler --- EXERCISE
%
% Consider the continuous-time version of the cobweb model (tutorial 3,
% exercise 2), leading to the first-order differential equation 
% 
%     p' = 45 - 3p.
% 
% Implement one time step using this scheme! It should take the current
% price p, as well as the size of the timestep \delta as inputs and
% return the estimated new price after a step of size \delta.
%
% Put your solution into the file cobweb_ee_1step.m.

%%% Runge's method --- EXERCISE
%
% Implement a single step of Runge's method for the continuous-time cobweb
% model! You will have to calculate the midpoint state by implementing a
% single Euler step of size \delta/2 to calculate the next step. you can
% use the function you created above for that purpose.
%
% Put your solution into the file cobweb_runge_1step.m.

%%% Simulation --- EXERCISE
%
% Complete the function below to simulate the cobweb model. They both take
% an initial value `p`, the number of unit steps `T`, and the number of
% increments per unit step, `n`. Hint: \delta=1/(n+1). They should not
% return a whole timeseries of values, but only the final value at time T.
% The final input is a function handle, `timestep_func`. In MATLAB (as in
% many other programming languages), you can pass a function handle as an
% input to another function. We do not evaluate the function, but we
% call it later in the code block of the function we are writing in the
% following way:
%
% function my_func(other_func, a)
%     other_func(a)
% end
%
% In the same way, you can run the timestep_func with inputs `p` and
% `delta` inside the function that simulates a series of steps,
% `simulate_cobweb`.
%
% Put your solution into the file cobweb_simulate.m. The analytical
% solution is in the file cobweb_1period.m.

% Below we compare the behaviour of both methods in terms of their errors
% and convergence towards the true value, as calculated with the analytical
% solution (see Tutorial). We iterate through decreasing values of
% $\delta\in\{2^{-2}, 2^{-3}, \dots 2^{-10}\}$, halving it every step, i.e.
% doubling the amount of time increments per unit time steps.

p0 = 60;
T = 1;
p_analytical = cobweb_1period(p0, T);

% errors
ee_error = 1;
rg_error = 1;

% analyse convergence, doubling the number of steps per time unit
for exponent = 2:10
    n = pow2(exponent);

    % update last period errors
    ee_last_error = ee_error;
    rg_last_error = rg_error;
    
    % starting prices
    p_ee = p0;
    p_rg = p0;
    
    % calculate solutions;
    p_ee = cobweb_simulate(p_ee, T, n, @cobweb_ee_1step);
    p_rg = cobweb_simulate(p_rg, T, n, @cobweb_runge_1step);
    
    % new errors
    ee_error = p_ee - p_analytical;
    rg_error = p_rg - p_analytical;
    
    % convergence
    fprintf("delta = 1/%u:\n", n);
    fprintf("\tExplicit Euler scheme\n\t\tCurrent value: p = %.3f; error = %.3f; error ratio = %.2f\n", p_ee, ee_error, ee_last_error / ee_error);
    fprintf("\tCentral difference scheme\n\t\tCurrent value: p = %.3f; error = %.3f; error ratio = %.2f\n", p_re, re_error, re_last_error / re_error);
    fprintf("\n");

end

% If your code is correct, you will notice that the errors decrease much
% faster for the Runge method, i.e. the method converges to the true value
% faster. By halving \delta, we can also cut the errors in half if we use
% the Euler scheme, but we make it four times smaller using the Runge
% method. That is because the convergence is quadratic instead of linear.
% We perform twice as many computationally steps per time increment
% $\delta$ because we have to compute the midpoint, but because of the
% faster convergence, we still reach the same level of accuracy with lower
% computational cost. The error of the standard difference method at
% \delta = 1/1024 is approximately 0.001, which has been approximately
% reached at \delta = 1/64 with the central differences method!

%%% Simulating time series --- EXERCISE
% 
% Consider the equation $y' + 3y = 2$. Complete the functions
% ts_ee_1step.m, ts_runge_1stepm.m and ts_simulate.m, each in its own file:
% single incremental steps using the Euler and Runge methods, and a
% function that can apply either of these methods to simulate a time series
% (the output should be an array) for a given number of time steps.

% Below, we simulate the model for 3 steps from initial value 5, using a
% relatively large increment $\delta=1/4$, and then we plot the results.

y0 = 5;
T = 3;
n = 4;

% results using Euler
ee_res = ts_simulate(y0, T, n, @ts_ee_1step);
% results using Runge
rg_res = ts_simulate(y0, T, n, @ts_runge_1step);

fig = figure;
title("y'(t) + 3y(t) = 2, y_0 = 5")

% values for the x-axis
x = linspace(0, T, T*n+1);

% plot the exact solution too
A = y0 - 2/3;
x_exact = linspace(0, T, 1000); % more points for a smoother curve
y_exact = A * exp(-3 * x_exact) + 2/3;

hold on
plot(x, ee_res, DisplayName = "Explicit Euler", LineWidth = 1, Color = "blue")
plot(x, rg_res, DisplayName = "Runge", LineWidth = 1, Color = "darkgreen")
plot(x_exact, y_exact, DisplayName = "Analytical solution", LineWidth = 1, Color = "red")
yline(2/3, LineWidth = 1, LineStyle = "--", Color = "black")
hold off

legend show

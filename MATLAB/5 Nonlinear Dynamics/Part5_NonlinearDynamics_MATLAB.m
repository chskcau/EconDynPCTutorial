%%% 5 Nonlinear Dynamics
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

%%% Solow model with constant technology and population --- EXERCISE
%
% Implement a single step of the Crank-Nicolson and Runge methods in the
% functions below. For the Crank-Nicolson method, estimate $k_{t+\delta}$
% with an explicit Euler step and then calculate the derivates at $k_t$ and
% $k_{t+\delta}$ to perform the step forward.
%
% Write a separate function for the Euler step, which you can use in the
% other functions. That way, we can compare behaviour of the methods
% afterwards, and your code becomes more readable. Generally, it is a good
% idea to split functions into subroutines, so that each function has
% narrow and focused responsibilities.
%
% Put your solutions into the files solow_ee_1step.m, solow_cn_1step.m and
% solow_runge_1step.m.

%%% EXERCISE
%
% Implement the function that simulates Solow's model with either of the
% two timestepping functions!
% 
% Inputs are the standard model parameters, the time increment $\delta$, as
% well as the total number of *unit* time steps `T` and the timestepping
% function. Output should be a numpy array of capital values $k$.
%
% Put your solution into the file solow_simulate.m.

%%% Simulation

% set variable values
delta = 1/16; % time increment
T = 75;       % time unit steps
alpha = 1/3;  % Cobb-Douglas exponent
gamma = 0.1;  % depreciation rate of capital
s = 0.1;      % savings rate
k_0 = 0.1;    % initial capital

Solow_T_CN = solow_simulate(k_0, alpha, s, gamma, delta, T, @solow_cn_1step);

fig = figure;

% x-axis re-adjusted
t = linspace(0, T, fix(T/delta)+1);
% plot the time series
plot(t, Solow_T_CN, LineWidth = 1)

% analytical solution of the steady state:
ss = (s / gamma)^(1 / (1-alpha));

% horizontal line at steady state
yline(ss, LineStyle = "--", LineWidth = 0.5, Color = "black", Alpha = 0.8)

title("Solow growth model implementation")
xlabel("$t$")
ylabel("$k$")

%%% Classic Runge-Kutta --- EXERCISE

% In order to compare convergence to the true value, we will once more
% revisit the cobweb model $p' = 45 - 3p$. Implement one step of the
% classic Runge-Kutta method for this model.
%
% Put your solution into the file cobweb_rk_1step.m.

% Evaluation of convergence

p0 = 60;
T = 1;
p_analytical = cobweb_1period(p0, T);

% errors
ee_error = 1;
cn_error = 1;
rk_error = 1;

% analyse convergence, doubling the number of steps per time unit
for exponent = 2:8
    n = pow2(exponent);

    % update last period errors
    ee_last_error = ee_error;
    cn_last_error = cn_error;
    rk_last_error = rk_error;
    
    % starting prices
    p_ee = p0;
    p_cn = p0;
    p_rk = p0;
    
    % calculate solutions;
    p_ee = cobweb_simulate(p_ee, T, n, @cobweb_ee_1step);
    p_cn = cobweb_simulate(p_cn, T, n, @cobweb_cn_1step);
    p_rk = cobweb_simulate(p_rk, T, n, @cobweb_rk_1step);
    
    % new errors
    ee_error = p_ee - p_analytical;
    cn_error = p_cn - p_analytical;
    rk_error = p_rk - p_analytical;
    
    % convergence
    fprintf("delta = 1/%u:\n", n);
    fprintf("\tExplicit Euler scheme:\n\t\tCurrent value: p = %.4f; error = %.4f; error ratio = %.2f\n", p_ee, ee_error, ee_last_error / ee_error);
    fprintf("\tCrank-Nicolson scheme:\n\t\tCurrent value: p = %.4f; error = %.4f; error ratio = %.2f\n", p_cn, cn_error, cn_last_error / cn_error);
    fprintf("\tRunge-Kutta scheme:\n\t\tCurrent value: p = %.4f; error = %.4f; error ratio = %.2f\n", p_rk, rk_error, rk_last_error / rk_error);
    fprintf("\n");

end

%%% BONUS EXERCISE
%
% Implement the logistic growth function $x' = rx(1-x)$ using any method of
% your choice!

%%% Systems of non-linear equations --- EXERCISE
%
% Write four separate functions:
% * one that takes the current state vector (array) as input and returns
%   the vector of derivatives at that point,
% * one that implements a single explicit Euler step,
% * one that implements a single Crank-Nicolson step,
% * and finally, one that implements a single step of the Runge-Kutta 
%   method.
%
% Put your solutions into the files system_derivative.m, system_ee_1step.m,
% system_cn_1step.m and system_rk_1step.m.

% Simulation

delta = 1/2014;               % time increment
step_func = @system_rk_1step; % define a new name here, so it is easier to change the method for every point at once

% two different time lengths for stable and unstable starting positions
% (for plotting purposes)
T_stable = 2;
T_unstable = 1;

% different initial conditions
% stable
za = [1; -2];
zb = [-4; -4];
zc = [-0.75; 2];
% unstable
zd = [2; -1.52];
ze = [-0.5; 2];

z1 = NaN(2, fix(T_stable/delta) + 1);
z1(:, 1) = za;

z2 = NaN(2, fix(T_stable/delta) + 1);
z2(:, 1) = zb;

z3 = NaN(2, fix(T_stable/delta) + 1);
z3(:, 1) = zc;

z4 = NaN(2, fix(T_unstable/delta) + 1);
z4(:, 1) = zd;

z5 = NaN(2, fix(T_unstable/delta) + 1);
z5(:, 1) = ze;

U_stable = fix(T_stable/delta);
U_unstable = fix(T_unstable/delta);

for u = 1:U_stable
    z1(:, u+1) = step_func(z1(:, u), delta);
    z2(:, u+1) = step_func(z2(:, u), delta);
    z3(:, u+1) = step_func(z3(:, u), delta);
end
    
for u = 1:U_unstable
    z4(:, u+1) = step_func(z4(:, u), delta);
    z5(:, u+1) = step_func(z5(:, u), delta);
end

% Plot

fig = figure;
hold on

for z = {z1, z2, z3, z4, z5}
    plot(z{1}(1, :), z{1}(2, :), LineWidth = 1, Color = "black")
end

% Add poor man's arrow heads; this is a separate loop because reasons
for z = {z1, z2, z3, z4, z5}
    theta = cart2pol(z{1}(1, end) - z{1}(1, end-1), z{1}(2, end) - z{1}(2, end-1));
    myarrowhead(z{1}(1, end), z{1}(2, end), theta, 1);
end

% steady states
scatter([0, -1], [0, -3], MarkerFaceColor = "black")

xlabel("$z_1$")
ylabel("$z_2$")

grid on
currentAxis = gca;
currentAxis.GridLineStyle = ":";
currentAxis.GridAlpha = 0.4;
currentAxis.GridLineWidth = 0.4;

currentAxis.XAxisLocation = "origin";
currentAxis.YAxisLocation = "origin";

% Gradient fields

% gridpoints on both axes
z1_ax = linspace(-3, 2, 20);
z2_ax = linspace(-4, 3, 20);

% create arrays for dz1, dz2. NOTE: we could create a 3D grid like in the
% Python version, but for MATLAB's quiver() plot two separate 2D arrays are
% more convenient.
dz1 = NaN(numel(z1_ax), numel(z2_ax));
dz2 = dz1;

% fill grid
for i = 1:numel(z1_ax)
    z1_ = z1_ax(i);
    for j = 1:numel(z2_ax)
        z2_ = z2_ax(j);
        dz = system_derivative([z1_; z2_]);
        dz1(i, j) = dz(1);
        dz2(i, j) = dz(2);
    end
end
        
% colours will be based on magnitude of change; create a grid with
% derivatives where total change is scaled between 0 and 1
col_grid = NaN(numel(z1_ax), numel(z2_ax));
for i = 1:numel(z1_ax)
    for j = 2:numel(z2_ax)
        col_grid(i, j) = hypot(dz1(i, j), dz2(i, j));
    end
end
        
% scaling with logistic function - created better distribution of hot and
% cold colours in my opinion
col_grid = 1 ./ (1 + exp(-0.5*(col_grid - mean(col_grid, "all"))));

fig = figure;
hold on

quiver(z1_ax, z2_ax, dz1.', dz2.')
scatter([0 -1], [0 -3], MarkerFaceColor = "black")

grid on
currentAxis = gca;
currentAxis.GridLineStyle = ":";
currentAxis.GridAlpha = 0.4;
currentAxis.GridLineWidth = 0.4;

% Applying the colormap to the quiver() plot is left as an exercise for the
% reader

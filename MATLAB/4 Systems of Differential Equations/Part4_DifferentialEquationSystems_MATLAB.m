%%% 3 Differential Equation Systems
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

%%% Implicit Euler and Crank-Nicolson --- EXERCISE
%
% Before moving on to systems of equations, complete the functions for a
% single step using the implicit Euler and Crank-Nicolson methods.
% The model is the continuous-time cobweb model again: $p' = 45 - 3p$.
%
% Put your solutions into the files cobweb_ie_1step.m and
% cobweb_cn_1step.m.

%%% Runge's method --- EXERCISE
%
% Implement a single step of Runge's method for the continuous-time cobweb
% model! You will have to calculate the midpoint state by implementing a
% single Euler step of size \delta/2 to calculate the next step. you can
% use the function you created above for that purpose.
%
% Put your solution into the file cobweb_runge_1step.m. Refer to the
% solutions for the last tutorial, cobweb_ee_1step_SOLUTION.m,
% cobweb_runge_1step.m, and cobweb_1period.m, for details.

%%% Simulation

p0 = 60;
T = 1;
p_analytical = cobweb_1period(p0, T);

% errors
ee_error = 1;
ie_error = 1;
rg_error = 1;
cn_error = 1;

% analyse convergence, doubling the number of steps per time unit
for exponent = 2:5
    n = pow2(exponent);

    % update last period errors
    ee_last_error = ee_error;
    ie_last_error = ie_error;
    rg_last_error = rg_error;
    cn_last_error = cn_error;
    
    % starting prices
    p_ee = p0;
    p_ie = p0;
    p_rg = p0;
    p_cn = p0;
    
    % calculate solutions;
    p_ee = cobweb_simulate_SOLUTION(p_ee, T, n, @cobweb_ee_1step_SOLUTION);
    p_ie = cobweb_simulate_SOLUTION(p_ie, T, n, @cobweb_ie_1step_SOLUTION);
    p_rg = cobweb_simulate_SOLUTION(p_rg, T, n, @cobweb_runge_1step_SOLUTION);
    p_cn = cobweb_simulate_SOLUTION(p_cn, T, n, @cobweb_cn_1step_SOLUTION);
    
    % new errors
    ee_error = p_ee - p_analytical;
    ie_error = p_ie - p_analytical;
    rg_error = p_rg - p_analytical;
    cn_error = p_cn - p_analytical;
    
    % convergence
    fprintf("delta = 1/%u:\n", n);
    fprintf("\tExplicit Euler scheme:\n\t\tCurrent value: p = %.4f; error = %.4f; error ratio = %.2f\n", p_ee, ee_error, ee_last_error / ee_error);
    fprintf("\tImplicit Euler scheme:\n\t\tCurrent value: p = %.4f; error = %.4f; error ratio = %.2f\n", p_ie, ie_error, ie_last_error / ie_error);
    fprintf("\tCentral difference scheme:\n\t\tCurrent value: p = %.4f; error = %.4f; error ratio = %.2f\n", p_rg, rg_error, rg_last_error / rg_error);
    fprintf("\tCrank-Nicolson scheme:\n\t\tCurrent value: p = %.4f; error = %.4f; error ratio = %.2f\n", p_cn, cn_error, cn_last_error / cn_error);
    fprintf("\n");

end

% As you can see, the Crank-Nicolson methods also exhibits second-order
% convergence, i.e. the errors are 4 times larger if we double $\delta$.
% The implicit Euler method, following the same reasoning as its explicit
% counterpart, converges proportionally to $\delta$ (first-order
% convergence).
% 
% For $n=2$, we would obtain the explicit Euler time-stepping scheme
% $p(t+\delta) = (1-3\delta)p(t) + 45\delta = -0.5p(t) + 22.5$, i.e. a
% first-order difference equation with a negative eigenvalue. The implicit
% method on the other hand yields $p_{t+\delta} = \frac{1}{1+3\delta}(p_t +
% 45\delta) = \frac{2}{5}(p_t + 45\delta)$, which is a difference equation
% with a positive eigenvalue and therefore does not lead to the undesired
% oscillations.

%%% Two-goods model --- EXERCISE
% 
% Implement the explicit Euler, implicit Euler, Runge central-difference
% quotient, and Crank-Nicolson methods in the files twogoods_ee.m,
% twogoods_ie.m, twogoods_runge.m and twogoods_cn.m. They should take as
% inputs the current price vector $p$, the coefficient matrix $A$, and the
% size of the step $\delta$. Avoid explicitly inverting matrices, and use
% the right and left matrix division operators / and \ instead.
%
% Next, implement the loop in the function twogoods_simulate.m. This
% function simulates the behaviour of the model over time for 1 unit time
% step, which is divided into $1/\delta$ incremental time steps. The
% particular timestepping method is passed as an input as well, so later on
% we can exchange the methods flexibly and compare behaviour.

% Now we can simulate this model for a number of unit time steps and save
% the results to an array.

T = 10; % 10 unit time steps
delta = 1/512;

% Initial price vector
p = [2; 2];

% TODO: coefficient matrix
A = ...; 

results = twogoods_simulate(p, A, T, delta, @twogoods_cn);

%%% Plot the results
%
% In the figure below, the results are plotted. In the left panel, you can
% see the time series of both prices, the right panel depicts the phase
% portrait.
%
% For the phase portrait, we also have to calculate the isoclines.

x_iso = [-1; 3];
p1_iso = 0.5 * x_iso;
p2_iso = x_iso;

fig = figure;
sgtitle("Samuelson's 2-goods model", Interpreter = "latex")

nexttile;
title("Time series")
hold on

x_ts = linspace(0, T, width(results));
plot(x_ts, results(1, :), LineWidth = 1, Color = "blue", DisplayName = "$p_1$")
plot(x_ts, results(2, :), LineWidth = 1, Color = "red", DisplayName = "$p_2$")
legend(Location = "northeast", AutoUpdate = "off")

yline(0, LineStyle = "--", LineWidth = 1, Color = "black", DisplayName = "Steady state")
hold off
grid on
xlabel("$t$")
ylabel("$p_1(t)$, $p_2(t)$")

nexttile
title("Phase portrait")
hold on

plot(results(1, :), results(2, :), LineWidth = 1, Color = "#007700")
plot(x_iso, p1_iso, LineWidth = 1, Color = "black", LineStyle = "--")
plot(x_iso, p2_iso, LineWidth = 1, Color = "black", LineStyle = "--")

hold off
grid on

%%% Second-order differential equation --- EXERCISE
%
% Now consider the second-order differential equation $y'' + 2y = 0$.
% Instead of extending the methods we have learned to higher-order systems,
% re-state this equation as a 2-dimensional system of first-order
% differential equations and simulate it. You only have to define the
% coefficient matrix $A$, then we can re-use the single-step functions
% above. Finally, we will compare the three methods with this particular
% equation.
%

%
A = ...; % TO DO

y0 = [2; 2];

T = 20;
delta = 1/32;

% We can apply the 2-goods model function, as the steps are exactly the
% same!
results_ee = twogoods_simulate(y0, A, T, delta, @twogoods_ee);
results_ie = twogoods_simulate(y0, A, T, delta, @twogoods_ie);
results_rg = twogoods_simulate(y0, A, T, delta, @twogoods_runge);
results_cn = twogoods_simulate(y0, A, T, delta, @twogoods_cn);

%%%% Accuracy comparison
%
% See the phase diagram below for the motivation to prefer the
% Crank-Nicolson method over either of the two Euler schemes. We could show
% analytically that the system should stay in a stable limit cycle,
% orbiting the equilibrium. As the Euler schemes are first-order Taylor
% approximations of the "true" behaviour of the system, they create small
% errors, when second-order effects are present. Namely, in the case of a
% convex function ($\frac{\partial^2f}{\partial x^2}>0$), the explicit
% Euler scheme will create a positive bias, and the implicit Euler scheme a
% negative one. This can easily be proven with Jensen's inequality. The
% opposite holds for concave functions. The circle being convex, we can
% verify that the explicit Euler scheme diverges outward, while the
% implicit one turns inwards. Taking the mean of both will hence always
% provide much more accurate solutions! (Note: in physical applications,
% this is often related to the conservation of quantities such as energy.)
% The Runge method would in this case yield practically the same result as
% the Crank-Nicolson method, so plotting only one of the two makes more
% sense here.

fig = figure;
title("Comparison of timestepping schemes\n in terms of accuracy")

hold on
plot(results_ee(1, :), results_ee(2, :), Color = "blue", LineWidth = 0.7, DisplayName = "Explicit Euler")
plot(results_ie(1, :), results_ie(2, :), Color = "red", LineWidth = 0.7, DisplayName = "Implicit Euler")
plot(results_cn(1, :), results_cn(2, :), Color = "black", LineWidth = 0.7, DisplayName = "Crank-Nicolson")
hold off

xlabel("$y$")
ylabel("$y'$")
legend(Location = "southoutside", NumColumns = 3)

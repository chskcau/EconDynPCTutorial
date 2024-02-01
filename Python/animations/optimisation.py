# animate the optimisation process of the forward-backward-sweep method
import os

import numpy as np
import matplotlib.pyplot as plt

# for animation output
from matplotlib.animation import PillowWriter

# this renders text in figures in Latex font
from matplotlib import rc
rc('text', usetex=True)

def Hamiltonian(x, u, mu, t):
    return x * (x + 0.5 * mu) + u * (mu - u)

def dxdt(x, u, t):
    return 0.5 * x + u

def dHdu(H, x, u, mu, t, eps):
    return (H(x, u + 0.5 * eps, mu, t)- H(x, u - 0.5 * eps, mu, t)) / eps

def dHdx(H, x, u, mu, t, eps):
    return (H(x + 0.5 * eps, u, mu, t) - H(x - 0.5 * eps, u, mu, t)) / eps

def xRK_1step(x, u, t, dt):
    k1 = dxdt(x, u, t)
    k2 = dxdt(x + dt * k1 * 0.5, u, t)
    k3 = dxdt(x + dt * k2 * 0.5, u, t)
    k4 = dxdt(x + dt * k3, u, t)
    return x + (dt / 6) * (k1 + 2 * (k2 + k3) + k4)

def muRK_1step(H, x, u, mu, t, dt, eps):
    k1 = dHdx(H, x, u, mu, t, eps)
    k2 = dHdx(H, x + dt * k1 * 0.5, u, mu, t, eps)
    k3 = dHdx(H, x + dt * k2 * 0.5, u, mu, t, eps)
    k4 = dHdx(H, x + dt * k3, u, mu, t, eps)
    return mu + (dt / 6) * (k1 + 2 * (k2 + k3) + k4)

def d2Hdu2(H, x, u, mu, t, eps):
    return (dHdu(H, x, u + 0.5 * eps, mu, t, eps) - dHdu(H, x, u - 0.5 * eps, mu, t, eps)) / eps

def uNewton(H, x, u, mu, t):
    '''
    Find the optimal value of the control variable u at one point in time
    using Newton's method.

    Critical values to determine satisfactory convergence or iteration
    limits are defined in the function to reduce the amount of inputs.
    Note that in your own applications, it might make sense to designate
    them as input variables.

    Inputs:
        H: function object to specify the Hamiltonian
        x: value of state variable
        u: initial value u
        mu: value of co-state variable (shadow price)
        t: time index (in case it matters, e.g. when discounting is involved)

    Output:
        optimal value for control variable u, given the other variables
    '''
    crit = 1e-6      # critical value for convergence
    max_iter = 100   # maximum amount of iterations
    eps = 0.01       # step size in numerical differencing scheme
    for i in range(max_iter):
        # single Newton step
        u = u - (dHdu(H, x, u, mu, t, eps) / d2Hdu2(H, x, u, mu, t, eps))
        # check convergence criterion
        if abs(dHdu(H, x, u, mu, t, eps)) < crit:
            break
    # return updated control u
    return u

def update_control(H, X, U, Mu, T, omega):
    '''
    Update the entire array of control variable values.

    Imputs:
        H: Hamiltonian function object
        X: array of state variable x values
        U: array of last iterations best guess of control variables u values
        Mu: array of co-state variable values
        T: time array
        omega: step size towards new optimal guess with 0<omega<1

    Output:
        updated best guess for control variable array U
    '''
    for i, u in enumerate(U):
        U[i] = (1 - omega) * u + omega * uNewton(H, X[i], u, Mu[i], T[i])
    return U

def optimize(H, x0, dt, T):
    '''
    Optimization function to implement the forward-backward-sweep method
    for cases where the transversality condition mu(T)=0 applies.

    Final time T is set to 1.

    Convergence is considered achieved when the optimal guess in the control
    variable does not change considerably anymore. To measure this change,
    we use the Euclidean norm of the difference between the old and new
    optimal time series arrays of u.

    Inputs:
        H: Hamiltonian function object
        x0: initial state of state variable x
        dt: size of time increment (subject to adjustments so equal steps
            can be guaranteed)

    Outputs:
        x: state variable time series
        u: control variable time series
        mu: co-state time series
    '''
    # these could be function inputs as well:
    max_iter = 1000
    omega = 0.05 # small omega for nicer visuals
    eps = 0.01

    # initialise some variables and arrays
    N = int(1 / dt)              # number of time steps, as an integer
    dt = 1 / N                   # adjust dt to fit into interval
    t = np.linspace(0, T, N+1)   # time array
    x = np.empty(N+1)            # state variable array (empty at first)
    x[0] = x0                    # first entry is the initial state
    mu = np.empty(N+1)           # empty array for co-state (shadow price)
    mu[-1] = 0                   # last entry is 0
    u = np.zeros(N+1)            # intial guess for control variable: array of zeros

    ######################################
    # figure
    ######################################

    fig = plt.figure(figsize=(8,8))
    ps = fig.add_axes([0.025, 0.05, 0.95, 0.9])
    ps1, = ps.plot([], [], lw=0.5, c="black", label="state")
    ps2, = ps.plot([], [], lw=0.5, c="red", label="control")
    ps.grid(lw=0.2)
    plt.legend(loc="upper left", fontsize=14)
    ps.set_xlim(-0.05, 1.05)
    ps.set_ylim(-0.05, 5.05)
    ps.set_xticks(np.linspace(0,1,6))
    ps.set_yticks(np.linspace(0,5,6))
    t = np.linspace(0, T, len(x))

    writer = PillowWriter(fps=7)

    # path the script is executed from
    script_path = os.path.dirname(os.path.realpath(__file__))
    file_name = "optimisation.gif"
    # join file name and path
    file_path = os.path.join(script_path, file_name)

    with writer.saving(fig, file_path, 100):
        # start iterating to update u
        for j in range(max_iter):
            # create time series of state and costate based on u
            for i in range(N):
                x[i+1] = xRK_1step(x[i], u[i], t[i], dt)
            for i in range(N, 0, -1):
                mu[i-1] = muRK_1step(H, x[i], u[i], mu[i], t[i], dt, eps)
            if j == 0:
                for _ in range(10):
                    ps1.set_data(t, x)
                    ps2.set_data(t, u)
                    writer.grab_frame()

            # store last value of u for comparison afterwards
            u_old = u.copy()
            # new control guess
            u = update_control(H, x, u, mu, t, omega)

            ps1.set_data(t, x)
            ps2.set_data(t, u)
            writer.grab_frame()

            # stopping criterion
            if np.linalg.norm(u - u_old) < 1e-3:
                print(f"convergence after {j+1} iterations")
                break

    return x, u, mu

if __name__ == '__main__':
    x0 = 1
    T = 1
    dt = 1/(2**10)

    x, u, mu = optimize(Hamiltonian, x0, dt, T)
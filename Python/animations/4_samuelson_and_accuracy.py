# animate the figures from tutorial 4
import os

import numpy as np
import matplotlib.pyplot as plt

# for animation output
from matplotlib.animation import PillowWriter

# this renders text in figures in Latex font
from matplotlib import rc
rc('text', usetex=True)

# explicit Euler
def ee_2goods(p, A, delta):
    # In this solution I factor out the price vector first and then perform the multiplication
    # Of course it is possible to achieve the correct results without this step
    mat = np.eye(2) + delta * A # for better readability, I create the matrix in a separate step
    return np.matmul(mat, p)

# implicit Euler
def ie_2goods(p, A, delta):
    # note that it would be computationally much more efficient to calculate this inverse once
    # and pass it into the single-step function when needed. To keep the use of all three functions
    # consistent (pass the coefficient matrix as input), we calculate it each time though
    M = np.eye(2) - delta*A
    M_inv = np.linalg.inv(M)
    return np.matmul(M_inv, p)

# Crank-Nicolson
def cn_2goods(p, A, delta):
    # same logic applies as above, it would be more efficient to create the matrix M only once
    M1 = np.eye(2) - 0.5 * delta * A
    M1_inv = np.linalg.inv(M1)
    M2 = np.eye(2) + 0.5 * delta * A
    M = np.matmul(M1_inv, M2)
    return np.matmul(M, p)

def simulate_2d_model(p, A, T, delta, timestep_func):
    '''
    This function simulates 2-dimensional dynamic models for T unit time steps.

    Inputs
        p            : initial value vector (numpy array length 2)
        A            : coefficient matrix (2x2 numpy array)
        T            : number of unit steps
        delta        : size of individual time steps (<<1)
        timestep_func: a function that implements one time step increment of size delta (ee, ie, cn)

    Output
        Time series array of values, starting with the initial values
    '''
    # number of time increments
    U = int(T / delta) # to make sure it is an integer!

    results = np.empty((2, U+1))
    results[:,0] = p

    for u in range(U):
        p = timestep_func(p, A, delta)
        results[:,u+1] = p

    return results

def animate_samuelson(results, T):
    x_iso = np.array([-1, 3])

    p1_iso = 0.5 * x_iso
    p2_iso = x_iso

    fig, (ax1, ax2) = plt.subplots(nrows=1, ncols=2, figsize=(14,6))

    plt.suptitle("Samuelson's 2-goods model", fontsize=18)
    ax1.set_title("time series", fontsize=14)
    ax2.set_title("phase portrait", fontsize=14)

    x_ts = np.linspace(0, T, len(results[0]))

    ts1, = ax1.plot([], [], lw=0.7, c="darkblue", label="$p_1$")
    ts2, = ax1.plot([], [], lw=0.7, c="darkred", label="$p_2$")
    ts1_dot, = ax1.plot([], [], c="darkblue", marker="o")
    ts2_dot, = ax1.plot([], [], c="darkred", marker="o")
    ax1.hlines(0, 0, T, ls="--", lw=0.7, color="black", label="steady state")

    ax1.legend(fontsize=14)

    ps, = ax2.plot([], [], lw=0.7, c="darkgreen")
    ps_dot, = ax2.plot([], [], c="darkgreen", marker="o")
    ax2.plot(x_iso, p1_iso, lw=0.7, c="black", ls='--')
    ax2.plot(x_iso, p2_iso, lw=0.7, c="black", ls='--')

    ax1.grid(alpha=0.4)
    ax2.grid(alpha=0.4)

    ax1.set_xlim(0, T)
    ax1.set_ylim(-1.1, 3.1)
    ax2.set_xlim(-1.1, 3.1)
    ax2.set_ylim(-1.1, 3.1)
    ax1.set_xticks(np.arange(0, T+1, 2))
    ax1.set_yticks(np.arange(-1, 3, 1))
    ax2.set_xticks(np.arange(-1, 3, 1))
    ax2.set_yticks(np.arange(-1, 3, 1))

    ax1.set_xlabel("$t$", fontsize=14)
    ax1.set_ylabel("$p_1$, $p_2$", fontsize=14)
    ax2.set_xlabel("$p_1$", fontsize=14)
    ax2.set_ylabel("$p_2$", fontsize=14)

    # path the script is executed from
    script_path = os.path.dirname(os.path.realpath(__file__))
    file_name = "samuelson2goods.gif"
    # join file name and path
    file_path = os.path.join(script_path, file_name)

    writer = PillowWriter(fps=50)
    with writer.saving(fig, file_path, 100):
        for u in range(len(results[0])):
            ts1.set_data(x_ts[:u], results[0,:u])
            ts2.set_data(x_ts[:u], results[1,:u])
            ts1_dot.set_data(x_ts[u], results[0,u])
            ts2_dot.set_data(x_ts[u], results[1,u])

            ps.set_data(results[0,:u], results[1,:u])
            ps_dot.set_data(results[0,u], results[1,u])

            writer.grab_frame()
    print(f"animation saved to {file_path}")

def animate_accuracy_comparison(results_ee, results_ie, results_cn):
    fig = plt.figure(figsize=(10,10))
    plt.title("Comparison of timestepping schemes\n in terms of accuracy", fontsize=18)

    ee, = plt.plot([], [], c="blue", lw=0.7, label="Explicit Euler")
    ie, = plt.plot([], [], c="red", lw=0.7, label="Implicit Euler")
    cn, = plt.plot([], [], c="black", lw=0.7, label="Crank-Nicolson")

    ee_dot, = plt.plot([], [], c="blue", marker="o")
    ie_dot, = plt.plot([], [], c="red", marker="o")
    cn_dot, = plt.plot([], [], c="black", marker="o")

    plt.xlabel("y", fontsize=14)
    plt.ylabel("y'", fontsize=14)

    plt.xlim(-4.5, 4.5)
    plt.ylim(-6.5, 6.5)
    plt.xticks([])
    plt.yticks([])

    plt.legend(fontsize=14, loc="upper right")

    # path the script is executed from
    script_path = os.path.dirname(os.path.realpath(__file__))
    file_name = "accuracy_comparison.gif"
    # join file name and path
    file_path = os.path.join(script_path, file_name)

    writer = PillowWriter(fps=20)
    with writer.saving(fig, file_path, 100):
        for u in range(len(results_ee[0])):
            ee.set_data(results_ee[0,:u], results_ee[1,:u])
            ie.set_data(results_ie[0,:u], results_ie[1,:u])
            cn.set_data(results_cn[0,:u], results_cn[1,:u])

            ee_dot.set_data(results_ee[0,u], results_ee[1,u])
            ie_dot.set_data(results_ie[0,u], results_ie[1,u])
            cn_dot.set_data(results_cn[0,u], results_cn[1,u])

            writer.grab_frame()
    print(f"animation saved to {file_path}")


if __name__ == '__main__':

    ##########################################
    # Samuelson 2-goods model
    ##########################################
    T = 10 # 10 unit time steps
    delta = 1/64

    p = np.array([2,2]) # initial price vector

    A = np.array(
        [[-2, 4],
        [-1, 1]]
    ) # coefficient matrix

    results = simulate_2d_model(p, A, T, delta, cn_2goods)
    animate_samuelson(results, T)

    ##########################################
    # Accuracy comparison
    ##########################################
    A = np.array(
        [[0, 1],
        [-2, 0]]
    )

    y0 = np.array([2,2])

    T = 20
    delta = 1/32

    # we can apply the 2-goods model function, as the steps are exactly the same!
    results_ee = simulate_2d_model(y0, A, T, delta, ee_2goods)
    results_ie = simulate_2d_model(y0, A, T, delta, ie_2goods)
    results_cn = simulate_2d_model(y0, A, T, delta, cn_2goods)

    animate_accuracy_comparison(results_ee, results_ie, results_cn)




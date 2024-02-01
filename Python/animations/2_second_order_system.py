# animate the plot representing the second order system in the second tutorial
# simulation code is copied from the solution of the second tutorial, only
# the animation part is added

import os

import numpy as np
import matplotlib.pyplot as plt

# for animation output
from matplotlib.animation import PillowWriter

from matplotlib import rc
rc("text", usetex=True)

def system_1step(yz_t, A, g):
    return np.matmul(A, yz_t) + g

yz_0 = np.array([1600, 1300])
A = np.array(
    [[1.1, -0.6],
     [1, 0]]
)
g = np.array([1100, 0])

T = 25

results = np.empty((2, T+1))
results[:,0] = yz_0

# iterate T times
for t in range(T):
    results[:,t+1] = system_1step(results[:,t], A, g)

def animate_2_order_system(results, T):
    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(14, 6))
    plt.suptitle("Second-order equation as first-order 2x2 system")

    ax1.set_title("Behaviour over time", fontsize=10)
    ax1.plot([2200]*(T+1), color="black", lw=0.7, ls="--", label="ss")
    ts, = ax1.plot([], [], color="darkblue", lw=0.7, label="$y_t$")
    ts_dot, = ax1.plot([], [], marker="o", color="darkblue")
    ax1.legend()

    ax1.set_xlabel("$t$")
    ax1.set_ylabel("$y$")

    ax1.set_xlim(0, T+1)
    ax1.set_ylim(1600, 2600)
    ax1.set_xticks(np.arange(0, T+1, 5))
    ax1.set_yticks(np.arange(1600, 2600+1, 200))

    #######################

    ax2.set_title("Behaviour in phase space", fontsize=10)
    ax2.scatter((2200), (2200), color="black", label="steady state")
    ps, = ax2.plot([], [], color="green", lw=0.7, label="path")
    ps_dot, = ax2.plot([], [], marker="o", color="green")

    # isoclines
    y = np.array([1700, 2500]) # two points are enough for straight lines
    ybar = y / 6 + 1100 / 0.6
    zbar = y
    # plot iscoclines
    ax2.plot(y, ybar, color="black", lw=0.7, ls="--", label="isoclines")
    ax2.plot(y, zbar, color="black", lw=0.7, ls="--")


    ax2.set_xlabel("$y_t$")
    ax2.set_ylabel("$y_{t-1}$")
    ax2.set_xlim(1600, 2600)
    ax2.set_ylim(1300, 2600)
    ax2.set_xticks(np.arange(1600, 2600+1, 200))
    ax2.set_yticks(np.arange(1400, 2600+1, 200))
    ax2.legend()

    writer = PillowWriter(fps=2)

    # path the script is executed from
    script_path = os.path.dirname(os.path.realpath(__file__))
    file_name = "2_order_system.gif"
    # join file name and path
    file_path = os.path.join(script_path, file_name)

    with writer.saving(fig, file_path, 100):
        for t in range(1, T+1):
            ts.set_data(np.linspace(1, t+1, t+1), results[0,:t+1])
            ts_dot.set_data(t+1, results[0,t])
            ps.set_data(results[0,:t+1], results[1,:t+1])
            ps_dot.set_data(results[0,t], results[1,t])
            writer.grab_frame()

if __name__ == '__main__':
    animate_2_order_system(results, T)
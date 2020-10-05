import numpy as np
import responseClass as rC
import matplotlib.pyplot as plt
stepI = "tests/StepInput"
stepIF = "tests/StepInputFlip"

response = {}
for i in range(3):
    with open(stepI + str(i) + ".csv", "r") as file:
        response["I" + str(i)] = rC.responseClass(np.loadtxt(file, delimiter=",", skiprows = 1))
        response["I" + str(i)].loc = (0,i)
    with open(stepIF + str(i) + ".csv", "r") as file:
        response["IF" + str(i)] = rC.responseClass(np.loadtxt(file, delimiter=",", skiprows = 1))
        response["IF" + str(i)].loc = (1,i)

fig, axs = plt.subplots(2,3)
for v in response.values():
    print(v.delay)
    axs[v.loc].plot(v.t[v.bound] - v.delay, v.r[v.bound])
    axs[v.loc].plot(v.t[v.bound], v.c[v.bound])
    axs[v.loc].plot(v.t[v.bound], v.f[v.bound])
    #axs[i,j].plot(v.t[0:-1], v.dc)
plt.show()
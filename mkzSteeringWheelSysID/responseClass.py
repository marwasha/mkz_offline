import numpy as np

class responseClass:
    alpha = 3.75
    def filter(self, data):
        f = []
        f.append(data[0])
        for i in range(len(data) - 1):
            n = f[i]*(1-self.dt[i]*self.alpha) + self.dt[i]*self.alpha*data[i]
            f.append(n)
        return np.array(f)
    def __init__(self, data):
        self.t = data[:,0]
        self.r = data[:,1]
        self.c = data[:,2]
        self.dt = self.t[1:] - self.t[0:-1]
        self.dr = (self.r[1:] - self.r[0:-1]) / self.dt
        self.dc = (self.c[1:] - self.c[0:-1]) / self.dt
        self.switch = self.t[0:-1][abs(self.dc) > .1][0]
        low = self.t > (self.switch - 1)
        high = self.t < (self.switch + 3)
        self.bound = [a and b for a, b in zip(low, high)]
        self.delay = self.t[self.bound][abs(self.dr[self.bound[0:-1]]) > .1][0] - self.switch
        self.f = self.filter(self.c)

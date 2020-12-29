clear all 

filename = "driver_test_lc_video";
folder = "Data";
data = readtable(folder + "\" + filename + ".csv");
name = "Autonomous Lane Change OLD:";

[r c] = size(data);
dt = 1/25;
T = r*dt - dt;

t = 0:dt:T;

figure(1)
plot(t,data.uOpt,t,data.uUser, t,data.uOut)
xlim([2,T])
ylim([-.6 .6])
ylabel("Input")
xlabel("time (s)")
legend("optimum", "user", "blended")
title(name + " Input Data")

figure(2)
plot(t,data.M)
xlim([2,T])
ylabel("Barrier Magnitute")
xlabel("time (s)")
title(name + " Barrier Magnitude Plots")

figure(3)
subplot(2,2,1)
plot(t,data.y)
ylabel("offset")
xlim([2,T])
subplot(2,2,2)
plot(t,data.nu)
ylabel("Lateral Velocity")
xlim([2,T])
subplot(2,2,3)
plot(t,data.r)
ylabel("Yaw Error")
xlim([2,T])
xlabel("time (s)")
subplot(2,2,4)
plot(t,data.dPsi)
ylabel("Yaw Rate")
xlim([2,T])
xlabel("time (s)")
sgtitle(name + " State Measurements")


figure(4)
wgs84 = wgs84Ellipsoid;
lat0 = 42.30095833;
lon0 = -83.69758056;
h0 = 0;
format shortG
[xEast,yNorth,zUp] = geodetic2enu(data.latitude,data.longitude,data.el,lat0,lon0,h0,wgs84);
plot(xEast,yNorth)
axis equal
xlabel("x (m)")
ylabel("y (m)")
title(name + " Top Down Plot")

figure(5)


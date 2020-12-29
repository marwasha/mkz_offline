function xdot = linlkDynamics(x,u,d,con)

assert(length(x) == 5);
xdot = zeros(5,1);

% Model (z forward speed)
% \dot x = (A + Ap1/z + Ap2*z ) x + B u + E v

A = [0 1 0 0 0;
     0 0 0 0 con.Caf/con.m;
     0 0 0 1 0;
     0 0 0 0 con.a*(con.Caf/con.Iz);
     0 0 0 0 -con.tau];
B = [0; 0; 0; 0; con.tau];
Ev = [0; 0; -1; 0; 0];

% Parameter dependence
c22 = -((con.Caf+con.Car)/con.m);
c24 = (con.b*con.Car - con.a*con.Caf)/con.m;
c42 = ((con.b*con.Car-con.a*con.Caf)/con.Iz);
c44 = -((con.a^2*con.Caf+con.b^2*con.Car)/con.Iz);

Ap1 = [0 0 0 0 0;
       0 c22 0 c24 0;
       0 0 0 0 0;
       0 c42 0 c44 0;
       0 0 0 0 0];

Ap2 = [0 0 1  0 0;
       0 0 0 -1 0;
       0 0 0  0 0;
       0 0 0  0 0;
       0 0 0  0 0];

Ah = A + Ap1/con.u_ave + Ap2*con.u_ave;

xdot = Ah*x + B*u + Ev*d;

end
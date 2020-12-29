function xdot = nonlinlkDynamics(x,u,d,con, long_speed)

if (nargin < 5)
    long_speed = con.u_ave;
end


assert(length(x) == 5);
xdot = zeros(5,1);

xdot(1) =  x(2)*cos(x(3)) + long_speed*sin(x(3));
xdot(2) = -con.Car*(x(2)-x(4)*con.b)/(long_speed*con.m) + ...
          -con.Caf*(x(2)+x(4)*con.a)/(long_speed*con.m) + ...
          -x(4)*long_speed + con.Caf*x(5)/con.m;
xdot(3) =  x(4) - d;
xdot(4) = -con.a*con.Caf*(x(2)+x(4)*con.a)/(long_speed*con.Iz) + ...
           con.b*con.Car*(x(2)-x(4)*con.b)/(long_speed*con.Iz) + ...
           con.a*con.Caf*x(5)/con.Iz;
xdot(5) =  con.tau*(u-x(5));

end
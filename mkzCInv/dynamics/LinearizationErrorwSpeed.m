function bnds = LinearizationErrorwSpeed(con)
% This function will check for the maximum deviations of or linear dynamics
    % from the nonlinear dynamics withen our bounded domain
    X = Polyhedron('A', [eye(8); -eye(8)], ...
                   'b', [con.y_max; con.nu_max; con.psi_max; con.r_max; ...
                         con.df_max; con.df_max; con.rd_ave; .05; ...
                         con.y_max; con.nu_max; con.psi_max; con.r_max; ...
                         con.df_max; con.df_max; con.rd_ave; .05]);
    X.computeVRep;
    [R,~] = size(X.V);
    % Expecting These to be symetric
    maxs = zeros(5,1);
    mins = zeros(5,1);
    for i = 1:R
       x = X.V(i,1:5)';
       u = X.V(i,6);
       d = X.V(i,7);
       long_speed = con.u_ave + X.V(i,8);
       xdote = nonlinlkDynamics(x,u,d,con, long_speed) - linlkDynamics(x,u,d,con);
       idxMax = xdote > maxs;
       idxMin = xdote < mins;
       maxs(idxMax) = xdote(idxMax);
       mins(idxMin) = xdote(idxMin);
    end

    if sum(abs(abs(maxs) - abs(mins)) < .0000001) == 5
       bnds = maxs; 
       return;
    end
    bnds = [maxs mins];
    return;
end

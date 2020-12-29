mptopt('lpsolver', 'gurobi');

lkDynamics

%%


XU = Polyhedron('H', [0 0 0 0 0  1 con.df_max; 
                      0 0 0 0 0 -1 con.df_max]);

Fp1 = zeros(5,1);
Fp2 = zeros(5,1);

% Over-approximation of parameters
syms z;
P = compute_hull([1/z, z], [con.u_min con.u_max], 1);

% External disturbance
if con.rd_max > con.rd_min
  V_max = con.rd_min - con.u_min*(con.rd_max-con.rd_min)/(con.u_max-con.u_min);
  V_max_p2 = (con.rd_max-con.rd_min)/(con.u_max-con.u_min);
  XV_V = {[0 0 0 0 0 0 V_max_p2 V_max], [0 0 0 0 0 0 -V_max_p2 -V_max]};
else
  XV_V = {[0 0 0 0 0 0 0 con.rd_max], [0 0 0 0 0 0 0 -con.rd_max]};
end

% Dyn object
dyn = Dyn(A_d, [], B_d, XU, ...
          {Ap1_d, Ap2_d}, {Fp1, Fp2}, P, ...
          [], [], [], ...
          Ev_d, XV_V);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%% Compute invariant set %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

X = Polyhedron('A', [eye(5); -eye(5)], ...
			         'b', [con.y_max; con.nu_max; con.psi_max; con.r_max; con.df_max; ...
                     con.y_max; con.nu_max; con.psi_max; con.r_max; con.df_max]);

Cinv = dyn.win_always(X, con.rho_lk, 0, 1);

if ~Cinv.isEmptySet
  poly_A = Cinv.A;
  poly_b = Cinv.b;
  save('results/lk_cinv', 'poly_A', 'poly_b', 'con')
end 

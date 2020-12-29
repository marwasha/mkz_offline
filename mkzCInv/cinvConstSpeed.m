%% Setup

clear all
mptopt('lpsolver', 'gurobi');
addpath('pcis\lib')
addpath('dynamics')
con = constants;
lkDynamics

%% Find Linearization Error Bounds

Dum_bnd = LinearizationError(con);
idx = (Dum_bnd > .00001);
Eum = zeros(con.dn,0);
for i = 1:length(idx)
    if idx(i) == 1
        temp = zeros(con.dn,1);
        temp(i) = 1;
        Eum = [Eum temp];
    end
end

%% Find Cinv

XU = Polyhedron('H', [zeros(1,con.dn)  1 con.df_max; 
                      zeros(1,con.dn) -1 con.df_max]);
P = Polyhedron('H', [1 con.rd_ave; -1 con.rd_ave]);
D = Polyhedron('H', [1 Dum_bnd(1)*con.dt; -1 Dum_bnd(1)*con.dt]);
                  

% Dyn object
dyn = Dyn(Ah_d, [], B_d, XU, ...
          [], Ev, P, ...
          [], Eum, D);
      
X = Polyhedron('A', [eye(5); -eye(5)], ...
			         'b', [con.y_max; con.nu_max; con.psi_max; con.r_max; con.df_max; ...
                     con.y_max; con.nu_max; con.psi_max; con.r_max; con.df_max]);
      
Cinv = dyn.win_always(X, con.rho_lk, 0, 1);

%% Save Results

if ~Cinv.isEmptySet
  W_A = Cinv.A;
  W_b = Cinv.b;
  dyn_A = Ah_d;
  dyn_B = B_d;
  dyn_Ed = Eum;
  dyn_Ep = Ev_d;
  bnd_Ed = Dum_bnd(1)*con.dt;
  bnd_Ep = con.rd_ave;
  delay = con.delay;
  dt = con.dt;
  pos_to_save = strcat("Cinv/Cinv", num2str(con.mph_u_ave));
  save(pos_to_save, 'bnd_Ed', 'dyn_A', 'dyn_B', 'dyn_Ed', 'dyn_Ep', 'W_A', 'W_b', 'delay', 'dt')
end 
function con = constants
    MPH2MPS = 0.44704;

    % State Dimensions
    con.dn = 5;
    con.dm = 1;
    con.ddm = 1;
    con.ddum = 1;
    % Delay Param
    con.tau = 3.75;
    con.delay = .12; %seconds

    % Common parameters
    con.m = 1800; %kg

    % ACC parameters
    con.f0bar = 74.63;
    con.f1bar = 40.59;

    % ACC bounds
    con.u_min = 9*MPH2MPS;
    con.u_max = 11*MPH2MPS;
    con.mph_u_ave = 20;
    con.u_ave = con.mph_u_ave*MPH2MPS;
    con.h_min = 5;
    con.vl = 7;

    con.Fw_max = 2*con.m;
    con.Fw_min = -3*con.m;

    % LK parameters
    con.Iz = 3270; % kgm^2
    con.a = 1.2; % m
    con.b = 1.65; % m
    con.Caf = 1.4e5; % N/rad 
    con.Car = 1.2e5; % N/rad
    con.steeringRatio = 14.8; %Steering angle to wheel angle
    con.maxWheelTurn = 450/con.steeringRatio; %Degrees

    % LK bounds
    con.y_max = 0.9;
    con.nu_max = 1;             % max lateral speed [m/s]
    con.psi_max = deg2rad(20);  % max yaw angle     [deg]
    con.r_max = deg2rad(90);    % max yaw rate      [deg/s]
    
    con.df_max = deg2rad(con.maxWheelTurn);        % control
    con.rd_ave = 0.06 * con.u_ave;   % inverse curvature at average s[[ed
    con.rd_max = 0.06 * con.u_min;   % inverse curvature at lowest speed
    con.rd_min = 0.06 * con.u_max;   % inverse curvature at highest speed

    % Time discretization
    con.dt = 0.04;
    con.delaySteps = ceil(con.delay/con.dt);

    % Rho factors for convergence
    con.rho_lk = 0.02*[con.y_max; con.nu_max; con.psi_max; con.r_max; con.df_max];
    con.rho_acc = [0.05; 0.05];
end

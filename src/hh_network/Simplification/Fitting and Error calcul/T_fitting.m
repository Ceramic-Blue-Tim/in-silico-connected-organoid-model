
%% Add path
    addpath(genpath('../../Ionnic Channel'),genpath('../../Tools'), genpath('../../Synapses'), genpath('../../Datas'));

%% Import data from neuron (FS)
    dt          = 0.01;
    Vmem        = -90:dt:50;
    l_V         = length(Vmem);

%% Matrix Initialization
    T           = zeros(1, l_V);
    T_error     = zeros(1, l_V);
    
    T_fitfunc= '0.5*tanh((x+c)/d)+0.5'; TInit = [1 1];
    
   Tmax    = 1;   %mM
   Vp      = 2;   %mV
   Kp      = 5;   %mV
       
%% Computation
    for i = 1:l_V-1

        T(i)           = (Tmax/(1+exp(-(Vmem(i) - Vp)/Kp))); 
    end

%% Fitting
    T_fit    = fit(Vmem', T', T_fitfunc, 'start', TInit);
    
%% Error Calcul

    T_fitted  = T_fit(Vmem);
    
    RMSE_T   = 0;

    for i = 1:l_V-1
        T_error(i)   = abs(T(i) - (T_fitted(i)));

        RMSE_T       = RMSE_T + (T(i) - (T_fitted(i)))^2;
    end

%% Plot
    figure;
    subplot(2,1,1);
    plot(Vmem, T_fitted, Vmem, T);
    title('uinf');
    subplot(2,1,2);
    plot(Vmem, T_error);
    title('Error u_{inf}');

%% Display
    % Root-Mean Square Error
    disp(' -**** Root Mean Square Error ****-');
    disp('RMSE T');
    disp(RMSE_T);
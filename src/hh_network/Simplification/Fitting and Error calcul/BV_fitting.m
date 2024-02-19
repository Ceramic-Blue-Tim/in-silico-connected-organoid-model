
%% Add path
    addpath(genpath('../../Ionnic Channel'),genpath('../../Tools'), genpath('../../Synapses'), genpath('../../Datas'));

%% Import data from neuron (FS)
    dt          = 0.01;
    Vmem        = -90:dt:50;
    l_V         = length(Vmem);

%% Matrix Initialization
    Bv           = zeros(1, l_V);
    Bv_error     = zeros(1, l_V);
    
    Bv_fitfunc= '0.5*tanh((x+c)/32)+0.5'; TInit = [1];
    
   Tmax    = 1;   %mM
   Vp      = 2;   %mV
   Kp      = 5;   %mV
       
%% Computation
    for i = 1:l_V-1

        Bv(i)           = 1/(1 + (1/3.57)*exp(0.062*-Vmem(i))*10^-3); 
    end

%% Fitting
    T_fit    = fit(Vmem', Bv', Bv_fitfunc, 'start', TInit);
    
%% Error Calcul

    T_fitted  = T_fit(Vmem);
    
    RMSE_T   = 0;

    for i = 1:l_V-1
        Bv_error(i)   = abs(Bv(i) - (T_fitted(i)));

        RMSE_T       = RMSE_T + (Bv(i) - (T_fitted(i)))^2;
    end

%% Plot
    figure;
    subplot(2,1,1);
    plot(Vmem, T_fitted, Vmem, Bv);
    title('uinf');
    subplot(2,1,2);
    plot(Vmem, Bv_error);
    title('Error u_{inf}');

%% Display
    % Root-Mean Square Error
    disp(' -**** Root Mean Square Error ****-');
    disp('RMSE T');
    disp(RMSE_T);
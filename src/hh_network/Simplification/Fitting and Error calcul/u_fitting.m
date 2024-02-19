
%% Add path
    addpath(genpath('../../Ionnic Channel'),genpath('../../Tools'), genpath('../../Synapses'), genpath('../../Datas'));

%% Import data from neuron (FS)
    dt          = 0.01;
    Vmem        = -900:dt:50;
    l_V         = length(Vmem);

%% Matrix Initialization
    uinf        = zeros(1, l_V);
    tauu        = zeros(1, l_V);   
    
    expX1       = zeros(1, l_V);   
    expX2       = zeros(1, l_V);   

    u           = zeros(1, l_V);
    u_fit       = zeros(1, l_V);

    uinf_error  = zeros(1, l_V);
    tauu_error  = zeros(1, l_V);
    u_error     = zeros(1, l_V);
    
%     uinf_fitfunc= '1/(1 + exp((a+x)/b))';
%     uinf_fitfunc= '1/(1 + exp((a+x)/b))';
    uinf_fitfunc= 'a*tanh((x+c)/d)+e'; uinfInit = [1 1 1 1];
    tauu_fitfunc= 'a*tanh((x+c)/d)+e'; tauufInit = [1 1 1 1];
%     tauu_fitfunc= '((a*x+b)/cosh((x+c)/d))+e'; tauufInit = [1 1 1 1 1];

%a = 30.8 + ((211.4 + exp((v+vx+113.2)/5)) / (1 + exp((v+vx+84)/3.2))) * (1/(3 ^ 1.2)) 
    
%% Computation
    for i = 1:l_V-1
        uinf(i)     =   u_inf(Vmem(i));
        tauu(i)     =   tau_u(Vmem(i));

        du          =   (uinf(i)-u(i))/tauu(i);
        u(i+1)      = Euler(du, u(i), dt);
    end

%% Fitting
    uinf_fit    = fit(Vmem', uinf', uinf_fitfunc, 'start', uinfInit);
    tauu_fit    = fit(Vmem', tauu', tauu_fitfunc, 'start', tauufInit);
    
%% Error Calcul

    y_uinf_fit  = uinf_fit(Vmem);
    y_tauu_fit  = tauu_fit(Vmem);

    RMSE_uinf   = 0;
    RMSE_tauu   = 0;
    RMSE_u      = 0;

    for i = 1:l_V-1
        uinf_error(i)   = abs(uinf(i) - (y_uinf_fit(i)));
        tauu_error(i)   = abs(tauu(i) - y_tauu_fit(i));

        RMSE_uinf       = RMSE_uinf + (uinf(i) - (y_uinf_fit(i)))^2;
        RMSE_tauu       = RMSE_tauu + (tauu(i) - y_tauu_fit(i))^2;

        du              = (y_uinf_fit(i) - u_fit(i))/y_tauu_fit(i);
        u_fit(i+1)      = Euler(du, u_fit(i), dt);

        u_error(i)      = abs(u(i) - u_fit(i))/abs(u(i));
        RMSE_u          = RMSE_u + (u(i) - u_fit(i))^2;
    end

%% Plot
    figure;

    subplot(3,2,1);
    plot(uinf_fit, Vmem, uinf);
    title('uinf');
    subplot(3,2,2);
    plot(Vmem, uinf_error);
    title('Error u_{inf}');

    subplot(3,2,3);
    plot(tauu_fit, Vmem, tauu);
    title('tau_u');
    subplot(3,2,4);
    plot(Vmem, tauu_error);
    title('Error tau_u');

    subplot(3,2,5);
    plot(Vmem, u, Vmem, u_fit);
    title('u (blue) and simplified u (green)');
    subplot(3,2,6);
    plot(Vmem, u_error.*100);
    title('Error u');

%% Display
    % Root-Mean Square Error
    disp(' -**** Root Mean Square Error ****-');
    disp('RMSE u_{inf}');
    disp(RMSE_uinf);
    
    disp('RMSE tau_u');
    disp(RMSE_tauu);

    disp('RMSE u');
    disp(RMSE_u);
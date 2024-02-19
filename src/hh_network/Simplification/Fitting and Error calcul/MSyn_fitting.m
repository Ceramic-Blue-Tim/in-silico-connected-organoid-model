
%% Add path
    addpath(genpath('../../Ionnic Channel'),genpath('../../Tools'), genpath('../../Synapses'), genpath('../../Datas'));

%% Import data from neuron (FS)
    dt          = 0.01;
    dtSI        = dt*10^-3;
    Vmem        = -90:dt:60;
    VmemSI      = Vmem .* 10^-3;
    l_V         = length(Vmem);

%% Matrix Initialization
    Minftab     = zeros(1, l_V);
    Testtab     = zeros(1, l_V);
    M           = zeros(1, l_V);
    M_fit       = zeros(1, l_V);
    dM       = zeros(1, l_V);
    
    Minf_error  = zeros(1, l_V);
    M_error     = zeros(1, l_V);
    
    M_fitfunc= 'a*tanh(c + 500*x)+d';    minfInit = [0.4499 20.01 0.5499];

%% Computation
    for i = 1:l_V-1
        Minftab(i)  =   Minf(VmemSI(i));    
        dM(i)       =   0.5*(Minftab(i)-M(i));
        M(i+1)      =   dtSI*dM(i) + M(i);
    end

%% Fitting
    Minf_fit    = fit(VmemSI', Minftab', M_fitfunc);

%% Error Calcul
    y_minf_fit  = Minf_fit(VmemSI);

    RMSE_Minf   = 0;
    RMSE_M      = 0;

    for i = 1:l_V-1
        Minf_error(i)   = abs(Minftab(i) - (y_minf_fit(i)))/abs(Minftab(i));

        RMSE_Minf       = RMSE_Minf + (Minftab(i) - (y_minf_fit(i)))^2;

        dMfit              = (y_minf_fit(i) - M_fit(i))*0.5;
        M_fit(i+1)      = Euler(dMfit, M_fit(i), dtSI);

        M_error(i)      = abs(M(i) - M_fit(i))/abs(M(i));
        RMSE_M          = RMSE_M + (M(i) - M_fit(i))^2;
    end
    
%% Plot
    figure;
    set(gca,'FontSize',18)

    subplot(2,2,1);
    plot(Minf_fit, VmemSI, Minftab);
    xlabel('Vmem','fontsize',18); ylabel('m_{inf}','fontsize',18);
    title('minf', 'fontsize',18);
    subplot(2,2,2);
    plot(Vmem, Minf_error.*100, 'linewidth',4);
    xlabel('Vmem','fontsize',18); ylabel('error (%)','fontsize',18);
    title('Error m_{inf}', 'fontsize',18);

    subplot(2,2,3);
    hold on;
    plot(VmemSI, M,'linewidth',4);
    plot(VmemSI, M_fit, 'r--', 'linewidth',2);
    xlabel('Vmem','fontsize',18); ylabel('m','fontsize',18);
    title('m (blue) and simplified m (green)', 'fontsize',18);
    subplot(2,2,4);
    plot(VmemSI, M_error.*100, 'linewidth',4);
    xlabel('Vmem','fontsize',18); ylabel('error (%)','fontsize',18);
    title('Error m', 'fontsize',18);

%% Display
    % Root-Mean Square Error
    disp(' -**** Root Mean Square Error ****-');
    disp('RMSE m_{inf}');
    disp(RMSE_Minf);

    disp('RMSE m');
    disp(RMSE_M);
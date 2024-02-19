
%% Add path
    addpath(genpath('../Ionnic Channel'),genpath('../Tools'), genpath('../Synapses'), genpath('../Datas'));

%% Import data from neuron (FS)
    dt          = 0.01;
    Vmem        = -90:dt:60;
    l_V         = length(Vmem);

%% Matrix Initialization
    sinf        = zeros(1, l_V);

    sinf_error  = zeros(1, l_V);
    
    sinf_fitfunc= '(2^-1)*tanh(((2^-4)+(2^-6))*x+c)+d'; sinfInit = [1 1];

%% Computation
    for i = 1:l_V-1
        sinf(i)     =   s_inf(Vmem(i));
    end

%% Fitting
    sinf_fit    = fit(Vmem', sinf', sinf_fitfunc, 'start', sinfInit);

%% Error Calcul
    y_sinf_fit  = sinf_fit(Vmem);

    RMSE_sinf   = 0;

    for i = 1:l_V-1
        sinf_error(i)   = abs(sinf(i) - (y_sinf_fit(i)))/abs(sinf(i));
        RMSE_sinf       = RMSE_sinf + (sinf(i) - (y_sinf_fit(i)))^2;
    end
    
%% Plot
    figure;
    set(gca,'FontSize',18)

    subplot(2,1,1);
    plot(sinf_fit, Vmem, sinf);
    xlabel('Vmem','fontsize',18); ylabel('s_{inf}','fontsize',18);
    title('minf', 'fontsize',18);
    subplot(2,1,2);
    plot(Vmem, sinf_error.*100, 'linewidth',4);
    xlabel('Vmem','fontsize',18); ylabel('error (%)','fontsize',18);
    title('Error m_{inf}', 'fontsize',18);

%% Display
    % Root-Mean Square Error
    disp(' -**** Root Mean Square Error ****-');
    disp('RMSE s_{inf}');
    disp(RMSE_sinf);

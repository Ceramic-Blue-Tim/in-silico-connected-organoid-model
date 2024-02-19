%% Add path
    addpath(genpath('../../Ionnic Channel'),genpath('../../Tools'), genpath('../../Synapses'), genpath('../../Datas'));

%% Import data from neuron (FS)
    dt          = 0.01;
    Vmem        = -90:0.01:60;
    SplineVmem  = -90:1:60;
    l_V         = length(Vmem);
    Spline_lV   = length(SplineVmem);
    VTraub      = -55;
    
    ninf        = zeros(1, l_V);  
    taun        = zeros(1, l_V);      
    n           = zeros(l_V, 1);
    
    Splineninf  = zeros(1, Spline_lV);
    Splinetaun  = zeros(1, Spline_lV);
    Splinen     = zeros(1, Spline_lV);
    
    ninf_error  = zeros(1, l_V);
    taun_error  = zeros(1, l_V);
    n_error     = zeros(1, l_V);
  
%% Computation
    for i = 1:l_V
        ninf(i)     =   n_inf(Vmem(i), VTraub);
        taun(i)     =   tau_n(Vmem(i), VTraub);
        
        dn          =   (ninf(i)-n(i))/taun(i);
        if i < l_V
            n(i+1)      =   Euler(dn, n(i), dt);
        end
    end
    
%% Save Minimal Useful Data
    Splinen(1)  = n(1);
    for i = 2:Spline_lV
        Splineninf(i)   =   n_inf(SplineVmem(i), VTraub);
        Splinetaun(i)   =   tau_n(SplineVmem(i), VTraub);
        Splinen(i)      =   n(i*10);
    end

%% Spline interpolation
    %spp = spline(SplineVmem, n, Vmem);
    sppninf = spline(SplineVmem, Splineninf, Vmem);

%% Error Calcul
    RMSE_ninf   = 0;
    RMSE_taun   = 0;
    RMSE_n      = 0;
    
    for i = 1:l_V-1
        % Relative Error
        ninf_error(i)   = abs(ninf(i) - sppninf(i))/abs(ninf(i));
        %taun_error(i)   = abs(taun(i) - y_taun_fit(i));
        
        %dnfit           = (sppninf(i) - n_fit(i))/y_taun_fit(i);
        %n_fit(i+1)      = Euler(dnfit, n_fit(i), dt);

        %n_error(i)      = abs(taun(i) - y_taun_fit(i));
        
        % Root Mean Square
        RMSE_ninf       = RMSE_ninf + (ninf(i) - (sppninf(i)))^2;
    end

%% Plot
    plot(SplineVmem, Splineninf, 'o', Vmem, sppninf, '-', Vmem, ninf);
    
%% Plot
    figure;
    set(gca,'FontSize',18)
    
    subplot(3,2,1);
    plot(Vmem, sppninf, Vmem, ninf);
    xlabel('Vmem','fontsize',18); ylabel('n_{inf}','fontsize',18);
    title('ninf', 'fontsize',18);
    subplot(3,2,2);
    plot(Vmem, ninf_error.*100, 'linewidth',4);
    xlabel('Vmem','fontsize',18); ylabel('error (%)','fontsize',18);
    title('Error n_{inf}', 'fontsize',18);

%     subplot(3,2,3);
%     plot(taum_fit, Vmem, taum);
%     xlabel('Vmem','fontsize',18); ylabel('tau_m','fontsize',18);
%     title('tau_m', 'fontsize',18);
%     subplot(3,2,4);
%     plot(Vmem, taum_error.*100, 'linewidth',4);
%     xlabel('Vmem','fontsize',18); ylabel('error (%)','fontsize',18);
%     title('Error tau_m', 'fontsize',18);
% 
%     subplot(3,2,5);
%     hold on;
%     plot(Vmem, m,'linewidth',4);
%     plot(Vmem, m_fit, 'r--', 'linewidth',2);
%     xlabel('Vmem','fontsize',18); ylabel('m','fontsize',18);
%     title('m (blue) and simplified m (green)', 'fontsize',18);
%     subplot(3,2,6);
%     plot(Vmem, m_error.*100, 'linewidth',4);
%     xlabel('Vmem','fontsize',18); ylabel('error (%)','fontsize',18);
%     title('Error m', 'fontsize',18);

%% Display
    % Root-Mean Square Error
    disp(' -**** Root Mean Square Error ****-');
    disp('RMSE n_{inf}');
    disp(RMSE_ninf);
    
%     disp('RMSE tau_m');
%     disp(RMSE_taum);
% 
%     disp('RMSE m');
%     disp(RMSE_m);
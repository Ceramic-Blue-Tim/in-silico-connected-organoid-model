
%% Add path
    addpath(genpath('../../Ionnic Channel'),genpath('../../Tools'), genpath('../../Synapses'), genpath('../../Datas'));

%% Import data from neuron (FS)
    dt          = 2^-5;
    Vmem        = -30:dt:60;
    l_V         = length(Vmem);

    Invtaum_simp   = @(v) cosh(1.32+0.04105*v)/(0.08938 + 0.0289*cosh(1.32+0.04105*v));

%% Matrix Initialization
    minf        = zeros(1, l_V);
    taum        = zeros(1, l_V);

    minfDivtaum = zeros(1, l_V);
    InvTaum     = zeros(1, l_V);

    m           = zeros(1, l_V);
    m_fit       = zeros(1, l_V);

    alpham      = zeros(1, l_V);

    minf_error  = zeros(1, l_V);
    minf_abserror  = zeros(1, l_V);
    taum_error  = zeros(1, l_V);
    m_error     = zeros(1, l_V);
   
    minf_fitfunc= '(a*x+b)*tanh(c*x+d)+e';    minfInit = [1 1 1 1 1];
%     minf_fitfunc= 'a*tanh(c+b*(x-(-55)))+d';    minfInit = [1 1 1 1];
%     minf_fitfunc= '0.5*tanh(c+(2^-4)*(x-(-55)))+d';    minfInit = [1 1];
%     minf_fitfunc= '0.5*tanh(c+(2^-4 + 2^-8)*(x-(-55)))+d';    minfInit = [1 1];
%     minf_fitfunc= '0.5*tanh(c+(2^-4 + 2^-8 + 2^-10)*(x-(-55)))+d';    minfInit = [1 1];
%     minf_fitfunc= '(a*x^2 + b*x + c)*tanh(d+e*(x-(-55)))+f';    minfInit = [1 1 1 1 1 1];
%     taum_fitfunc= '((a*x+b)/cosh(c*x+d))+e'; taumInit = [1 1 1 1 1];
    taum_fitfunc= '((a*x+b)/cosh(c*(x-(-55))+d))+e'; taumInit = [1 1 1 1 1];
    
%% Computation
    for i = 1:l_V-1
        minf(i)     =   m_inf(Vmem(i), -55);
        taum(i)     =   tau_m(Vmem(i), -55);

        dm          =   (minf(i)-m(i))/taum(i);
        m(i+1)      =   Euler(dm, m(i), dt);
    end

%% Fitting
    minf_fit    = fit(Vmem', minf', minf_fitfunc, 'start', minfInit);
    taum_fit    = fit(Vmem', taum', taum_fitfunc, 'start', taumInit);

%% Error Calcul
    y_minf_fit  = minf_fit(Vmem);
    y_taum_fit  = taum_fit(Vmem);

    RMSE_minf   = 0;
    RMSE_taum   = 0;
    RMSE_m      = 0;

    for i = 1:l_V-1
        minf_error(i)   = abs(minf(i) - (y_minf_fit(i)))/abs(minf(i));
        minf_abserror(i) = abs(minf(i) - (y_minf_fit(i)));
        taum_error(i)   = abs(taum(i) - y_taum_fit(i));

        RMSE_minf       = RMSE_minf + (minf(i) - (y_minf_fit(i)))^2;
        RMSE_taum       = RMSE_taum + (taum(i) - y_taum_fit(i))^2;

        dm              = (y_minf_fit(i) - m_fit(i))/y_taum_fit(i);

        m_fit(i+1)      = Euler(dm, m_fit(i), dt);

        m_error(i)      = abs(m(i) - m_fit(i));
        RMSE_m          = RMSE_m + (m(i) - m_fit(i))^2;
    end
    
%% Plot
    figure;
    set(gca,'FontSize',18)
    
    subplot(3,2,1);
    plot(minf_fit, Vmem, minf);
    xlabel('Vmem','fontsize',18); ylabel('m_{inf}','fontsize',18);
    title('minf', 'fontsize',18);
    subplot(3,2,2);
    plot(Vmem, minf_abserror, 'linewidth',4);
    xlabel('Vmem','fontsize',18); ylabel('error (%)','fontsize',18);
    title('Error m_{inf}', 'fontsize',18);

    subplot(3,2,3);
    plot(taum_fit, Vmem, taum);
    xlabel('Vmem','fontsize',18); ylabel('tau_m','fontsize',18);
    title('tau_m', 'fontsize',18);
    subplot(3,2,4);
    plot(Vmem, taum_error, 'linewidth',4);
    xlabel('Vmem','fontsize',18); ylabel('error (%)','fontsize',18);
    title('Error tau_m', 'fontsize',18);

    subplot(3,2,5);
    hold on;
    plot(Vmem, m,'linewidth',4);
    plot(Vmem, m_fit, 'r--', 'linewidth',2);
    xlabel('Vmem','fontsize',18); ylabel('m','fontsize',18);
    title('m (blue) and simplified m (green)', 'fontsize',18);
    subplot(3,2,6);
    plot(Vmem, m_error, 'linewidth',4);
    xlabel('Vmem','fontsize',18); ylabel('error (%)','fontsize',18);
    title('Error m', 'fontsize',18);

%% Display
    % Root-Mean Square Error
    disp(' -**** Root Mean Square Error ****-');
    disp('RMSE m_{inf}');
    disp(RMSE_minf);
    
    disp('RMSE tau_m');
    disp(RMSE_taum);

    disp('RMSE m');
    disp(RMSE_m);

%% Add path
    addpath(genpath('../../Ionnic Channel'),genpath('../../Tools'), genpath('../../Synapses'), genpath('../../Datas'));

%% Import data from neuron (FS)
    dt          = 0.01;
    Vmem        = -90:dt:60;
    l_V         = length(Vmem);

%% Matrix Initialization
    pinf        = zeros(1, l_V);
    taup        = zeros(1, l_V);   
    
    p           = zeros(1, l_V);
    p_fit       = zeros(1, l_V);

    pinf_error  = zeros(1, l_V);
    taup_error  = zeros(1, l_V);
    p_error     = zeros(1, l_V);
    
    pinf_fitfunc= '0.5*tanh(b+(2^-5 + 2^-6 + 2^-8)*x)+d'; pinfInit = [1 1];
%     pinf_fitfunc= '0.5*tanh((a+(x-(-55)))/b)+d'; pinfInit = [1 1 1];
%     taup_fitfunc= '(a/cosh((x+b)/20)) '; taupInit = [1 1];
    taup_fitfunc= '1/(a*cosh((c+x)*(1/d)))'; taupInit = [1 1 1];
    
%% Computation
    for i = 1:l_V-1
        pinf(i)     =   p_inf(Vmem(i));
        taup(i)     =   tau_p(Vmem(i), 1000);
        
        dp          =   (pinf(i)-p(i))/taup(i);
        p(i+1)      =   Euler(dp, p(i), dt);
    end

%% Fitting
    pinf_fit    = fit(Vmem', pinf', pinf_fitfunc, 'start', pinfInit);
    taup_fit    = fit(Vmem', taup', taup_fitfunc, 'start', taupInit);
    
%% Error Calcul
    epsilon = 0.007046494;
    y_pinf_fit  = pinf_fit(Vmem);
    y_taup_fit  = taup_fit(Vmem);

    RMSE_pinf   = 0;
    RMSE_taup   = 0;
    RMSE_p      = 0;

    for i = 1:l_V-1
        pinf_error(i)   = abs(pinf(i) - (y_pinf_fit(i)))/abs(pinf(i));
        taup_error(i)   = abs(taup(i) - y_taup_fit(i))/abs(taup(i));

        RMSE_pinf       = RMSE_pinf + (pinf(i) - (y_pinf_fit(i)))^2;
        RMSE_taup       = RMSE_taup + (taup(i) - y_taup_fit(i))^2;

        dp              = (y_pinf_fit(i) - p_fit(i))/y_taup_fit(i);
        p_fit(i+1)      = Euler(dp, p_fit(i), dt);

        p_error(i)      = abs(p(i) - p_fit(i))/abs(p(i));
        RMSE_p          = RMSE_p + (p(i) - p_fit(i))^2;
    end
    
%% Plot
    figure;

    subplot(3,2,1);
    plot(pinf_fit , Vmem, pinf);
    title('pinf');
    subplot(3,2,2);
    plot(Vmem, pinf_error.*100);
    title('Error p_{inf}');

    subplot(3,2,3);
    plot(taup_fit, Vmem, taup);
    title('tau_p');
    subplot(3,2,4);
    plot(Vmem, taup_error.*100);
    title('Error tau_p');

    subplot(3,2,5);
    plot(Vmem, p, Vmem, p_fit);
    title('p (blue) and simplified p (green)');
    subplot(3,2,6);
    plot(Vmem, p_error.*100);
    title('Error p');

%% Display
    % Root-Mean Square Error
    disp(' -**** Root Mean Square Error ****-');
    disp('RMSE p_{inf}');
    disp(RMSE_pinf);
    
    disp('RMSE tau_p');
    disp(RMSE_taup);

    disp('RMSE p');
    disp(RMSE_p);
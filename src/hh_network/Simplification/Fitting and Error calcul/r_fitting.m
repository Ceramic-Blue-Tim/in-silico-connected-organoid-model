
%% Add path
    addpath(genpath('../Ionnic Channel'),genpath('../Tools'), genpath('../Synapses'), genpath('../Datas'));

%% Import data from neuron (FS)
    dt          = 0.01;
    Vmem        = -90:dt:60;
    l_V         = length(Vmem);

%% Matrix Initialization
    rinf        = zeros(1, l_V);
    taur        = zeros(1, l_V);   

    r           = zeros(1, l_V);
    r_fit       = zeros(1, l_V);

    rinf_error  = zeros(1, l_V);
    taur_error  = zeros(1, l_V);
    r_error     = zeros(1, l_V);
    
    rinf_fitfunc= '(2^-1)*tanh(-(2^-6 + 2^-7)*x+b)+c'; rinfInit = [1 1];
    taur_fitfunc= '2^9*(((a*x + b)/cosh(c*x+d))+e)'; taurInit = [1 1 1 1 1];
    
%% Computation
    for i = 1:l_V-1
        rinf(i)     =   r_inf(Vmem(i));
        taur(i)     =   tau_r(Vmem(i));

        dr          =   (rinf(i)-r(i))/taur(i);
        r(i+1)      = Euler(dr, r(i), dt);
    end

%% Fitting
    rinf_fit    = fit(Vmem', rinf', rinf_fitfunc, 'start', rinfInit);
    taur_fit    = fit(Vmem', taur', taur_fitfunc, 'start', taurInit);
    
%% Error Calcul

    y_rinf_fit  = rinf_fit(Vmem);
    y_taur_fit  = taur_fit(Vmem);

    RMSE_rinf   = 0;
    RMSE_taur   = 0;
    RMSE_r      = 0;

    for i = 1:l_V-1
        rinf_error(i)   = abs(rinf(i) - (y_rinf_fit(i)))/abs(rinf(i));
        taur_error(i)   = abs(taur(i) - y_taur_fit(i))/abs(taur(i));

        RMSE_rinf       = RMSE_rinf + (rinf(i) - (y_rinf_fit(i)))^2;
        RMSE_taur       = RMSE_taur + (taur(i) - y_taur_fit(i))^2;

        dr              = (y_rinf_fit(i) - r_fit(i))/y_taur_fit(i);
        r_fit(i+1)      = Euler(dr, r_fit(i), dt);

        r_error(i)      = abs(r(i) - r_fit(i))/abs(r(i));
        RMSE_r          = RMSE_r + (r(i) - r_fit(i))^2;
    end

%% Plot
    figure;

    subplot(3,2,1);
    plot(rinf_fit, Vmem, rinf);
    title('rinf');
    subplot(3,2,2);
    plot(Vmem, rinf_error.*100);
    title('Error r_{inf}');

    subplot(3,2,3);
    plot(taur_fit, Vmem, taur);
    title('tau_r');
    subplot(3,2,4);
    plot(Vmem, taur_error.*100);
    title('Error tau_r');

    subplot(3,2,5);
    plot(Vmem, r, Vmem, r_fit);
    title('r (blue) and simplified r (green)');
    subplot(3,2,6);
    plot(Vmem, r_error.*100);
    title('Error r');

%% Display
    % Root-Mean Square Error
    disp(' -**** Root Mean Square Error ****-');
    disp('RMSE r_{inf}');
    disp(RMSE_rinf);
    
    disp('RMSE tau_r');
    disp(RMSE_taur);

    disp('RMSE r');
    disp(RMSE_r);
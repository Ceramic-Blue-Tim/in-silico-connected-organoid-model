
%% Add path
    addpath(genpath('../../Ionnic Channel'),genpath('../../Tools'), genpath('../../Synapses'), genpath('../../Datas'));

%% Import data from neuron (FS)
    dt          = 0.01;
    Vmem        = -90:dt:60;
    l_V         = length(Vmem);
    
    ninf        = zeros(1, l_V);
    
    taun        = zeros(1, l_V); 
    
    n           = zeros(1, l_V);
    n_fit       = n;
    
    test        = zeros(1, l_V);
    
    ninf_error  = zeros(1, l_V);
    ninf_abserror  = zeros(1, l_V);
    taun_error  = zeros(1, l_V);
    n_error     = zeros(1, l_V);
    
%     ninf_fitfunc= '((a*x+b)*tanh(c+d*x)+e)'; ninfInit = [1 1 1 1 1];
%     ninf_fitfunc= '((a*x+b)*tanh(c+d*(x-(-55)))+e)'; ninfInit = [1 1 1 1 1];
    ninf_fitfunc= '((a*(x+55)+b)*tanh(c+(2^-5 + 2^-6 + 2^-8)*(x-(-55)))+e)'; ninfInit = [1 1 1 1];
    taun_fitfunc= '(a/cosh(c+b*(x-(-55))))+d'; taunInit = [1 1 1 1];
    
%% Computation
    for i = 1:l_V-1
        ninf(i)     =   n_inf(Vmem(i), -55);
        taun(i)     =   tau_n(Vmem(i), -55);
        
        dn          =   (ninf(i)-n(i))/taun(i);
        n(i+1)      =   Euler(dn, n(i), dt);
    end

%% Fitting
    ninf_fit    = fit(Vmem', ninf', ninf_fitfunc, 'start', ninfInit);
    taun_fit    = fit(Vmem', taun', taun_fitfunc, 'start', taunInit);
    
%% Relative Error Calcul (%)
    y_ninf_fit  = ninf_fit(Vmem);
    y_taun_fit  = taun_fit(Vmem);

    for i = 1:l_V-1
        ninf_error(i)   = (abs(ninf(i) - y_ninf_fit(i)))/abs(ninf(i));
        ninf_abserror(i)= abs(ninf(i) - y_ninf_fit(i));
        taun_error(i)   = (abs(taun(i) - y_taun_fit(i)))/abs(taun(i));
        
        dnfit           = (y_ninf_fit(i) - n_fit(i))/y_taun_fit(i);
        n_fit(i+1)      = Euler(dnfit, n_fit(i), dt);

        n_error(i)      = abs(taun(i) - y_taun_fit(i));
    end
    
%% Plot
    figure;

%     plot(Vmem, n);
    
    subplot(3,2,1);
    plot(ninf_fit, Vmem, ninf);
    title('ninf');
    subplot(3,2,2);
    plot(Vmem, ninf_abserror);
    title('Error n_{inf}');

    subplot(3,2,3);
    plot(taun_fit, Vmem, taun);
    title('tau_n');
    subplot(3,2,4);
    plot(Vmem, taun_error.*100);
    title('Error tau_n');

    subplot(3,2,5);
    plot(Vmem, n, Vmem, n_fit);
    title('n (blue) and simplified n (green)');
    subplot(3,2,6);
    plot(Vmem, n_error.*100);
    title('Error n');
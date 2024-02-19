
%% Add path
    addpath(genpath('../../Ionnic Channel'),genpath('../../Tools'), genpath('../../Synapses'), genpath('../../Datas'));

%% Import data from neuron (FS)
    dt          = 0.00001;
    Vmem        = -0.090:dt:0.060;
    l_V         = length(Vmem);
    
    ninf        = zeros(1, l_V);
    
    taun        = zeros(1, l_V);
    
    n           = zeros(1, l_V);
    n_fit       = n;
    
    test        = zeros(1, l_V);
    
    ninf_error  = zeros(1, l_V);
    taun_error  = zeros(1, l_V);
    n_error     = zeros(1, l_V);
    
    ninf_fitfunc= 'a*tanh(c+d*x)+e';
    taun_fitfunc= '(a*x+b)/cosh(c+d*x)+e';
    
%% Computatione
    for i = 1:l_V-1
        ninf(i)     =   n_inf(Vmem(i), -55);
        taun(i)     =   tau_n(Vmem(i), -55);
        
        dn          =   (ninf(i)-n(i))/taun(i);
        n(i+1)      =   Euler(dn, n(i), dt);
    end

%% Fitting
    ninf_fit    = fit(Vmem', ninf', ninf_fitfunc, 'start', [1 1 1 1]);
    taun_fit    = fit(Vmem', taun', taun_fitfunc, 'start', [1 1 1 1 1]);
    
%% Relative Error Calcul (%)
    y_ninf_fit  = ninf_fit(Vmem);
    y_taun_fit  = taun_fit(Vmem);

    for i = 1:l_V-1
        ninf_error(i)   = abs(ninf(i) - y_ninf_fit(i))/abs(ninf(i));
        taun_error(i)   = abs(taun(i) - y_taun_fit(i))/abs(taun(i));
        
        dn              = (y_ninf_fit(i) - n_fit(i))/y_taun_fit(i);
        n_fit(i+1)      = Euler(dn, n_fit(i), dt);

        n_error(i)      = abs(taun(i) - y_taun_fit(i))/taun(i);
    end
    
%% Plot
    figure;

%     plot(Vmem, n);
    
    subplot(3,2,1);
    plot(ninf_fit, Vmem, ninf);
    title('ninf');
    subplot(3,2,2);
    plot(Vmem, ninf_error.*100);
    title('Error n_{inf}');

    subplot(3,2,3);
    plot(taun_fit, Vmem, taun);
    title('tau_n');
    subplot(3,2,4);
    plot(Vmem, taun_error.*100);
    title('Error tau_n');

    subplot(3,2,5);
    plot(Vmem, n(1:l_V), Vmem, n_fit(1:l_V));
    title('n (blue) and simplified n (green)');
    subplot(3,2,6);
    plot(Vmem, n_error.*100);
    title('Error n');
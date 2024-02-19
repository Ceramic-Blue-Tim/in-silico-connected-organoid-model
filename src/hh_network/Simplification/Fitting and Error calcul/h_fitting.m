
%% Add path
    addpath(genpath('../../Ionnic Channel'),genpath('../../Tools'), genpath('../../Synapses'), genpath('../../Datas'));

%% Import data from neuron (FS)
    dt          = 0.01;
    Vmem        = -90:dt:60;
    l_V         = length(Vmem);
    
    hinf        = zeros(1, l_V);
    
    tauh        = zeros(1, l_V);   

    h           = zeros(1, l_V);
    h(1)        = 1;
    h_fit       = h;
    
    hinf_error  = zeros(1, l_V);
    tauh_error  = zeros(1, l_V);
    h_error     = zeros(1, l_V);
    
    hinf_fitfunc= '0.5*tanh(c-(2^-3)*(x-(-55)))+d'; hinfInit = [1 1];
%     hinf_fitfunc= '(a*x+b)*tanh(c-(2^-3)*(x-(-55)))+d'; hinfInit = [1 1 1 1];
    tauh_fitfunc= '((a*(x-(-55))+b)/cosh((c*(x-(-55)))+d))+e'; tauhInit = [1 1 0.0001 1 1];
    
%% Computatione
    for i = 1:l_V-1
        hinf(i)     =   h_inf(Vmem(i), -55);
        tauh(i)     =   tau_h(Vmem(i), -55);
%         X1          = (17-Vmem(i)-55)/18;
%         X2          = ((40-Vmem(i)-55)/5);
%         y_tauh_fit(i)     = ((1+exp(X2))/(0.128*exp(X1)*(1+exp(X2))+4));

        dh          =   (hinf(i)-h(i))/tauh(i);
        h(i+1)      =   Euler(dh, h(i), dt);
    end

%% Fitting
    hinf_fit    = fit(Vmem', hinf', hinf_fitfunc, 'start', hinfInit);
    tauh_fit    = fit(Vmem', tauh', tauh_fitfunc, 'start', tauhInit);
    
%% Relative Error Calcul (%)
    y_hinf_fit  = hinf_fit(Vmem);
    y_tauh_fit  = tauh_fit(Vmem);

    for i = 1:l_V-1
        hinf_error(i)   = abs(hinf(i) - y_hinf_fit(i))/abs(hinf(i));
        tauh_error(i)   = abs(tauh(i) - y_tauh_fit(i))/abs(tauh(i));
        
        dh              = (y_hinf_fit(i) - h_fit(i))/y_tauh_fit(i);
        h_fit(i+1)      = Euler(dh, h_fit(i), dt);

        h_error(i)      = abs(h(i) - h_fit(i))/abs(h(i));
    end
    
%% Plot
    figure;

    subplot(3,2,1);
    plot(hinf_fit, Vmem, hinf);
    title('h_{inf}');
    subplot(3,2,2);
    plot(Vmem, hinf_error.*100);
    title('Error h_{inf}');

    subplot(3,2,3);
    plot(tauh_fit, Vmem, tauh);
%     plot(Vmem, y_tauh_fit, Vmem, tauh);
    title('tau_h');
    subplot(3,2,4);
    plot(Vmem, tauh_error.*100);
    title('Error tau_h');

    subplot(3,2,5);
    plot(Vmem, h, Vmem, h_fit);
    title('h (blue) and simplified h (green)');
    subplot(3,2,6);
    plot(Vmem, h_error.*100);
    title('Error h');
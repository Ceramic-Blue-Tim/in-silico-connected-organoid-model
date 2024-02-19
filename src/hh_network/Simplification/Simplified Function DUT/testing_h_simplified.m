
%% Add path
    addpath(genpath('../../Ionnic Channel'),genpath('../../Tools'), genpath('../../Synapses'), genpath('../../Datas'));

%% Import data from neuron (FS)
    dt          = 0.01;
    Vmem        = -90:dt:60;
    l_V         = length(Vmem);
    
%% Anonymous function
    hinf_simp   = @(v) -0.4991*tanh(4.146+0.1243*v)+ 0.5015;
    tauh_simp   = @(v) (-0.2334*v -3.191)/cosh(3.487+0.09904*v) + 0.3498;
    
    hinf        = zeros(1, l_V);
    hinf(1)     = h_inf(Vmem(1));
    
    tauh        = zeros(1, l_V);
    tauh(1)     = tau_h(Vmem(1));
    
    h           = zeros(1, l_V);
    h(1)        = 1;
    
    simplifiedhinf      = zeros(1, l_V);
    simplifiedtauh      = zeros(1, l_V);
    simplifiedh         = h;
    
    h_error     = zeros(1, l_V);
    
%% Computatione
    for i = 1:l_V-1
        hinf(i)     =   h_inf(Vmem(i));
        tauh(i)     =   tau_h(Vmem(i));
        
        dh          = (hinf(i) - h(i))/tauh(i);
        h(i+1)      = Euler(dh, h(i), dt);

        simplifiedhinf(i)   = hinf_simp(Vmem(i));
        simplifiedtauh(i)   = tauh_simp(Vmem(i));  
        simplifieddh        = (simplifiedhinf(i)-simplifiedh(i))/simplifiedtauh(i);
        simplifiedh(i+1)    = Euler(simplifieddh, simplifiedh(i), dt);
    end
    
%% Error Calcul
    h_RMSE  = 0;
    for i = 1:l_V-1
        h_error(i)  = abs(h(i) - simplifiedh(i))/h(i);
        h_RMSE      = h_RMSE + (h(i) - simplifiedh(i))^2;
    end
    
%% Plot
    figure;
    subplot(2,1,1);
    plot(Vmem, simplifiedh, Vmem, h);
    title('m');
    subplot(2,1,2);
    plot(Vmem, h_error);
    title('Relative Error (%)');   
 
    disp('RMSE :');
    disp(h_RMSE);

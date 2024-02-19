
%% Add path
    addpath(genpath('../../Ionnic Channel'),genpath('../../Tools'), genpath('../../Synapses'), genpath('../../Datas'));

%% Import data from neuron (FS)
    dt          = 0.01;
    Vmem        = -90:dt:60;
    l_V         = length(Vmem);
    
%% Anonymous function
    ninf_simp   = @(v) (0.001451*v +0.5204)*tanh(1.833+0.05311*v)+ 0.3959;
    taun_simp   = @(v) (0.002036*v +1.423)/cosh(2.080+0.04597*v) + 0.3281;
    
    ninf        = zeros(1, l_V);
    ninf(1)     = n_inf(Vmem(1));
    
    taun        = zeros(1, l_V);
    taun(1)     = tau_n(Vmem(1));
    
    n           = zeros(1, l_V);
    
    simplifiedninf      = zeros(1, l_V);
    simplifiedtaun      = zeros(1, l_V);
    simplifiedn         = zeros(1, l_V);
    
    tanhrange           = zeros(1, l_V);
    
    n_error     = zeros(1, l_V);
    
%% Computatione
    for i = 1:l_V-1
        ninf(i)     =   n_inf(Vmem(i));
        taun(i)     =   tau_n(Vmem(i));
        
        tanhrange(i)= 1.833+0.05311*Vmem(i);
        
        dn          = (ninf(i) - n(i))/taun(i);
        n(i+1)      = Euler(dn, n(i), dt);

        simplifiedninf(i)   = ninf_simp(Vmem(i));
        simplifiedtaun(i)   = taun_simp(Vmem(i));  
        simplifieddn        = (simplifiedninf(i)-simplifiedn(i))/simplifiedtaun(i);
        simplifiedn(i+1)    = Euler(simplifieddn, simplifiedn(i), dt);
    end
    
%% Error Calcul
    for i = 1:l_V-1
        n_error(i) = abs(n(i) - simplifiedn(i))/n(i);
    end
    
%% Plot
    figure;
    subplot(2,1,1);
    plot(Vmem, simplifiedn, Vmem, n);
    title('m');
    subplot(2,1,2);
    plot(Vmem, n_error);
    title('Relative Error (%)');    
%     plot(Vmem, simplifiedminf , Vmem, minf);
%     figure;
%     plot(Vmem, simplifiedtaum , Vmem, taum);

%     figure;
%     plot(Vmem, taum);
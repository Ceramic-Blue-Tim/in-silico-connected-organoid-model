
%% Add path
    addpath(genpath('../Ionnic Channel'),genpath('../Tools'), genpath('../Synapses'), genpath('../Datas'));

%% Import data from neuron (FS)
    dt          = 0.01;
    Vmem        = -90:dt:60;
    l_V         = length(Vmem);
    
%% Anonymous function
    rinf_simp   = @(v) ((-0.000396*v - 0.5129)*tanh(1.583 + 0.02531*v)) + 0.5503;
    taur_simp   = @(v) ((-0.9446*v + 237.6)/cosh(-0.02908*v - 1.833)) + 150.7;
    
    rinf        = zeros(1, l_V);
    rinf(1)     = r_inf(Vmem(1));
    
    taur        = zeros(1, l_V);
    taur(1)     = tau_r(Vmem(1));
    
    r           = zeros(1, l_V);
    r(1)        = 0;
    
    simplifiedrinf      = zeros(1, l_V);
    simplifiedtaur      = zeros(1, l_V);
    simplifiedr         = zeros(1, l_V);
    
%% Computatione
    for i = 1:l_V-1
        rinf(i)     =   r_inf(Vmem(i));
        taur(i)     =   tau_r(Vmem(i));
        
        dr          = (rinf(i) - r(i))/taur(i);
        r(i+1)      = Euler(dr, r(i), dt);

        simplifiedrinf(i)   = rinf_simp(Vmem(i));
        simplifiedtaur(i)   = taur_simp(Vmem(i));  
        simplifieddr        = (simplifiedrinf(i)-simplifiedr(i))/simplifiedtaur(i);
        simplifiedr(i+1)    = Euler(simplifieddr, simplifiedr(i), dt);
    end
    
%% Error Calcul
%     y_mfit      = m_fit(Vmem);
% 
%     for i = 1:l_V-1
%         error(i) = abs(m(i) - y_mfit(i))/y_mfit(i);
%     end
    
%% Plot
    figure;
    plot(Vmem, simplifiedr, Vmem, r);
    title('m');
%     plot(Vmem, simplifiedminf , Vmem, minf);
%     figure;
%     plot(Vmem, simplifiedtaum , Vmem, taum);

%     figure;
%     plot(Vmem, taum);
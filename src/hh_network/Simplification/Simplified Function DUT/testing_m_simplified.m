
%% Add path
    addpath(genpath('../../Ionnic Channel'),genpath('../../Tools'), genpath('../../Synapses'), genpath('../../Datas'));

%% Import data from neuron (FS)
    dt          = 2^-6;
    Vmem        = -90:dt:60;
    l_V         = length(Vmem);
    
    Vtraub      = -55;
    
%% Anonymous function
    minf_simp   = @(v) 0.504*tanh(1.935+0.06631*v)+0.4966;
    taum_simp   = @(v) 0.08938/cosh(1.32+0.04105*v) + 0.0289;
    
    minf        = zeros(1, l_V);
    minf(1)     = m_inf(Vmem(1), Vtraub);
    
    taum        = zeros(1, l_V);
    taum(1)     = tau_m(Vmem(1), Vtraub);
    
    m           = zeros(1, l_V);
    m(1)        = 0;
    
    simplifiedminf      = zeros(1, l_V);
    simplifiedtaum      = zeros(1, l_V);
    simplifiedm         = zeros(1, l_V);
    
    minf_error  = zeros(1, l_V);
    taum_error  = zeros(1, l_V);
    m_error     = zeros(1, l_V);
    
%% Computatione
    for i = 1:l_V-1
        minf(i)     =   m_inf(Vmem(i), Vtraub);
        taum(i)     =   tau_m(Vmem(i), Vtraub);
        
        dm          = (minf(i) - m(i))/taum(i);
%         dm          = am(Vmem(i))*(1-m(i)) - betam(Vmem(i))*m(i);
        m(i+1)      = Euler(dm, m(i), dt);
%         m(i+1)     = mchan(Vmem(i), m(i), dt);

        simplifiedminf(i)   = minf_simp(Vmem(i));
        simplifiedtaum(i)   = taum_simp(Vmem(i));  
        simplifieddm        = (simplifiedminf(i)-simplifiedm(i))/simplifiedtaum(i);
        simplifiedm(i+1)    = Euler(simplifieddm, simplifiedm(i), dt);
    end
    
%% Error Calcul
%     y_mfit      = m_fit(Vmem);
% 
%     for i = 1:l_V-1
%         error(i) = abs(m(i) - y_mfit(i))/y_mfit(i);
%     end
    
%% Plot
    figure;
    plot(Vmem, simplifiedm, Vmem, m);
    title('m');
%     plot(Vmem, simplifiedminf , Vmem, minf);
%     figure;
%     plot(Vmem, simplifiedtaum , Vmem, taum);

%     figure;
%     plot(Vmem, taum);
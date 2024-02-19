
%% Add path
    addpath(genpath('../Ionnic Channel'),genpath('../Tools'), genpath('../Synapses'), genpath('../Datas'));

%% Import data from neuron (FS)
    dt          = 0.01e-3;
    Vmem        = -90e-3:dt:60e-3;
    l_V         = length(Vmem);
    
%% Anonymous function
    Minf_simp   = @(v) 0.4499*tanh(20.01 + 500.1*v) + 0.5499;
    
    Minftab        = zeros(1, l_V);
    Minftab(1)     = r_inf(Vmem(1));
    
    M           = zeros(1, l_V);
    M(1)        = 0;
    
    simplifiedMinf      = zeros(1, l_V);
    simplifiedM         = zeros(1, l_V);
    
%% Computatione
    for i = 1:l_V-1
        Minftab(i)     =   Minf(Vmem(i));
        
        dr          = (Minftab(i) - M(i))*5;
        M(i+1)      = Euler(dr, M(i), dt);

        simplifiedMinf(i)   = Minf_simp(Vmem(i));
        simplifieddr        = (simplifiedMinf(i)-simplifiedM(i))*5;
        simplifiedM(i+1)    = Euler(simplifieddr, simplifiedM(i), dt);
    end
    
%% Error Calcul
%     y_mfit      = m_fit(Vmem);
% 
%     for i = 1:l_V-1
%         error(i) = abs(m(i) - y_mfit(i))/y_mfit(i);
%     end
    
%% Plot
    figure;
    plot(Vmem, simplifiedM, Vmem, M);
    title('m');
%     plot(Vmem, simplifiedminf , Vmem, minf);
%     figure;
%     plot(Vmem, simplifiedtaum , Vmem, taum);

%     figure;
%     plot(Vmem, taum);
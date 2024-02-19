
%% Add path
    addpath(genpath('../Ionnic Channel'),genpath('../Tools'), genpath('../Synapses'), genpath('../Datas'));

%% Import data from neuron (FS)
    dt          = 0.01;
    Vmem        = -90:dt:60;
    l_V         = length(Vmem);
    
%% Anonymous function
    qinf_simp   = @(v) ((0.000297*v +0.5059)*tanh(3.749 + 0.1119*v))+0.4824;
    tauq_simp   = @(v) ((-0.1118*v +2.264)/cosh(0.09308*v + 3.452))+0.3711;
    
    qinf        = zeros(1, l_V);
    qinf(1)     = q_inf(Vmem(1));
    
    tauq        = zeros(1, l_V);
    tauq(1)     = tau_q(Vmem(1));
    
    q           = zeros(1, l_V);
    q(1)        = 0;
    
    simplifiedqinf      = zeros(1, l_V);
    simplifiedtauq      = zeros(1, l_V);
    simplifiedq         = zeros(1, l_V);
    
%% Computatione
    for i = 1:l_V-1
        qinf(i)     =   q_inf(Vmem(i));
        tauq(i)     =   tau_q(Vmem(i));
        
        dq          = (qinf(i) - q(i))/tauq(i);
        q(i+1)      = Euler(dq, q(i), dt);

        simplifiedqinf(i)   = qinf_simp(Vmem(i));
        simplifiedtauq(i)   = tauq_simp(Vmem(i));  
        simplifieddq        = (simplifiedqinf(i)-simplifiedq(i))/simplifiedtauq(i);
        simplifiedq(i+1)    = Euler(simplifieddq, simplifiedq(i), dt);
    end
    
%% Error Calcul
%     y_mfit      = m_fit(Vmem);
% 
%     for i = 1:l_V-1
%         error(i) = abs(m(i) - y_mfit(i))/y_mfit(i);
%     end
    
%% Plot
    figure;
    plot(Vmem, simplifiedq, Vmem, q);
    title('m');
%     plot(Vmem, simplifiedminf , Vmem, minf);
%     figure;
%     plot(Vmem, simplifiedtaum , Vmem, taum);

%     figure;
%     plot(Vmem, taum);
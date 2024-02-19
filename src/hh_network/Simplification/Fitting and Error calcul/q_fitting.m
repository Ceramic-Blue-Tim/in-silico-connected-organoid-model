
%% Add path
    addpath(genpath('../../Ionnic Channel'),genpath('../../Tools'), genpath('../../Synapses'), genpath('../../Datas'));

%% Import data from neuron (FS)
    dt          = 0.01;
    Vmem        = -50:dt:50;
    l_V         = length(Vmem);

%% Matrix Initialization
    qinf        = zeros(1, l_V);
    tauq        = zeros(1, l_V);   

    q           = zeros(1, l_V);
    q_fit       = zeros(1, l_V);

    qinf_error  = zeros(1, l_V);
    tauq_error  = zeros(1, l_V);
    q_error     = zeros(1, l_V);
    
    qinf_fitfunc= 'a*tanh((2^-4 + 2^-5 + 2^-6)*x+d)+e'; qinfInit = [1 3.105 0.4955];
    tauq_fitfunc= '((-(2^-4 + 2^-5 + 2^-6)*x+b)/cosh((c+x)/d))+e'; tauqInit = [1 1 1 1];
    
%% Computation
    for i = 1:l_V-1
        qinf(i)     =   q_inf(Vmem(i));
        tauq(i)     =   tau_q(Vmem(i));

        dq          =   (qinf(i)-q(i))/tauq(i);
        q(i+1)      = Euler(dq, q(i), dt);
    end

%% Fitting
    qinf_fit    = fit(Vmem', qinf', qinf_fitfunc, 'start', qinfInit);
    tauq_fit    = fit(Vmem', tauq', tauq_fitfunc, 'start', tauqInit);
    
%% Error Calcul

    y_qinf_fit  = qinf_fit(Vmem);
    y_tauq_fit  = tauq_fit(Vmem);

    RMSE_qinf   = 0;
    RMSE_tauq   = 0;
    RMSE_q      = 0;

    for i = 1:l_V-1
        qinf_error(i)   = abs(qinf(i) - (y_qinf_fit(i)));
        tauq_error(i)   = abs(tauq(i) - y_tauq_fit(i));

        RMSE_qinf       = RMSE_qinf + (qinf(i) - (y_qinf_fit(i)))^2;
        RMSE_tauq       = RMSE_tauq + (tauq(i) - y_tauq_fit(i))^2;

        dq              = (y_qinf_fit(i) - q_fit(i))/y_tauq_fit(i);
        q_fit(i+1)      = Euler(dq, q_fit(i), dt);

        q_error(i)      = abs(q(i) - q_fit(i))/abs(q(i));
        RMSE_q          = RMSE_q + (q(i) - q_fit(i))^2;
    end

%% Plot
    figure;

    subplot(3,2,1);
    plot(qinf_fit, Vmem, qinf);
    title('qinf');
    subplot(3,2,2);
    plot(Vmem, qinf_error);
    title('Error q_{inf}');

    subplot(3,2,3);
    plot(tauq_fit, Vmem, tauq);
    title('tau_q');
    subplot(3,2,4);
    plot(Vmem, tauq_error);
    title('Error tau_q');

    subplot(3,2,5);
    plot(Vmem, q, Vmem, q_fit);
    title('q (blue) and simplified q (green)');
    subplot(3,2,6);
    plot(Vmem, q_error.*100);
    title('Error q');

%% Display
    % Root-Mean Square Error
    disp(' -**** Root Mean Square Error ****-');
    disp('RMSE q_{inf}');
    disp(RMSE_qinf);
    
    disp('RMSE tau_q');
    disp(RMSE_tauq);

    disp('RMSE q');
    disp(RMSE_q);
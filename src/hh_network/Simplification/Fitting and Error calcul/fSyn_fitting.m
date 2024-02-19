
%% Add path
    addpath(genpath('../../Ionnic Channel'),genpath('../../Tools'), genpath('../../Synapses'), genpath('../../Datas'));

%% Import data from neuron (FS)
    dt          = 0.01e-3;
    t           = 0:dt:0.1;
    l_t         = length(t);

%% Matrix Initialization
    tau1        = 0.011;        % s
    tau2        = 0.002;        % s
    tpeak       = (tau1*tau2*log(tau1/tau2))/(tau1-tau2);
    a           = 1/(exp(-tpeak/tau1) - exp(-tpeak/tau2));
    fsynS       = @(t) a * (exp(-t/tau1) - exp(-t/tau2));
    exp1        = zeros(l_t, 1);
    exp2        = zeros(l_t, 1);
    resexp1        = zeros(l_t, 1);
    resexp2        = zeros(l_t, 1);
    fsyn        = zeros(1, l_t);
    
    fsynFit   = 'a*(exp(x) - exp(x))';    fsynInit = [1];
%% Computation
    for i = 1:l_t-1
        fsyn(i) = fsynS(t(i));
        exp1(i) = -t(i)/tau1;
        exp2(i) = -t(i)/tau2;
        resexp1(i) = exp(-t(i)/tau1);
        resexp2(i) = exp(-t(i)/tau2);
    end

    fsyn_fit    = fit(t', fsyn', fsynFit, 'start', fsynInit);
    
%% Fitting
%     Minf_fit    = fit(VmemSI', Minftab', M_fitfunc);

%% Error Calcul

%% Plot
    figure;
    plot(t, fsyn, t, fsyn_fit(t));
%     plot(t, fsyn);
%     figure;
%     set(gca,'FontSize',18)
% 
%     subplot(2,2,1);
%     plot(Minf_fit, VmemSI, Minftab);
%     xlabel('Vmem','fontsize',18); ylabel('m_{inf}','fontsize',18);
%     title('minf', 'fontsize',18);
%     subplot(2,2,2);
%     plot(Vmem, Minf_error.*100, 'linewidth',4);
%     xlabel('Vmem','fontsize',18); ylabel('error (%)','fontsize',18);
%     title('Error m_{inf}', 'fontsize',18);
% 
%     subplot(2,2,3);
%     hold on;
%     plot(VmemSI, M,'linewidth',4);
%     plot(VmemSI, M_fit, 'r--', 'linewidth',2);
%     xlabel('Vmem','fontsize',18); ylabel('m','fontsize',18);
%     title('m (blue) and simplified m (green)', 'fontsize',18);
%     subplot(2,2,4);
%     plot(VmemSI, M_error.*100, 'linewidth',4);
%     xlabel('Vmem','fontsize',18); ylabel('error (%)','fontsize',18);
%     title('Error m', 'fontsize',18);

% @title      Test script for Hill synapses
% @file       test_Hillsyn.m
% @author     Romain Beaubois
% @date       11 Aug 2021
% @copyright
% SPDX-FileCopyrightText: © 2021 Romain Beaubois <refbeaubois@yahoo.com>
% SPDX-License-Identifier: GPL-3.0-or-later
%
% @brief Test script for Hill synapses
% 
% @details
% > **11 Aug 2021** : file creation (RB)

%% Remove data?
clc;    
clear all;
close all;
tic;

%% Add required folders and subfolders to path
addpath(genpath('../hh_network'));

%% Parameters ####################################################################################
% Time
    dt              = 2^-5;                 % ms - Time step
    sim_time        = 1000;               % ms - Simulation time

% Network
    MAX_N           = 2;                    % Number of neurons

% Synaptic connection parameters
    wstim           = [0.63e-6  0.3e-6];    % stim current weight  [FS RS]
    offset          = [0.22e-6  0.60e-6];   % stim current offset  [FS RS]
    org_stim_indep  = true;                 % independant stimulation current for organoids otherwise identical

% Noise generator
    Theta   = 1;        % Amplitude : higher : 1 
    Mu      = 0.1;      % Mean : higher : 0.1
    Sigma   = 1.05;     % Standard deviation : higher : 2.2 lower : 1.05

% Optogenetic external stimulation
    opto_stim = struct(...
        'en'        , false, ...            % Enable optogenetic stimulation
        'ratio'     , 0.3, ...              % Ratio of neurons in bundle affected
        'Pmax'      , 0.0651, ...           % Max light dependant excitation rate (1/ms)
        'Gd'        , 0.1923, ...           % Decrease transition rate (1/ms)
        'Gr'        , 1e-3, ...             % Rise transition rate (1/ms)
        'GChRh2'    , 0.07e-5, ...          % Max conductance Channel Rhodospin 2 (?)
        'pattern'   , [ [0,     -1]; ...    % [ms, Hz] - Associate time to stimulation frequency
                        [300,   0.5]; ...   % [ms, Hz] - Associate time to stimulation frequency     
                        [600,   1]; ...     % [ms, Hz] - Associate time to stimulation frequency     
                        [900,   1.5]; ...   % [ms, Hz] - Associate time to stimulation frequency     
                        [1200,  -1]]...     % [ms, Hz] - Associate time to stimulation frequency     
    );

% ##########################################################################################################

%% Generate time variables
t                   = 0:dt:sim_time;
l_t                 = length(t);

%% Generate optogenetic stimulation
opto_stim_pulse = gen_opto_stim(t, l_t, dt, opto_stim.pattern);

%% Hill spike mediated synapse
max_spk         = 2;
tau1            = 11;  % ms
tau2            = 2;   % ms
Hillsyn_param   = [max_spk, tau1, tau2];
Hillsyn_th      = -0.1;  % mV

fsm_spk_ev      = zeros(MAX_N, 1);
ev_tab          = -100*ones(MAX_N, max_spk);
ev_tabnew       = -100*ones(MAX_N, max_spk);
nb_spk          = ones(MAX_N, 1);
last_ev         = zeros(MAX_N, 1);

%% Initialize network
    V           = zeros(MAX_N, l_t);
    I           = zeros(MAX_N, l_t, 5);
    Istim       = zeros(MAX_N, l_t);
    offset_t    = zeros(MAX_N, 1);
    wstim_t     = zeros(MAX_N, 1);
    Istim_pre   = zeros(MAX_N, 1);
    m = 0;  h = 1;  n = 0;
    p = 0;  q = 0;  r = 0;
    s = 0;  u = 0;
    A = 0;  P = 0;  M = 0;
    IonChanInit = [m,h,n,p,q,r,s,u,A,M,P];
    once1   = true;
    once2   = true;

    nt = string(zeros(1,MAX_N));
    nt(1) = 'RS';
    nt(2) = 'RS';

    kFS_simpl_lin03 = @(x) (-77.02*x^3 + 152.4*x^2 - 91.42*x + 17.66)*10^-6;     
        
    for i = 1:MAX_N
        [Cmem,Imax,Vinit,GVal,EVal,TauMax,Sm, Vtraub]= NeuronType(nt(i));
        N(i) = PospischilNeuralNetworkV2( nt(i), dt, GVal, EVal, IonChanInit, Hillsyn_param, opto_stim, Cmem, TauMax, Sm, Vtraub, MAX_N);

        if strcmp(nt(i), 'FS')
            Istim(i) = kFS_simpl_lin03(Imax);
            offset_t(i) = offset(1);
            wstim_t(i)  = wstim(1);
        elseif strcmp(nt(i), 'RS')
            Istim(i) = 0.3*Imax;
            offset_t(i) = offset(2);
            wstim_t(i)  = wstim(2);            
        end

        V(i,1)      = -10;
        V(i,2)      = -60;
    end
    
    
%% Raster plot detection
    event       = zeros(MAX_N, l_t);
    detect      = zeros(MAX_N, 1);
    ev_count    = zeros(MAX_N, 1);
    threshold   = 0; % mV

%% Synapse codage
    NONE            = 000;  % No synapse
    AMPA            = 001;  % Excitatoty synapse
    GABAa           = 011;  % Ihnibitory synapse
    exc_Hill        = 101;  % Short-term plasticity synapse
    inh_Hill        = 110;  % Short-term plasticity synapse

    wsyn            = 1*ones(MAX_N, MAX_N, 2);
    S_con           = zeros(MAX_N, MAX_N);
    S_con(1,2)      = inh_Hill;
    S_con(2,1)      = inh_Hill;

%% Simulation
for i = 1:l_t-1
    % For each neuron
    for j = 1:MAX_N
        % Spike detection
            [ev_tabnew, fsm_spk_ev, nb_spk, last_ev] = spk_dtc_Hillsyn(j, V(j,i), i*dt, ev_tabnew, fsm_spk_ev, nb_spk, last_ev, max_spk, Hillsyn_th);

        % Noisy stimulation current
            if j == 2
                % IstimN          = OUproc(Istim_pre(j), Theta, Mu, Sigma, dt);
                % Istim_pre(j)    = IstimN;            
                % IstimN          = offset_t(j) + IstimN*wstim_t(j);
                IstimN = 4*Istim(j);
                % IstimN          = 0;
            else
                IstimN = 4*Istim(j);
            end
    
        % Calculation
            A_con = zeros(MAX_N, MAX_N);
            [N(j), V(j,i+1), I(j,i,:)] = N(j).PospischilCalc(V(:,i), IstimN, S_con, opto_stim, opto_stim_pulse, A_con, j, wsyn, i*dt, ev_tab);
        
        % Detection for raster plot
            if (V(j,i+1) > threshold) && (detect(j)==0)
                ev_count(j)             = ev_count(j) + 1;
                event(j, ev_count(j))   = i+1;
                detect(j)               = 1;
            elseif (V(j,i+1) < threshold) && (detect(j)==1)
                detect(j) = 0;
            end
    end
    ev_tab = ev_tabnew;
    LoadSim(i, l_t);        
end

%% Print
figure('Name','Membrane voltage','NumberTitle','off');
for i = 1:MAX_N
    % subplot(MAX_N/2,2,i);
    hold on
    plot(t, V(i,:));
    title(sprintf("V_{mem} neurons", i));
    ylabel('Amplitude (mV)');
    xlabel('Time (ms)');
    ll{i} = sprintf('N%d',i);
    legend(ll);
    % ylim([-120 60]);
end

figure('Name','Raster plot','NumberTitle','off');

%              ORG1     ORG2
colors_inh  = {'blue';  'black'};
colors_exc  = {'red';   'green'};

for j = 1:MAX_N
    if strcmp(nt(j),'FS')
        color = colors_inh{1};
    else
        color = colors_exc{1};
    end
   
    
    for i = 1:ev_count(j)
        plot(event(j,i)/(dt*1e6), j, sprintf('.%s',color));
        hold on
    end
end

toc;
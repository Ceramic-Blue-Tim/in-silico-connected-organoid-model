% @title      Test script for 3 FS neurons
% @file       FS_x3.m
% @author     Romain Beaubois
% @date       18 Feb 2020
% @copyright
% SPDX-FileCopyrightText: © 2020 Romain Beaubois <refbeaubois@yahoo.com>
% SPDX-License-Identifier: GPL-3.0-or-later
%
% @brief Test script for 3 FS neurons
% 
% @details
% > **18 Feb 2020** : file creation (RB)

%% Remove data?
    clc;    
    clear all;
    close all;
    tic;

%% Add path
    addpath(genpath('../hh_network'));
        
%% Time constant
    Simulation_duration = 1000;
    dt                  = 0.01e-1;
    t                   = 0:dt:Simulation_duration;
    l_t                 = length(t);
    
%% Initialize Neuron Object
    Type    = 'FS';
    [Cmem,Imax,Vinit,GVal,EVal,TauMax,Sm,VTraub]= NeuronType(Type);

    m = 0;      h = 1;
    n = 0;
    p = 0;
    q = 0;      r = 1;
    s = 0;      u = 1;
    IonChanInit = [m,h,n,p,q,r,s,u];
    
    % Constants
        MAX_N = 3;
        
    N1  = SimplifiedPospischilNeuronV2(Type, dt, GVal, EVal, IonChanInit, Cmem, TauMax, Sm, VTraub);
    N2  = SimplifiedPospischilNeuronV2(Type, dt, GVal, EVal, IonChanInit, Cmem, TauMax, Sm, VTraub);
    N3  = SimplifiedPospischilNeuronV2(Type, dt, GVal, EVal, IonChanInit, Cmem, TauMax, Sm, VTraub);
    V = zeros(l_t, MAX_N); 
    V(1,MAX_N)   = -70;

    I = zeros(l_t, 6, MAX_N); % 6 ionic currents

    kFS_nonsimpl_lin = @(x) (7.537*x - 3.381)*10^-6; 
    kf_nonlin2 = @(x) (2.417*x^2) + 4.399*x - 2.394;
    kf_nonlin3 = @(x) ((-80.34*x^3) + (159.2*x^2) - 95.9*x + 18.63) * 10^-6;

    kFS_simpl_lin01 = @(x) (7.528*x -3.381)*10^-6; 
    kFS_simpl_lin02 = @(x) (2.156*x^2 + 4.73*x - 2.501)*10^-6; 
    kFS_simpl_lin03 = @(x) (-77.02*x^3 + 152.4*x^2 - 91.42*x + 17.66)*10^-6; 

    % Decode neuron type
    if strcmp(Type,'FS')  
        IStim = kFS_simpl_lin03(Imax);
    elseif strcmp(Type,'RS')
        IStim  = 0.3*Imax;
    elseif strcmp(Type,'IB')
        IStim   = 0.978*Imax;
    elseif strcmp(Type,'LTS')
        Istim   = StimCurrentForm(Imax, t, dt, Simulation_duration/2, 50, 'square');
    else
        IStim   = Imax;
    end

    K = 1;
    
    rGABAa      = ones(1, MAX_N);
    rGABA_pre   = ones(1, MAX_N);
    
%% Simulation
    for i = 1:l_t-1
        [Isyn2, rGABAa(2)]  = IsynGABAa2(dt,V(i,1),V(i,2), rGABA_pre(2));
        [Isyn3, rGABAa(3)]  = IsynGABAa2(dt,V(i,2),V(i,3), rGABA_pre(3));
        rGABA_pre(2)        = rGABAa(2);
        rGABA_pre(3)        = rGABAa(3);
        IstimN1 =  Imax*K;
        IstimN2 =  Imax*K - 0.5*Isyn2;
        IstimN3 =  Imax*K - 0.5*Isyn3;
        [N1, V(i+1,1), I(i,:,1)]   = N1.PospischilCalc(V(i,1), IstimN1);
        [N2, V(i+1,2), I(i,:,2)]   = N2.PospischilCalc(V(i,2), IstimN2);
        [N3, V(i+1,3), I(i,:,3)]   = N3.PospischilCalc(V(i,3), IstimN3);
        LoadSim(i, l_t);
    end

%% Print
    figure
    i = 1;
    
        subplot(311)
    plot(t, V(:,1), 'red');
    title('V_{mem} FS neuron');
    ylabel('Amplitude (mV)');
    xlabel('Time (ms)');
    
        subplot(312)
    plot(t, V(:,2), 'blue');
    title('V_{mem} FS neuron');
    ylabel('Amplitude (mV)');
    xlabel('Time (ms)');
    
        subplot(313)
    plot(t, V(:,3), 'green');
    title('V_{mem} FS neuron');
    ylabel('Amplitude (mV)');
    xlabel('Time (ms)');
toc;
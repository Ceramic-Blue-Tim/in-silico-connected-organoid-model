% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function [Cm, I_stim, Vinit, GVal, EVal, TauMax, Sm, VTraub] = NeuronTypeV2(TypeOfNeuron)
    if strcmp(TypeOfNeuron,'FS')
        %% FS Hodgkin-Huxley parameter
        %Size of neuron
        Diam    = 67;       % Diameter of neuron (�m)
        Diam    = Diam * 10^-4; % cm
        Lmem    = 67;      % Length of neuron (�m)
        Lmem    = Lmem * 10^-4;% cm

        Cmem   = 1;         % �F/cm�
        Cmem   = Cmem*10^-3;    % mF/cm�

        %Membrane Area (neuron is seeing as a tube in neuron)
        % 2*pi*r� + 2*pi*r*h    % for tube
        % 4*pi*r� then pi*d�    % for spherical cell
        % pi * r�               % for disk
        Sm      = (pi * Diam * Lmem);   % cm�
        Cm      = Cmem * Sm*(10^9);             % mF
        %C_m     = K2 * C_mem * Sm;
        

        % Stimulation current (mA)
        I_stim   = 0.5;                 % nA
        I_stim   = (10^9) * I_stim * 10^-6;% mA

        % Ionics conductances
        g_Kd    = 0.01*Sm*(10^9);         % S/cm�
        g_Na    = 0.05*Sm*(10^9);         % S/cm�
        g_M     = 0;
        g_Ca    = 0;
        g_leak  = 0.00015*Sm*(10^9);      % S/cm�

        %Reversal potential of ions
        E_Na    = 50;       % mV
        E_K     = -100;     % mV
        E_leak  = -70;      % mV

        % mV, Adjust spike threshold according to Traub
        TauMax  = 1000;     % ms
        
        Vinit   = -70;
        
        VTraub  = -55;
    elseif strcmp(TypeOfNeuron,'RS')  
        %% RS Hodgkin-Huxley parameter
        %Size of neuron
        Diam    = 96*10^-4;         %Diameter of neuron (cm)
        L_m     = 96*10^-4;         %Length of neuron (cm)

%         Diam    = 61.4*10^-4;         %Diameter of neuron (cm)
%         L_m     = 61.4*10^-4;         %Length of neuron (cm)
        
        C_mem   = 1*10^-3;                % �F/cm�

        Sm      = pi * Diam * L_m;         % cm� disc (coef 7)

        Cm     = C_mem*Sm;     % �F

        I_stim  = 0.75*10^-6;      %�A/cm� or nA

        %Ionics conductances
        g_Kd    = 0.005*Sm;        %S/cm� 
        g_Na    = 0.05*Sm;         %S/cm�
        g_Ca    = 0;      %S/cm�
        g_M     = 7*(10^-5)*Sm;      %S/cm�
        g_leak  = 0.0001*Sm;       %S/cm�
        
        %Reversal potential of ions
        E_Na    = 50;           %mV
        E_K     = -100;         %mV
        E_leak  = -70;          %mV

        % mV, Adjust spike threshold according to Traub
        TauMax  = 1000;         %ms    
        
        Vinit   = -70;
        
        VTraub  = -55;
    elseif strcmp(TypeOfNeuron,'IB')  
        %% IB Hodgkin-Huxley parameter
        %Size of neuronr
        Diam    = 96*10^-4;         %Diameter of neuron (cm)
        L_m     = 96*10^-4;         %Length of neuron (cm)

        C_mem   = 1*10^-3;                % �F/cm�

        Sm      = pi * Diam * L_m;         % cm� disc (coef 7)

        Cm     = C_mem*Sm*(10^9);      % �F

        I_stim  = 0.15*10^-6*(10^9);   %mA

        %Ionics conductances
        g_Kd    = 0.005*Sm*(10^9);        %S/cm� 
        g_Na    = 0.05*Sm*(10^9);         %S/cm�
        g_Ca    = 1.7*(10^-4)*Sm*(10^9);      %S/cm�
        g_M     = 3*(10^-5)*Sm*(10^9);      %S/cm�
        g_leak  = 1*(10^-5)*Sm*(10^9);      %S/cm�

        %Reversal potential of ions
        E_Na    = 50;           %mV
        E_K     = -100;         %mV
        E_leak  = -85;          %mV

        % mV, Adjust spike threshold according to Traub
        TauMax  = 1000;         %ms    
        
        Vinit   = -84;
        
        VTraub  = -55;
    elseif strcmp(TypeOfNeuron,'LTS')  
        %% LTS Hodgkin-Huxley parameter
        %Size of neuron
        Diam    = 96*10^-4;         %Diameter of neuron (cm)
        L_m     = 96*10^-4;         %Length of neuron (cm)

        C_mem   = 1*10^-3;                % �F/cm�

        Sm      = pi * Diam * L_m;         % cm� disc (coef 7)

        Cm     = C_mem*Sm*(10^9);     % �F

        I_stim  = -0.36*(10^-6)*(10^9);      %�A/cm� or nA

        %Ionics conductances
        g_Kd    = 0.005*Sm*(10^9);        %S/cm� 
        g_Na    = 0.05*Sm*(10^9);         %S/cm�
        g_M     = 3*(10^-5)*Sm*(10^9);      %S/cm�
        g_Ca    = 4*(10^-4)*Sm*(10^9);
        g_leak  = 1*(10^-5)*Sm*(10^9);       %S/cm�

        %Reversal potential of ions
        E_Na    = 50;           %mV
        E_K     = -100;         %mV
        E_leak  = -50;          %mV

        % mV, Adjust spike threshold according to Traub
        TauMax  = 1000;         %ms     
        
        Vinit   = -84;
        
        VTraub  = -55;
    end
    
    Esyn= -62.5e-3;    % mV
    GSyn = 20*42.5e-9;

    GVal= [g_Kd, g_Na, g_M, g_Ca, g_leak, GSyn, 0];
    EVal= [E_K, E_Na, E_leak, Esyn];
end
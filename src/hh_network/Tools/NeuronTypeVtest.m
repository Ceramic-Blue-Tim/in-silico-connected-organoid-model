% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function [Cm, I_stim, Vinit, GVal, EVal, TauMax, Sm] = NeuronTypeVtest()

    %% RS Hodgkin-Huxley parameter
    %Size of neuron
    Diam    = 96*10^-4;         %Diameter of neuron (cm)
    L_m     = 96*10^-4;         %Length of neuron (cm)

    C_mem   = 1*10^-3;                % �F/cm�

    Sm      = pi * Diam * L_m;         % cm� disc (coef 7)

    Cm     = C_mem*Sm*(10^9);     % �F

    I_stim  = (10^9)*0.75*10^-6;      %�A/cm� or nA

    %Ionics conductances
    g_Kd    = 0.005*Sm*(10^9);        %S/cm� 
    g_Na    = 0.05*Sm*(10^9);         %S/cm�
    g_Ca    = 0;      %S/cm�
    g_M     = 7*(10^-5)*Sm*(10^9);      %S/cm�
    g_leak  = 0.0001*Sm*(10^9);       %S/cm�

    %Reversal potential of ions
    E_Na    = 50;           %mV
    E_K     = -100;         %mV
    E_leak  = -70;          %mV

    % mV, Adjust spike threshold according to Traub
    TauMax  = 1000;         %ms    

    Vinit   = -70;
    
    Esyn    = -62.5;    % mV
    GSynG   = 30;
    GSynS   = 42.5;
    
    GVal= [g_Kd, g_Na, g_M, g_Ca, g_leak, GSynG, GSynS];
    EVal= [E_K, E_Na, E_leak, Esyn];
end
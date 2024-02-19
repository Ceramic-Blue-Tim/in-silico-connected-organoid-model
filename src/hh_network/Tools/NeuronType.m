%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%   Optimized vs Original Pospischil equations
%
%   Authors     : KHOYRATEE Farad
%   Date        : 25/01/2017
%   Update by   : KHOYRATEE Farad
%   Update      : 16/04/2019
%
%   Version     : V1.0
%   
%   Descritption: Optimized Hodgkin-Huxley from Pospischil
%                 parameters
%
%   log         :
%       --
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Cm, I_stim, Vinit, GVal, EVal, TauMax, Sm, VTraub] = NeuronType(TypeOfNeuron)
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
        Cm      = Cmem * Sm;             % mF
        %C_m     = K2 * C_mem * Sm;

        % Stimulation current (mA)
        I_stim   = 0.5;                 % nA
        I_stim   = I_stim * 10^-6;% mA

        % Ionics conductances
        g_Kd    = 0.01*Sm;         % S/cm�
        g_Na    = 0.05*Sm;         % S/cm�
        g_M     = 0;
        g_Ca    = 0;
        g_leak  = 0.00015*Sm;      % S/cm�

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

        Cm     = C_mem*Sm*x;      % �F

        I_stim  = 0.15*10^-6*(10^9);   %mA
%         I_stim  = -0.15*10^-6*x;   %mA

        %Ionics conductances
        g_Kd    = 0.005*Sm*(10^9);        %S/cm� 
        g_Na    = 0.05*Sm*(10^9);         %S/cm�
        g_Ca    = 1.7*(10^-4)*Sm*(10^9);  %S/cm�
        g_M     = 3*(10^-5)*Sm*(10^9);    %S/cm�
        g_leak  = 1*(10^-5)*Sm*(10^9);    %S/cm�
%         g_Kd    = 0.005*Sm*x;          %S/cm�  **
%         g_Na    = 0.05*Sm*x;           %S/cm�  **
%         g_Ca    = 1.43*(10^-4)*Sm*x;    %S/cm�  **
%         g_M     = 3*(10^-5)*Sm*x;      %S/cm�  **
%         g_leak  = 1*(10^-5)*Sm*x;      %S/cm�  **

        %Reversal potential of ions
%         E_Na    = 50;           %mV
%         E_K     = -100;         %mV
%         E_leak  = -85;          %mV -85
        E_Na    = 50;           %mV
        E_K     = -90;         %mV
        E_leak  = -85;          %mV -85     **

        % mV, Adjust spike threshold according to Traub
        TauMax  = 1000;         %ms    
        
        Vinit   = 0;
        
        VTraub  = -55;
    elseif strcmp(TypeOfNeuron,'LTS')  
        %% LTS Hodgkin-Huxley parameter
        x = 1e9; % Real value of x ?
        %Size of neuron
        Diam    = 96*10^-4;         %Diameter of neuron (cm)
        L_m     = 96*10^-4;         %Length of neuron (cm)

        C_mem   = 1*10^-3;                % �F/cm�

        Sm      = pi * Diam * L_m;         % cm� disc (coef 7)

        Cm     = C_mem*Sm*10^9;     % �F

        I_stim  = 0.15*(10^-6)*x;      %�A/cm� or nA

        %Ionics conductances
        g_Kd    = 0.005*Sm*x;        %S/cm� 
        g_Na    = 0.05*Sm*x;         %S/cm�
        g_M     = 3*(10^-5)*Sm*x;      %S/cm�
        g_Ca    = 4*(10^-4)*Sm*x;
        g_leak  = 1*(10^-5)*Sm*x;       %S/cm�

        %Reversal potential of ions
        E_Na    = 50;           %mV
        E_K     = -100;         %mV
        E_leak  = -50;          %mV

        % mV, Adjust spike threshold according to Traub
        TauMax  = 1000;         %ms     
        
        Vinit   = -84;
        
        VTraub  = -48;
    end
    
    Esyn= -62.5;    % mV
    GSynG = 400*(10^-9);
    % GSynS = (10^9)*20*42.5e-9;
    GSynS = 6e-7;

    
    GVal= [g_Kd, g_Na, g_M, g_Ca, g_leak, GSynG, GSynS];
    EVal= [E_Na, E_K, E_leak, Esyn];
end
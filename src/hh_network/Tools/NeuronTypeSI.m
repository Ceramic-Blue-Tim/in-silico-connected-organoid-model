function [Cm, I_stim, Vinit, GVal, EVal, TauMax, Sm, Vtraub] = NeuronTypeSI(TypeOfNeuron)
    if strcmp(TypeOfNeuron,'FS')
        %% FS Hodgkin-Huxley parameter
        %Size of neuron
        Diam    = 67;       % Diameter of neuron (µm)
        Diam    = Diam * 10^-4; % cm
        Lmem    = 67;       % Length of neuron (µm)
        Lmem    = Lmem * 10^-4; % cm

        Cmem   = 1;             % µF/cm²
        Cmem   = Cmem*10^-6;    % F/cm²

        %Membrane Area (neuron is seeing as a tube in neuron)
        % 2*pi*r² + 2*pi*r*h    % for tube
        % 4*pi*r² then pi*d²    % for spherical cell
        % pi * r²               % for disk
        Sm      = (pi * Diam * Lmem);       % cm²
        Cm      = Cmem * Sm;                % F
        %C_m     = K2 * C_mem * Sm;

        % Stimulation current (mA)
        I_stim   = 0.5;                     % nA
        I_stim   = I_stim * 10^-9;          % A

        % Ionics conductances
        g_Kd    = 0.01*Sm;                  % S
        g_Na    = 0.05*Sm;                  % S
        g_M     = 0;
        g_Ca    = 0;
        g_leak  = 0.00015*Sm;               % S

        %Reversal potential of ions
        E_Na    = 50e-3;                    % V
        E_K     = -100e-3;                  % V
        E_leak  = -70e-3;                   % V

        % mV, Adjust spike threshold according to Traub
        TauMax  = 1000e-3;                  % s
        
        Vinit   = -70e-3;                   % V
        
        Vtraub  = -55;
    elseif strcmp(TypeOfNeuron,'RS')  
        %% RS Hodgkin-Huxley parameter
        %Size of neuron
        Diam    = 96*10^-4;         %Diameter of neuron (cm)
        L_m     = 96*10^-4;         %Length of neuron (cm)

        C_mem   = 1*10^-6;                  % F/cm²

        Sm      = pi * Diam * L_m;          % cm² disc (coef 7)
        Cm      = C_mem*Sm;                 % F

        I_stim  = 0.75*10^-9;               % A

        %Ionics conductances
        g_Kd    = 0.005*Sm;                 % S 
        g_Na    = 0.05*Sm;                  % S
        g_Ca    = 0;                        % S
        g_M     = 7*(10^-5)*Sm;             % S
        g_leak  = 0.0001*Sm;                % S

        %Reversal potential of ions
        E_Na    = 50e-3;                    % V
        E_K     = -100e-3;                  % V
        E_leak  = -70e-3;                   % V

        % mV, Adjust spike threshold according to Traub
        TauMax  = 1000;                  % s    
        
        Vinit   = -70e-3;                   % V
        
        Vtraub  = -55;
    elseif strcmp(TypeOfNeuron,'IB')  
        %% IB Hodgkin-Huxley parameter
        %Size of neuronr
        Diam    = 96*10^-4;         %Diameter of neuron (cm)
        L_m     = 96*10^-4;         %Length of neuron (cm)

        C_mem   = 1*10^-6;                % F/cm²

        Sm      = pi * Diam * L_m;         % cm² disc (coef 7)

        Cm     = C_mem*Sm*(10^9);      % F

        I_stim  = 0.15*(10^-9);   %A

        %Ionics conductances
        g_Kd    = 0.005*Sm;        %S/cm² 
        g_Na    = 0.05*Sm;         %S/cm²
        g_Ca    = 1.7*(10^-4)*Sm;      %S/cm²
        g_M     = 3*(10^-5)*Sm;      %S/cm²
        g_leak  = 1*(10^-5)*Sm;      %S/cm²

        %Reversal potential of ions
        E_Na    = 50e-3;           %V
        E_K     = -100e-3;         %V
        E_leak  = -85e-3;          %V

        % mV, Adjust spike threshold according to Traub
        TauMax  = 1000;         %ms    
        
        Vinit   = -84e-3;
        
        Vtraub  = -55;
    elseif strcmp(TypeOfNeuron,'LTS')  
        %% LTS Hodgkin-Huxley parameter
        %Size of neuron
        Diam    = 96*10^-4;         %Diameter of neuron (cm)
        L_m     = 96*10^-4;         %Length of neuron (cm)

        C_mem   = 1*10^-3;                % µF/cm²

        Sm      = pi * Diam * L_m;         % cm² disc (coef 7)

        Cm     = C_mem*Sm*(10^9);     % µF

        I_stim  = 0.15*(10^-6)*(10^9);      %µA/cm² or nA

        %Ionics conductances
        g_Kd    = 0.005*Sm*(10^9);        %S/cm² 
        g_Na    = 0.05*Sm*(10^9);         %S/cm²
        g_M     = 3*(10^-5)*Sm*(10^9);      %S/cm²
        g_Ca    = 4*(10^-4)*Sm*(10^9);
        g_leak  = 1*(10^-5)*Sm*(10^9);       %S/cm²

        %Reversal potential of ions
        E_Na    = 50;           %mV
        E_K     = -100;         %mV
        E_leak  = -85;          %mV

        % mV, Adjust spike threshold according to Traub
        TauMax  = 1000;         %ms     
        
        Vinit   = -84;
        
        Vtraub  = -55;
    elseif strcmp(TypeOfNeuron,'Test')  
        %% RS Hodgkin-Huxley parameter
        %Size of neuron
        Diam    = 96*10^-4;         %Diameter of neuron (cm)
        L_m     = 96*10^-4;         %Length of neuron (cm)

        C_mem   = 1*10^-3;                % µF/cm²

        Sm      = pi * Diam * L_m;         % cm² disc (coef 7)

        Cm     = C_mem*Sm*(10^9);     % µF

        I_stim  = (10^9)*0.75*10^-6;      %µA/cm² or nA

        %Ionics conductances
        g_Kd    = 100;        %S/cm² 
        g_Na    = 200;         %S/cm²
        g_Ca    = 5;      %S/cm²
        g_M     = 80;      %S/cm²
        g_leak  = 4.72;       %S/cm²

        %Reversal potential of ions
        E_Na    = 50;           %mV
        E_K     = -100;         %mV
        E_leak  = -70;          %mV

        % mV, Adjust spike threshold according to Traub
        TauMax  = 1000;         %ms    
        
        Vinit   = -70;
        
        Vtraub  = -55;
    end
    
    Esyn    = -62.5e-3;         % V
    GSynG   = 30e-9;            % S
    %GSynS   = 10*42.5e-9;          % S
    GSynS   = 20*42.5e-9;          % S
    
    GVal= [g_Kd, g_Na, g_M, g_Ca, g_leak, GSynG, GSynS];
    EVal= [E_K, E_Na, E_leak, Esyn];
end
% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function [HHVal] = PospischilNeuronFunc(TypeOfNeuron, Dt, HHValpre, en_stim)

Vprev   = HHValpre(1);
npre    = HHValpre(2);
mpre    = HHValpre(3);
hpre    = HHValpre(4);
ppre    = HHValpre(5);
qpre    = HHValpre(6);
rpre    = HHValpre(7);
upre    = HHValpre(8);
ICaPrev = HHValpre(9);

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
elseif strcmp(TypeOfNeuron,'RS')  
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
elseif strcmp(TypeOfNeuron,'LTS')  
    %% LTS Hodgkin-Huxley parameter
    %Size of neuron
    Diam    = 96*10^-4;         %Diameter of neuron (cm)
    L_m     = 96*10^-4;         %Length of neuron (cm)

    C_mem   = 1*10^-3;                % �F/cm�

    Sm      = pi * Diam * L_m;         % cm� disc (coef 7)

    Cm     = C_mem*Sm*(10^9);     % �F

    I_stim  = 0.15*(10^-6)*(10^9);      %�A/cm� or nA

    %Ionics conductances
    g_Kd    = 0.005*Sm*(10^9);        %S/cm� 
    g_Na    = 0.05*Sm*(10^9);         %S/cm�
    g_M     = 3*(10^-5)*Sm*(10^9);      %S/cm�
    g_Ca    = 4*(10^-4)*Sm*(10^9);
    g_leak  = 1*(10^-5)*Sm*(10^9);       %S/cm�

    %Reversal potential of ions
    E_Na    = 50;           %mV
    E_K     = -100;         %mV
    E_leak  = -85;          %mV

    % mV, Adjust spike threshold according to Traub
    TauMax  = 1000;         %ms     
end

% Adaptation, Calcium etc
% p_inf   = @(v) 1 / (1 + exptable(-(v+35)/10));
% tau_p   = @(v) TauMax / ( 3.3 * exptable((v+35)/20) + exptable(-(v+35)/20));

% aq      = @(v) 0.055 * (-27-v) / ((exp((-27-v)/3.8))- 1);
% bq      = @(v) 0.94 * exp((-75-v)/17);

% ar      = @(v) 0.000457 * exp((-13-v)/50);
% br      = @(v) 0.0065/(exp((-15-v)/28)+1);

Tcelsius= 36;       % Temp�rature en Celsius
cai     = 2.4e-4;
cao     = 2;
FARADAY = 96485;
R       = 8.3144621; % Constante des gazs parfaites
carev = 120.24;

Kchan = -(1*10^4) / (2 * FARADAY);
Kcarev= (1*10^3) * (R*(Tcelsius+273.15)) / (2*FARADAY);

s_inf = @(v) 1/(1+exp(-(v+2+57)/6.2));
u_inf = @(v) 1/(1+exp((v+2+81)/4));

tau_u   = @(v) (30.8 + ((211.4 + exp((v+2+113.2)/5)) / (1 + exp((v+2+84)/3.2)))) * (1/(3 ^ 1.2)) ;

drive_channel = @(i) Kchan * i;

q       = 0;

%% Simulation
    %Current injection timing dependent
    if en_stim == 1
        I_inj           = I_stim;
    else
        I_inj           = 0;
    end
    
%     I_inj           = I_stim;

	%Ionic channel
    m               = mchan(Vprev, mpre, Dt);
    h               = hchan(Vprev, hpre, Dt);
    n               = nchan(Vprev, npre, Dt);
    
    if g_M ~= 0
        p           = ppre + ((pinf(Vprev)-ppre) / tau_p(Vprev, TauMax))*Dt;
        I_M         = g_M  * p * (Vprev-E_K);
    else
        I_M         = 0;
        p           = 0;
    end
    
    if strcmp(TypeOfNeuron,'IB')   
        dq              = aq(Vprev)*(1-qpre) - (bq(Vprev)*qpre);
%         dq              = aq(Vprev, aprev, Dt)*(1-qpre) - (bq(Vprev)*qpre);
        q               = Euler(dq, qpre, Dt);
        
        dr              = ar(Vprev)*(1-rpre) - br(Vprev)*rpre;
        r               = rpre + dr * Dt;
        
%         dcai  = drive_channel(I_ts/(Sm*(10^9))) + ((2e-4)-cai)/5;
%         cai   = cai + dcai * Dt;
        
        %carev = Kcarev * log(cao/cai);      
        carev           = 120.24;
        
        I_L             = g_Ca * q^2 * r * (Vprev - carev);
        ICa             = I_L;
    else
        I_L             = 0;
        q               = 0;
        r               = 0;
        ICa             = 0;
    end 
    
    if strcmp(TypeOfNeuron,'LTS')
        du           = (u_inf(Vprev)- upre)/tau_u(Vprev);
        u            = upre + du * Dt;
        
        dcai  = drive_channel(ICaPrev/(Sm*(10^9))) + ((2e-4)-cai)/5;
        cai   = cai + dcai * Dt;
        
        carev = Kcarev * log(cao/cai);
%         carev           = 120.24;
        I_T      = g_Ca * s_inf(Vprev)^2 * u * (Vprev - carev);
        ICa             = I_T;
    else
        I_T      = 0;
        u        = 0;
        ICa         = 0;
    end
    
	%Ionic current
    I_Na     = g_Na  * (m^3) * h    * (Vprev - E_Na);
    I_Kd     = g_Kd  * (n^4)        * (Vprev - E_K);
    I_Leak   = g_leak               * (Vprev - E_leak);
 
    
    
    sigma_I   = I_inj - (I_Leak + I_Na + I_Kd + I_M + I_L + I_T);
    dv        = sigma_I/(Cm);
    
	%Euler method for membrane voltage
    Vmem    = Vprev + dv * Dt;
    
    HHVal(1) = Vmem;
    HHVal(2) = n;    
    HHVal(3) = m;
    HHVal(4) = h;
    HHVal(5) = p;
    HHVal(6) = q;
    HHVal(7) = r;
    HHVal(8) = u;
    HHVal(9) = ICa;
end

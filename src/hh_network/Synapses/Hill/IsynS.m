% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Authors     : Farad KHOYRATEE, Romain BEAUBOIS
%   Create Date : 04 Mar 2018
%   Update Date : 10 Aug 2021
%
%   Description : 
%
%   Revision :
%       > Revision 0.01 - File created
%       > Revision 0.02 - Integrate sum in function
%
%   Additional Comments :
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [IsynS, Mval] = IsynS(dt, Vpre, Vpost, syn_param, Mpre, t, ev_tab)
% | **Compute spike mediated current from Hill's article**
% |
% | **dt** : Time step (ms)
% | **Vpre** : Membrane potential of pre synaptic neuron (mV)
% | **Vpost** : Membrane potential of post synaptic neuron (mV)
% | **syn_param** : Hill synapse parameters
% | **Mpre** : previous value of M for Euler method
% | **t** : Current time (ms)
% | **ev_tab** : Event time table (ms)
%
% | Simplified computation of spike mediated current from Hill's article
% | (truncated number of spike instead of infinite)

    % Fetch parameters
    Esyn    = syn_param(1);
    GsynS   = syn_param(2);
    tau1    = syn_param(3);
    tau2    = syn_param(4);
    max_spk = syn_param(5);
    
    % Compute state variable
    Mval    = Mfunc(Vpre, Mpre, dt);

    % Compute spike mediated induced current
    Isum = 0;
    for i = 1:max_spk
        Isum = Isum + (Vpost - Esyn) * GsynS * Mval * fsynS(t-ev_tab(i), tau1, tau2);
    end

    IsynS = Isum; % mA
end
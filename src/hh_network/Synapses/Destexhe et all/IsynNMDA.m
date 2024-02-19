%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Authors     : CHATENET Louis
%   Date        : 24/05/2018 
%   Version     : V1.0
%   
%   Description : NMDA current calculation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Isyn, r] = IsynNMDA(dt,Vpre, Vpost, rpre)     
       alpha   = 0.072;  % /kM-1.ks-1
       beta    = 0.0066; % /ks
       cgmax   = 3.5*10e-9; % nS
       Erev    = 0;      %mV
       Mg      = 1;      %mM       
       
       T    = Tcalc(Vpre); % mM
       r    = Euler(alpha*T*(1-rpre)-beta*rpre ,rpre,dt);
%        Bv   = 1/(1 + (Mg/3.57)*exp(0.062*-Vpre)*10^-3) ;
       Bv   = 0.5*tanh((Vpre+131.5)/32)+0.5;
       Isyn = cgmax*r*Bv*(Vpost-Erev);
end
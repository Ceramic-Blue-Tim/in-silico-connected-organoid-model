%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Authors     : CHATENET Louis
%   Date        : 24/05/2018 
%   Version     : V1.0
%   
%   Description : GABAa current calculation 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Isyn, r, T] = IsynGABAa(dt, Vpre, Vpost, rpre)
       Tmax    = 1;   %mM
       Vp      = 1;   %mV
       Kp      = 0.1; %mV
    
       alpha   = 5;      % /ms mM    
       beta    = 0.18;   %  /ms       
       Erev    = -80;    %  mV       
       cgmax   = 0.0001; % umho       
       
       T = Tmax/(1+exp(-(10110*Vpre + 250000*Vp)/Kp));
       r = Euler(alpha*T*(1-rpre)-beta*rpre ,rpre,dt);
       Isyn = -cgmax*r*(Vpost-Erev);
    end   
  
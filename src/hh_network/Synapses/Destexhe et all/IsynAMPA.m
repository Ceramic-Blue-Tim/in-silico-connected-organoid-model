%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Authors     : CHATENET Louis
%   Date        : 24/05/2018 
%   Version     : V1.0
%   
%   Description : AMPA current calculation  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Isyn, r, T] = IsynAMPA(dt, Vpre, Vpost, rpre)
       Tmax    = 1;   %mM
       Vp      = 1;   %mV
       Kp      = 0.5; %mV
       
       alpha   = 1.1;    % /mM ms
       beta    = 0.19;   % /ms
       cgmax   = 0.0001; % umho
       Erev    = 0;      % mV 
       T = Tmax/(1+exp(-(10110*Vpre + 250000*Vp)/Kp));
       r = Euler(alpha*T*(1-rpre)-beta*rpre ,rpre,dt);
       Isyn = cgmax*r*(Vpost-Erev); 
 end   
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Authors     : CHATENET Louis
%   Date        : 24/05/2018 
%   Version     : V1.0
%   
%   Description : GABAb current calculation 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Isyn, r, s] = IsynGABAb(dt, Vpre, Vpost, rpre, spre)
       Tmax   = 1;      %mM
       Vp     = 2;      %mV
       Kp     = 5;      %mV
       
       Erev   = -95;    %mV
       cgmax  = 50*0.001*10^-6; %µS     
      
       K1 = 0.09;   % /kM-1.ks-1 
       K2 = 0.0012; % /ks   
       K3 = 0.18;   % /ks  
       K4 = 0.034;  % /ks
       Kd = 100;    
       n  = 4;      % binding sites        

       T = Tmax/(1+exp(-(Vpre + Vp)/Kp)); 
       r = Euler(K1*T*(1-rpre)-K2*rpre, rpre, dt);
       s = Euler(K3*r - K4*spre, spre, dt);
       Isyn = cgmax*(s^n)*(Vpost-Erev)/((s^n)+Kd);
end   
  
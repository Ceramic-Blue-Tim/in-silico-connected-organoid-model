%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Authors     : CHATENET Louis
%   Date        : 24/05/2018
%   Updated     : 30/05/2018
%   Version     : V2.0
%   
%   Description : GABAb current calculation 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Isyn, r, s] = IsynGABAb2(dt, T, Vpost, rpre, spre)
       Erev   = -95;    %mV
       cgmax  = 0.0001; % umho     
      
       K1 = 0.09;   % /ms mM 
       K2 = 0.0012; % /ms   
       K3 = 0.18;   % /ms  
       K4 = 0.034;  % /ms
       Kd = 100;    
       n  = 4;      % binding sites        
       
       r = Euler(K1*T*(1-rpre)-K2*rpre, rpre, dt);
       s = Euler(K3*r - K4*spre, spre, dt);
       Isyn = cgmax*(s^n)*(Vpost-Erev)/((s^n)+Kd);
end   
  
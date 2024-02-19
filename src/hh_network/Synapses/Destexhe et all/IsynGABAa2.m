%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Authors     : CHATENET Louis
%   Date        : 24/05/2018 
%   Updated     : 30/05/2018
%   Version     : V2.0
%   
%   Description : GABAa current calculation 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Isyn, r] = IsynGABAa2(dt, Vpre, Vpost, rpre)
       alpha   = 5;      % /ms mM    
       beta    = 0.18;   %  /ms       
       Erev    = -80;    %  mV       
       cgmax   = 80*10^-9; % umho          
       
       T    = Tcalc(Vpre); % mM
       r = Euler(alpha*T*(1-rpre)-beta*rpre ,rpre,dt);
       Isyn = cgmax*r*(Vpost-Erev);
    end   
  
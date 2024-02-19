%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Authors     : BEAUBOIS Romain
%   Date        : 30/03/2020 
%   Updated     : 30/03/2020
%   Version     : V2.0
%   
%   Description : GABAa current calculation 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Isyn, r] = IsynGABAa3(dt, T, Vpost, rpre)
       alpha   = 5;      % /ms mM    
       beta    = 0.18;   %  /ms       
       Erev    = -80;    %  mV       
       cgmax   = 80*10^-9; % umho          
       
       r = Euler(alpha*T*(1-rpre)-beta*rpre ,rpre,dt);
       Isyn = cgmax*r*(Vpost-Erev);
    end   
  
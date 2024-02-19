%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Authors     : CHATENET Louis
%   Date        : 24/05/2018 
%   Updated     : 30/05/2018
%   Version     : V2.0
%   
%   Description : AMPA current calculation  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Isyn, r] = IsynAMPA4(dt, T, Vpost, rpre)
       alpha   = 1.1;    % /mM ms
       beta    = 0.19;   % /ms
       cgmax   = 0.0001; % umho
       Erev    = 0;      % mV 

       r = Euler(alpha*T*(1-rpre)-beta*rpre ,rpre,dt);
       Isyn = cgmax*r*(Vpost-Erev); 
 end   
  
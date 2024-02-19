%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Authors     : CHATENET Louis
%   Date        : 24/05/2018 
%   Updated     : 30/05/2018
%   Version     : V2.0
%   
%   Description : AMPA current calculation  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Isyn, r, T] = IsynAMPAV5(dt, Vpre, Vpost, rpre)
       alpha    = 1.1;    % kM-1.ks-1
       beta     = 0.19;   % /ks
       G        = 8.8*10e-9; % mS
       Erev     = 0;      % mV 
        
       T        = Tcalc(Vpre); % mM
       r        = Euler(alpha*T*(1-rpre)-beta*rpre ,rpre,dt);
       Isyn     = G*r*(Vpost-Erev);
 end   
  
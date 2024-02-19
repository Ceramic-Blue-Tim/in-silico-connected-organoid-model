%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Authors     : CHATENET Louis
%   Modified    : Khoyratee Farad
%   Creation    : 30/05/2018
%   Modified    : 26/10/2018
%   Version     : V5.0
%   
%   Description : Neuotransmitter concentration calculation (T)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [T] = Tcalc(Vpre)
       Tmax    = 1;   %mM
       Vp      = 2;   %mV
       Kp      = 5;   %mV
       
%        T = (Tmax/(1+exp(-(Vpre - Vp)/Kp))); 
       T = 0.5*tanh((Vpre-2)/10)+0.5;
end
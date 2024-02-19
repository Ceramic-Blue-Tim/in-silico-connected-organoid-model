%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%   Frequency calculator
%
%   Authors     : KHOYRATEE Farad
%   Date        : 24/01/2017
%   Update by   : KHOYRATEE Farad
%   Update      : 24/04/2017
%
%   Version     : V1.1
%   
%   Descritption: Mesure the spike frequency. Every spike
%   must have the same frequency.
%   log         :
%       v.1.1 : Selection between Biologist unity or SI unity 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%Frequency calcultation
function f=freq(t, V, Unity, SpikeThreshold)
    
    if nargin < 3
        Unity           = 'm'; % mili
        SpikeThreshold  = 11;
    end
    
    if strcmp(Unity, 'm')
        Fthreshold  = -30;
        ktime       = 1e-3;
    elseif strcmp(Unity, 'SI')
        Fthreshold  = -0.03;
        ktime       = 1;
    end
    
    t1 = 0; % First maximum
    t2 = 0; % Second maximum

    signal_state    = 0;
    max_state       = 0;
    
    Spike_detected  = 0;
    
    for i=1:length(t)-1
       if Spike_detected < SpikeThreshold
           if (V(i)>V(i+1)) && V(i)>Fthreshold
               if signal_state == 0 
                  t1 = t(i); 
                  max_state = 1;
                  signal_state = 1;
               elseif signal_state == 2 
                  t2 = t(i);
                  max_state = 2;
                  signal_state = 0;
                  Spike_detected = Spike_detected + 1;
               end
           end

           if V(i) < Fthreshold && max_state == 1
               signal_state = 2;
           end
        end;
    end

    if (t1==0) || (t2 == 0) || (Spike_detected ~= SpikeThreshold)
        f       = 0;
    else
        Tspike  = abs(t2-t1)*ktime;
        f       = 1/Tspike;
    end
end
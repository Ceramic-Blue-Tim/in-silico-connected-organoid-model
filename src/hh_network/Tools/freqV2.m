%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%   Frequency calculator
%
%   Authors     : KHOYRATEE Farad
%   Date        : 11/10/2017
%   Update by   : KHOYRATEE Farad
%   Update      : 24/04/2017
%
%   Version     : V1.1
%   
%   Descritption: Mesure the spike frequency. Every spike
%   must have the same frequency.
%   log         :
%       v.1.1 : Selection between Biologist unity or SI unity 
%       v.2.0 : Use of fsm 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%Frequency calcultation
function f=freqV2(t, V)

    fsm     = 0;
    Vmax    = 0;
    t1 = 0; % First maximum
    t2 = 0; % Second maximum
    f  = 0;
    
    for i=1:length(t)
        switch fsm
            case 0
                if V(i) > 0
                    fsm = 1;
                    Vmax= 0;
                end
            case 1
                if Vmax < V(i)
                    Vmax = V(i);
                end

                if Vmax > V(i)
                    t1  = t(i-1);
                    fsm = 2;
                end
            case 2
                if V(i) < 0
                    fsm = 3;
                end
            case 3
                if V(i) > 0
                    fsm = 4;
                    Vmax= 0;
                end
            case 4
                if Vmax < V(i)
                    Vmax = V(i);
                end

                if Vmax > V(i)
                    t2  = t(i-1);
                    fsm = 5;
                end
            case 5 
                f = 1/(abs(t2-t1)*10^-3);
        end
    end
 end

    
    
    
    
    
    
    
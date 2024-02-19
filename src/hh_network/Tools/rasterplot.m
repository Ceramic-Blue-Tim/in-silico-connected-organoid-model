%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Authors     : Khoyratee Farad
%   Date        : 28/11/2018 
%   Version     : V1.0
%   
%   Description : GABAb current calculation 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [N, Yplot] = rasterplot(t, V, Threshold)
    N       = length(V(:,1));
    LT      = length(t);
    Yplot   = zeros(N,LT);
    fsm     = 0;
    figure;
    hold on;
    for i = 1:N
        for j = 1:LT
            switch fsm
                case 0
                    if V(i,j) > Threshold
                        Yplot(i,j)  = N-i+1;
                        fsm         = 1;
                    else
                        Yplot(i,j)  = nan;
                    end
                case 1
                    if V(i,j) < Threshold
                        fsm         = 0;
                    end  
                    Yplot(i,j)  = nan;
            end
        end
        plot(t, Yplot(i,:), '+');
    end
end
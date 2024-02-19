% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function Iexc  = StimCurrentForm(Imax, t, dt, Period, DutyCycle, WaveForm)
    
    Iexc    = zeros(1, length(t)); 
    if strcmp(WaveForm,'square')
        j   = 2;
        k   = 0;
        Ton = (DutyCycle/100)*Period;
        for i = 1:length(t)-1
            if (j*dt) <= Period
                if (k*dt) <= Ton
                    Iexc(i) = Imax;
                    k       = k+1;
                else
                    Iexc(i) = 0;
                end
                j   = j+1;
            else
                j   = 2;
                k   = 0;
            end
        end
    elseif strcmp(WaveForm,'triangle')
            
    elseif strcmp(WaveForm,'sawtooth')
    
    else
        Iexc    = Imax;
    end
end
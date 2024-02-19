% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function LoadSim = LoadSim(i, Imax)
    LoadSim = (i*100)/(Imax-1); 
    switch LoadSim
        case 10.0
            disp('10%');
        case 20.0
            disp('20%');
        case 30.0
            disp('30%');
        case 40.0
            disp('40%');
        case 50.0
            disp('50%');
        case 60.0
            disp('60%');
        case 70.0
            disp('70%');
        case 80.0
            disp('80%');
        case 90.0
            disp('90%');
        case 100.0
            disp('100%');
    end
end
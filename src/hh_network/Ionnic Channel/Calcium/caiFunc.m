% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function cai = caiFunc(IPre, caiPre, dt, Sm)
    dcai    = drive_channel(IPre/(Sm*(10^9))) + ((2e-4)-caiPre)/5;
    cai     = Euler(dcai, caiPre, dt);
end

function drive_channel = drive_channel(I)
    FARADAY = 96485;
    
    Kchan = -(1*10^4) / (2 * FARADAY);
    
    drive_channel   = Kchan * I;
end
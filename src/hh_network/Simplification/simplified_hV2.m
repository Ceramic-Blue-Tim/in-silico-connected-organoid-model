% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function simplified_hV2= simplified_hV2(v, hpre, dt, Vt)
    hinf    = (2^-1)*tanh(2.705-(2^-3)*(v-Vt))+ 0.5018;
    tauh    = 2^-3*((-(2^-2)*(v-Vt)+9.649)/cosh(-1.96+0.09904*(v-Vt))) + (2^-3)*0.3498;
    dh      = (2^-3)*(hinf-hpre)/tauh;
    
    simplified_hV2 = Euler(dh, hpre, dt);
end
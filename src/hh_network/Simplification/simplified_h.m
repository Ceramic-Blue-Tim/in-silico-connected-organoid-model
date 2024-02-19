% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function simplified_h= simplified_h(v, hpre, dt)
    hinf    = -0.4991*tanh(4.146+0.1243*v)+ 0.5015;
    tauh    = (-0.2334*v -3.191)/cosh(3.487+0.09904*v) + 0.3498;
    dh      = (hinf-hpre)/tauh;
    
    simplified_h = Euler(dh, hpre, dt);
end
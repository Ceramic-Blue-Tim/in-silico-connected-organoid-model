% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function simplified_mV2= simplified_mV2(v, mpre, dt, Vt)
    minf    = 0.5*tanh(-1.718+(2^-4 + 2^-8)*(v-Vt))+0.4976;
    taum    = 0.08938/cosh(0.9374-0.04105*(v-Vt)) + 0.02889;
    dm      = (minf-mpre)/taum;
    
    simplified_mV2 = Euler(dm, mpre, dt);
end
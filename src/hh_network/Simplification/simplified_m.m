% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function simplified_m= simplified_m(v, mpre, dt)
    minf    = 0.504*tanh(1.935+0.06631*v)+0.4966;
    taum    = 0.08938/cosh(1.32+0.04105*v) + 0.0289;
    dm      = (minf-mpre)/taum;
    
    simplified_m = Euler(dm, mpre, dt);
end
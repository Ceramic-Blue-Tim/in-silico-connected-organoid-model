% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function simplified_p= simplified_p(v, ppre, dt, Vt)
    pinf    = 0.5*tanh(-0.9378+((2^-6)+(2^-5))*(x-(-55)))+0.5001;
    taup    = 1.325/cosh(-0.4974+0.04616*(v-Vt)) + 0.3346;
    dn      = (pinf-ppre)/taup;
    
    simplified_p = Euler(dn, ppre, dt);
end
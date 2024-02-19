% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function simplified_nV2= simplified_nV2(v, npre, dt, Vt)
    ninf    = (2^-1)*tanh(-1.128+((2^-5)+(2^-6))*(v-Vt))+ 0.4675;
    taun    = 1.325/cosh(-0.4974+0.04616*(v-Vt)) + 0.3346;
    dn      = (ninf-npre)/taun;

    simplified_nV2 = Euler(dn, npre, dt);
end
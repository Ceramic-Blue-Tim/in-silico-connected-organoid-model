% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function simplified_n= simplified_n(v, npre, dt)
    ninf    = (0.001451*v +0.5208)*tanh(1.833+0.05311*v)+ 0.3959;
    taun    = (0.002036*v +1.423)/cosh(2.080+0.04597*v) + 0.3281;
    dn      = (ninf-npre)/taun;
    
    simplified_n = Euler(dn, npre, dt);
end
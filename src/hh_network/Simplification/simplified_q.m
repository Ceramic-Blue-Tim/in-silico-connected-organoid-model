% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function simplified_q= simplified_q(v, qpre, dt)
    inf    = ((0.000297*v +0.5059)*tanh(3.749 + 0.1119*v))+0.4824;
    tau    = ((-0.1118*v +2.264)/cosh(0.09308*v + 3.452))+0.3711;
    d      = (inf-qpre)/tau;
    
    simplified_q = Euler(d, qpre, dt);
end
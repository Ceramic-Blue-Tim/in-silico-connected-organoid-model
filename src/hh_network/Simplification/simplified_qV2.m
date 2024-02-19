% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function simplified_qV2= simplified_qV2(v, qpre, dt)
    inf    = 0.5*tanh((2^-4 + 2^-5 + 2^-6)*v+3.628)+0.4952;
    tau    = ((2^-3)*(-(2^-4 + 2^-5 + 2^-6)*v+2.264)/cosh(0.09308*v+3.452))+0.3711*2^-3;
    d      = 2^-3*(inf-qpre)/tau;
    
    simplified_qV2 = Euler(d, qpre, dt);
end
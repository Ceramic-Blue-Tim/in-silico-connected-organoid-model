% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function tau_u = tau_u(v)
    vx      = 7;
    tau_u   = (30.8 + ((211.4 + exp((v+vx+113.2)/5)) / (1 + exp((v+vx+84)/3.2)))) * (1/(3 ^ 1.2)) ;
end
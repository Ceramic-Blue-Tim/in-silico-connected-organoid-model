% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function uchan = uchan(v, upre, Dt)
    du      = (u_inf(v)- upre)/tau_u(v);
    uchan   = Euler(du, upre, Dt);
end
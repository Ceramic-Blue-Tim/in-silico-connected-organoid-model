% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function rchan = rchan(v, rpre, Dt)
    dr      = ar(v)*(1-rpre) - (br(v)*rpre);
    rchan   = Euler(dr, rpre, Dt);
end
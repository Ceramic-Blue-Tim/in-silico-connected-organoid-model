% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function s_inf = s_inf(v)
    vx      = 7;
    s_inf   = 1/(1+exp(-(v+vx+57)/6.2));
end
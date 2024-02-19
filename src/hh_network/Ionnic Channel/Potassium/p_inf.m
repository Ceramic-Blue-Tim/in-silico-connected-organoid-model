% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function pinf = p_inf(v)
    pinf = 1 / (1 + exptable(-(v+35)/10));
    %pinf = 1 / (1 + exp(-(v+35)/10));
end
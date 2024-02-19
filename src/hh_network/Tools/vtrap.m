% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function v = vtrap(x,y)
    if (abs(x/y) < (1*10^-6))
        v = y*(1- x/(y*2));
    else
        v = x/(exp_t(x/y)-1);
    end
end
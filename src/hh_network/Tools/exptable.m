% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function y = exptable(x)
    if ((x> -25) && (x<25))
       y = exp(x);
    else
       y = 0;
    end
end
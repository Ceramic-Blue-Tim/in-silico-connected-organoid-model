% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function mhFunc = mhFunc(v, mhPre, dt)
    dh      = (fhinf(v) - mhPre) / tauFunc(-100, 0.073, 0.7, 1.7, v);
    mhFunc  = Euler(dh, mhPre,dt);
end
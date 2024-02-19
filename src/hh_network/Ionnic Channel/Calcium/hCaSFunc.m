% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function hCaSFunc = hCaSFunc(v, hCaSPre, dt)
    dCaS    = (Funcinf(360, 0.055, v) - hCaSPre) / tauFunc(-250, 0.043, 0.2, 5.25, v);
    hCaSFunc= Euler(dCaS, hCaSPre,dt);
end
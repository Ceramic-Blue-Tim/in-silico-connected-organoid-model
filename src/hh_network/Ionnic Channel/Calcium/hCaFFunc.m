% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function hCaFFunc = hCaFFunc(v, hCaFPre, dt)
    dCaF    = (Funcinf(350, 0.0555, v) - hCaFPre) / tauFunc(270, 0.055, 0.06, 0.31, v);
    hCaFFunc= Euler(dCaF, hCaFPre,dt);
end
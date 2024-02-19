% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function mCaFFunc = mCaFFunc(v, mCaFPre, dt)
    dCaF    = (Funcinf(-600, 0.0467, v) - mCaFPre) / taumCaFFunc(v);
    mCaFFunc= Euler(dCaF, mCaFPre,dt);
end
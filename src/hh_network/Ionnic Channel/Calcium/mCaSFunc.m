% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function mCaSFunc = mCaSFunc(v, mCaSPre, dt)
    dCaS    = (Funcinf(-420, 0.0472, v) - mCaSPre) / tauFunc(-400, 0.0487, 0.005, 0.134, v);
    mCaSFunc= Euler(dCaS, mCaSPre,dt);
end
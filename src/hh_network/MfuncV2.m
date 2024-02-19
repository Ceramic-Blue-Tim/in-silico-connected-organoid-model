% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function Mfunc = MfuncV2(Vpre, Mpre, Dt)
    dMval   = dMV2(Vpre, Mpre);
    Mfunc   = Euler(dMval, Mpre, Dt);
end
% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function Pfunc = Pfunc(ICa, Pprev, Dt)
    B       = 10;
    dP      = ICa - (B * Pprev);
    Pfunc   = Pprev + dP * Dt;
end
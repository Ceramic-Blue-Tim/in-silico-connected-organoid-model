% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function [IsynG, Aval, Pval] = IsynG(Vpresyn, Esyn, GsynG, ICa, Ppre, Apre, Dt)
    C       = 10^(-29);     % Coulombs

    Aval    = Afunc(Vpresyn, Apre, Dt);
    Pval    = Pfunc(ICa, Ppre, Dt);
    IsynG   = GsynG * ((Pval^3)/(C + (Pval^3))) * (Vpresyn - Esyn); % mA
end
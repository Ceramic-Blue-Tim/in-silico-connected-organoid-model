% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function y = dA( Vpresyn, Aprev )
    y = ( A_inf(Vpresyn) - Aprev ) / 0.2;
end


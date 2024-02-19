% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function tauhNa = tauhNa(v)
    tauhNa = 0.004 + (0.006/( 1 + exp(500*(v+0.028)))) + (0.01/(cosh(300*(v+0.027))));
end
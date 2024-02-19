% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function tauFunc = tauFunc(a, b, c, d, v)
    tauFunc = c + d./ (1 + exp(a.*(v+b)));
end
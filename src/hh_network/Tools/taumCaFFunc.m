% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function taumCaFFunc = taumCaFFunc(v)
    taumCaFFunc     = 0.011 + (0.024/cosh(-330*(v + 0.0467)));
end
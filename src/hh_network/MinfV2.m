% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function Minf = MinfV2(Vpre)
    Minf = 0.4499*tanh(0.5*Vpre + 20) + 0.5499;
end
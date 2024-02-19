% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function Minf = Minf(Vpre)
    Minf = 0.1 + 0.9 / (1 + exp(-1000*(Vpre+0.04)));
end


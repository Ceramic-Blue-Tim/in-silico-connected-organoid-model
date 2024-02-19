% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function fhinf = fhinf(v)
    fhinf   = 1/ (1 + 2*exp(180*(v+0.047)) + exp(500*(v+0.047))); 
end
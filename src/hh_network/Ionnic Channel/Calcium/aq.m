% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function [aq] = aq(v)
    if v == -27
        aq = 0.2090;
    else
        aq = 0.055 * (-27-v) / ((exp((-27-v)/3.8))- 1);
    end
end
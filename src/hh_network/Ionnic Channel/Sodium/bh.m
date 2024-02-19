% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function bh = bh(v, VTraub)
    bh = 4/(1+exp_t((40-v2(v, VTraub))/5));
end
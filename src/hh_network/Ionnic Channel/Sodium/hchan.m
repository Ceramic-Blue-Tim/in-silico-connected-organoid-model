% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function hchan = hchan(v, hpre, Dt, VTraub)
    hchan = hpre + h_exp(v,Dt, VTraub) * (h_inf(v, VTraub) - hpre);
end
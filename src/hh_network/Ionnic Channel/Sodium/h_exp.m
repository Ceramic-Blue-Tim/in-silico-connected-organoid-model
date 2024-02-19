% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function h_exp = h_exp(v,Dt, VTraub)
    h_exp = 1 - exp_t(-Dt/tau_h(v, VTraub));
end
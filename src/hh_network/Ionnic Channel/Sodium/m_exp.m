% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function m_exp = m_exp(v, Dt, VTraub)
    m_exp = 1 - exp_t(-Dt/tau_m(v, VTraub));
end
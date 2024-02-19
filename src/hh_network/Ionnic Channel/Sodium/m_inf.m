% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function m_inf= m_inf(v, VTraub)
    m_inf = am(v, VTraub)/(am(v, VTraub)+betam(v, VTraub));
end
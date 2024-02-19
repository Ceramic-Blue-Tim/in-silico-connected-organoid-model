% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function mchan = mchan(v, mpre, Dt, VTraub)
    mchan = mpre + m_exp(v,Dt, VTraub) * (m_inf(v, VTraub) - mpre);
%     dm = am(v, VTraub)*(1-mpre) - betam(v, VTraub)*mpre;
%     mchan = Euler(dm, mpre, Dt);
end
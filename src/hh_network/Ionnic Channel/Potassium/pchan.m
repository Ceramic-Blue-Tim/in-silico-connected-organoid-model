% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function pchan = pchan(Vprev, ppre, Dt, TauMax)
    pchan = ppre + ((p_inf(Vprev)-ppre) / tau_p(Vprev, TauMax))*Dt;
end
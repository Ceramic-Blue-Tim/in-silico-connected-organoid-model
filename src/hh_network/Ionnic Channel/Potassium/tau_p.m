% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function tau_p = tau_p(v, TauMax)
    tau_p = TauMax / ( 3.3 * exptable((v+35)/20) + exptable(-(v+35)/20));
    %tau_p = TauMax / ( 3.3 * exp((v+35)/20) + exp(-(v+35)/20));
end
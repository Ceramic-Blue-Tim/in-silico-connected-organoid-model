% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function tau_m= tau_m(v, VTraub)
    tau_m = 1/(am(v, VTraub) + betam(v, VTraub));
end
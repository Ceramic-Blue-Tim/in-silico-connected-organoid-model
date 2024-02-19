% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function tau_n = tau_n(v, VTraub)
    tau_n = 1/(an(v, VTraub) + bn(v, VTraub));
end
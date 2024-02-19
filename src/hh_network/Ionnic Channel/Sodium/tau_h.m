% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function tau_h = tau_h(v, VTraub)
    tau_h = 1/(ah(v, VTraub) + bh(v, VTraub));
end
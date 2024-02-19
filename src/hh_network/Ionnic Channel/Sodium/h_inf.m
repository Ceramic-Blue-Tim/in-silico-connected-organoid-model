% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function h_inf = h_inf(v, VTraub)
    h_inf = ah(v, VTraub)/(ah(v, VTraub)+bh(v, VTraub));
end
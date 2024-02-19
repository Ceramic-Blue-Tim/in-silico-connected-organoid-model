% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function y = A_inf( V_pre )
    y = (10^-10)/(1+exp(-100*(V_pre+0.02))) ;
end


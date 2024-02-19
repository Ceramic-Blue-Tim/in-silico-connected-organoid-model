% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function simplified_sV2= simplified_sV2(v)
    simplified_sV2 = (2^-1)*tanh(((2^-4)+(2^-6))*v+5)+0.5;
end
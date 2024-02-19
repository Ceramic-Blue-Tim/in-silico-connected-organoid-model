% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function betam = betam(v, VTraub)
    betam = 0.28*vtrap((v2(v, VTraub)-40), 5);
end
% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function qchan = qchan(v, qpre, Dt)
    dq      = aq(v)*(1-qpre) - (bq(v)*qpre);
    qchan   = Euler(dq, qpre, Dt);
end
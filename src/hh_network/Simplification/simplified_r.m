% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function simplified_r= simplified_r(v, rpre, dt)
    inf    = ((-0.000396*v - 0.5129)*tanh(1.583 + 0.02531*v)) + 0.5503;
    tau    = ((-0.9446*v + 237.6)/cosh(-0.02908*v - 1.833)) + 150.7;
    d      = (inf-rpre)/tau;
    
    simplified_r = Euler(d, rpre, dt);
end
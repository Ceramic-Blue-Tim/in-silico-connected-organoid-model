% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function simplified_rV2= simplified_rV2(v, rpre, dt)
    inf    = (2^-1)*tanh(-(2^-6 + 2^-7)*v-1.404)+0.5193;
%     tau    = ((-0.9446*v + 237.6)/cosh(-0.02908*v-1.833))+150.7;
%     tau    = (((-0.01476*v + 3.713)/cosh(0.02908*v+1.833))+2.354);
    tau    = (((-0.001845*v + 0.4641)/cosh(0.02908*v+1.833))+0.2943);
% 2^9*(((a*x + b)/cosh(c*x+d))+e)
    d      = 2^-9*(inf-rpre)/tau;
    
    simplified_rV2 = Euler(d, rpre, dt);
end
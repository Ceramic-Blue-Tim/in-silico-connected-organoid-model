% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function simplified_uV2= simplified_uV2(v, rpre, dt)
%     inf    = (2^-1)*tanh(-(2^-6 + 2^-7)*v-1.404)+0.5193;
%     tau    = ((-0.9446*v + 237.6)/cosh(-0.02908*v-1.833))+150.7;
%     d      = (inf-rpre)/tau;
%     
%     simplified_uV2 = Euler(d, rpre, dt);

    a1 = 0.5; b1 = 88; c1 = -8; d1 = 0.5;
    a2 = -28.09; b2 = 79.14; c2 = 6.179; d2 = 37.03;


%     inf    = a1 * tanh((v + b1)/c1) + d1;
%     tau    = a2 * tanh((v + b2)/c2) + d2;
    inf     = 0.5*tanh(-(2^-3)*v -11) + 0.5;
    tau     = -28.09*tanh(0.162*v + 12.808)+37.03;
    d       = (inf-rpre)/tau;
    
    simplified_uV2 = Euler(d, rpre, dt);
end
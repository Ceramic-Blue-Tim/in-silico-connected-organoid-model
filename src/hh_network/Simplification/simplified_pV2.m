% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function simplified_pV2= simplified_pV2(v, ppre, dt)
    pinf    = 0.5*tanh((2^-5 + 2^-6 + 2^-8)*v+1.778)+0.4998;
    taup    = 1/(cosh(2.3470+0.05*v));%275.2
    dp      = (pinf-ppre)/taup;
    
    simplified_pV2 = Euler((1/275.2)*dp, ppre, dt);
end

%0.5*tanh(b+((2^-6)+(2^-5))*(x-(-55)))+d
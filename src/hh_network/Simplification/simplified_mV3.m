% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function simplified_mV3= simplified_mV3(v, mpre, dt, Vt)
%     minf    = 0.5029*tanh(1.942+0.075*v)+0.4972;
%     minf    = (0.0001005 * v + 0.5052)*tanh(1.961+0.06681*v)+0.4921;
%     minf    = 0.5*tanh(-1.718+(2^-4 + 2^-8)*(v-Vt))+0.4976; % 10^-1 error
%     minf    = ((-4.626e-06)*v^2 + 0.00013 * v + 0.5224) * tanh(-1.615 + 0.064*(v-Vt)) + 0.4803; % 10^-3 error
%     minf    = am(v, Vt)/(am(v, Vt)+betam(v, Vt));
    if v < -30
%         minf = (0.001179*v+0.5479)*tanh(0.06397*v+1.954)+0.4577;
        minf = (0.001179*v+0.5479)*tanh((2^-4 + 2^-10)*v+1.954)+0.4577;
    else
%         minf = (-0.0001474*v+0.4383)*tanh(0.06707*v+1.817)+0.567;
        minf = (-0.0001474*v+0.4383)*tanh((2^-4 + 2^-8)*v+1.817)+0.567;
    end

    taum    = 0.08938/cosh(0.9374-0.04105*(v-Vt)) + 0.02889;
%     taum    = ((-0.0001183*v + 0.08484)/cosh(-0.04146*(v-Vt)+0.989))+0.02973;
%     taum    = 1/(am(v, Vt)+betam(v, Vt));
    dm      = (minf-mpre)/taum;
    
    simplified_mV3 = Euler(dm, mpre, dt);
end
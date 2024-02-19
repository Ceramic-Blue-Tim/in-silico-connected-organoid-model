% @author     Farad Khoyratee
% @date       16 Apr 2019
% @copyright
% SPDX-FileCopyrightText: © 2021 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later

function fsynS = fsynS(t, tau1, tau2)  
    tpeak       = (tau1*tau2*log(tau1/tau2))/(tau1-tau2);
    a           = 1/(exp(-tpeak/tau1) - exp(-tpeak/tau2));
    
    fsynS       = a * (exp(-t/tau1) - exp(-t/tau2));
end
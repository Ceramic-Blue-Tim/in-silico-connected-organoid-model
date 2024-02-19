% @title      Output neuron properties for a given type
% @file       ntype_to_params.m
% @author     Romain Beaubois
% @date       06 Aug 2021
% @copyright
% SPDX-FileCopyrightText: © 2021 Romain Beaubois <refbeaubois@yahoo.com>
% SPDX-License-Identifier: GPL-3.0-or-later
% 
% @details
% > **08 Mar 2021** : file creation (RB)
% > **06 Aug 2021** : fix coefficients for neurons parameters (RB)

function [Istim, Cm, Sm, GNa, GK, GLeak, GM, GCa, ENa, EK, ELeak, ECa] = ntype_to_params(ntype)
% | **Output neuron properties for a given type**
% |
% | **ntype** : neuron type : 'FS', 'RS', 'IB', 'LTS'
%
% | Fill the values of neurons' properties for .txt file generation

    switch ntype
        case 'FS'
            Istim   = 0.5;
            GK      = 0.01;
            GNa     = 0.05;
            GLeak   = 0.00015;
            GM      = 0;
            GCa     = 0;
            
            EK      = -100;
            ENa     = 50;
            ELeak   = -70;
            ECa     = 0;
            
            Cm      = 1;
            Sm      = 67;
        
        case 'RS'
            Istim   = 0.75;
            GK      = 0.005;
            GNa     = 0.05;
            GLeak   = 0.0001;
            GM      = 7.0e-5;
            GCa     = 0;
            
            EK      = -100;
            ENa     = 50;
            ELeak   = -70;
            ECa     = 0;
            
            Cm      = 1;
            Sm      = 96;

        case 'IB'
            Istim   = 0.15;
            GK      = 0.005;
            GNa     = 0.05;
            GLeak   = 1.0e-5;
            GM      = 3.0e-5;
            GCa     = 1.2e-4;

            EK      = -90;
            ENa     = 50;
            ELeak   = -85;
            ECa     = 0;

            Cm      = 1;
            Sm      = 96;
        
        case 'LTS'
            Istim   = 0.15;
            GK      = 0.005;
            GNa     = 0.05;
            GLeak   = 1.0e-5;
            GM      = 3.0e-5;
            GCa     = 5.0e-4;
            
            EK      = -100;
            ENa     = 50;
            ELeak   = -50;
            ECa     = 0;
            
            Cm      = 1;
            Sm      = 96;
    end
end
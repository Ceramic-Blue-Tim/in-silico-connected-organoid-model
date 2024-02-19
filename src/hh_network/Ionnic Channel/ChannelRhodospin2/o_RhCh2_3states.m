% @title      o state for Channel Rhodospin 2 (3 states model)
% @file       o_RhCh2_3states.m
% @author     Romain Beaubois
% @date       09 Aug 2021
% @copyright
% SPDX-FileCopyrightText: © 2021 Romain Beaubois <refbeaubois@yahoo.com>
% SPDX-License-Identifier: GPL-3.0-or-later
% 
% @details
% > **09 Aug 2021** : file creation (RB)

function onew = o_RhCh2_3states(opre, dpre, P, Gd, dt)
% | **Equation for o state ChRh2 (3-states model)**
% |
% | **opre** : Previous value o state
% | **dpre** : Previous value d state
% | **P** : light dependant equation rate (1/ms)
% | **Gd** : Decrease transition rate (1/ms)
% | **dt** : Time step (ms)
%
% | Calculates next value for o state
    
    do      = P*(1 - opre - dpre) - Gd*opre;
    onew    = Euler(do, opre, dt);
end
% @title      d state for Channel Rhodospin 2 (3 states model)
% @file       d_RhCh2_3states.m
% @author     Romain Beaubois
% @date       09 Aug 2021
% @copyright
% SPDX-FileCopyrightText: © 2021 Romain Beaubois <refbeaubois@yahoo.com>
% SPDX-License-Identifier: GPL-3.0-or-later
% 
% @details
% > **09 Aug 2021** : file creation (RB)

function dnew = d_RhCh2_3states(opre, dpre, Gr, Gd, dt)
% | **Equation for d state ChRh2 (3-states model)**
% |
% | **opre** : Previous value o state
% | **dpre** : Previous value d state
% | **Gr** : Rise transition rate (1/ms)
% | **Gd** : Decrease transition rate (1/ms)
% | **dt** : Time step (ms)
%
% | Calculates next value for d state

    dd      = Gd*opre - Gr*dpre;
    dnew    = Euler(dd, dpre, dt);
end
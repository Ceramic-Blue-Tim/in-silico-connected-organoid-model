% @title      Update spike event table according to Hill article for spike mediated synaptic current
% @file       spk_dtc_Hillsyn.m
% @author     Romain Beaubois
% @date       11 Aug 2021
% @copyright
% SPDX-FileCopyrightText: © 2021 Romain Beaubois <refbeaubois@yahoo.com>
% SPDX-License-Identifier: GPL-3.0-or-later
% 
% @details
% > **11 Aug 2021** : file creation (RB)

function [ev_tabnew, fsm_spk_ev, nb_spk, last_ev] = spk_dtc_Hillsyn(j, V, t, ev_tab, fsm_spk_ev, nb_spk, last_ev, max_spk, threshold)
% | **Update spike event table according to Hill article for spike mediated synaptic current**
% |
% | **j** : Index of neuron
% | **V** : Voltage of neuron at index j
% | **ev_tab** : Tab of events
% | **fsm_spk_ev** : State of spike detection
% | **nb_spk** : Number of spikes detected
% | **last_ev** : Time last event occured
% | **max_pk** : Maximum number of spikes
% | **threhsold** : Threhsold for spike detection
%
% | Fill event table with the new events

    switch (fsm_spk_ev(j))
        case 0  % Detect over-threshold crossing
            if V > threshold
                fsm_spk_ev(j) = 1;
                
                if nb_spk(j) > max_spk
                    nb_spk(j) = 1;
                end
                
                ev_tab(j, nb_spk)   = t;
                last_ev(j)          = t;
                nb_spk(j)           = nb_spk(j) + 1;
            end
        case 1  % Detect sub-threshold crossing
            if V < threshold
                fsm_spk_ev(j) = 2;
            end
        case 2  % Apply 10 ms refractory time for detection
            if abs(last_ev(j) - t) > 10
                fsm_spk_ev(j) = 0;
            end
    end

    ev_tabnew = ev_tab;
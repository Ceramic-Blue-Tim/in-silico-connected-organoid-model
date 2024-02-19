% @title      Generate optogenetic stimulation pattern
% @file       gen_opto_stim.m
% @author     Romain Beaubois
% @date       14 Aug 2021
% @copyright
% SPDX-FileCopyrightText: © 2021 Romain Beaubois <refbeaubois@yahoo.com>
% SPDX-License-Identifier: GPL-3.0-or-later
% 
% @details
% > **06 Aug 2021** : file creation (RB)
% > **14 Aug 2021** : optionnal fixed time on and stimulation starts high state (RB)

function stim_pulse = gen_opto_stim(t, l_t, dt, pattern, t_on)
% | **Generate optogenetic stimulation pattern**
% |
% | **t** : Time vector (ms)
% | **l_t** : Number of time samples
% | **dt** : Time step (ms)
% | **pattern** : External simulation pattern [ms, Hz]
% | **t_on** : Specified time at high state (ms)
%
% | Generate external optogenetics stimulation pattern for whole simulation.
% | Pattern is a square signal with varying frequency

    % Initialize variables
    stim_pulse  = zeros(1,l_t);
    nb_state    = length(pattern(:,1));     % Number state for stimulation pattern
    Pstate      = 1;                        % Pattern state
    Sstate      = true;                     % Signal state
    max_count   = 1e3./(pattern(:,2)*dt);
    cnt         = 0;

    % If no imposed time on specified then set 50% duty cycle
    if ~exist('t_on', 'var') || t_on == -1
        Ton = 0.5e3./(pattern(:,2)*dt);
    else
        Ton = (t_on/dt)*ones(nb_state, 1);
    end
    
    % Check if required Ton can be met
    for i = 1 : length(pattern(:,2))
        if Ton(i) >= (1e3/(pattern(i,2)*dt)) && (pattern(i,2) ~= -1)
            Ton(i) = 0.5e3./(pattern(i,2)*dt);
            warning('Value of t_on too high for required frequency');
        end
    end

    for i = 1 : l_t
        % Update state along time
        if Pstate < nb_state
            if t(i) > pattern(Pstate+1,1)
                Pstate      = Pstate + 1;
                cnt         = 0;
                Sstate      = true;
            end
        end

        % Generate square signal at state requested frequency
        if max_count(Pstate) > 0
            if cnt <= Ton(Pstate)
                cnt  = cnt + 1;
                Sstate = true;
            elseif cnt < max_count(Pstate)
                cnt  = cnt + 1;
                Sstate = false;
            else
                cnt = 0;
            end
        else
            Sstate = false;
        end

        % Assign high and low level values
        if Sstate
            stim_pulse(i) = 1;
        else
            stim_pulse(i) = 0;
        end
    end

end
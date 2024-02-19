% @title      Generate synaptic connection for assembloid (prioritize connection to close by neurons)
% @file       syncon_assembloid.m
% @author     Romain Beaubois
% @date       06 Aug 2021
% @copyright
% SPDX-FileCopyrightText: © 2020 Romain Beaubois <refbeaubois@yahoo.com>
% SPDX-License-Identifier: GPL-3.0-or-later
% 
% @details
% > **20 Apr 2020** : file creation (RB)
% > **06 Aug 2021** : modify S_con handling (RB)

function [S_con] = syncon_assembloid(MAX_N, nt, x, y, pre_id, post_id, max_d, pcon, no_con, inh, exc)
% | **Generate synaptic connection for assembloid (prioritize connection to close by neurons)**
% |
% | **MAX_N** : Number of neurons
% | **nt** : Array of neuron types
% | **x** : Array of neuron coordinates x
% | **y** : Array of neuron coordinates y
% | **pre_id** : Index offset for pre-synaptic connection
% | **post_id** : Index offset for post-synaptic connection
% | **max_d** : Longest distance possible from x and y coordinates
% | **pcon** : Maximum probability of connection
% | **no_con** : Synapse coding : no connection
% | **inh** : Synapse coding : inhibitory
% | **exc** : Synapse coding : excitatory
%
% | Generate synaptic connection for assembloid based on the distance between neurons.
% | The higher the distance, the lower the connection probability
% | Here, ratio is proportional to relative distance of the neuron compared ot max_d

    S_con = zeros(MAX_N, MAX_N);
    for pre = pre_id(1):pre_id(2)
        for post = post_id(1):post_id(2)
            if pre ~= post
                d = (x(post)-x(pre))^2 + (y(post)-y(pre))^2;
                p = pcon - pcon*sqrt(d)/max_d;
                if (rand() < p) && strcmp(nt(pre),'FS')
                    S_con(post,pre) = inh;
                elseif (rand() < p) && strcmp(nt(pre),'RS')
                    S_con(post,pre) = exc;
                else
                    S_con(post,pre) = no_con;
                end
            else
                S_con(post,pre) = no_con;                
            end    
        end
    end  
end
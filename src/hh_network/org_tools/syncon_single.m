% @title      Generate synaptic connection inside organoid based on distance between neurons
% @file       syncon_single.m
% @author     Romain Beaubois
% @date       06 Aug 2021
% @copyright
% SPDX-FileCopyrightText: © 2020 Romain Beaubois <refbeaubois@yahoo.com>
% SPDX-License-Identifier: GPL-3.0-or-later
% 
% @details
% > **20 Apr 2020** : file creation (RB)
% > **06 Aug 2021** : modify S_con handling (RB)

function [S_con] = syncon_single(MAX_N, nt, x, y, pre_id, post_id, org_diam, pcon, no_con, inh, exc) 
    % | **Generate synaptic connection inside organoid based on distance between neurons**
    % |
    % | **MAX_N** : Number of neurons
    % | **nt** : Array of neuron types
    % | **x** : Array of neuron coordinates x
    % | **y** : Array of neuron coordinates y
    % | **pre_id** : Index offset for pre-synaptic connection
    % | **post_id** : Index offset for post-synaptic connection
    % | **org_diam** : Organoid diameter (µm)
    % | **pcon** : Maximum probability of connection
    % | **no_con** : Synapse coding : no connection
    % | **inh** : Synapse coding : inhibitory
    % | **exc** : Synapse coding : excitatory
    %
    % | Generate synaptic connection inside organoid based on distance between neurons.
    % | Neurons on the outside of the orgnaoid (higher relative distance to center) have higher connection probabilities
    % | Here, ratio is proportional to relative distance between neurons compared to the organoid diameter

    S_con = zeros(MAX_N, MAX_N);
    
    for pre = pre_id(1):pre_id(2)
        for post = post_id(1):post_id(2)
            if pre ~= post
                d = (x(post)-x(pre))^2 + (y(post)-y(pre))^2;
                p = pcon - pcon*sqrt(d)/org_diam;
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
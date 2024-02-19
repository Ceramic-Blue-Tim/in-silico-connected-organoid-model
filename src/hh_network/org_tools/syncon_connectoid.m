% @title      Generate synaptic connection for connectoid (prioritize connection for neuron on the outside of the organoid)      
% @file       syncon_connectoid.m
% @author     Romain Beaubois
% @date       06 Aug 2021
% @copyright
% SPDX-FileCopyrightText: © 2020 Romain Beaubois <refbeaubois@yahoo.com>
% SPDX-License-Identifier: GPL-3.0-or-later
% 
% @details
% > **20 Apr 2020** : file creation (RB)
% > **06 Aug 2021** : modify S_con handling (RB)

function [S_con] = syncon_connectoid(MAX_N, nt, dist2c, pre_id, post_id, pcon, no_con, inh, exc)
    % | **Generate synaptic connection for connectoid (prioritize connection for neuron on the outside of the organoid)**
    % |
    % | **MAX_N** : Number of neurons
    % | **nt** : Array of neuron types
    % | **dist2c** : Array of neuron's relative distances to center of the organoid
    % | **pre_id** : Index offset for pre-synaptic connection
    % | **post_id** : Index offset for post-synaptic connection
    % | **pcon** : Maximum probability of connection
    % | **no_con** : Synapse coding : no connection
    % | **inh** : Synapse coding : inhibitory
    % | **exc** : Synapse coding : excitatory
    %
    % | Generate synaptic connection for connectoid based on the position of the neuron in the organoid.
    % | The higher the distance, the lower the connection probability
    % | Here, ratio is proportional to relative distance of the neuron to the center of the organoid

    S_con = zeros(MAX_N,MAX_N);  

    for pre = pre_id(1):pre_id(2)
        for post = post_id(1):post_id(2)
            if pre ~= post
                p = pcon*(dist2c(pre)+dist2c(post));
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
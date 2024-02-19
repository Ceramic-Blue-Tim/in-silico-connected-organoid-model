% @title      Generate neuron type array
% @file       gen_ntype.m
% @author     Romain Beaubois
% @date       12 Aug 2021
% @copyright
% SPDX-FileCopyrightText: © 2021 Romain Beaubois <refbeaubois@yahoo.com>
% SPDX-License-Identifier: GPL-3.0-or-later
% 
% @details
% > **12 Aug 2021** : file creation (RB)

function nt = gen_ntype(n_inh, id_start, id_end)
% | **Generate neuron type array**
% |
% | **n_inh** : Max number of inhibitory neurons
% | **id_start** : Start index
% | **id_end** : End index
%
% | Generate neuron type array for an organoid while promoting
% | placement of inhibitory neurons on the outside


    nb_nrn  = id_end-id_start+1;
    nt      = string(zeros(1,nb_nrn));
    
    i = 1;
    while i<nb_nrn+1
        % Promoting placement of inhibitory neuron on the outside of the organoid
        if (rand() <= (0.01*nb_nrn/n_inh+0.002*nb_nrn/n_inh)) && (n_inh > 0)
            nt(i)   = 'FS';
            n_inh   = n_inh - 1;
        else
            nt(i)   = 'RS';
        end
        
        i = i + 1;
    end
end
% @title      Create synaptic connection matrix for a group
% @file       gen_syncon.m
% @author     Romain Beaubois
% @date       04 Aug 2021
% @copyright
% SPDX-FileCopyrightText: © 2021 Romain Beaubois <refbeaubois@yahoo.com>
% SPDX-License-Identifier: GPL-3.0-or-later
% 
% @details
% > **04 Aug 2021** : file creation (RB)

function SX_con = gen_syncon(z, con_type, syn_type, org_params, GX_id, MAX_N, nt, x, y, dist2c, pre_id, post_id, Sc_con, zc)
% | **Create synaptic connection matrix for a group**
% |
% | **z** : id of synaptic connection group
% | **con_type** : type of connection
% | **syn_type** : type of synapse
% | **org_params** : spatial parameters on organoid structure
% | **GX_id** : neuron index of synaptic connection groups
% | **MAX_N** : number of neurons for the whole structure
% | **nt** : array containing neurons' types
% | **x** : x spatial coordinates of neurons 
% | **y** : y spatial coordinates of neurons
% | **dist2c** : prec-computed array of distance to center of organoid for each neuron
% | **pre_id** : start and end index of pre synaptic group
% | **post_id** : start and end index of post synaptic group
% | **Sc_con** : synaptic connections to copy from
% | **zc** : synaptic connection group index to copy from
%
% | This function generates the synaptic connection matrix for a given group of neurons
% | according to different rules and using different synapse types

    %% Arguments handling
        if ~exist('Sc_con', 'var')
            Sc_con = zeros(MAX_N, MAX_N);
        elseif ~exist('zc', 'var')
            zc = 2;
        end

        SX_con      = zeros(MAX_N, MAX_N);

        org_diam    = org_params(1);
        dist_orgs   = org_params(2);
        pcon_in     = org_params(3);
        pcon_out    = org_params(4);

    %% Synapse codage
        NONE            = 000;  % No synapse
        AMPA            = 001;  % Fast Excitatoty synapse
        NDMA            = 010;  % Slow Excitatoty synapse
        GABAa           = 011;  % Fast Ihnibitory synapse
        GABAb           = 100;  % Slow Ihnibitory synapse
        exc_Hill        = 101;  % Short-term plasticity synapse
        inh_Hill        = 110;  % Short-term plasticity synapse

        no_syn      = NONE;
        if strcmp(syn_type, 'DestexheFast')
            exc_syn     = AMPA;
            inh_syn     = GABAa;
        elseif strcmp(syn_type, 'DestexheSlow')
            exc_syn     = NDMA;
            inh_syn     = GABAb;
        elseif strcmp(syn_type, 'Hill')
            exc_syn     = exc_Hill;
            inh_syn     = inh_Hill;
        end

    %% Generate structure from given connection type

        % [Connection inside organoid based on distance between neurons]
        if strcmp(con_type,'dist')
            SX_con = syncon_single(MAX_N, nt, x, y, pre_id{z}, post_id{z}, org_diam, pcon_in, no_syn, inh_syn, exc_syn);

        % [Loaded from .mat file]
        elseif strcmp(con_type, 'load')
            % syn_con_path = 'custom_fixed_path';
            % if isfile(syn_con_path)
            %     load(syn_con_path, 'S_con');
            % elseif( strcmp(org_struct.org1,'load') || strcmp(org_struct.org2,'load') || ...
            %         strcmp(org_struct.org1_to_org2,'load') || strcmp(org_struct.org2_to_org1,'load'))
            %     error('Trying to load synaptic connection from file but file not found');
            % end
            uimsg = sprintf('Specify synaptic connection matrix to use for G%d',z);
            tmp = load(uigetfile('*.mat',uimsg), 'S_con'); % ask path to user
            SX_con(GX_id{z}.post, GX_id{z}.pre) = tmp.S_con(GX_id{z}.post, GX_id{z}.pre); clear tmp;

        % [Connection identical to group zc]   
        elseif strcmp(con_type, 'id')
            SX_con(GX_id{z}.post, GX_id{z}.pre) = Sc_con(GX_id{zc}.post, GX_id{zc}.pre);
        
        % [Connectoid type connection : position of neuron in organoid surface/inside]
        elseif strcmp(con_type, 'connectoid')
            SX_con      = syncon_connectoid(MAX_N, nt, dist2c, pre_id{z}, post_id{z}, pcon_out, no_syn, inh_syn, exc_syn);
        
        % [Assembloid type connection : distance between neurons]
        elseif strcmp(con_type, 'assembloid')
            max_d       = dist_orgs + org_diam;
            SX_con      = syncon_assembloid(MAX_N, nt, x, y, pre_id{z}, post_id{z}, max_d, pcon_out, no_syn, inh_syn, exc_syn);
        end
    
end
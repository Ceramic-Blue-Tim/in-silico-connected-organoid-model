% @title      Main script for parameters sweep
% @file       sweep_sim_organoid.m
% @author     Romain Beaubois
% @date       04 Oct 2022
% @copyright
% SPDX-FileCopyrightText: © 2022 Romain Beaubois <refbeaubois@yahoo.com>
% SPDX-License-Identifier: GPL-3.0-or-later
%
% @brief Main script for in silico organoid sweep parameters
% 
% @details
% > **04 Oct 2022** : file creation (RB)

function [] = sweep_sim_organoid(params)
%% Fetch params

sw_type             = params.sw_type;
dist_orgs_factor    = params.dist_orgs_factor;
sw_pcon_in          = params.sw_pcon_in;
sw_pcon_out         = params.sw_pcon_out;
sw_wsyn_exc_in      = params.sw_wsyn_exc_in;
sw_wsyn_inh_in      = params.sw_wsyn_inh_in;
sw_wsyn_exc_out     = params.sw_wsyn_exc_out;
sw_wsyn_inh_out     = params.sw_wsyn_inh_out;

%% Remove data?
    tic;

%% Add required folders and subfolders to path
    addpath(genpath('~/Documents/Organoid-Modeling/matlab/Network_V2'));

%% Parameters ####################################################################################
    % Data saving folder
    dirpath_data    = "~/Documents/Organoid-Modeling/matlab/data";
    mkdir(dirpath_data);
    dirpath_save    = dirpath_data + filesep + "sim";
    mkdir(dirpath_save);
    fname_save      = sprintf("%s_pi=%.2f_po=%.2f_wei=%.2f_wii=%2.f_weo=%.2f_wio=%.2f" , sw_type, sw_pcon_in, sw_pcon_out, sw_wsyn_exc_in, sw_wsyn_inh_in, sw_wsyn_exc_out, sw_wsyn_inh_out);
    fpath_save      = dirpath_save + filesep + fname_save + ".mat" ;

    % Time
        dt              = 2^-5;                 % ms - Time step
        sim_time        = 5*60*1e3;             % ms - Simulation time

    % Geometry
        org_diam        = 138.25;               % um | 100 neurons->138.25 | 10 neurons->35.25
        neur_diam       = 15;                   % um - Average diameter of a neuron
        dist_orgs       = dist_orgs_factor*org_diam; % um - Distance between centers of organoids
        ccx             = [0 dist_orgs];        % x cood of organoid center [org1 org2]
        ccy             = [0 0];                % y cood of organoid center [org1 org2]
        n_inh           = [10 10];              % number of ihnibitory neurons [org1 org2]
    
    % Synaptic connection parameters
        pcon_in         = sw_pcon_in;    % connection probability inside org
        pcon_out        = sw_pcon_out;                 % connection probability outside org
        wsyn_gexc       = [sw_wsyn_exc_in sw_wsyn_exc_in sw_wsyn_exc_out sw_wsyn_exc_out];    % synaptic current weight for exc synapses in groups[G1 G2 G1->G2 G2->G1]
        wsyn_ginh       = [sw_wsyn_inh_in sw_wsyn_inh_in sw_wsyn_inh_out sw_wsyn_inh_out];    % synaptic current weight for inh synapses in groups[G1 G2 G1->G2 G2->G1]
        wstim           = [0.63e-6  0.3e-6];    % stim current weight  [FS RS]
        offset          = [0.22e-6  0.60e-6];   % stim current offset  [FS RS]
        org_stim_indep  = true;                 % independant stimulation current for organoids otherwise identical

    % Cut synaptic connections
        cut_con_en      = false;                 % Disable connections of given groups for a given time
        cut_con_gx      = [3 4];                % Group of synaptic connections to cut [nb_grp_to_cut nb_grp_to_cut nb_grp_to_cut nb_grp_to_cut]
        cut_con_ratio   = 0.3;                  % Ratio of synaptic connections to cut ratio_all or [ratio_exc ratio_inh]
        cut_con_start   = 30;                   % s - Start time to remove synaptic connection
        cut_con_dur     = 30;                   % s - Duration of synaptic connection removal

    % Plot layout
        article_rp      = false;                 % Article layout for raster plot else real neuron index layout

    % FPGA files
        gen_fpga_conf   = false;                % Generate configuration files for fpga

    % Noise generator
        Theta   = 1;        % Amplitude : higher : 1 
        Mu      = 0.1;      % Mean : higher : 0.1
        Sigma   = 1.05;     % Standard deviation : higher : 2.2 lower : 1.05

    % Optogenetic external stimulation
        opto_stim = struct(...
            'en'        , false, ...            % Enable optogenetic stimulation
            'ratio'     , 0.3, ...              % Ratio of neurons in bundle affected
            'Pmax'      , 0.0651, ...           % Max light dependant excitation rate (1/ms)
            'Gd'        , 0.1923, ...           % Decrease transition rate (1/ms)
            'Gr'        , 1e-3, ...             % Rise transition rate (1/ms)
            'GChRh2'    , 0.07e-5, ...          % Max conductance Channel Rhodospin 2 (?)
            'pattern'   , [ [0,     -1]; ...    % [ms, Hz] - Associate time to stimulation frequency
                            [5e3,   1.5]; ...   % [ms, Hz] - Associate time to stimulation frequency     
                            [40e3,   1]; ...    % [ms, Hz] - Associate time to stimulation frequency     
                            [50e3,  -1]],...    % [ms, Hz] - Associate time to stimulation frequency
            't_on'      , -1 ...                % Fixed time on (ms), (set to -1 for 50% duty cycle)
        );

    % Organoids structure
        % Synaptic connection
            % dist : synaptic connection probability based on distance between 2 neurons
            % id : synaptic connection identical to org 1
            % assembloid : synaptic connection probability on distance between 2 neurons (non linear)
            % connectoid : synaptic connection probability on position of neurons in organoid
            % load : synaptic connection from .mat file
            % none : no synaptic connection
        % Synapses type
            % DestexheFast : simple model of synapse ( exc : AMPA | inh : GABAa )
            % DestexheSlow : (WIP) simple model of synapse ( exc : NDMA | inh : GABAb )
            % Hill : complex model of synapse with short term plasticity
        org_struct = struct(...
            'org1',             'dist',         ...
            'org2',             'dist',           ...
            'org1_to_org2',     sw_type,        ...
            'org2_to_org1',     sw_type,        ...
            'in_org_syntype',   'DestexheFast',     ...
            'out_org_syntype',  'DestexheFast',     ...
            'load_wsyn',        false,          ...
            'save',             false           ...
        );
        f_header = sprintf("G1=%s | G2=%s | G1 to G2=%s | G2 to G1=%s", ...
            org_struct.org1, org_struct.org2, org_struct.org1_to_org2, org_struct.org2_to_org1);
        synconmatrix_fname  = 'Syncon_matrix';
        ntypematrix_fname   = 'Ntype_matrix';

    % Parameters structure
    param_struct = struct(...
        'dt',               dt,                 ...
        'sim_time',         sim_time,           ...
        'org_diam',         org_diam,           ...
        'neur_diam',        neur_diam,          ...
        'dist_orgs',        dist_orgs,          ...
        'ccx',              ccx,                ...
        'ccy',              ccy,                ...
        'n_inh',            n_inh,              ...
        'pcon_in',          pcon_in,            ...
        'pcon_out',         pcon_out,           ...
        'wsyn_gexc',        wsyn_gexc,          ...
        'wsyn_ginh',        wsyn_ginh,          ...
        'wstim',            wstim,              ...
        'offset',           offset,             ...
        'org_stim_indep',   org_stim_indep,     ...
        'cut_con_en',       cut_con_en,         ...
        'cut_con_gx',       cut_con_gx,         ...
        'cut_con_ratio',    cut_con_ratio,      ...
        'cut_con_start',    cut_con_start,      ...
        'cut_con_dur',      cut_con_dur,        ...
        'Theta',            Theta,              ...
        'Mu',               Mu,                 ...
        'Sigma',            Sigma,              ...
        'opto_stim',        opto_stim,          ...
        'org_struct',       org_struct          ...
    );
    
% ##########################################################################################################

%% Generate time variables
    t                   = 0:dt:sim_time;
    l_t                 = length(t);

%% Generate XY position of neurons
    [MAX_N_tmp(1), x_tmp(1,:) , y_tmp(1,:), dist2c_tmp(1,:)] = XY_placement(ccx(1), ccy(1), org_diam, neur_diam);
    [MAX_N_tmp(2), x_tmp(2,:) , y_tmp(2,:), dist2c_tmp(2,:)] = XY_placement(ccx(2), ccy(2), org_diam, neur_diam);
    fprintf("Number of neurons of organoid 1 : %d\n", MAX_N_tmp(1));
    fprintf("Number of neurons of organoid 2 : %d\n", MAX_N_tmp(2));
    
    MAX_N       = MAX_N_tmp(1) + MAX_N_tmp(2);
    ORG1_START  = 1;
    ORG1_END    = MAX_N_tmp(1);
    ORG2_START  = MAX_N_tmp(1)+1;
    ORG2_END    = MAX_N;
   
    x(1,ORG1_START:ORG1_END)        = x_tmp(1,1:MAX_N_tmp(1));   
    x(1,ORG2_START:ORG2_END)        = x_tmp(2,1:MAX_N_tmp(2));
    y(1,ORG1_START:ORG1_END)        = y_tmp(1,1:MAX_N_tmp(1));   
    y(1,ORG2_START:ORG2_END)        = y_tmp(2,1:MAX_N_tmp(2));
    dist2c(1,ORG2_START:ORG2_END)   = dist2c_tmp(1,1:MAX_N_tmp(1));
    dist2c(1,ORG2_START:ORG2_END)   = dist2c_tmp(2,1:MAX_N_tmp(2));
    
    clear x_tmp y_tmp dist2c_tmp MAX_N_tmp

%% Initialize type of neuron
    nt  = string(zeros(1,MAX_N));
    nt(ORG1_START:ORG1_END) = gen_ntype(n_inh(1), ORG1_START, ORG1_END);
    nt(ORG2_START:ORG2_END) = gen_ntype(n_inh(2), ORG2_START, ORG2_END);

%% Load synaptic weight matrix
    if org_struct.load_wsyn
        wsyn_path = 'syn_weight_saved.mat'; % fixed path
        % wsyn_path = uigetfile('*.mat','Synaptic weight matrix'); % ask path to user
        if isfile(wsyn_path)
            load(wsyn_path); 
        else
            error('Trying to load synaptic weight from file but file not found');
        end
    end

%% Groups handling tables and variables
    %                       G1                     G2                 G1 to G2              G2 to G1
    pre_id      = {[ORG1_START ORG1_END] [ORG2_START ORG2_END] [ORG1_START ORG1_END] [ORG2_START ORG2_END]};
    post_id     = {[ORG1_START ORG1_END] [ORG2_START ORG2_END] [ORG2_START ORG2_END] [ORG1_START ORG1_END]};
    for i = 1:4
        GX_id{i}    = struct('post', post_id{i}(1):post_id{i}(2), 'pre', pre_id{i}(1):pre_id{i}(2));
        SX_con{i}   = zeros(MAX_N, MAX_N);
        wsynX{i}    = zeros(MAX_N, MAX_N, 2);
    end

%% Synaptic weight
    if ~org_struct.load_wsyn
        wsyn = zeros(MAX_N, MAX_N, 2);
        for i = 1:4
            wsynX{i}(GX_id{i}.post, GX_id{i}.pre, 1) = wsyn_gexc(i);
            wsynX{i}(GX_id{i}.post, GX_id{i}.pre, 2) = wsyn_ginh(i);
            wsyn = wsyn + wsynX{i};
        end
    end

%% Generate synaptic connection matrix
    org_params = [org_diam, dist_orgs, pcon_in, pcon_out];
    SX_con{1} = gen_syncon(1, org_struct.org1,          org_struct.in_org_syntype,  org_params, GX_id, MAX_N, nt, x, y, dist2c, pre_id, post_id);
    SX_con{2} = gen_syncon(2, org_struct.org2,          org_struct.in_org_syntype,  org_params, GX_id, MAX_N, nt, x, y, dist2c, pre_id, post_id, SX_con{1}, 1);
    SX_con{3} = gen_syncon(3, org_struct.org1_to_org2,  org_struct.out_org_syntype, org_params, GX_id, MAX_N, nt, x, y, dist2c, pre_id, post_id);
    SX_con{4} = gen_syncon(4, org_struct.org2_to_org1,  org_struct.out_org_syntype, org_params, GX_id, MAX_N, nt, x, y, dist2c, pre_id, post_id);

    S_con   = zeros(MAX_N,MAX_N);
    for i = 1:4
        S_con   = S_con + SX_con{i};
    end

%% Generate optogenetic stimulation
    opto_stim_pulse = gen_opto_stim(t, l_t, dt, opto_stim.pattern, opto_stim.t_on);

%% Get neurons having axon in bundle
    if opto_stim.en
        A_con = (SX_con{3} > 0) | (SX_con{4} > 0);
    else
        A_con = zeros(MAX_N, MAX_N);
    end

%% Save matrix
    if org_struct.save
        save('syn_con_saved.mat', 'S_con');
        save('syn_weight_saved.mat', 'wsyn');
    end

%% Generate topology txt files for hdl
    % Synapses
    Gexcitatory = 88.0e-9;
    Ginhibitory = 80.0e-9;

    if gen_fpga_conf
        mat_to_synmatrixf(synconmatrix_fname, S_con);
        mat_to_ntypematrixf(ntypematrix_fname, synconmatrix_fname, f_header, nt, Gexcitatory, Ginhibitory, Theta, Mu, Sigma);
    end

%% Hill spike mediated synapse
    max_spk         = 2;
    tau1            = 11;  % ms
    tau2            = 2;   % ms
    Hillsyn_param   = [max_spk, tau1, tau2];
    Hillsyn_th      = -0.1;  % mV
    
    fsm_spk_ev      = zeros(MAX_N, 1);
    ev_tab          = -100*ones(MAX_N, max_spk);
    ev_tabnew       = -100*ones(MAX_N, max_spk);
    nb_spk          = ones(MAX_N, 1);
    last_ev         = zeros(MAX_N, 1);

%% Initialize network

    % Initialize parameters
    Vprev       = zeros(MAX_N, 1);
    Vnew        = zeros(MAX_N, 1);
    Inew        = zeros(MAX_N, 5);
    offset_t    = zeros(MAX_N, 1);
    wstim_t     = zeros(MAX_N, 1);
    Istim_pre   = zeros(MAX_N, 1);
    m = 0;  h = 1;  n = 0;
    p = 0;  q = 0;  r = 0;
    s = 0;  u = 0;
    A = 0;  P = 0;  M = 0;
    IonChanInit = [m,h,n,p,q,r,s,u,A,M,P];
    once1   = true;
    once2   = true;

    kFS_simpl_lin03 = @(x) (-77.02*x^3 + 152.4*x^2 - 91.42*x + 17.66)*10^-6;     
        
    for i = 1:MAX_N
        [Cmem,Imax,Vinit,GVal,EVal,TauMax,Sm, Vtraub]= NeuronType(nt(i));
        N(i) = PospischilNeuralNetworkV2( nt(i), dt, GVal, EVal, IonChanInit, Hillsyn_param, opto_stim, Cmem, TauMax, Sm, Vtraub, MAX_N);

        if strcmp(nt(i), 'FS')
            Istimprev(i) = kFS_simpl_lin03(Imax);
            offset_t(i) = offset(1);
            wstim_t(i)  = wstim(1);
        elseif strcmp(nt(i), 'RS')
            Istimprev(i) = 0.3*Imax;
            offset_t(i) = offset(2);
            wstim_t(i)  = wstim(2);            
        end

        Vprev(i) = Vinit;
    end
    
    % Plot stim current generated
%     j =1;
%     IstimN2 = zeros(1,l_t);
%     for i = 1:l_t-1
%         IstimN2(i)          = OUproc(Istim_pre(j), Theta, Mu, Sigma, dt);
%         Istim_pre(j)       = IstimN2(i);            
%         IstimN2(i)          = offset_t(1) + IstimN2(i)*wstim_t(1);
%     end
%     figure
%     plot(t,IstimN2)

%% Raster plot detection
    event       = single(zeros(MAX_N, l_t));
    detect      = zeros(MAX_N, 1);
    ev_count    = zeros(MAX_N, 1);
    threshold   = 0; % mV

%% Simulation
    for i = 1:l_t-1
        % For each neuron
        for j = 1:MAX_N

            % Spike detection
            [ev_tabnew, fsm_spk_ev, nb_spk, last_ev] = spk_dtc_Hillsyn(j, Vprev(j), i*dt, ev_tabnew, fsm_spk_ev, nb_spk, last_ev, max_spk, Hillsyn_th);

            % Noisy stimulation current
            if j < ORG2_START
                IstimN          = OUproc(Istim_pre(j), Theta, Mu, Sigma, dt);
                Istim_pre(j)    = IstimN;            
                IstimN          = offset_t(j) + IstimN*wstim_t(j);
            else
                if org_stim_indep
                    IstimN          = OUproc(Istim_pre(j), Theta, Mu, Sigma, dt);
                    Istim_pre(j)    = IstimN;
                    IstimN          = offset_t(j) + IstimN*wstim_t(j);
                else
                    IstimN          = offset_t(j-ORG1_END) + Istim_pre(j-ORG1_END)*wstim_t(j-ORG1_END);
                end
            end
        
            % Remove synaptic connection for given time
            if cut_con_en
                if t(i) >= (cut_con_start*1000) && once1
                    for h = 1:length(cut_con_gx)
                        gx = cut_con_gx(h); % Group id number to cut

                        % Connected synapses
                        smat = S_con(GX_id{gx}.post, GX_id{gx}.pre) ~= 0; % Logical array of connection

                        if length(cut_con_ratio) == 1
                            % Same ratio for exc and inh
                            wsyn(GX_id{gx}.post, GX_id{gx}.pre, :) = wsyn(GX_id{gx}.post, GX_id{gx}.pre, :) .* (rand(MAX_N/2, MAX_N/2, 2) > (cut_con_ratio*smat));
                        else 
                            % Different ratio for exc and inh
                            wsyn(GX_id{gx}.post, GX_id{gx}.pre, 1) = wsyn(GX_id{gx}.post, GX_id{gx}.pre, 1) .* (rand(MAX_N/2) > (cut_con_ratio(h)*smat));
                            wsyn(GX_id{gx}.post, GX_id{gx}.pre, 2) = wsyn(GX_id{gx}.post, GX_id{gx}.pre, 2) .* (rand(MAX_N/2) > (cut_con_ratio(h)*smat));
                        end
                    end
                    once1 = false;
                elseif t(i) >= ((cut_con_start+cut_con_dur)*1000) && once2
                    for h = 1:length(cut_con_gx)
                        gx = cut_con_gx(h); % Group id number to cut
                        wsyn(GX_id{gx}.post, GX_id{gx}.pre, :) = wsynX{gx}(GX_id{gx}.post, GX_id{gx}.pre, :);
                    end
                    once2 = false;
                end
            end

            % Calculation
            [N(j), Vnew(j), Inew(j, :)] = N(j).PospischilCalc(Vprev, IstimN, S_con, opto_stim, opto_stim_pulse(i), A_con, j, wsyn, i*dt, ev_tab);
            
            % Detection for raster plot
            if (Vnew(j) > threshold) && (detect(j)==0)
                ev_count(j)             = ev_count(j) + 1;
                event(j, ev_count(j))   = i+1;
                detect(j)               = 1;
            elseif (Vnew(j) < threshold) && (detect(j)==1)
                detect(j) = 0;
            end  
        end
        Vprev = Vnew;
        ev_tab = ev_tabnew;
        LoadSim(i, l_t);     
    end

%% Save data
save(fpath_save, 'S_con', 'wsyn', 'nt', 'x', 'y', 'param_struct', 'ev_count', 'event')

toc;
end
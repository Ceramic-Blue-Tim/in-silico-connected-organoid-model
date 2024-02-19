% @title      Pospischil Neuron optimized for network simulations
% @file       PospischilNeuralNetworkV2.m
% @author     Farad Khoyratee, Romain Beaubois
% @date       10 Aug 2021
% @copyright
% SPDX-FileCopyrightText: © 2018 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-FileCopyrightText: © 2021 Romain Beaubois <refbeaubois@yahoo.com>
% SPDX-License-Identifier: GPL-3.0-or-later
% 
% @details
% > **22 Feb 2018** : file creation (FK)
% > **05 Aug 2021** : Add optogenetic stimulation + clean script (RB)
% > **10 Aug 2021** : Add Hill synapse (RB)

classdef PospischilNeuralNetworkV2
    
    properties
        %% Time
            t;          % ms - Time
            dt;         % ms - Time step
            dtsyn;      % ms - Time step synapses
        
        %% Network
            nb_nrn;      % Number of neurons

        %% Neuron Parameters
            % Type
            TypeOfNeuron;   % Type of neuron
            IM_Enable;      % Ionic current M enable
            ICa_State;      % Ionic current Ca enable

            % Geometry
            Sm;             % ? - Membrane surface
        
            % Conductances (mS/cm²)
            GK;         GNa;        Gleak;
            GM;        
            GCa;
            GCaF = 5e-9;       GCaS = 3.2e-9;        
            GSynG;      GSynS;
        
            % Reversal Potential (mV)
            EK;
            ENa;
            Eleak;
            Esyn;
            ECa = 135;
        
            % Membrane Capacitance (µF/cm²)
            Cmem;

            % Constants
            Tcelsius= 36;           % Temperature in °C
            cao     = 2;
            FARADAY = 96485;
            R       = 8.3144621; 	% Gas constant
            carev   = 120.24;
            Kcarev;
            TauMax;
            VTraub;
    
        %% Optogenetic Channel Rhodospin 2
            GChRh2; % Max conductance for ChRh2 (?)
            Pmax;   % Max light dependant excitation rate (1/ms)
            Gr;     % Rise transition rate (1/ms)
            Gd;     % Decrease transition rate (1/ms)
            opre;   % Previous state values for Euler
            dpre;   % Previous state values for Euler
            
        %% Ionic channels
            % Previous values for Euler method
            m;           h;
            n;
            p;
            q;           r;
            u;           s;
            cai;
            I_Ca = 0;
        
        %% Synapses
            % Previous values for Euler method
            rspre;      sspre;
            Mpre;
            ISynT;

            % Hill synapses
            max_spk;
            tau1;
            tau2;
    end
    
    methods
        %% Constructor
        function obj=PospischilNeuralNetworkV2(TypeOfNeuron, dt, GVal, EVal, IonChanInit, Hillsyn_param, opto_stim, Cmem, TauMax, Sm, VTraub, nb_nrn)
            %% Time
                obj.t       = 0;
                obj.dt      = dt;
                obj.dtsyn   = dt;
            
            %% Network
                obj.nb_nrn  = nb_nrn;

            %% Neuron parameters
                % Type of neuron
                obj.TypeOfNeuron    = TypeOfNeuron;
                
                % Geometry
                obj.Sm      = Sm;

                % Membrane capacitance
                obj.Cmem    = Cmem;

                % Constants
                obj.TauMax  = TauMax;
                obj.Kcarev  = 1e3 * (obj.R*(obj.Tcelsius+273.15)) / (2*obj.FARADAY);
                obj.VTraub  = VTraub;

                % Conductances
                obj.GK      = GVal(1);
                obj.GNa     = GVal(2);
                obj.GM      = GVal(3);
                obj.GCa     = GVal(4);
                obj.Gleak   = GVal(5);
                obj.GSynG   = GVal(6);
                obj.GSynS   = GVal(7);

                % Reversal Potential
                obj.EK      = EVal(2);
                obj.ENa     = EVal(1);
                obj.Eleak   = EVal(3);
                obj.Esyn    = EVal(4);
            
            %% Ionic channels
                % Previous Values for Euler Method
                obj.m       = IonChanInit(1);
                obj.h       = IonChanInit(2);
                obj.n       = IonChanInit(3);
                obj.p       = IonChanInit(4);
                obj.q       = IonChanInit(5);
                obj.r       = IonChanInit(6);
                obj.s       = IonChanInit(7);
                obj.u       = IonChanInit(8);
                obj.opre    = 0;
                obj.dpre    = 0;
                obj.cai     = 2.4e-4;

                % Used ionic currents according to neuron type
                if strcmp(TypeOfNeuron,'RS')
                    obj.IM_Enable = 1;
                    obj.ICa_State = 0;
                elseif strcmp(TypeOfNeuron,'IB')
                    obj.IM_Enable = 1;
                    obj.ICa_State = 1;
                elseif strcmp(TypeOfNeuron,'LTS')
                    obj.IM_Enable = 1;
                    obj.ICa_State = 2;
                else
                    obj.IM_Enable = 0;
                    obj.ICa_State = 0;
                end

            %% Optogenetic Channel Rhodospin 2
                obj.GChRh2  = opto_stim.GChRh2;
                obj.Pmax    = opto_stim.Pmax;
                obj.Gr      = opto_stim.Gr;
                obj.Gd      = opto_stim.Gd;
            
            %% Synapses
                % Previous synaptic current
                obj.ISynT   = 0;
            
                % Destexhe synapses
                obj.rspre   = zeros(obj.nb_nrn, 1);
                obj.sspre   = zeros(obj.nb_nrn, 1);
            
                % Hill synapses
                obj.Mpre    = zeros(obj.nb_nrn, 1);
                obj.max_spk = Hillsyn_param(1);
                obj.tau1    = Hillsyn_param(2);
                obj.tau2    = Hillsyn_param(3);
        end
        
        %% Computation
        function [obj, Vmem, IVal] = PospischilCalc(obj, V, Iexc, ConnM, opto_stim, opto_stim_pulse, A_con, INeur, wsyn, t, ev_tab)
               
            %% Ionic channels
                % Ionic channels states
                mNa     = mchan(V(INeur), obj.m, obj.dt, obj.VTraub);
                hNa     = hchan(V(INeur), obj.h, obj.dt, obj.VTraub);
                nK      = nchan(V(INeur), obj.n, obj.dt, obj.VTraub);
            
                % Ionic Current computation
                INa     = obj.GNa       * (obj.m^3)     * obj.h         * (V(INeur) - obj.ENa);
                IK      = obj.GK        * (obj.n^4)                     * (V(INeur) - obj.EK);
                ILeak   = obj.Gleak                                     * (V(INeur) - obj.Eleak);
            
                if obj.IM_Enable == 1
                    pIon    = pchan(V(INeur), obj.p, obj.dt, obj.TauMax);
                    
                    IM      = obj.GM    * obj.p                         * (V(INeur) - obj.EK);
                else
                    pIon    = 0;
                    IM      = 0;
                end
                
                if      obj.ICa_State == 1      % IB Calcium current
                    qIon    = qchan(Vprev, obj.q, obj.dt);
                    rIon    = rchan(Vprev, obj.r, obj.dt);
                    sIon    = 0;
                    uIon    = 0;
                    
                    caiVal  = caiFunc(obj.I_Ca, obj.cai, obj.dt, obj.Sm);
                    carevVal= obj.Kcarev * log(obj.cao/caiVal);
                    
                    ICa     = obj.GCa   * (obj.q^2)  * obj.r            * (Vprev - 120.24); 
                elseif  obj.ICa_State == 2      % LTS Calcium current
                    qIon    = 0;
                    rIon    = 0;
                    sIon    = s_inf(Vprev);
                    uIon    = uchan(Vprev, obj.u, obj.dt);
                    
                    caiVal  = caiFunc(obj.I_Ca, obj.cai, obj.dt, obj.Sm);
                    carevVal= obj.Kcarev * log(obj.cao/caiVal);
                    
                    ICa     = obj.GCa   * (obj.s^2) * obj.u             * (Vprev - carevVal);
                else
                    qIon    = 0;
                    rIon    = 0;
                    sIon    = 0;
                    uIon    = 0;
                    
                    caiVal  = 0;
                    carevVal= 0;
                    
                    ICa     = 0;
                end

            %% Synapses
                % New values for synapses from Euler method
                Mnew        = zeros(obj.nb_nrn, 1);
                rsnew       = zeros(obj.nb_nrn, 1);
                ssnew       = zeros(obj.nb_nrn, 1);

                % Temporary variables
                ISynTtmp    = 0;
                ISyn        = 0;
                
                % Table index
                exc         = 1;
                inh         = 2;

                % Optogen connection check
                opto_con    = 0;

                % Compute synaptic current
                for Npre = 1:obj.nb_nrn % Npre = neuron pre | INeur = neuron post
                    switch ConnM(INeur,Npre) 
                        case 000    % No connection 
                            syn_type                = exc;
                            ISyn                    = 0;
                        case 001    % AMPA
                            syn_type                = exc;
                            [ISyn, rsnew(Npre)]     = IsynAMPAV5(obj.dtsyn, V(Npre), V(INeur), obj.rspre(Npre));
                        case 010    % NDMA
                            syn_type                = exc;
                            [ISyn, rsnew(Npre)]     = IsynNMDA(obj.dtsyn, V(Npre), V(INeur), obj.rspre(Npre));
                        case 011    % GABAa
                            syn_type                = inh;
                            [ISyn, rsnew(Npre)]     = IsynGABAa2(obj.dtsyn, V(Npre), V(INeur), obj.rspre(Npre));
                        case 100    % GABAb
                            syn_type                = inh;
                            [ISyn, rsnew(Npre), ssnew(Npre)] = IsynGABAb(obj.dtsyn, V(Npre), V(INeur), obj.rspre(Npre), obj.sspre(Npre));
                        case 101    % Hill exc
                            syn_type                = exc;
                            syn_param               = [obj.Esyn, obj.GSynS, obj.tau1, obj.tau2, obj.max_spk];
                            [ISyn, Mnew(Npre)]      = IsynS(obj.dtsyn, V(Npre), V(INeur), syn_param, obj.Mpre(Npre), t, ev_tab(Npre,:));
                            ISyn = -ISyn;
                        case 110    % Hill inh
                            syn_type                = inh;
                            syn_param               = [obj.Esyn, obj.GSynS, obj.tau1, obj.tau2, obj.max_spk];
                            [ISyn, Mnew(Npre)]      = IsynS(obj.dtsyn, V(Npre), V(INeur), syn_param, obj.Mpre(Npre), t, ev_tab(Npre,:));
                        otherwise
                            warning('%d does not correpond to a synapse type in synpatic matrix',ConnM(INeur,Npre));
                    end
                    
                    % Sum current participation to total synaptic current
                    ISynTtmp    = ISynTtmp + wsyn(INeur, Npre, syn_type)*ISyn;

                    % Check connection to opposide organoid
                    if A_con(Npre, INeur)
                        opto_con = 1;
                    end
                end

            %% Optogenetic Channel Rhodospin 2
                % Detect light pulse
                if opto_stim_pulse == 1
                    P = obj.Pmax;
                else
                    P = 0;
                end

                % Channels state
                onew        = o_RhCh2_3states(obj.opre, obj.dpre, P, obj.Gd, obj.dt);
                dnew        = d_RhCh2_3states(obj.opre, obj.dpre, obj.Gr, obj.Gd, obj.dt);

                % Photogenetic current
                IChRh2      = (rand() < opto_stim.ratio) * opto_con * obj.GChRh2 * obj.opre * V(INeur);

            %% Compute membrane voltage
                I       = - INa - IK - ILeak - IM - ICa - obj.ISynT - IChRh2 + Iexc;
                dV      = I/obj.Cmem;
                Vmem    = Euler(dV, V(INeur), obj.dt);
            
            %% Save Data
                % Ionic channels states
                obj.m       = mNa;
                obj.h       = hNa;
                obj.n       = nK;
                obj.p       = pIon;
                obj.q       = qIon;
                obj.r       = rIon;
                obj.u       = uIon;
                obj.s       = sIon;
                
                % Ionic currents
                obj.ISynT   = ISynTtmp;
                IVal(1)     = INa;
                IVal(2)     = IK;
                IVal(3)     = ILeak;
                IVal(4)     = onew;
                IVal(5)     = IChRh2;
                obj.I_Ca    = ICa;

                % Optogenetic channel
                obj.opre    = onew;
                obj.dpre    = dnew;

                % Synapses
                obj.rspre   = rsnew;
                obj.sspre   = ssnew;
                obj.Mpre    = Mnew;
                
                % Calcium current
                obj.cai     = caiVal;
                obj.carev   = carevVal;
        end
    end 
end
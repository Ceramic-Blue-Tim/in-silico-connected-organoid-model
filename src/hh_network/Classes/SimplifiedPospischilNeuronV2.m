%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%   Optimized vs Original Pospischil equations
%
%   Authors     : KHOYRATEE Farad
%   Date        : 25/01/2017
%   Update by   : KHOYRATEE Farad
%   Update      : 16/04/2019
%
%   Version     : V1.0
%   
%   Descritption: Optimized Hodgkin-Huxley from Pospischil
%                 parameters
%
%   log         :
%       --
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef SimplifiedPospischilNeuronV2
    
    properties
        %% Time
        t;          % Time
        dt;         % Delta T
        
        %% Neuron Parameters
        % Neuron Type
        TypeOfNeuron;
        Sm;
        
        IM_Enable;
        ICa_State;
        
        % Conductances
        GK;         GNa;        Gleak;
        GM;        
        GCa;
        GCaF = 5*(10^-9);       GCaS = 3.2*(10^-9);        
        GSynG;      GSynS;  
        
        % Reversal Potential
        EK;
        ENa;
        Eleak;
        Esyn;
        ECa = 135;
        Cmem;       % Membrane Capacitance
        
    % Previous Values for Euler Method
        m;           h;
        n;
        p;
        q;           r;
        u;           s;
        
        cai;
        I_Ca = 0;
        
    % Constant
        Tcelsius= 36;           % Temp�rature en Celsius
        cao     = 2;
        FARADAY = 96485;
        R       = 8.3144621; 	% Constante des gazs parfaites
        carev   = 120.24;
        Kcarev;
        
        TauMax;
        VTraub;
        
    % Noise
        Theta   = 0.5;
        Mu      = 0;
        Sigma   = 0.05;
        Inoise;

    end
    
    methods
        %% Constructor
        function obj=SimplifiedPospischilNeuronV2(TypeOfNeuron, dt, GVal, EVal, IonChanInit, Cmem, TauMax, Sm, VTraub)
            
            obj.TypeOfNeuron = TypeOfNeuron;
            obj.Sm      = Sm;
            
            obj.TauMax  = TauMax;
            
            obj.t       = 0;
            obj.dt      = dt;
            
            obj.Cmem    = Cmem;

            % Conductances
            obj.GK      = GVal(1);
            obj.GNa     = GVal(2);
            obj.GM      = GVal(3);
            obj.GCa     = GVal(4);
%             obj.GCa     = 1.43*(10^-4)*Sm*(10^9); % IB
            obj.Gleak   = GVal(5);
            obj.GSynG   = GVal(6);
            obj.GSynS   = GVal(7);
            
            % Reversal Potential
            obj.EK      = EVal(2);
            obj.ENa     = EVal(1);
            obj.Eleak   = EVal(3);
            obj.Esyn    = EVal(4);
            
            % Previous Values for Euler Method
            obj.m    = IonChanInit(1);
            obj.h    = IonChanInit(2);
            obj.n    = IonChanInit(3);
            obj.p    = IonChanInit(4);
            obj.q    = IonChanInit(5);
            obj.r    = IonChanInit(6);
            obj.s    = IonChanInit(7);
            obj.u    = IonChanInit(8);
            
            obj.cai  = 2.4e-4;
            
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
            
            obj.Kcarev  = (1*10^3) * (obj.R*(obj.Tcelsius+273.15)) / (2*obj.FARADAY);
            obj.VTraub  = VTraub;
        end
        
        %% Computation
        function [obj, Vmem, dV, IVal] = PospischilCalc(obj, Vprev, Iexc)

            % Ionic Channel computation
%             mNa      = simplified_m(Vprev, obj.m, obj.dt);
%             hNa      = simplified_h(Vprev, obj.h, obj.dt);
%             nK       = simplified_n(Vprev, obj.n, obj.dt);
%             mNa      = simplified_mV2(Vprev, obj.m, obj.dt, obj.VTraub);
%             minf     = 0.5*tanh(-1.718+(2^-4 + 2^-8)*(Vprev-obj.VTraub))+0.4976;

            hNa      = simplified_hV2(Vprev, obj.h, obj.dt, obj.VTraub);
            nK       = simplified_nV2(Vprev, obj.n, obj.dt, obj.VTraub);
            mNa      = simplified_mV3(Vprev, obj.m, obj.dt, obj.VTraub);            
%             mNa      = mchan(Vprev, obj.m, obj.dt, obj.VTraub);
%             hNa      = hchan(Vprev, obj.h, obj.dt, obj.VTraub);
%             nK       = nchan(Vprev, obj.n, obj.dt, obj.VTraub);
            
            % Ionic Current computation
            INa     = obj.GNa       * (obj.m) * (obj.m) * (obj.m)   * obj.h  * (Vprev - obj.ENa);
            IK      = obj.GK        * (obj.n^4)                     * (Vprev - obj.EK);
            ILeak   = obj.Gleak                                     * (Vprev - obj.Eleak);
            
            if obj.IM_Enable == 1
                pIon    = simplified_pV2(Vprev, obj.p, obj.dt);
%                 pIon    = pchan(Vprev, obj.p, obj.dt, obj.TauMax);
                
                IM      = obj.GM    * obj.p                         * (Vprev - obj.EK);
            else
                pIon    = 0;
                IM      = 0;
            end

            % IB Calcium current
            if      obj.ICa_State == 1
%                 qIon    = qchan(Vprev, obj.q, obj.dt);
%                 rIon    = rchan(Vprev, obj.r, obj.dt);
                qIon    = simplified_qV2(Vprev, obj.q, obj.dt);
                rIon    = simplified_rV2(Vprev, obj.r, obj.dt);
                sIon    = 0;
                uIon    = 0;
                
                caiVal  = caiFunc(obj.I_Ca, obj.cai, obj.dt, obj.Sm);
                carevVal= obj.Kcarev * log(obj.cao/caiVal);

                ICa     = obj.GCa   * (obj.q^2)  * obj.r            * (Vprev - 120.24);
                
            % LTS Calcium current
            elseif  obj.ICa_State == 2
                qIon    = 0;
                rIon    = 0;
%                 sIon    = s_inf(Vprev);
%                 uIon    = uchan(Vprev, obj.u, obj.dt);
                sIon    = simplified_sV2(Vprev);
                uIon    = simplified_uV2(Vprev, obj.u, obj.dt);
                
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

            pIon    = simplified_pV2(Vprev, obj.p, obj.dt);
            qIon    = simplified_qV2(Vprev, obj.q, obj.dt);
            rIon    = simplified_rV2(Vprev, obj.r, obj.dt);

            I       = - INa - IK - ILeak - IM - ICa + Iexc;
            dV      = I/obj.Cmem;
            Vmem    = Euler(dV, Vprev, obj.dt);
            
            % Save Data        
            obj.m       = mNa;
            obj.h       = hNa;
            obj.n       = nK;
            obj.p       = pIon;
            obj.q       = qIon;
            obj.r       = rIon;
            obj.u       = uIon;
            obj.s       = sIon;
            
            obj.cai     = caiVal;
            obj.carev   = carevVal;
            
            IVal(1)     = INa;
            IVal(2)     = IK;
            IVal(3)     = ILeak;
            IVal(4)     = IM;
            IVal(5)     = qIon;
            IVal(6)     = rIon;
            IVal(7)     = ICa;
            
            obj.I_Ca    = ICa;
        end
        
    end
    
end
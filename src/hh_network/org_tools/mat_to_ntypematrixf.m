% @title      Convert .mat of neuron types into .txt file
% @file       mat_to_ntypematrixf.m
% @author     Romain Beaubois
% @date       06 Aug 2021
% @copyright
% SPDX-FileCopyrightText: © 2021 Romain Beaubois <refbeaubois@yahoo.com>
% SPDX-License-Identifier: GPL-3.0-or-later
% 
% @details
% > **08 Mar 2021** : file creation (RB)
% > **06 Aug 2021** : fix coefficients for neurons parameters (RB)

function mat_to_ntypematrixf(fname, fname_scon, header, nt, Gexcitatory, Ginhibitory, theta, mu, sigma)
% | **Convert .mat of neuron types into .txt file**
% |
% | **fname** : .txt filename for neuron types
% | **fname_scon** : .txt filename for synpatic connection
% | **header** : .txt file header
% | **nt** : array of neuron types
% | **Gexcitatory** : synaptic weight for excitatory neurons
% | **Ginhibitory** : synaptic weight for inhibitory neurons
% | **theta** : noise configuration
% | **mu** : noise configuration
% | **sigma** : noise configuration
%
% | Convert the array of neuron types from matlab into a .txt file
% | used to initialize the FPGA network implementation

    fname_ext   = sprintf("../py/%s_%s.txt",fname,date);
    fid         = fopen(fname_ext, 'w');
    
    % File header
%     fprintf(fid,"######################################################## \n");
%     fprintf(fid,"# %s\n",header);
%     fprintf(fid,"######################################################## \n\n\n");
    fprintf(fid,"#:Number of neurons \n");
    fprintf(fid,"#:Synapse file \n");
    fprintf(fid,"# \n");
    fprintf(fid,"#Neuron configuration      > Nx \n");
    fprintf(fid,"#Stimulation curren        > Istim (nA) \n");
    fprintf(fid,"#Type                      > FS/RS/IB/LTS/- (- is customed option) \n");
    fprintf(fid,"#Parameters 			    > Cmem (µF/cm²), Size (µm) \n");
    fprintf(fid,"#Reversal Potential (mV)   > EK, ENa, ELeak, ECa \n");
    fprintf(fid,"#Conductances (S/cm²)      > GNa, GK, GLeak, GM, Gca \n");
    fprintf(fid,"#Synapses conductances     > G synapse for all the synapses that are connected to the current neuron \n");
    fprintf(fid,"#Noise configuration       > theta, mu, sigma \n \n");
    
    fprintf(fid,":%d\n",length(nt));
    fprintf(fid,":%s_%s\n\n",fname_scon, date);
    
    % Generate neuron type matrix
    for i = 1 : length(nt)
        fprintf(fid,"#N%d\n",i-1);

        [Istim, Cm, Sm, GNa, GK, GLeak, GM, GCa, ENa, EK, ELeak, ECa] = ntype_to_params(nt(i));

        % Neuron geometry
        fprintf(fid,":%.2f\n", Istim);
        fprintf(fid,":%s\n",nt(i));
        fprintf(fid,":%.1f, %.1f\n", Cm, Sm);

        % Reversal potentials and conductances
        fprintf(fid,":%.1f, %.1f, %.1f\n", EK, ENa, ELeak);
        fprintf(fid,":%f, %f, %f, %f\n", GNa, GK, GLeak, GM);

        % Synapses
        if strcmp(nt(i), 'FS')
            fprintf(fid,":%.10f\n", Ginhibitory);
        elseif strcmp(nt(i), 'RS')
            fprintf(fid,":%.9f\n", Gexcitatory);
        end
        
        % Noise
        fprintf(fid,":%.3f, %.3f, %.3f\n", theta, mu, sigma);
        fprintf(fid,"\n");
    end
    
    % Close file
    fclose(fid);
end
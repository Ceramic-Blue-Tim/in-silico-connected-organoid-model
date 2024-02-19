% @title      Convert .mat of synaptic connections into .txt file
% @file       mat_to_synmatrixf.m
% @author     Romain Beaubois
% @date       06 Aug 2021
% @copyright
% SPDX-FileCopyrightText: © 2021 Romain Beaubois <refbeaubois@yahoo.com>
% SPDX-License-Identifier: GPL-3.0-or-later
% 
% @details
% > **08 Mar 2021** : file creation (RB)
% > **06 Aug 2021** : fix coefficients for neurons parameters (RB)

function mat_to_synmatrixf(fname, S_con, export_type)
    % | **Convert .mat of synaptic connections into .txt file**
    % |
    % | **fname** : .txt filename for synaptic connection
    % | **S_con** : array for synaptic connections
    % | **export_type** : type of export file, either fullpl or zynq
    %
    % | Convert the array of synaptic connections from matlab into a .txt file
    % | used to initialize the FPGA network implementation
    
        if ~exist('export_type', 'var')
            export_type = "fullpl";
        end

        NONE            = 000;  % No synapse
        AMPA            = 001;  % Excitatoty synapse
        GABAa           = 011;  % Ihnibitory synapse
        exc_Hill        = 101;  % Short-term plasticity synapse
        inh_Hill        = 110;  % Short-term plasticity synapse
    
        fname_ext   = sprintf("../fpga/zynq/data/%s_%s.txt",fname, date);
        fid         = fopen(fname_ext, 'w');
    
        % Generate syn con matrix
        if strcmp(export_type, "fullpl")
            for row = 1 : length(S_con)
                for col = 1 : length(S_con)
                    fprintf(fid,"%.3d",S_con(row,col));
                end
                fprintf(fid, "\n");     % End of line
            end
        elseif strcmp(export_type, "zynq")
            for row = 1 : length(S_con)
                for col = 1 : length(S_con)
                    switch S_con(row,col)
                    case NONE
                        fprintf(fid,"0");
                    case AMPA
                        fprintf(fid,"1");
                    case GABAa
                        fprintf(fid,"2");
                    case exc_Hill
                        fprintf(fid,"3");
                    case inh_Hill
                        fprintf(fid,"4");
                    end
                end
                fprintf(fid, "\n");     % End of line
            end
        end
    
        % Close file
        fclose(fid);
    end
% @title      Associate xy coordinates to neurons
% @file       XY_placement.m
% @author     Romain Beaubois
% @date       06 Aug 2021
% @copyright
% SPDX-FileCopyrightText: © 2020 Romain Beaubois <refbeaubois@yahoo.com>
% SPDX-License-Identifier: GPL-3.0-or-later
% 
% @details
% > **20 Apr 2020** : file creation (RB)
% > **06 Aug 2021** : modify S_con handling (RB)

function [Nb_neur, x_pos , y_pos, dist2c_p] = XY_placement(ccx, ccy, org_diam, neur_diam)    
% XY placement relatives variables
    ring_diam   = org_diam;
    delta_a     = neur_diam*180/(pi*(ring_diam/2));
    keepout     = neur_diam*1.25;  
    boundary    = 110;
    x           = zeros(1,boundary);
    y           = zeros(1,boundary);
    dist2c      = zeros(1,boundary);
    N           = 1;

    % Calculate coordinates
    while 1
        theta = 0;
        while theta < (360-delta_a)
            x_t = ccx + (ring_diam/2) * cos(theta*pi/180);
            y_t = ccy + (ring_diam/2) * sin(theta*pi/180);
            x(N) = x_t;
            y(N) = y_t;
            dist = exp(sqrt((ccx-x_t)*(ccx-x_t)+(ccy-y_t)*(ccy-y_t))/(org_diam/2))/exp(1);
            dist2c(N) = dist;
            N = N + 1;
            theta = theta + delta_a;
        end
            
        ring_diam = ring_diam - keepout;
        if ring_diam <= 0
            break
        end
    
        delta_a = (keepout*180)/(pi*(ring_diam/2));
    end

    x(N)    = ccx;
    y(N)    = ccy;
    dist2c(N)  = 0; % center so probability of 0
    
    Nb_neur     = N; 
    x_pos       = x;
    y_pos       = y;
    dist2c_p    = dist2c;
end
% @title      Ornstein-Uhlenbeck process to mimic synaptic noise
% @file       OUproc.m
% @author     Farad Khoyratee
% @date       22 Feb 2018
% @copyright
% SPDX-FileCopyrightText: © 2018 Farad Khoyratee <farad.khoyratee@gmail.com>
% SPDX-License-Identifier: GPL-3.0-or-later
% 
% @details
% > **22 Feb 2018** : file creation (FK)

function OUproc = OUproc(Iprev, Theta, Mu, Sigma, dt)
% | **Ornstein-Uhlenbeck process**
% |
% | **Iprev** : Previous value of current
% | **Theta** : Amplitude
% | **Mu** : Mean
% | **Sigma** : Square root of variance
% | **dt** : Time step (ms)
%
% | Calculate synaptic noise based on a Ornstein Uhlenbeck process

    dW      = (2^-4)*randn(1,1);
    OUproc  = Iprev + Theta*dt*(Mu - Iprev)+Sigma*dW;

end
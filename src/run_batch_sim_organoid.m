clc
clear all
close all

pcon_in     = [0.01,    0.02,   0.03,   0.05,   0.08,   0.01,    0.02,   0.03,   0.05,   0.08,  0.01,    0.02];
pcon_out    = [0.01,    0.01,   0.01,   0.01,   0.01,   0.02,    0.02,   0.02,   0.02,   0.02,  0.03,    0.03];

NB_WORKERS = 12;
for i = 1 : NB_WORKERS
    tab_sw_type(i)             = {'connectoid'};
    tab_sw_pcon_in(i)          = pcon_in(i);
    tab_sw_pcon_out(i)         = pcon_out(i);
    tab_dist_orgs_factor(i)    = 4;
    tab_sw_wsyn_exc_in(i)      = 0.3;
    tab_sw_wsyn_inh_in(i)      = 0.3;
    tab_sw_wsyn_exc_out(i)     = 0.3;
    tab_sw_wsyn_inh_out(i)     = 0.3;

    params(i) = struct(...
        'sw_type',            tab_sw_type(i),             ...
        'sw_pcon_in',         tab_sw_pcon_in(i),          ...
        'sw_pcon_out',        tab_sw_pcon_out(i),         ...
        'dist_orgs_factor',   tab_dist_orgs_factor(i),    ...
        'sw_wsyn_exc_in',     tab_sw_wsyn_exc_in(i),      ...
        'sw_wsyn_inh_in',     tab_sw_wsyn_inh_in(i),      ...
        'sw_wsyn_exc_out',    tab_sw_wsyn_exc_out(i),     ...
        'sw_wsyn_inh_out',    tab_sw_wsyn_inh_out(i)      ...
    );
end

parfor i = 1 : NB_WORKERS
    sweep_sim_organoid(params(i));
end

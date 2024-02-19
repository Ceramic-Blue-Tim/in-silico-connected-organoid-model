function n_exp = n_exp(v, Dt, VTraub)
    n_exp = 1 - exp_t(-Dt/tau_n(v, VTraub));
end
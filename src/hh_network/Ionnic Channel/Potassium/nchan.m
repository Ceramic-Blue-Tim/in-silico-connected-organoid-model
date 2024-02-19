function nchan = nchan(v, npre, Dt, VTraub)
    nchan = npre + n_exp(v,Dt, VTraub) * (n_inf(v, VTraub) - npre);
end
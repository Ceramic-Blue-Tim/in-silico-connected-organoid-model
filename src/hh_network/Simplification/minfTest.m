dt          = 2^-5;
Vmem        = -90:dt:60;
l_V         = length(Vmem);

Vt = -55; 

% minf1    = @(v) ((-4.626e-06)*v^2 + 0.00013 * v + 0.5224) * tanh(-1.615 + 0.064*(v-Vt)) + 0.4803;
minf1    = @(v) (0.0001005 * v + 0.5052)*tanh(1.961+0.06681*v)+0.4921;
minf2    = @(v) am(v, Vt)/(am(v, Vt)+betam(v, Vt));

minf1tab = zeros(l_V, 1);
minf2tab = zeros(l_V, 1);
m1 = zeros(l_V, 1);
m2 = zeros(l_V, 1);

for i = 1:l_V-1
    minf1tab(i)     =   minf1(Vmem(i));
    minf2tab(i)     =   minf2(Vmem(i));

    dm1             =   (minf1tab(i)-m1(i))/tau_m(Vmem(i), -55);
    dm2             =   (minf2tab(i)-m2(i))/tau_m(Vmem(i), -55);
    m1(i+1)         =   Euler(dm1, m1(i), dt);
    m2(i+1)         =   Euler(dm2, m2(i), dt);
end

figure;
plot(Vmem, m1, Vmem, m2);

figure;
plot(Vmem, abs(m2-m1));
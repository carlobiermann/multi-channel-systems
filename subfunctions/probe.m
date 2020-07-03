function y = probe(nSample)

hNLOS = randn(1, nSample) + 1i*randn(1, nSample);
hNLOS = setMeanPower(hNLOS,0.01);
pNLOS = quadMean(hNLOS);

K=600;
hLOS = 1 * exp(1i*2*pi*rand(1, nSample));
pLOS = K * pNLOS; 
hLOS = setMeanPower(hLOS, pLOS);

h = hLOS + hNLOS;

y = setMeanPower(h, 1);


realRC = real(y); 
imagRC = imag(y);
scatter(realRC, imagRC);
title('Normally distributed random complex Rayleigh channel coefficients');

end

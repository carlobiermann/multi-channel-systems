% This function returns the normalized complex coefficients of a Rayleigh
% channel

function y = radioFadingChannel(nSample, K)

hNLOS = randn(1, nSample) + 1i*randn(1, nSample);
hNLOS = setMeanPower(hNLOS,1);
pNLOS = quadMean(hNLOS); 

hLOS = 1 * exp(1i*2*pi*randn(1, nSample));
pLOS = K * pNLOS; 
hLOS = setMeanPower(hLOS, pLOS);

h = hLOS + hNLOS;

y = setMeanPower(h, 1);

end
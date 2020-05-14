% This function returns the normalized complex coefficients of a Rayleigh
% channel

function y = radioFadingChannel(nSample)

h = randn(nSample,1) + 1i*randn(nSample,1);

y = setMeanPower(h, 1);

end
% This function returns the normalized complex coefficients of a Rayleigh
% channel

function y = radioFadingChannel(nSample)

h = randn(1, nSample) + 1i*randn(1, nSample);

y = setMeanPower(h, 1);

end
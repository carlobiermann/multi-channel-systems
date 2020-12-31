% This function returns the normalized complex coefficients of a Rice
% channel. Nr indicates the degree of antenna diversity and determines the
% number of rows in the complex coefficient matrix this function returns.

function y = radioFadingChannel(nSample, K, Nr)

y = zeros(Nr, nSample);

for j = 1:Nr
    hNLOS = randn(1, nSample) + 1i*randn(1, nSample);
    hNLOS = setMeanPower(hNLOS,1);
    pNLOS = quadMean(hNLOS); % get Power of hNLOS

    hLOS = exp(1i * rand(1, nSample) * 2*pi); %  generate uniformly distributed phases between 0 and 2pi
    pLOS = K * pNLOS; 
    hLOS = setMeanPower(hLOS, pLOS); % set Power of hLOS to pLos

    h = hLOS + hNLOS;

    y(j,:) = setMeanPower(h, 1/Nr); 
    
end

end
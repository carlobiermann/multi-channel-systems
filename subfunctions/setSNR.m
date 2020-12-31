% This function adds Gaussian Noise to a signal according to the
% Signal-to-Noise Ratio per symbol (snrDb). If 'signal' is a matrix, 
% the function will add the SNR in 'snrDb' to EVERY row of the
% 'signal'-matrix

function y = setSNR(signal, snrDb)

[r,c] = size(signal);
y = zeros(r,c);
snrSlin = db2lin(snrDb); % get linear SNR per symbol

for j = 1:r
    pSignal = quadMean(signal(j,:));
    pNoise = pSignal/snrSlin;     
    nVec = randn(1,length(signal(j,:))) + 1i*randn(1,length(signal(j,:)));

    nVec = setMeanPower(nVec, pNoise); % scale nVec to power of pNoise
    
    y(j,:) = signal(j,:) + nVec; 
    
end    
    
end
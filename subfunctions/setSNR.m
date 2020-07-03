function y = setSNR(signal, snrDb)

[r,c] = size(signal);
y = zeros(r,c);
snrSlin = db2lin(snrDb); % snr for every single antenna

for j = 1:r
    pSignal = quadMean(signal(j,:));
    pNoise = pSignal/snrSlin;     
    nVec = randn(1,length(signal(j,:))) + 1i*randn(1,length(signal(j,:)));

    nVec = setMeanPower(nVec, pNoise); 
    
    y(j,:) = signal(j,:) + nVec;
    
end    
    
end
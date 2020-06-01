function y = setSNR(signal, snrDb, M)

    snrSlin = db2lin(snrDb);
    snrBit = snrSlin/log2(M);
    
    pSignal = quadMean(signal)/snrBit;
    pNoise = pSignal/snrBit;
    
    nVec = randn(1,length(signal)) + 1i*randn(1,length(signal));

    nVec = setMeanPower(nVec, pNoise); % is that right?
    
    y = signal + nVec;
end
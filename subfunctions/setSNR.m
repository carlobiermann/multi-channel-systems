function y = setSNR(signal, snrDb)

    snrSlin = db2lin(snrDb);

    
    pSignal = quadMean(signal);
    pNoise = pSignal/snrSlin; 
    

    nVec = randn(1,length(signal)) + 1i*randn(1,length(signal));

    nVec = setMeanPower(nVec, pNoise); 
    
    y = signal + nVec;
end
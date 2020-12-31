% This function scales a 'signal' with mean power of 'pZero' to a desired 'Power'

function y = setMeanPower(signal, Power)

pZero = quadMean(signal);

    if pZero == 0
        disp('The signal has a mean Power of 0.'); 
    else
        alpha = sqrt(Power/pZero);
        y = signal.*alpha;
    end

end
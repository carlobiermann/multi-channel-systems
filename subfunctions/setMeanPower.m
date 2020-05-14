% This function scales a 'signal' with mean power of 'pZero' to a desired 'Power'

function y = setMeanPower(signal, Power)
% check if Power is real number  && > 0
% check if Power of signal >0 
pZero = mean(abs(signal).^2);

    if pZero == 0
        disp('The signal has a mean Power of 0.'); 
    else
        alpha = sqrt(Power/pZero);
        y = signal.*alpha;
    end

end
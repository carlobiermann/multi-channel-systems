% This function calculates the quadratic mean of a signal. It is 
% mainly used to calculate the power of a signal (RMS).

function y = quadMean(x)

    y = mean(abs(x).^2);
    
end
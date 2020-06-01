% This function converts a logarithmic set of values into a linear one

function y = db2lin(x)
    y = 10^(x./10);
end
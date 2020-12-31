% This function performs the combination of the signals that the Nr
% antennas receive to enhance the BERs of the receiver.

% [4] SEE REFERENCES IN README-DOC
function y = antennaCombining(x, h, combMethod)

[r, c] = size(x);

switch combMethod 
    case 'sum'
        zT = ones(r,c);
        combRx = sum(zT .* x ./ h, 1); % sum all rows
        
    case 'MRC'
        zT = conj(h); 
        combRx = sum(zT .* x, 1);
               
    case 'EGC' 
        zT = exp(-1i*angle(h));
        combRx = sum(zT .* x, 1);
        
    case 'SDC'  
        [~, ind] = max(abs(h), [], 1); % get index of longest vector in each column of h
        zT = zeros(r,c);
        for j = 1:length(ind) 
            zT(ind(j),j) = 1;
        end
        combRx = sum(x .* zT ./ h, 1);

end

y = combRx;

end
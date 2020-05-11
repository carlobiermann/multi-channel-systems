% This function generates and plots a random 1 x nBits logical array
% 
% 'randi' is used to uniformly distribute the random integers between 0 and 1
%  via [0 1]

function y = generateBits(nBits)

    y = logical(randi([0 1],1,nBits)); % make nBit-long array of random logical values 
    % stem(y); % plot y as discrete sequence

end


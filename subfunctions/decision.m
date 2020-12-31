% The function returns an array of modulation signs. The decided modulation
% signs represent the shortest distance between each element of x and the
% modulation signs of the constellation array.

function y = decision(x, const)
szX = length(x);
szConst = length(const);
distances = zeros(1, szConst); % initiate arrays
decidedArr = zeros(1, szX); 

    for i = 1:szX % loop through x
        for j = 1:szConst % loop through const
            distances(1,j) = norm(x(1,i) - const(1,j)); % calculate euclidean distances between x(1,i) and each element of the constellation array
                                                                                                                                                      
        end       
        [~, shortestInd] = min(distances); % get the index of the smallest value in distances array (i.e. shortest distance)
        decidedArr(1,i) = const(1, shortestInd); % assign modulation sign the shortest index points to, to 'decided' array
    end
    
    y = decidedArr;
end
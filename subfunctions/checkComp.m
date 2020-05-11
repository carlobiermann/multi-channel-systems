% This function checks if the bit sequence can be transformed into an array
% of modulation signs. The length of the constellation array determines the
% size of the bit groups into which the bit sequence will be divided.
% Therefore the bitstream has to have a length (meaning a number of
% elements) which can be divided by the length of the bit groups without
% leaving a rest. 
%
% For example:
%
% The length of a constellation array in BPSK would be 4, meaning the bit
% group size will be log2(4) = 2 bits. The bit sequence will therefore be
% divided into groups of 2 bits. 8-PSK would result in a constellation
% array length of 8. This means bit group length of log2(8) = 3 bits. 
% So the bit sequence array has to be divisible by 3 without rest. 

% If the bit sequence is not compatible, extra random bits will be added to
% the bit sequence array to make it compatible. 


function [y, groupSz] = checkComp(bits, const)

groupSz = log2(length(const)); % get size of bit groups
modRes = mod(length(bits), groupSz); % check if modulos operation leaves a rest

    if (modRes == 0) 
        y = bits;           
    else       
        missingBits = groupSz - modRes;
        extraBits = generateBits(missingBits);
        str = 'The original length of the bit sequence was not compatible with the length of the constellation array.';
            if(missingBits > 1)
                str = [str newline 'As a result %i random bits were added to the bit sequence to make it compatible. \n'];
            else
                str = [str newline 'As a result %i random bit was added to the bit sequence to make it compatible. \n'];
            end
        str = sprintf(str, missingBits);
        fprintf(str);   
        y = [bits, extraBits];
    end


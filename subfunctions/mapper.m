% This function maps a bit sequence to a corresponding array of complex modulation
% signs. 
%
% The arrangement of elements inside the constellation array will
% determine the encoding of the bit sequence. 
%
% For example:
%
% The first element of the constellation array with an index of 1 correspond to either a bit
% value of '0', '00', '000' or '0000', depending on modulation method.
% The number of elements in the const-array will determine the modulation method 
% like PSK, BPSK, 8-PSK or 16-QAM and subsequently the size of the groups 
% the bit sequence is going to be divided into.

function y = mapper(bits, const)

[newBits, groupSz] = checkComp(bits, const); % check if sequence and bit group size are compatible
groupedBits = reshape(newBits,groupSz,[])'; % divide bit sequence by bit group size -> reshape/transpose into matrix
szGrBits = size(groupedBits,1); % get # of resulting bit groups (# of rows) out of groupedBits-matrix
modVec = zeros(1, szGrBits); % initialize are zeros array for modulation signs
         
        for i = 1:szGrBits % loop through rows of groupedBits-matrix        
            bitStr = num2str(groupedBits(i,:)); % get row content and convert into string value
            decInt = bin2dec(bitStr); % convert resulting binary string value into decimal value
            modIndex = decInt+1; % make decimal value an index for constellation array of modulation signs
            modVec(1,i) = const(1,modIndex); % assign corresponding modulation sign value to modVec array                                                  
        end
        
y = modVec;
        
end

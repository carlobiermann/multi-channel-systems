function y = mapper(bits, const)

groupSz = log2(length(const)); % the result of the log operation will determine the length of bit groups
y = []; % initialize y as empty vector

    if (mod(length(bits),groupSz) == 0) % check if length of bit sequence is divisible by the length of bit groups
        
        groupedBits = reshape(bits,groupSz,[]); % divide the bit sequence by the group size and assign to a corresponding matrix
        groupedBits = groupedBits'; % transpose matrix
        szGrBits = size(groupedBits,1); % get the number of grouped bits
        modVec = zeros(1, szGrBits); % initialize a vector of zeros the size of the number of grouped bits(1 by szGrBits)
                                     % It is important to preallocate arrays which grow in 
                                     % size via for loops
                              
         
        for i = 1:szGrBits % loop through matrix of grouped bits
            
            bitStr = num2str(groupedBits(i,:)); % look at bit group one by one and convert the bit group into a string
            decInt = bin2dec(bitStr); % convert binary string into corresponding decimal value
            modIndex = decInt+1;  % assign the decimal value to the index of the constellation vector. Add +1 bc indices start at 1
            modVec(1,i) = const(1,modIndex); % fill in modVec with correspending modulation signs the modIndex points to 
                                             % in the constellation vector                                             
            
        end
        
        y = modVec;
        
    else
        
        disp('The length of the constellation vector is not compatible with the length of your bitstream');
        
    end
    

end

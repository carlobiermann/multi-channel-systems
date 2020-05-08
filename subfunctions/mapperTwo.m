function y = mapperTwo(bits, const)

groupSz = log2(length(const)); % the result of the log operation will determine the length of bit groups
y = []; % initialize y as empty vector

    if (mod(length(bits),groupSz) == 0) % check if length of bit stream is divisible by the length of bit groups
        
        groupedBits = reshape(bits,groupSz,[]);
        groupedBits = groupedBits';
        szGrBits = size(groupedBits,1);
        modVec = zeros(1, szGrBits);
         
        for i = 1:szGrBits
            
            bitStr = num2str(groupedBits(i,:));
            decInt = bin2dec(bitStr);
            modIndex = decInt+1; 
            modVec(1,i) = const(1,modIndex);
            
        end
        
        y = modVec;
        
    else
        
        disp('The length of the constellation vector is not compatible with the length of your bitstream')
        
    end
    

end

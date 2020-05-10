function y = mapper(bits, const)

[newBits, groupSz] = checkComp(bits, const);

groupedBits = reshape(newBits,groupSz,[])'; 
szGrBits = size(groupedBits,1); 
modVec = zeros(1, szGrBits); 
         
        for i = 1:szGrBits % loop through matrix of grouped bits
            
            bitStr = num2str(groupedBits(i,:)); 
            decInt = bin2dec(bitStr); 
            modIndex = decInt+1;  
            modVec(1,i) = const(1,modIndex);                                          
            
        end
        
y = modVec;
        
end

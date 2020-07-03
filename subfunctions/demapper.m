
function y = demapper(x, const)

szX = length(x);
szConst = length(const);
decValArr = zeros(1, szX); %iniate decimal value array

    for i = 1:szX
        demapIndex = 1;
        for j = 1:szConst
            if x(1,i) == const(1,j) 
                bitVal = demapIndex-1;
                break;
            else
                bitVal = NaN; % redundant bc decision.m wouldn't create symbols different from constellation array
            end
            demapIndex = demapIndex+1;
        end

        decValArr(1,i) = bitVal; % bit values are stored as decimal value array
    end

% [2] SEE REFERENCES IN README-DOC   
bitRx = logical(reshape(dec2bin(decValArr,2).'-'0',1,[])); % change dec2bin to be compatible w diff length of const
y = bitRx;
end
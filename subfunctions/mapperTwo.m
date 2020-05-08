
% Use this to divide a random bit stream into groups of 1, 2, 3, 4
% (depending on modulation technique PSK, BPSK, 8-PSK or 16-QAM) in a for-loop. 
% Then convert these groups (via matrix transformation) into binary strings. 
% Afterwards convert these binary strings into their decimal value and use that
% decimal value+1 as an index of the const-array. 

% With this you assign groups of your bitstream to modulation signs
% The resulat will be an array/matrix of different modulation signs, which 
% represents the bitstream. The representation will depending on the length
% of const and its values. The order of the modulation signs in const will
% depend on the encoding method (Gray Code etc.)

bits = generateBits(16);

% TODO:
%
%   -   implement if/else to determine wether the length of generateBits 
%       and length of constellation array are compatible for modulation
%       assigning // if not maybe add or cut away bits
%
%   -   loop through bit sequence and assign all bit groups to an array y of
%       modulation signs
% 

% Divide bitstream into groups 
% The size of the groups is determined by the length of the 
% constellation array (wich is always going to be 'an exponent of 2' - long

groupedBits = reshape(bits,log2(length(const)),[]);

% Transpose the grouped bits so that every row of B (in ascending order) represents the the
% bit sequence in groups (size of groups determined by length of const)

groupedBits = groupedBits';

% Convert the first row of groupedBits into a string. This represents the first two bits of the 
% randomly generated bit sequence


bitStr = num2str(groupedBits(1,:));



% Convert the resulting two-bit binary string into the corresponding
% decimal integer

decInt = bin2dec(bitStr);

% The decimal integer now represents the index of the constellation array
% +1 because in MATLAB indices start at 1

i = decInt+1; 

% The decimal index now represents the first two bits of the random
% bitstream. Depending on their value, the value of the index will change 
% accordingly. 


% Now the first two bits of the random bitstream are assigned a modulation
% sign via indexing of const. 

modSign = const(1,i);
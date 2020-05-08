% radio communication system simulation script
%

clc; clear variables; 
addpath('subfunctions');

% global simulation parameters 
const = [-1-1j, 1-1j, -1+1j, 1+1j];

bits = generateBits(12);

r = mapperTwo(bits,const);
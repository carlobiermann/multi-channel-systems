% radio communication system simulation script

clc; clear variables; 
addpath('subfunctions');

% global simulation parameters 
const = [-1-1j, 1-1j, -1+1j, 1+1j]; % BPSK with Gray Code

% create bit sequence
bits = generateBits(50);

% map the bit sequence to an array of corresponding modulation signs
r = mapper(bits,const);

% radio communication system simulation script

clc; clear variables; 
addpath('subfunctions');

% global simulation parameters 
const = [-1-1j, 1-1j, -1+1j, 1+1j]; % BPSK with Gray Code

% create bit sequence
bits = generateBits(10000);

% map the bit sequence to an array of corresponding modulation signs
r = mapper(bits,const);

rfc = radioFadingChannel(10000);




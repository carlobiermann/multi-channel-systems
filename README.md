# multi-channel-systems

This repository contains MATLAB files and functions to simulate multiple types 
of radio communication models. These models include Rayleigh- and Rice-channels. 

All simulations will generate a fixed number of random bits which will be transmitted 
over the two types of channel models and received with varying Signal-to-Noise-Ratios (SNR). 

The performance of these channels will then be evaluated by the received bit errors through the 
bit error rate (BER) plotted over the SNRs.

The differented simulation types are the following: 

### Simulation A - SISO

Rice-channel without antenna diversity over varying K-factors.

### Simulation B - SIMO

Rice-channel with a fixed K=5 over varying degrees of antenna diversity 
 

### Simulation C - SIMO

Rayleigh-channel (K=0) with fixed antenna diversity (Nr=2) over different antenna combining methods.

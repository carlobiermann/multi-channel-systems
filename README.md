# multi-channel-systems

This repository contains MATLAB files and functions to simulate multiple types 
of radio communication models. These models include Rayleigh- and Rice-channels. 

All simulations will generate a fixed number of random bits which will be transmitted 
over the two types of channel models and received with varying Signal-to-Noise-Ratios (SNR). 

The performance of these channels will then be evaluated by the received bit errors through the 
bit error rate (BER) plotted over the SNRs.

## Table of Contents

- [How to use](##hot%20to%20use)
- [Types of simulations](##types%20of%20simulations)
  * [Simultaion A](###simulation%20a)
  * [Simulation B](###simulation%20b)
  * [Simulation C](###simulation%20c)

## How to use

## Types of simulations

### Simulation A 

Rice-channel without antenna diversity over varying K-factors. 
![PLOT A](https://github.com/carlobiermann/multi-channel-systems/blob/master/PLOTS/PLOT1-RICE-CHANNEL-SIM.jpg)

### Simulation B 

Rice-channel with a fixed K=5 over varying degrees of antenna diversity using the MRC-Method.
![PLOT B](https://github.com/carlobiermann/multi-channel-systems/blob/master/PLOTS/PLOT2-RICE-CHANNEL-MRC-COMB.jpg)
 
Rayleigh-channel (K=0) over varying degrees of antenna diversity using the MRC-Method.
![PLOT C](https://github.com/carlobiermann/multi-channel-systems/blob/master/PLOTS/PLOT3-RAYLEIGH-CHANNEL-MRC-COMB.jpg)

### Simulation C 

Rayleigh-channel (K=0) with fixed antenna diversity (Nr=2) over different antenna combining methods.
![PLOT D](https://github.com/carlobiermann/multi-channel-systems/blob/master/PLOTS/PLOT4-RAYLEIGH-COMB-METHODS.jpg)

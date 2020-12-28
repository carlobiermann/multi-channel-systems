# multi-channel-systems

This repository contains MATLAB files and functions to simulate multiple types 
of radio communication models. These models include Rayleigh- and Rice-channels. 

All simulations will generate a fixed number of random bits which will be transmitted 
over the two types of channel models and received with varying Signal-to-Noise-Ratios (SNR). 

The performance of these channels will then be evaluated by the received bit errors through the 
bit error rate (BER) plotted over the SNRs.

## Table of Contents

- [How to use](#how-to-use)
- [Types of simulations](#types-of-simulations)
  * [Simulation A](#simulation-a)
  * [Simulation B](#simulation-b)
  * [Simulation C](#simulation-c)

## How to use

1. `git clone` this repository 
2. Open one of the simulation `.m` files in your directory with MATLAB
3. `Run` the file in MATLAB

The simulation will take a couple of seconds to plot the results. 
For better results change the `nBitsPerLoop` under the `% RANDOM BIT GENERATION PARAMETERS` to `10e3`.
Keep in mind that this  will significantly increase the simulation time.

## Types of simulations

The simulations are based on a simple radio communication model consisiting of a `% TRANSMITTER`, `% RADIO CHANNEL` and a `% RECEIVER`.

- The `% TRANSMITTER` generates random bits and performs an I/Q modulation on these random bits.  

- The `% RADIO CHANNEL` simulates either single path or mulipath Rayleigh-/Rice Fading channels.

- The `% RECEIVER` receives the signal path/s and can perform different combining methods depending on the simulation type. 

### Simulation A 

SISO: Single Input Single Output

#### Rice-channel without antenna diversity over varying K-factors. 
![PLOT A](https://github.com/carlobiermann/multi-channel-systems/blob/master/PLOTS/PLOT1-RICE-CHANNEL-SIM.jpg)

### Simulation B 

SIMO: Single Input Multiple Output

#### Rice-channel with a fixed K=5 over varying degrees of antenna diversity using the MRC-Method.
![PLOT B](https://github.com/carlobiermann/multi-channel-systems/blob/master/PLOTS/PLOT2-RICE-CHANNEL-MRC-COMB.jpg)
 
#### Rayleigh-channel (K=0) over varying degrees of antenna diversity using the MRC-Method.
![PLOT C](https://github.com/carlobiermann/multi-channel-systems/blob/master/PLOTS/PLOT3-RAYLEIGH-CHANNEL-MRC-COMB.jpg)

### Simulation C 

SIMO: Single Input Multiple Output

#### Rayleigh-channel (K=0) with fixed antenna diversity (Nr=2) over different antenna combining methods.
![PLOT D](https://github.com/carlobiermann/multi-channel-systems/blob/master/PLOTS/PLOT4-RAYLEIGH-COMB-METHODS.jpg)

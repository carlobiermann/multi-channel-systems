%% RADIO COMMUNICATION SIMULATION SCRIPT %%
clc; clear variables; 
addpath('subfunctions');

%% GLOBAL SIMULATION PARAMETERS %%
SNR = 0:30;
const = [-1-1j, 1-1j, -1+1j, 1+1j]; % QPSK with Gray Code

% RANDOM BIT GENERATION PARAMETERS
nBitsPerLoop = 10e2; % # of generated bits per loop
nMinErr = 100; % keep simulation running until at least 100 bit errors were detected
nMaxBits = 10 * nBitsPerLoop; % or simulate until the maximum # of bits have been generated

% INITIALIZING VARIABLES FOR ERROR COUNTING
bitsTotal = []; 
bitRxTotal = []; 
nErrTotal = 0;
nBitsTotal = 0;

% CHANNEL PARAMETERS AND COMBINING METHOD
K = 0; % Rayleigh-Channel
% K = 5; % Rice-Channel
Nr = [1, 2, 5 ,10];
combMethod = 'MRC';
BERperSNR = zeros(length(Nr), length(SNR));
BERperSNRtheor = BERperSNR;

%% SIMULATION LOOP %%
for i = 1:length(SNR)
   for k = 1:length(Nr) 
        while (nErrTotal <= nMinErr)
            if nBitsTotal == nMaxBits, break, end 
            
            % TRANSMITTER
            bits = generateBits(nBitsPerLoop);
            mappedBits = mapper(bits,const);

            % RADIO CHANNEL       
            radioCoeffs = radioFadingChannel(length(mappedBits), K, Nr(k)); 
            radioSig = mappedBits .* radioCoeffs;
          
            snrBlin = db2lin(SNR(i))/Nr(k); 
            snrSlin = snrBlin * log2(length(const));
            snrSdb = lin2db(snrSlin);

            radioSigNoise = setSNR(radioSig, snrSdb); % add Gaussian Noise

            % RECEIVER
            radioSigNoiseRx = antennaCombining(radioSigNoise, radioCoeffs, combMethod); 

            pConst = quadMean(const); 
            normRx = setMeanPower(radioSigNoiseRx, pConst); % Normalized Rx signal

            decisions = decision(radioSigNoiseRx, const);
            bitRx = demapper(decisions, const);
            
            % COUNTING BERs
            bitsTotal = logical([bitsTotal, bits]); 
            bitRxTotal = logical([bitRxTotal, bitRx]);
            nBitsTotal = length(bitsTotal);

            [nErrTotal, idx, ber] = countErrors(bitRxTotal, bitsTotal);
            BERperSNR(k,i) = ber; 
            
            berTheo = berfading(SNR(i), 'psk', length(const), Nr(k), K); 
            BERperSNRtheor(k,i) = berTheo; 
        end
        
    % RESET FOR NEXT SNR ITERATION    
    bitsTotal = []; 
    bitRxTotal = []; 
    nErrTotal = 0;
    nBitsTotal = 0;   
    end
end

%% BER PLOT PARAMETERS %%
BERawgn = berawgn(SNR, 'psk',length(const), 'nondiff');

scatter(SNR, BERperSNR(1,:), 'MarkerEdgeColor', 'green','MarkerFaceColor','green');

title('BERs for Rice/Rayleigh-Channels with varying Antenna-Diversity (Nr) and MRC-Combining');
xlabel('SNR/dB');
ylabel('BER');
set(gca, 'YScale', 'log');
xlim([0 max(SNR)]);
ylim([10^-6 10^-1]);
grid on;
box on;
hold on;

scatter(SNR, BERperSNR(2,:),'MarkerEdgeColor', 'cyan', 'MarkerFaceColor','cyan');
scatter(SNR, BERperSNR(3,:),'MarkerEdgeColor', 'magenta', 'MarkerFaceColor','magenta');
scatter(SNR, BERperSNR(4,:),'MarkerEdgeColor', 'blue', 'MarkerFaceColor','blue');

plot(SNR, BERperSNRtheor(1,:), 'Color','green');
plot(SNR, BERperSNRtheor(2,:), 'Color','cyan');
plot(SNR, BERperSNRtheor(3,:), 'Color','magenta');
plot(SNR, BERperSNRtheor(4,:), 'Color','blue');

plot(SNR, BERawgn, 'Color', 'red');
legend('Nr=1 num.','Nr=2 num.','Nr=5 num.', 'Nr=10 num.','Nr=1 analy.', 'Nr=2 analy.', 'Nr=5 analy.', 'Nr=10 analy.', 'AWGN'); 

hold off;

%% RADIO COMMUNICATION SIMULATION SCRIPT %%
clc; clear variables; 
addpath('subfunctions');

%% GLOBAL SIMULATION PARAMETERS %%
SNR = 0:30;
const = [-1-1j, 1-1j, -1+1j, 1+1j]; % QPSK with Gray Code

% RANDOM BIT GENERATION PARAMETERS %
nBitsPerLoop = 10e2; % # of generated bits per loop
nMinErr = 100; % keep simulation running until at least 100 bit errors were detected
nMaxBits = 10 * nBitsPerLoop; % or simulate until the maximum # of bits have been generated

% INITIALIZING VARIABLES FOR BER COUNTING
bitsTotal = []; 
bitRxTotal = []; 
nErrTotal = 0;
nBitsTotal = 0;

% CHANNEL PARAMETERS AND COMBINING METHODS
K = 0; 
Nr = 2;
combMethod = ["sum", "SDC", "EGC", "MRC"];
BERperSNR = zeros(length(combMethod), length(SNR));
BERperSNRtheor = BERperSNR;

%% SIMULATION LOOP %%
for i = 1:length(SNR)
   for m = 1:length(combMethod)  
        while (nErrTotal <= nMinErr)
            if nBitsTotal == nMaxBits, break, end 
            
            % TRANSMITTER
            bits = generateBits(nBitsPerLoop);
            mappedBits = mapper(bits,const);

            % RADIO CHANNEL
            radioCoeffs = radioFadingChannel(length(mappedBits), K, Nr); 
            radioSig = mappedBits .* radioCoeffs;

            snrBlin = db2lin(SNR(i))/Nr;          
            snrSlin = snrBlin * log2(length(const));
            snrSdb = lin2db(snrSlin);

            radioSigNoise = setSNR(radioSig, snrSdb); % add Gaussian Noise

            % RECEIVER
            radioSigNoiseRx = antennaCombining(radioSigNoise, radioCoeffs, combMethod(m)); 

            pConst = quadMean(const); 
            normRx = setMeanPower(radioSigNoiseRx, pConst); % Normalized Rx signal

            decisions = decision(radioSigNoiseRx, const);
            bitRx = demapper(decisions, const);
            
            % COUNTING BERs
            bitsTotal = logical([bitsTotal, bits]); 
            bitRxTotal = logical([bitRxTotal, bitRx]);
            nBitsTotal = length(bitsTotal);

            [nErrTotal, idx, ber] = countErrors(bitRxTotal, bitsTotal);
            BERperSNR(m,i) = ber; 

        end
    % RESET for next SNR iteration     
    bitsTotal = []; 
    bitRxTotal = []; 
    nErrTotal = 0;
    nBitsTotal = 0;   
    end
end

%% BER PLOT PARAMETERS %%
BERawgn = berawgn(SNR, 'psk',length(const), 'nondiff');

scatter(SNR, BERperSNR(1,:), 'MarkerEdgeColor', 'green','MarkerFaceColor','green');

title('BERs for a Rayleigh-Channel with varying Antenna-Combining Methods (Nr=2)');
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
plot(SNR, BERawgn, 'Color', 'red');
legend('sum','SDC','EGC', 'MRC', 'AWGN');

hold off;



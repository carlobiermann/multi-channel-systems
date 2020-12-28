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

% CHANNEL PARAMETERS
K = [1, 2, 5,10];
Nr = 1;
BERperSNR = zeros(length(K), length(SNR));
BERperSNRtheor = BERperSNR;

%% SIMULATION LOOP %%
for i = 1:length(SNR)
   for j = 1:length(K)
        while (nErrTotal <= nMinErr)
            if nBitsTotal == nMaxBits, break, end 
            
            % TRANSMITTER
            bits = generateBits(nBitsPerLoop);
            mappedBits = mapper(bits,const);

            % RADIO CHANNEL
            radioCoeffs = radioFadingChannel(length(mappedBits), K(j), Nr);     
            radioSig = mappedBits .* radioCoeffs;

            snrBlin = db2lin(SNR(i))/Nr;           
            snrSlin = snrBlin * log2(length(const));
            snrSdb = lin2db(snrSlin);

            radioSigNoise = setSNR(radioSig, snrSdb); % add Gaussian Noise

            % RECEIVER
            radioSigNoiseRx = radioSigNoise ./ radioCoeffs; 

            pConst = quadMean(const); 
            normRx = setMeanPower(radioSigNoiseRx, pConst); % Normalized Rx signal

            decisions = decision(radioSigNoiseRx, const);
            bitRx = demapper(decisions, const);
            
            % COUNTING BERs
            bitsTotal = logical([bitsTotal, bits]); 
            bitRxTotal = logical([bitRxTotal, bitRx]);
            nBitsTotal = length(bitsTotal);

            [nErrTotal, idx, ber] = countErrors(bitRxTotal, bitsTotal);
            BERperSNR(j,i) = ber; 

            funTheta = @(theta) ((1+K(j))*sin(theta).^2)/((1 + K(j))*sin(theta).^2 + snrBlin)*exp(-(K(j) * snrBlin)/((1+K(j)) * sin(theta).^2 + snrBlin)); 
            integralTheta = (1/pi) * integral(@(theta) funTheta(theta), 0, 0.5*pi, 'ArrayValued', true); 
            BERperSNRtheor(j,i) = integralTheta;
            
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

title('BERs for Rice Channels with different K-factors'); 
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
legend('K=1 num.','K=2 num.','K=5 num.', 'K=10 num.','K=1 analy.', 'K=2 analy.', 'K=5 analy.', 'K=10 analy.', 'AWGN');

hold off;

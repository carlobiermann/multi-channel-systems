%% RADIO COMMUNICATION SIMULATION SCRIPT %%
%%%% SEE README-DOC FOR FURTHER SIMULATION INSTRUCTIONS %%%%
clc; clear variables; 
addpath('subfunctions');

%% GLOBAL SIMULATION PARAMETERS %%

SNR = 0:30;
const = [-1-1j, 1-1j, -1+1j, 1+1j]; % QPSK with Gray Code

%%%% RANDOM BIT GENERATION PARAMETERS %%%%
nBitsPerLoop = 10e2; % # of generated bits per loop
nMinErr = 100; % keep simulation running until at least 100 bit errors were found
nMaxBits = 10 * nBitsPerLoop; % or simulate until the maximum # of bits have been generated

% initializing arrays/variables for error counting
bitsTotal = []; 
bitRxTotal = []; 
nErrTotal = 0;
nBitsTotal = 0;

%% SIMULATION TYPES %%
%-------------------------------------------------------------------------%
%%%% 1.1 SIMULATION PARAMETERS FOR RICE-CHANNEL SIMULATION WITHOUT ANTENNA
%%%% DIVERSITY

% K = [1, 2, 5,10];
% Nr = 1;
% BERperSNR = zeros(length(K), length(SNR));
% BERperSNRtheor = BERperSNR;

%-------------------------------------------------------------------------%
%%%% 1.3 SIMULATION PARAMETERS FOR RAYLEIGH-CHANNEL SIMULATION WITH ANTENNA
%%%% DIVERSITY (Nr=2) OVER DIFFERENT ANTENNA-COMBINING METHODS

K = 0; 
Nr = 2;
combMethod = ["sum", "SDC", "EGC", "MRC"];
BERperSNR = zeros(length(combMethod), length(SNR));
BERperSNRtheor = BERperSNR;

%-------------------------------------------------------------------------%
%%%% 1.2 SIMULATION PARAMETERS FOR RAYLEIGH (K=0)/RICE-CHANNEL (K=5) COMPARED WITH
%%%% DIFFERENT ORDERS OF ANTENNA DIVERSITY (Nr) OVER 'MRC'- ANTENNA
%%%% COMBINGING METHOD

% % K = 0; % Rayleigh-Channel
% K = 5; % Rice-Channel
% Nr = [1, 2, 5 ,10];
% combMethod = 'MRC';
% BERperSNR = zeros(length(Nr), length(SNR));
% BERperSNRtheor = BERperSNR;

%-------------------------------------------------------------------------%
%% SIMULATION LOOP %%

for i = 1:length(SNR)
%    for j = 1:length(K) % 1.1
%    for k = 1:length(Nr) % 1.2
   for m = 1:length(combMethod) % 1.3   
        while (nErrTotal <= nMinErr)
            if nBitsTotal == nMaxBits, break, end 
            % TRANSMITTER
            bits = generateBits(nBitsPerLoop);
            mappedBits = mapper(bits,const);

            % RADIO CHANNEL
%             radioCoeffs = radioFadingChannel(length(mappedBits), K(j), Nr); % 1.1        
%             radioCoeffs = radioFadingChannel(length(mappedBits), K, Nr(k)); % 1.2
            radioCoeffs = radioFadingChannel(length(mappedBits), K, Nr); % 1.3
            radioSig = mappedBits .* radioCoeffs;

            snrBlin = db2lin(SNR(i))/Nr; % 1.1/1.3           
%             snrBlin = db2lin(SNR(i))/Nr(k); % 1.2
            snrSlin = snrBlin * log2(length(const));
            snrSdb = lin2db(snrSlin);

            radioSigNoise = setSNR(radioSig, snrSdb); % add Gaussian Noise

            % RECEIVER
            radioSigNoiseRx = antennaCombining(radioSigNoise, radioCoeffs, combMethod(m)); % 1.3
%             radioSigNoiseRx = antennaCombining(radioSigNoise, radioCoeffs, combMethod); % 1.2
%             radioSigNoiseRx = radioSigNoise ./ radioCoeffs; % 1.1

            pConst = quadMean(const); 
            normRx = setMeanPower(radioSigNoiseRx, pConst); % Normalized Rx signal

            decisions = decision(radioSigNoiseRx, const);
            bitRx = demapper(decisions, const);
            
            % numerical error counting
            bitsTotal = logical([bitsTotal, bits]); 
            bitRxTotal = logical([bitRxTotal, bitRx]);
            nBitsTotal = length(bitsTotal);

            [nErrTotal, idx, ber] = countErrors(bitRxTotal, bitsTotal);
%             BERperSNR(j,i) = ber; % 1.1
%             BERperSNR(k,i) = ber; % 1.2
            BERperSNR(m,i) = ber; % 1.3  
            
            % theoretical errors  
            
            % [1] SEE REFERENCES IN README-DOC
%             funTheta = @(theta) ((1+K(j))*sin(theta).^2)/((1 + K(j))*sin(theta).^2 + snrBlin)*exp(-(K(j) * snrBlin)/((1+K(j)) * sin(theta).^2 + snrBlin)); %1.1 
%             integralTheta = (1/pi) * integral(@(theta) funTheta(theta), 0, 0.5*pi, 'ArrayValued', true); %1.1
%             BERperSNRtheor(j,i) = integralTheta; % 1.1
            
%             berTheo = berfading(SNR(i), 'psk', length(const), Nr(k), K); %1.2
%             BERperSNRtheor(k,i) = berTheo; %1.2
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

scatter(SNR, BERperSNR(1,:), 'MarkerEdgeColor', 'green','MarkerFaceColor','green')

%%%% TITLE FOR RICE-CHANNEL SIMULATION WITH DIFFERENT K-PARAMETERS
% title('BERs for Rice Channels with different K-factors') % 1.1

%%%% TITLE FOR ANTENNA DIVERSITY SIMULATION WITH DIFFERENT Nr-PARAMETERS
% title('BERs for Rice/Rayleigh-Channels with varying Antenna-Diversity (Nr) and MRC-Combining') % 1.2

%%%% TITLE FOR ANTENNA-DIVERSITY SIMULATION WITH DIFFERENT ANTENNA-COMBINING METHODS
title('BERs for a Rayleigh-Channel with varying Antenna-Combining Methods (Nr=2)') % 1.3

xlabel('SNR/dB')
ylabel('BER')
set(gca, 'YScale', 'log')
xlim([0 max(SNR)])
ylim([10^-6 10^-1])
grid on
box on
hold on

scatter(SNR, BERperSNR(2,:),'MarkerEdgeColor', 'cyan', 'MarkerFaceColor','cyan')
scatter(SNR, BERperSNR(3,:),'MarkerEdgeColor', 'magenta', 'MarkerFaceColor','magenta')
scatter(SNR, BERperSNR(4,:),'MarkerEdgeColor', 'blue', 'MarkerFaceColor','blue')

% plot(SNR, BERperSNRtheor(1,:), 'Color','green')
% plot(SNR, BERperSNRtheor(2,:), 'Color','cyan')
% plot(SNR, BERperSNRtheor(3,:), 'Color','magenta')
% plot(SNR, BERperSNRtheor(4,:), 'Color','blue')

plot(SNR, BERawgn, 'Color', 'red');

%%%% LEGEND FOR RICE-CHANNEL SIMULATION WITH DIFFERENT K-PARAMETERS
% legend('K=1 num.','K=2 num.','K=5 num.', 'K=10 num.','K=1 analy.', 'K=2 analy.', 'K=5 analy.', 'K=10 analy.', 'AWGN') % 1.1

%%%% LEGEND FOR ANTENNA-DIVERSITY SIMULATION WITH DIFFERENT Nr-PARAMETERS
% legend('Nr=1 num.','Nr=1 analy.','Nr=2 num.', 'Nr=2 analy.','Nr=5 num.', 'Nr=5 analy.', 'Nr=10 num.', 'Nr=10 analy.', 'AWGN') % 1.2

%%%% LEGEND FOR ANTENNA-DIVERSITY SIMULATION WITH DIFFERENT
%%%% ANTENNA-COMBINING METHODS
legend('sum','SDC','EGC', 'MRC', 'AWGN') % 1.3

hold off


%% UNUSED PLOTS

% figure(1);
% subplot(1,2,1);
% plot(bits);
% title('Randomly generated bit sequence');
% 
% subplot(1,2,2);
% scatter(real(mappedBits), imag(mappedBits));
% title('Mapped bits');
% 
% realRC = real(radioCoeffs); 
% imagRC = imag(radioCoeffs);
% figure(2);
% subplot(2,2,1);
% scatter(realRC, imagRC);
% title('Normally distributed random complex Rayleigh channel coefficients');
% 
% % plot Amplitude values of Rayleigh Coefficients in histogram
% rayAmpl = abs(radioCoeffs);
% subplot(2,2,2);
% histogram(rayAmpl);
% title('Amplitude Rayleigh Coefficients in histogram');
% 
% % plot Amplitude values of Rayleigh Coefficients 
% pdfRay = 2.*rayAmpl.*exp(-rayAmpl.^2);
% subplot(2,2,3);
% scatter(rayAmpl, pdfRay);
% title('Amplitude Rayleigh Coefficients');
% xlabel('Amplitude(R)');
% ylabel('PDF(p_R(R))');
% 
% % plot phase values of Rayleigh Coefficients
% radioAngle = angle(radioCoeffs);
% pdfRadioAngle = 2.*radioAngle.*exp(-radioAngle.^2);
% subplot(2,2,4);
% scatter(radioAngle, pdfRadioAngle); % is this right?
% title('Phase \Phi Rayleigh Coefficients');
% xlabel('Phase(\Phi)');
% ylabel('PDF(p_{\Phi}(\Phi))');
% 
% figure(3);
% subplot(1,2,1);
% scatter(real(radioSig), imag(radioSig));
% title('Mapped bits multplied with Rayleigh channel coefficients');
% 
% subplot(1,2,2);
% scatter(real(radioSigNoise), imag(radioSigNoise));
% title('Noisy Rayleigh Channel');
% 
% figure(4);
% subplot(1,2,1);
% scatter(real(radioSigNoiseRx), imag(radioSigNoiseRx));
% title('Noisy Rayleigh Rx signal');
% 
% subplot(1,2,2)
% scatter(real(normRx), imag(normRx));
% title('Normalized Rx signal');
% 
% figure(5);
% subplot(1,2,1);
% scatter(real(normRx), imag(normRx));
% title('before decisions');
% 
% subplot(1,2,2);
% scatter(real(decisions), imag(decisions));
% title('After decisions');
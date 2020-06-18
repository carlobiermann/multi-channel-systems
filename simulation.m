% radio communication system simulation script

clc; clear variables; 
addpath('subfunctions');

% global simulation parameters 
const = [-1-1j, 1-1j, -1+1j, 1+1j]; % BPSK with Gray Code

SNR = 1:30;
BERperSNR = zeros(1, length(SNR));

nBitsPerLoop = 10e3; % simulate nBitsPerLoop
nMinErr = 100; % simulate at least nMinErr bit errors 
nMaxBits = 100 * nBitsPerLoop;

% initialize for SNR loop
bitsTotal = []; 
bitRxTotal = []; 
nErrTotal = 0;
nBitsTotal = 0;


%% SIMULATION LOOP

for i = SNR
    while(nErrTotal < nMinErr) || (nBitsTotal == nMaxBits) 
        % TRANSMITTER
        bits = generateBits(nBitsPerLoop);
        mappedBits = mapper(bits,const);

        % RADIO CHANNEL
        radioCoeffs = radioFadingChannel(length(mappedBits));
        radioSig = mappedBits .* radioCoeffs;

        snrBlin = db2lin(i); % calculate SNR/Symbol in dB out of SNR (which is the SNR/Bit in dB)
        snrSlin = snrBlin * log2(length(const));
        snrSdb = lin2db(snrSlin);

        radioSigNoise = setSNR(radioSig, snrSdb); % add Gaussian Noise

        % RECEIVER
        raySigNoiseRx = radioSigNoise ./ radioCoeffs;

        pConst = quadMean(const); 
        normRx = setMeanPower(raySigNoiseRx, pConst); % Normalized Rx signal

        decisions = decision(normRx, const);
        bitRx = demapper(decisions, const);

        bitsTotal = logical([bitsTotal, bits]); 
        bitRxTotal = logical([bitRxTotal, bitRx]);
        nBitsTotal = length(bitsTotal);

        [nErrTotal, idx, ber] = countErrors(bitRxTotal, bitsTotal);
        BERperSNR(1,i) = ber; 
    end

% RESET for next SNR iteration     
bitsTotal = []; 
bitRxTotal = []; 
nErrTotal = 0;
nBitsTotal = 0;

% BER PLOT
scatter(SNR, BERperSNR);
title('BER for multiple SNRs of a single Rayleigh Channel');
xlabel('SNR/dB');
ylabel('BER');
set(gca, 'YScale', 'log');
ylim([10^-6 10^-1]);
grid on;
box on;
end

%% PLOTS

% figure(1);
% subplot(1,2,1);
% plot(bits);
% title('Randomly generated bit sequence');
% 
% subplot(1,2,2);
% scatter(real(mappedBits), imag(mappedBits));
% title('Mapped bits');
% 
% realRC = real(rayCoeffs); 
% imagRC = imag(rayCoeffs);
% figure(2);
% subplot(2,2,1);
% scatter(realRC, imagRC);
% title('Normally distributed random complex Rayleigh channel coefficients');
% 
% % plot Amplitude values of Rayleigh Coefficients in histogram
% rayAmpl = abs(rayCoeffs);
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
% rayAngle = angle(rayCoeffs);
% pdfRayAngle = 2.*rayAngle.*exp(-rayAngle.^2);
% subplot(2,2,4);
% scatter(rayAngle, pdfRayAngle); % is this right?
% title('Phase \Phi Rayleigh Coefficients');
% xlabel('Phase(\Phi)');
% ylabel('PDF(p_{\Phi}(\Phi))');
% 
% figure(3);
% subplot(1,2,1);
% scatter(real(raySig), imag(raySig));
% title('Mapped bits multplied with Rayleigh channel coefficients');
% 
% subplot(1,2,2);
% scatter(real(raySigNoise), imag(raySigNoise));
% title('Noisy Rayleigh Channel');
% 
% figure(4);
% subplot(1,2,1);
% scatter(real(raySigNoiseRx), imag(raySigNoiseRx));
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
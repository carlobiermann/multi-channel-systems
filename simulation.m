%% RADIO COMMUNICATION SIMULATION SCRIPT

clc; clear variables; 
addpath('subfunctions');

%% GLOBAL SIMULATION PARAMETERS
const = [-1-1j, 1-1j, -1+1j, 1+1j]; % BPSK with Gray Code

SNR = 1:30;
K = [1, 2, 5, 10];
BERperSNR = zeros(length(K), length(SNR));

nBitsPerLoop = 10e2; % simulate nBitsPerLoop 10e3
nMinErr = 100; % simulate at least nMinErr bit errors 
nMaxBits = 100 * nBitsPerLoop;

% initialize for SNR loop
bitsTotal = []; 
bitRxTotal = []; 
nErrTotal = 0;
nBitsTotal = 0;

%% SIMULATION LOOP

for i = SNR
    for j = 1:length(K)
        while (nErrTotal <= nMinErr)
            if nBitsTotal == nMaxBits, break, end 
            % TRANSMITTER
            bits = generateBits(nBitsPerLoop);
            mappedBits = mapper(bits,const);

            % RADIO CHANNEL
            radioCoeffs = radioFadingChannel(length(mappedBits), K(j));
            radioSig = mappedBits .* radioCoeffs;

            snrBlin = db2lin(i); % calculate SNR/Symbol in dB out of SNR (which is the SNR/Bit in dB)
            snrSlin = snrBlin * log2(length(const));
            snrSdb = lin2db(snrSlin);

            radioSigNoise = setSNR(radioSig, snrSdb); % add Gaussian Noise

            % RECEIVER
            radioSigNoiseRx = radioSigNoise ./ radioCoeffs;

            pConst = quadMean(const); 
            normRx = setMeanPower(radioSigNoiseRx, pConst); % Normalized Rx signal

            decisions = decision(normRx, const);
            bitRx = demapper(decisions, const);

            bitsTotal = logical([bitsTotal, bits]); 
            bitRxTotal = logical([bitRxTotal, bitRx]);
            nBitsTotal = length(bitsTotal);

            [nErrTotal, idx, ber] = countErrors(bitRxTotal, bitsTotal);
            BERperSNR(j,i) = ber; 
        end
    % RESET for next SNR iteration     
    bitsTotal = []; 
    bitRxTotal = []; 
    nErrTotal = 0;
    nBitsTotal = 0;   
    end
end

%% BER PLOTS

scatter(SNR, BERperSNR(1,:), 'MarkerEdgeColor', 'green','MarkerFaceColor','green')

title('BERs for Rice Channels with different K-factors')
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

% berQ = berawgn(SNR, 'QPSK', log2(length(const))); % has to use System
% Communication Toolbox
% plot(SNR, berQ)

legend('K=1','K=2', 'K=5', 'K=10')   
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
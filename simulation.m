% radio communication system simulation script

clc; clear variables; 
addpath('subfunctions');

% global simulation parameters 
const = [-1-1j, 1-1j, -1+1j, 1+1j]; % BPSK with Gray Code

% create bit sequence
bits = generateBits(10000);
figure(1);
subplot(1,2,1);
plot(bits);
title('Randomly generated bit sequence');

% map the bit sequence to an array of corresponding modulation signs
mappedBits = mapper(bits,const);
subplot(1,2,2);
scatter(real(mappedBits), imag(mappedBits));
title('Mapped bits');

% generate normally distributed random complex Rayleigh Channel
% coefficients
rayCoeffs = radioFadingChannel(length(mappedBits));
realRC = real(rayCoeffs); 
imagRC = imag(rayCoeffs);
figure(2);
subplot(2,2,1);
scatter(realRC, imagRC);
title('Normally distributed random complex Rayleigh channel coefficients');

% plot Amplitude values of Rayleigh Coefficients in histogram
rayAmpl = abs(rayCoeffs);
subplot(2,2,2);
histogram(rayAmpl);
title('Amplitude Rayleigh Coefficients in histogram');

% plot Amplitude values of Rayleigh Coefficients 
pdfRay = 2.*rayAmpl.*exp(-rayAmpl.^2);
subplot(2,2,3);
scatter(rayAmpl, pdfRay);
title('Amplitude Rayleigh Coefficients');
xlabel('Amplitude(R)');
ylabel('PDF(p_R(R))');

% plot phase values of Rayleigh Coefficients
rayAngle = angle(rayCoeffs);
pdfRayAngle = 2.*rayAngle.*exp(-rayAngle.^2);
subplot(2,2,4);
scatter(rayAngle, pdfRayAngle); % is this right?
title('Phase \Phi Rayleigh Coefficients');
xlabel('Phase(\Phi)');
ylabel('PDF(p_{\Phi}(\Phi))');

% multiply the mapped bits with Rayleigh Channel coefficients
raySig = mappedBits .* rayCoeffs;
figure(3);
subplot(1,2,1);
scatter(real(raySig), imag(raySig));
title('Mapped bits multplied with Rayleigh channel coefficients');

% add Noise to the Rayleigh Channel
raySigNoise = setSNR(raySig, 30, length(const));
subplot(1,2,2);
scatter(real(raySigNoise), imag(raySigNoise));
title('Noisy Rayleigh Channel');

% Divide Noisy Rayleigh Signal by Channel Coefficients to simulate 'ideal'
% transmission
% Rx stands for 'receive'
raySigNoiseRx = raySigNoise ./ rayCoeffs;
figure(4);
subplot(1,2,1);
scatter(real(raySigNoiseRx), imag(raySigNoiseRx));
title('Noisy Rayleigh Rx signal');

% Normalized Rx signal
pConst = quadMean(const);
normRx = setMeanPower(raySigNoiseRx, pConst)'; % why transpose?
subplot(1,2,2)
scatter(real(normRx), imag(normRx));
title('Normalized Rx signal');

figure(5);
subplot(1,2,1);
scatter(real(normRx), imag(normRx));
title('before decisions');

decisions = decision(normRx, const);
subplot(1,2,2);
scatter(real(decisions), imag(decisions));
title('After decisions');

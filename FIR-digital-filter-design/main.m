% MAIN  FIR digital filter design and software implementation.
%
% Pipeline:
%   1) Generate a noisy AM test signal (xtg.m)
%   2) Design a low-pass FIR filter via the window method (Blackman)
%   3) Design a low-pass FIR filter via the equiripple (Remez) method
%   4) Filter the noisy signal with both filters (fast convolution,
%      fftfilt) and compare frequency response, filter order,
%      time-domain recovery, and spectrum.
%
% Filter spec (shared by both designs):
%   passband cutoff  fp = 120 Hz   (max passband ripple  Rp = 0.1~0.2 dB)
%   stopband cutoff  fs = 150 Hz   (min stopband atten.   As = 60~70 dB)

clear; close all; clc;

%% 0. Parameters
N  = 1000;
Fs = 1000;
T  = 1/Fs;
Tp = N*T;
k  = 0:N-1;
f1 = k/Tp;

fp = 120;
fs = 150;
Rp = 0.2;
As = 60;

%% 1. Generate noisy test signal
xt = xtg();

%% 2. Window method (Blackman) design
[hn_w, Nb] = fir_lowpass_window(fp, fs, Fs);
Hw  = abs(fft(hn_w, 1024));
ywt = fftfilt(hn_w, xt, N);

f = (0:1023)*Fs/1024;
figure(2);
subplot(2,1,1);
plot(f, 20*log10(Hw/max(Hw)), 'g'); grid on;
title('窗函数法（Blackman）低通滤波器幅频特性');
axis([0, Fs/2, -120, 20]);
xlabel('f/Hz'); ylabel('幅度(dB)');

t = (0:N-1)/Fs;
subplot(2,1,2);
plot(t, ywt, 'r'); grid on;
axis([0, Tp/2, -1, 1]);
xlabel('t/s'); ylabel('y_w(t)');
title('窗函数法滤除噪声后的信号波形');

fxt = fftshift(fft(ywt, N));
figure(3);
stem(f1-500, abs(fxt)/max(abs(fxt)), 'k.'); grid on;
title('窗函数法滤除噪声后的信号频谱');
axis([0, 500, 0, 1]);

%% 3. Equiripple (Remez) method design
[hn_e, Ne] = fir_lowpass_remez(fp, fs, Rp, As, Fs);
He  = abs(fft(hn_e, 1024));
yet = fftfilt(hn_e, xt, N);

figure(4);
subplot(2,1,1);
plot(f, 20*log10(He/max(He)), 'g'); grid on;
title('等波纹法（Remez）低通滤波器幅频特性');
axis([0, Fs/2, -80, 10]);
xlabel('f/Hz'); ylabel('幅度(dB)');

subplot(2,1,2);
plot(t, yet, 'r'); grid on;
axis([0, Tp/2, -1, 1]);
xlabel('t/s'); ylabel('y_e(t)');
title('等波纹法滤除噪声后的信号波形');

fet = fftshift(fft(yet, N));
figure(5);
stem(f1-500, abs(fet)/max(abs(fet)), 'k.'); grid on;
title('等波纹法滤除噪声后的信号频谱');
axis([0, 500, 0, 1]);

%% 4. Compare filter orders
fprintf('窗函数法（Blackman）滤波器长度 Nb = %d\n', Nb);
fprintf('等波纹法（Remez）滤波器长度   Ne = %d\n', Ne+1);
fprintf('阶数比 Nb/Ne = %.2f\n', Nb/(Ne+1));

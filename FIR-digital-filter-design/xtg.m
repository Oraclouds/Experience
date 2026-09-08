function xt = xtg()
% XTG  Generate a single-tone amplitude-modulated signal corrupted by
%      colored (band-limited) noise, and plot its time-domain waveform
%      and amplitude spectrum.
%
%   xt = XTG()
%
%   The "carrier" is amplitude-modulated by a low-frequency tone, then
%   mixed with wideband random noise that has been shaped by a
%   high-pass FIR filter (designed with the Parks-McClellan / Remez
%   algorithm) so that the noise energy concentrates above ~150 Hz.
%
%   Output:
%       xt - 1x1000 row vector, the noisy composite signal

N  = 1000;
Fs = 1000;
T  = 1/Fs;
Tp = N*T;
t  = 0:T:(N-1)*T;

fc = Fs/10;     % carrier frequency
f0 = fc/10;     % modulating (message) frequency
mt = cos(2*pi*f0*t);
ct = cos(2*pi*fc*t);
xt = mt.*ct;    % clean AM signal

% ---- generate high-frequency noise ----
nt = 0.2*rand(1,N) - 1;

fp = 150; fs = 200;     % noise-shaping filter spec (high-pass)
Rp = 0.1; As = 70;
fb  = [fp, fs];
m   = [0, 1];
dev = [10^(-As/20), (10^(Rp/20)-1)/(10^(Rp/20)+1)];
[n, fo, mo, W] = remezord(fb, m, dev, Fs);
hn = remez(n, fo, mo, W);
yt = filter(hn, 1, 10*nt);

xt = xt + yt;   % signal + noise

% ---- plot ----
fst = fft(xt, N);
k = 0:N-1;
f = k/Tp;

figure(1);
subplot(2,1,1);
plot(t, xt); grid on;
xlabel('t/s'); ylabel('x(t)');
axis([0, Tp/5, min(xt), max(xt)]);
title('(a) 信号加噪声波形');

subplot(2,1,2);
plot(f, abs(fst)/max(abs(fst))); grid on;
xlabel('f/Hz'); ylabel('幅度');
axis([0, Fs/2, 0, 1.2]);
title('(b) 信号加噪声频谱');

end

function [hn, Ne] = fir_lowpass_remez(fp, fs, Rp, As, Fs)
% FIR_LOWPASS_REMEZ  Design a linear-phase FIR low-pass filter using the
%                     equiripple (Parks-McClellan / Remez) optimal
%                     approximation method.
%
%   [hn, Ne] = FIR_LOWPASS_REMEZ(fp, fs, Rp, As, Fs)
%
%   Inputs:
%       fp - passband cutoff frequency (Hz)
%       fs - stopband cutoff frequency (Hz)
%       Rp - passband max attenuation (dB)
%       As - stopband min attenuation (dB)
%       Fs - sampling frequency (Hz)
%
%   Outputs:
%       hn - filter coefficients (impulse response)
%       Ne - filter order (length - 1)

if nargin < 5
    fp = 120; fs = 150; Rp = 0.2; As = 60; Fs = 1000;
end

fb  = [fp, fs];
m   = [1, 0];
dev = [(10^(Rp/20)-1)/(10^(Rp/20)+1), 10^(-As/20)];

[Ne, fo, mo, W] = remezord(fb, m, dev, Fs);
hn = remez(Ne, fo, mo, W);

end

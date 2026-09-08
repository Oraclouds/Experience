function [hn, Nb] = fir_lowpass_window(fp, fs, Fs)
% FIR_LOWPASS_WINDOW  Design a linear-phase FIR low-pass filter with the
%                      window method (Blackman window) using FIR1.
%
%   [hn, Nb] = FIR_LOWPASS_WINDOW(fp, fs, Fs)
%
%   Inputs:
%       fp - passband cutoff frequency (Hz)
%       fs - stopband cutoff frequency (Hz)
%       Fs - sampling frequency (Hz)
%
%   Outputs:
%       hn - filter coefficients (impulse response)
%       Nb - filter length

if nargin < 3
    fp = 120; fs = 150; Fs = 1000;
end

wc = (fp + fs)/Fs;                 % normalized -6dB cutoff (average)
B  = 2*pi*(fs - fp)/Fs;            % transition band (rad/sample)
Nb = ceil(11*pi/B);                % Blackman window empirical length

hn = fir1(Nb-1, wc, blackman(Nb));

end

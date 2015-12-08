% Compute the FFT from the signal with the appropriate frequency resolution, and normalize by the length of the signal.
% 
% written by: Renato Naville Watanabe 
%
% [S, f] = computeSignalFFT(signal, Fs, fres)
%	
% Inputs:
%	
%   signal: vector of floats, vector with signal to have the FFT computed.
%
%   Fs: float, sampling frequency, in Hz.
%
%   fres: float, the wanted frequency resolution, in Hz.
%
%
% Outputs:
%   
%   S: vector of complex, the signal FFT.
%
%   f: vector of floats, vector of frequencies.

function [S, f] = computeSignalFFT(signal, Fs, fres)
    
    trials = size(signal, 2);
    for i = 1:trials
        f = -Fs/2:fres:Fs/2;
        F = fft(signal(:,i), length(f));               
        S(:,i) = fftshift(F)/length(F);
    end
end

%% Compute the FFT from the signal with the appropriate frequency resolution, and normalize by the length of the signal.
% signal is the vector with signal to have the FFT computed
% Fs is the sampling frequency, in Hz
% fres is the wanted frequency resolution, in Hz
% S is the signal FFT
% f is the vector of frequencies

function [S, f] = computeSignalFFT(signal, Fs, fres)
    
    trials = size(signal, 2);
    for i = 1:trials
        f = -Fs/2:fres:Fs/2;
        F = fft(signal(:,i), length(f));               
        S(:,i) = fftshift(F)/length(F);
    end
end
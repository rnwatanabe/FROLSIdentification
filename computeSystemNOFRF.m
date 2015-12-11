% This functions performs all steps to compute the NOFRFs (Nonlinear Output Frequency Response Function) of a system
% with the given GFRFs and input u.
%
% written by: Renato Naville Watanabe 
%
% [NOFRF, U, f] = computeSystemNOFRF(GFRF, u, Fs, fres, minDegree, maxDegree, fmin, fmax, f_inputMin, f_inputMax)
%	
%   
% Inputs:
% 
%   GFRF: cell, contains all the GFRFs until the specified degree.
%
%   u: vector of floats, input signal, in a column-vector.
%
%   Fs: float, sampling frequency, in Hz.
%
%   fres: float, frequency resolution of the FFT, in Hz.
%
%   minDegree: integer, minimal degree to have the NOFRF computed.
%
%   maxDegree: integer, maximal degree to have the NOFRF computed.
%
%   fmin: float, lower frequency limit of the NOFRF computation, in Hz.
%
%   fmax: float, upper frequency limit of the NOFRF computation, in Hz.
%
%   f_inputMin: vector of floats, lower frequency limit of the input signal, in Hz.
%   You can define one value for each degree or simply one value for all
%   degrees. For example: f_inputMin = [19;19;0;0;19;0] if you will use
%   GFRFs up to degree six.
%
%   f_inputMax: vector of floats, upper frequency limit of the input signal, in Hz.
%   You can define one value for each degree or simply one value for all
%   degrees. For example: f_inputMax = [21;21;2;2;21;2] if you will use
%   GFRFs up to degree six.
%
%
% Outputs:
%   
%   NOFRF: vector of complex, the NOFRF of the system for the given input at
%   each frequency.
%
%   U: vector of complex, the FFT of the input signal u.
%
%   f: vector of floats, the vector of frequencies.

function [NOFRF, U, f] = computeSystemNOFRF(GFRF, u, Fs, fres, minDegree, maxDegree, fmin, fmax, f_inputMin, f_inputMax)

    U = computeSignalFFT(u, Fs, fres);
    [NOFRF, f] = computeNOFRF(GFRF, U, minDegree, maxDegree, Fs, fres, fmin, fmax, f_inputMin, f_inputMax);       
    
end

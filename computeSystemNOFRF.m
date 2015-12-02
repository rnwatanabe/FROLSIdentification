%% This functions performs all steps to compute the NOFRFs (Nonlinear Output Frequency Response Function) of a system
%	with the given GFRFs and input u.
%
%   written by: Renato Naville Watanabe 
%
%	[NOFRF, f] = computeSystemNOFRF(GFRF, u, Fs, fres, degree, fmin, fmax)
%	
%   
%   Inputs:
% 
%	  GFRF: cell, contains all the GFRFs until the specified degree.
%
%	  u: vector of floats, input signal, in a column-vector.
%
%	  Fs: float, sampling frequency, in Hz.
%
%	  fres: float, frequency resolution of the FFT, in Hz.
%
%	  degree: integer, maximal degree to have the NOFRF computed.
%
% 	fmin: float, lower frequency limit of the NOFRF computation.
%
% 	fmax: float, upper frequency limit of the NOFRF computation.
%
%
%   Outputs:
%   
% 	NOFRF: vector of complex, the NOFRF of the system for the given input at
%	each frequency.
%
% 	f: vector of floats, the vector of frequencies.

function [NOFRF, f] = computeSystemNOFRF(GFRF, u, Fs, fres, degree, fmin, fmax)

    U = computeSignalFFT(u, Fs, fres);
    [NOFRF, f] = computeNOFRF(GFRF, U, degree, Fs, fres, fmin, fmax);       
    
end

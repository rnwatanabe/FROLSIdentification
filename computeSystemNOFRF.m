%% This functions performs all steps to compute the NOFRFs (Nonlinear Output Frequency Response Function) of a system
%	with the given GFRFs and input u.
%
%
%	[NOFRF, f] = computeSystemNOFRF(GFRF, u, Fs, fres, degree, fmin, fmax)
%	where:
%
%	GFRF is the cell with all the GFRFs until the specified degree.
%
%	u is is the input signal, in a column-vector.
%
%	Fs is the sampling frequency, in Hz.
%
%	fres is the frequency resolution of the FFT, in Hz.
%
%	degree is the maximal degree to have the NOFRF computed.
%
% 	fmin in the lower frequency limit of the NOFRF computation.
%
% 	fmax in the upper frequency limit of the NOFRF computation.
%
%	
% 	NOFRF is a vector with the NOFRF of the system for the given input at
%	each frequency.
%
% 	f is the vector of frequencies.

function [NOFRF, f] = computeSystemNOFRF(GFRF, u, Fs, fres, degree, fmin, fmax)

    U = computeSignalFFT(u, Fs, fres);
    [NOFRF, f] = computeNOFRF(GFRF, U, degree, Fs, fres, fmin, fmax);       
    
end

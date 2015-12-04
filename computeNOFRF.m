%% Computes the NOFRF (Nonlinear Output Frequency Response Function) for the specified input.
%
%   written by: Renato Naville Watanabe 
%
%	[NOFRF, f] = computeNOFRF(Hn, X, maxDegree, Fs, fres, fmin, fmax)
%	
%   
%   Inputs:
%   
% 	Hn: cell, contains all the GFRFs until the specified degree.
%
% 	X: vector of complex, the FFT of the input signal obtained with the computeSignalFFT function.
%
% 	maxDegree: integer, the maximal degree to have the NOFRF computed.
%
% 	Fs: float, sampling frequency, in Hz.
%
% 	fres: float, frequency resolution of the FFT, in Hz.
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

function [NOFRF, f] = computeNOFRF(Hn, X, maxDegree, Fs, fres, fmin, fmax)
    H1 = matlabFunction(Hn{1});
    fv = -Fs/2:fres:Fs/2;
    f = fmin:fres:fmax; 
    
    NOFRF = zeros(size(f));
    for j = 1:length(f)
        NOFRF(j) = 2 * H1(f(j)) * X(abs(fv-f(j))<=1e-6) ;
    end
    
    for i = 2:maxDegree
       if  logical(Hn{i} ~= 0)
           HnFunction = matlabFunction(Hn{i});
           for j = 1:length(f)
               if f(j) == 0
                  NOFRFConst = 1; 
               else
                  NOFRFConst = 2; 
               end
               NOFRF(j) = NOFRF(j) +  NOFRFConst * computeDegreeNOFRF(HnFunction, X, Fs, i, f(j), fres);
           end 
       end
    end  
end

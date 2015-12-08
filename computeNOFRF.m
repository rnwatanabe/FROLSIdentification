% Computes the NOFRF (Nonlinear Output Frequency Response Function) for the specified input.
%
% written by: Renato Naville Watanabe 
%
% [NOFRF, f] = computeNOFRF(Hn, X, maxDegree, Fs, fres, fmin, fmax)
%	
%   
% Inputs:
%   
%   Hn: cell, contains all the GFRFs until the specified degree.
%
%   X: vector of complex, the FFT of the input signal obtained with the computeSignalFFT function.
%
%   maxDegree: integer, the maximal degree to have the NOFRF computed.
%
%   Fs: float, sampling frequency, in Hz.
%
%   fres: float, frequency resolution of the FFT, in Hz.
%
%   fmin: float, lower frequency limit of the NOFRF computation, in Hz.
%
%   fmax: float, upper frequency limit of the NOFRF computation, in Hz.
%
%   f_inputMin: float, lower frequency limit of the input signal, in Hz.
%
%   f_inputMax: float, upper frequency limit of the input signal, in Hz.
%
%
% Outputs:
%
%   NOFRF: vector of complex, the NOFRF of the system for the given input at
%   each frequency.
%
%   f: vector of floats, the vector of frequencies.

function [NOFRF, f] = computeNOFRF(Hn, X, maxDegree, Fs, fres, fmin, fmax, f_inputMin, f_inputMax)
    H1 = matlabFunction(Hn{1});
    fv = [-f_inputMax:fres:-f_inputMin-fres f_inputMin:fres:f_inputMax];
    f = fmin:fres:fmax; 
    
    NOFRF = zeros(size(f));
    for j = 1:length(f)
        validFrequencyIndices = abs(fv-f(j))<=1e-3;
        if ~isempty(X(validFrequencyIndices))
            NOFRF(j) = 2 * H1(f(j)) * (X(validFrequencyIndices)) ;
        end
    end
    
    for i = 2:maxDegree
       if  logical(Hn{i} ~= 0)
           HnFunction = matlabFunction(Hn{i});
           for j = 1:length(f)
               NOFRF(j) = NOFRF(j) +  2 * computeDegreeNOFRF(HnFunction, X, Fs, i, f(j), fres, f_inputMin, f_inputMax);
           end 
       end
    end  
end

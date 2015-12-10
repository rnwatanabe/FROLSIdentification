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
%   U: vector of complex, the FFT of the input signal obtained with the computeSignalFFT function.
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
%   f: vector of floats, the vector of frequencies.

function [NOFRF, f] = computeNOFRF(Hn, U, maxDegree, Fs, fres, fmin, fmax, f_inputMin, f_inputMax)
    H1 = matlabFunction(Hn{1});
    fv = -Fs/2:fres:Fs/2;
    %fv = [-f_inputMax:fres:-f_inputMin f_inputMin:fres:f_inputMax];
    f_out = fmin:fres:fmax; 
    
    NOFRF = zeros(size(f_out));
    for j = 1:length(f_out)
        validFrequencyIndices = abs(fv-f_out(j))<=1e-3 & f_out(j)>=f_inputMin(1) & f_out(j) <= f_inputMax(1);
        if ~isempty(U(validFrequencyIndices))
            NOFRF(j) = 2 * H1(f_out(j)) * U(validFrequencyIndices);
        end
    end
    
    for i = 2:maxDegree
       if  logical(Hn{i} ~= 0)
           HnFunction = matlabFunction(Hn{i});
           for j = 1:length(f_out)
               NOFRF(j) = NOFRF(j) +  2 * computeDegreeNOFRF(HnFunction, U, Fs, i, f_out(j), fres, f_inputMin, f_inputMax);
           end 
       end
    end 
    
    f = f_out;
end

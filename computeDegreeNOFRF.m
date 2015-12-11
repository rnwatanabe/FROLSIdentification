% Computes the NOFRF of the specified degree in the frequency f.
%
% written by: Renato Naville Watanabe 
%
% DegreeNOFRF = computeDegreeNOFRF(HnFunction, U, Fs, degree, f, fres, f_inputMin, f_inputMax)
%	
%   
% Inputs:
%
%   HnFunction: function, is the function of the the GFRFs of the specified degree.
%
%   U: vector of complex, the FFT of the input signal obtained with the computeSignalFFT function.
%
%   Fs: float, the sampling frequency, in Hz.
%
%   degree: integer,  degree of the NOFRF to be computed.
% 
%   f: float, the frequency, in Hz, to have the NOFRF computed.
%	
%   fres: float, the frequency resolution of the FFT, in Hz.
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
% Output:
%   
%   DegreeOFRF: vector of complex,  the NOFRF relative to the specified degree.

function DegreeNOFRF = computeDegreeNOFRF(HnFunction, U, Fs, degree, f, fres, f_inputMin, f_inputMax)
        
        fv = -Fs/2:fres:Fs/2;
        
        for i = 1:degree
            if i == 1
                fnCall = ['fVector{' num2str(i) '}'];
            else
                fnCall = [fnCall ', fVector{' num2str(i) '}'];
            end
        end
                
        fVector = determineFrequencies(f, fres, degree, f_inputMin, f_inputMax);
        
        for i = 1:degree
            [A1, freqIndex{i}] = ismember(round(fVector{i}/fres), round(fv/fres)); 
        end

        eval(['DegreeNOFRF = HnFunction(' fnCall ');']);
        DegreeNOFRF = sum(DegreeNOFRF .* inputFFTDegree(U, freqIndex, degree));                
end

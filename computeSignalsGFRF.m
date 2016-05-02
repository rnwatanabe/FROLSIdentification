% Computes the GFRFs of a NARX model. It uses the Symbolic Toolbox of Matlab.
%
% written by: Renato Naville Watanabe 
%
% Hn = computeSignalsGFRF(Da, Fs, a, degree)
%	
%
% Inputs:
%	
%   Da: cell, contains the strings with the NARX model terms.
%
%   Fs: float, the sampling frequency, in Hz.
%
%   a: vector of floats, coefficients of the NARX model.
%
%   degree: integer, maximal order of GFRF you want to obtain.
%
%
% Outputs:
%   
%   Hn: cell, contains the GFRFs of the NARX model.

function Hn = computeSignalsGFRF(Da, Fs, a, degree)
    
    V = ver;
    for i = 1:length(V)
        if (strcmp(V(i).Name,'Octave'))
            pkg load symbolic;
        end
    end

    subjects = size(a, 2); 
    [Da, a] = removeConstant(Da, a, zeros(size(a)));
    
    Hn = cell(1, subjects);
    
    Mp = length(Da);
        
    I = modelLags(Da);
    
    [C, maxLag] = findCCoefficients(a, I);
    [Hnn, Hn] = buildHn(degree, C, Fs, maxLag, 0);
    
end

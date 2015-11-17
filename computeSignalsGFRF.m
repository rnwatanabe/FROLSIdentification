%% computes the GFRFs of a NARX model. It uses the Symbolic Toolbox of Matlab
% Da is a vector of strings with the NARX model terms
% Fs is the sampling frequency, in Hz
% a is the vector of coefficients of the NARX model
% degree is the maximal order of GFRF you want to obtain.
% Hn is a cell with the GFRFs of the NARX model

function [Hn] = computeSignalsGFRF(Da, Fs, a, degree)

    subjects = size(a, 2); 
    
    Hn = cell(1, subjects);
    
    Mp = length(Da);
        
    I = modelLags(Da);
    
    for i = 1:subjects
        [C, maxLag] = findCCoefficients(a(:,i), I);
        [Hnn, Hn{:,i}] = buildHn(degree, C, Fs, maxLag, 0);
    end
end

% Computes the FFT of the specified degree at the specified frequency combinations.
%
%written by: Renato Naville Watanabe 
%
%	degreeFFT = inputFFTDegree(X, freqIndex, degree)
%	
% Inputs:
%
%   X: vector of complex, FFT of the signal.
%
%   freqIndex: cell, contains the frequency vectors in which the FFT of the specified degree must be
%   computed.
%
%   degree: integer, degree of the FFT you wish to compute.
%
%
% Outputs:
%
%   degreeFFT: vector of complex, the FFT of the specified degree.

function degreeFFT = inputFFTDegree(X, freqIndex, degree)
    
    if degree > 1
       degreeFFT = inputFFTDegree(X, freqIndex, degree-1).*X(freqIndex{degree});
    else
       degreeFFT = X(freqIndex{1}); 
    end
end

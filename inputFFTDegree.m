%% Computes the FFT of the specified degree at he specified frequency combinations.
%
%
%	degreeFFT = inputFFTDegree(X, freqIndex, degree)
%	where:
%
% 	X is the FFT of the signal.
%
% 	freqIndexis a cell with the frequency vectors.
%
% 	degree is degree of the FFT you wish to compute.
%
%
% 	degreeFFT is the FFT of the specified degree.

function degreeFFT = inputFFTDegree(X, freqIndex, degree)
    
    if degree > 1
       degreeFFT = inputFFTDegree(X, freqIndex, degree-1).*X(freqIndex{degree});
    else
       degreeFFT = X(freqIndex{1}); 
    end


end

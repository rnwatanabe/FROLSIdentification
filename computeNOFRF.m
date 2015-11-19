%% Computes the NOFRF (Nonlinear Output Frequency Response Function) for the specified input
% Hn is the cell with all the GFRFs until the specified degree
% X is the FFT of the input signal obtained with the computeSignalFFT function
% maxDegree is the maximal degree to have the NOFRF computed
% Fs is the sampling frequency, in Hz
% fres is the frequency resolution of the FFT, in Hz
% fmin in the lower frequency limit of the NOFRF computation
% fmax in the upper frequency limit of the NOFRF computation
% NOFRF is a vector with the NOFRF of the system for the given input at
%each frequency
% f is the vector of frequencies

function [NOFRF, f] = computeNOFRF(Hn, X, maxDegree, Fs, fres, fmin, fmax)
    H1 = matlabFunction(Hn{1});
    fv = -Fs/2:fres:Fs/2;
    f = fmin:fres:fmax; 
    
    NOFRF = zeros(size(f));
    for j = 1:length(f)
        NOFRF(j) = 2 * H1(f(j)) * X(abs(fv-f(j))<=1e-6) ;
    end
    
    for i = 2:maxDegree
       i
       for j = 1:length(f)
           if f(j) == 0
              NOFRFConst = 1; 
           else
              NOFRFConst = 2; 
           end
           NOFRF(j) = NOFRF(j) +  NOFRFConst * computeDegreeNOFRF(Hn, X, Fs, i, f(j), fres);
       end       
    end  
end
%% Computes the NOFRF of the specified degree in the frequency f
% Hn is the cell with all the GFRFs until the specified degree
% X is the FFT of the input signal obtained with the computeSignalFFT function
% Fs is the sampling frequency, in Hz
% degree is the degree of the NOFRF to be computed 
% f if the frequency, in Hz, to have the NOFRF computed
% fres is the frequency resolution of the FFT, in Hz
% DegreeOFRF

function DegreeNOFRF = computeDegreeNOFRF(Hn, X, Fs, degree, f, fres)
        HnFunction = matlabFunction(Hn{degree});
        X = X';
        fv = -Fs/2:fres:Fs/2;
        
        for i = 1:degree
            if i == 1
                fnCall = ['fVector{' num2str(i) '}']; 
                XCall = ['X(freqIndex{' num2str(i) '})'];
            else
                fnCall = [fnCall ', fVector{' num2str(i) '}'];
                XCall = [XCall '.*X(freqIndex{' num2str(i) '})'];
            end
        end
                
        fresHn = fres;
        fVector = determineFrequencies(f, fresHn, degree, Fs);
        
        for i = 1:degree
            [A1, freqIndex{i}] = ismember(round(fVector{i}/fres), round(fv/fres)); 
        end

        eval(['DegreeNOFRF = sum(HnFunction(' fnCall ').*' XCall ');']);
                
end
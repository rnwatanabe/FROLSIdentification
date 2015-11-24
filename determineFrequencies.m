%% determine the combination of n frequencies that sum up f. Used in the NOFRF computation
%
%
%	fVectorValid = determineFrequencies(f, fres, n, Fs)
%	where:
%	
% 	f is the frequency, in Hz, that you wish to find the combinations of
%	frequencies that sum to f. Example: for f = 2 and n = 2, you will have:
%	f1=4 and f2 =-2, f1=0 and f2 = 2, and so on...
%
% 	fres is the frequency resolution that the search of combinations will use.
%
% 	n is the number of frequencies to make the combinations.
%
% 	Fs is the sampling frequency, in Hz.
%
% 	fVectorValid is a cell of n vectors with found combinations. It eliminates the frequencies 
%	that are above the Nyquist frequency (Fs/2).


function fVectorValid = determineFrequencies(f, fres, n, Fs)
    fVectorTemp = cell(n-1,1);
    fVector = cell(n-1,1);
    fVectorValid = cell(n,1);
    
    for i = 1:n-1
        fVectorTemp{i} = -Fs/2:fres:Fs/2;
        if i == 1
            fCoordVector = ['fVector{' num2str(i) '}'];
            fVectorTempCall = ['fVectorTemp{' num2str(i) '}'];
        else
            fCoordVector = [fCoordVector ', fVector{' num2str(i) '}'];
            fVectorTempCall = [fVectorTempCall ', fVectorTemp{' num2str(i) '}'];
        end
    end   
    
    fCoordVector = [fCoordVector ', fVector{' num2str(n) '}'];
    fVectorTempCall = [fVectorTempCall ', f'];
    
    eval(['[' fCoordVector '] = meshgrid(' fVectorTempCall ');']);
    
    
    for j = 1:n-1
         fVector{n} = fVector{n} - fVector{j};
    end
    validFrequenciesIndex = abs(fVector{n})<=Fs/2;
    for j = 1:n
         fVectorValid{j} = reshape(fVector{j}(validFrequenciesIndex), [], 1);
    end
end

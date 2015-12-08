% Determine the combination of n frequencies that sum up f. Used in the NOFRF computation
%
% written by: Renato Naville Watanabe 
%
% fVectorValid = determineFrequencies(f, fres, n, Fs)
%	
%
% Inputs:
%   
%   f: float, the frequency, in Hz, that you wish to find the combinations of
%   frequencies that sum to f. Example: for f = 2 and n = 2, you will have:
%   f1=4 and f2 =-2, f1=0 and f2 = 2, and so on...
%
%   fres: float, the frequency resolution that the search of combinations will use.
%
%   n: integer, the number of frequencies to make the combinations.
%
%   f_inputMin: float, lower frequency limit of the input signal, in Hz.
%
%   f_inputMax: float, upper frequency limit of the input signal, in Hz.
%
%
% Output:
%
%   fVector:  cell, contains n vectors with the found frequency
%   combinations. It eliminates the frequency combinations that contains frequencies above the Nyquist frequency (Fs/2).


function fVector = determineFrequencies(f, fres, n, f_inputMin, f_inputMax)
    fVectorTemp = cell(n-1,1);
    fVector = cell(n,1);
        
    for i = 1:n-1
        fVectorTemp{i} = [-f_inputMax:fres:-f_inputMin f_inputMin:fres:f_inputMax];
        if i == 1
            fCoordVector = ['fVector{' num2str(i) '}'];
            fVectorTempCall = ['fVectorTemp{' num2str(i) '}'];
            fVectorDefinitionString = ['length(fVectorTemp{' num2str(i) '}) ']; 
        else
            fCoordVector = [fCoordVector ', fVector{' num2str(i) '}'];
            fVectorTempCall = [fVectorTempCall ', fVectorTemp{' num2str(i) '}'];
            fVectorDefinitionString = [fVectorDefinitionString 'length(fVectorTemp{' num2str(i) '}) ']; 
        end
    end   
    
    
    fCoordVector = [fCoordVector ', fVector{' num2str(n) '}'];
    fVectorTempCall = [fVectorTempCall ', f'];
    
    for i = 1:n-1
        eval(['fVector{i} = zeros([' fVectorDefinitionString ']);']);
    end
    
    eval(['[' fCoordVector '] = ndgrid(' fVectorTempCall ');']);
    
    clear fVectorTemp
    
    for j = 1:n-1
         fVector{n} = fVector{n} - fVector{j};
    end
    validFrequenciesIndex = ((abs(fVector{n}) <= f_inputMax) & (abs(fVector{n}) >= f_inputMin));
    for j = 1:n
        fVector{j} = reshape(fVector{j}(validFrequenciesIndex), [], 1);
    end
end

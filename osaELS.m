%% Implements the one-step-ahead prediction algorithm for the ELS algorithm (page 124 from Billings, SA (2013)). 
%	The difference to the osa function is that this function incorporates the residue of the identification.
%
%
%	[yest xi] =  osaELS(u, y, e, beta, Mp, I, noise)
%	where:
%	
% 	u is the input signal.
%
% 	y is the output signal.
%
% 	e is the output signal.
%
% 	beta is a vector with the coefficients of the model terms.
%
% 	Mp is the number of terms found in the identification process, withot the residues.
% 	
%	I are the cells with the vector corresponding to each model term, obtained from the modelLags function.
%
% 	noise is a True/False variable to indicate if you have a residue signal. Normally you call it set to 0. The recursive
%	calls will call it set to 1.
%
%
% 	yest is the estimated output vector.
%
% 	xi is the residue of the estimation.

function [yest xi] =  osaELS(u, y, e, beta, Mp, I, noise)
    N = length(u);
    Mlag = 0;
    for i = 1:length(I)
        Nt = length(I{i})/2;
        for j = 1:Nt
            if (I{i}(j*2)>=Mlag)
               Mlag = I{i}(j*2);
            end
        end
    end
    
    p = buildPElsMatrix(u, y, e, I, noise, Mp);
    if (noise == 1)
        yest = p*beta;
    else
        yest = p*beta(1:Mp);
    end

    xi = y(Mlag+1:end) - yest;
end

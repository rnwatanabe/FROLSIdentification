% Implements the one-step-ahead prediction algorithm for the ELS algorithm (page 124 from Billings, SA (2013)). 
% The difference to the osa function is that this function incorporates the residue of the identification.
%
% written by: Renato Naville Watanabe 
%
% [yest xi] =  osaELS(u, y, e, beta, Mp, I, noise)
%	
% Inputs:
%	
%   u: vector of floats, the input signal.
%
%   y: vector of floats, the output signal.
%
%   e: vector of floats, the output signal.
%
%   beta: vector of floats, coefficients of the model terms.
%
%   Mp: integer, number of terms found in the identification process, withot the residues.
% 	
%   I: cell, obtained from the modelLags function.
%
%   noise: boolean, variable to indicate if you have a residue signal. Normally you call it set to 0. The recursive
%   calls will call it set to 1.
%
%
% Outputs:
%
%   yest: vector of floats, estimated output vector.
%
%   xi: vector of floats, residue of the estimation.

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

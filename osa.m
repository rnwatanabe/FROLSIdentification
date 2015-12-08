% Implements the one-step-ahead prediction algorithm  (page 124 from Billings, SA (2013)).
%
% written by: Renato Naville Watanabe 
%
% [yest xi] = osa(u, y, beta, l, degree, mu, my, delay)
%
% Inputs:
%	
%   u: vector of floats, input signal.
%
%   y: vector of floats, output signal.
%
%   beta: vector of floats, the coefficients of the model terms.
%
%   l: vector of integers, the indices of the model terms, sorted in the same order of the beta vector. 
%   It works together with the buildPMatrix function.
%
%   degree: integer, the maximal polynomial degree that you want the FROLS method to look for (it has been tested until 
%   the 9th degree).
% 	
%   mu: integer, maximal lag of the input signal.
%
%   my: integer, maximal lag of the output signal.
%
%   delay: integer, how much lags you want to not consider in the input terms. It comes from a previous knowledge of your system.
%
%
% Outputs:
%
%   yest: vector of floats, the estimated output vector.
%
%   xi: vector of floats, the residue of the estimation.

function [yest xi] = osa(u, y, beta, l, degree, mu, my, delay)
    M0 = length(beta); 
    [p, D]= buildPMatrix(u, y, degree, mu, my, delay);
    p=p(:,l(1:M0));
    yest = p*beta;
    xi = yest - y(max(mu,my)+1:end);
end

%% Implements the one-step-ahead prediction algorithm  (page 124 from Billings, SA (2013)).
%
%
%	[yest xi] = osa(u, y, beta, l, degree, mu, my, delay)
%	where:
%	
% 	u is the input signal.
%
% 	y is the output signal.
%
% 	beta is a vector with the coefficients of the model terms.
%
% 	l is a vector with the indices of the model terms, sorted in the same order of the beta vector. 
%	It works together with the buildPMatrix function.
%
% 	degree is the maximal polynomial degree that you want the FROLS method to look for (it has been tested until 
%	the 9th degree).
% 	
%	mu is the maximal lag of the input signal.
%
% 	my is the maximal lag of the output signal.
%
% 	delay is how much lags you want to not consider in the input terms. It comes from a previous knowledge of your system.
%
%
% 	yest is the estimated output vector.
%
% 	xi is the residue of the estimation.

function [yest xi] = osa(u, y, beta, l, degree, mu, my, delay)
    M0 = length(beta); 
    [p, D]= buildPMatrix(u, y, degree, mu, my, delay);
    p=p(:,l(1:M0));
    yest = p*beta;
    xi = yest - y(max(mu,my)+1:end);
end

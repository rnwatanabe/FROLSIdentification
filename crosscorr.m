%computes the normalized cross-correlation (formula 5.3 from Billings, SA (2013)) between the signals x and y
% x and y are column-vectors with the signals to compute the cross-correlation
% alpha is the significance value of the confidence boundaries. Usually is used alpha = 0.05.
% phi is the vector with the normalized crosscorrelation
% lags is the vector with the corresponding lags of the phi vector
% CB are the confidence boundaries to consider that the cross-correlation at a given value is zero.

function [phi, lags, CB] = crosscorr(x,y, alpha)
    [c, lags] = xcorr(x - mean(x), y - mean(y), 'biased');
    phi = c/(std(x-mean(x), 1)*std(y-mean(y), 1));
    N = length(x);
    CB = [-norminv(alpha/2,0,1)/sqrt(N) norminv(alpha/2,0,1)/sqrt(N)];   
end


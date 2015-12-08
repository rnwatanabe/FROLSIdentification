% Finds the number of terms in the matrizx p (see page 36 from Billings, SA (2013)).
%
% written by: Renato Naville Watanabe 
%
% size = findPMatrixSize(mu, my, degree)
%	
%
% Inputs:
%   
%   mu: integer, maximal lag for the input signal.
%
%   my: ineteger, maximal lag for the output signal.
%
%
% Outputs:
%
%   size: integer, number of candidates for the identification process.

function size = findPMatrixSize(mu, my, degree)
    n = mu + my;
    size = factorial(1+degree)/factorial(1)/factorial(degree);
    for i =2:n
        size = (i+degree)/i*size;
    end
end

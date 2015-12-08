% Find the coefficients of the coefficients in the format of Equation 6.46 of Billings (2013).
%
% written by: Renato Naville Watanabe 
%
% [C, maxLag] = findCCoefficients(a, I)
%	
%
% Inputs:
%   
%   a: vector of floats, coefficients of the NARX model.
%
%   I: cell, obtained from the modelLags functions.
%
%
% Outputs:
%   
%   C: struct, contains the coefficients of the model, in the format of Equation 6.46 of Billings (2013):
%   C.c_pq where:
%   p is  the number that the output signal appears in a term.
%   q is  the number that the input signal appears in a term.
%   For example, a model with the following terms:
%   y(k) = -2*y(k-1) + 4*y(k-2) - 1.5*u(k-5) + 10.5*u(k-6)y(k-2)
%   has the following C struct:
%   C.c_10 = [-2 4]
%   C.c_01 = [0 0 0 0 -1.5]
%   C.c11 = [0 0 0 0 0 0;...
%            0 0 0 0 0 10.5]
%
%   maxLag: integer, maximal Lag of the model.


function [C, maxLag] = findCCoefficients(a, I)
    Mp = length(a);
    maxLag = 0;
    for i = 1:Mp
       lags_y = [];
       lags_u = [];
       p = 0;
       q = 0;
       for j = 1:2:length(I{i})-1       
           if (I{i}(j+1) > maxLag)
                 maxLag = I{i}(j+1); 
           end
           if (I{i}(j) == 121)
              if (isempty(lags_y)) 
                  lags_y = [num2str(I{i}(j+1))]; 
              else
                  lags_y = [lags_y, ',' num2str(I{i}(j+1))]; 
              end
              p = p + 1;
           else
              if (isempty(lags_u)) 
                  lags_u = [num2str(I{i}(j+1))]; 
              else
                  lags_u = [lags_u, ',' num2str(I{i}(j+1))]; 
              end
              q = q + 1;
           end
       end
       if (~isempty(lags_y) && ~isempty(lags_u))
          lags_y = [lags_y, ',']; 
       end
       lags = strcat(lags_y, lags_u);
       eval(['C.c_' num2str(p) '' num2str(q) '(' lags ') = ' num2str(a(i)) ';']);
    end
end

% This function performs the identification of a NARX model that represents the dynamic of residue obtained during 
% the identification of a system with signal1 as input and signal2 as output.
%
% written by: Renato Naville Watanabe 
%
% [Dn, an, ln] = NARXNoiseModelIdentification(signal1, signal2, degree, mu, my, me, delay, dataLength, ...
% divisions, pho,  a, la)
%	
% Inputs:
%
%   signal1: matrix of floats, input signal. It can contain multiple trials of the same system. Each trial must be in one column 
%   of the signal1 matrix.
%
%   signal2: matrix of floats, output signal. It can contain multiple trials of the same system. Each trial must be in one column 
%   of the signal2 matrix. Each column of signal2 must be correspondent to the same column number of signal1.
%
%   degree: integer, maximal polynomial degree that you want the FROLS method to look for (it has been tested until the 
%   9th degree).
%
%   mu: integer, maximal lag of the input signal.
%
%   my: integer, maximal lag of the output signal.
%
%   me: integer, maximal lag of the residue signal.
%
%   delay: integer, how much lags you want to not consider in the input terms. It comes from a previous knowledge of your system.
%
%   dataLength: integer, number of steps of each column of the signal1 and 2 matrices to consider during the identification 
%   of the system. Normally a very high number do not leads to good results. 400 to 600 should be fine.
%	
%   divisions: integer, number of data parts (of dataLength length) to consider from each trial (each column) of the signals.
% 
%   pho: float, stop criteria.
%
%   a: vector of floats, coefficients of the chosen terms during the identification of the system.
%
%   la: vector of integers, indices of the chosen terms during the identification of the system.
%
%
% Outputs:
%
%   Dn: cell, contains the strings with the terms found during the residue idetification. u is the input 
%   signal, y is the output signal and e is the residue signal.
%
%   an: vector of floats, coefficients of the chosen terms during the identification of the residue.
%
%   ln: vector of integers, indices of the chosen terms during the identification of the residue.

function [Dn, an, ln] = NARXNoiseModelIdentification(signal1, signal2, degree, mu, my, me, delay, dataLength, ...
    divisions, pho,  a, la)
   
    global l q g err A ESR M0;

    subjects = size(signal1, 2);
    
   %% 
   
   k = 1;
   for i = 1:subjects
       for j = 1:divisions
           begin = randi([1 length(signal1) - dataLength - 1], 1);
           u(:,k) = (signal1(begin+1:begin + dataLength));
           y(:,k) = (signal2(begin+1:begin + dataLength));
           [yest xi(:,k)] = osa(u(:,k), y(:,k), a, la, degree, mu, my, delay);
           [pn(:,:,k), D]= buildPNoiseMatrix(u(mu+1:end, k), y(my:end, k), xi(:, k), degree, mu, my, me, delay);
           xi_output(:,k) = xi(max([mu my me]) + 1:end, k);
           k = k + 1;
       end
   end
   
   % noiseidentification of model 1 to 2
   q = []; err=[]; A=[]; g=[];
   s = 1;
   ESR = 1;
   M = size(pn,3);
   N = size(pn,1);
   l = zeros(1,M);

   
   %%
   V = ver;
   parallel = 0;
   for i = 1:length(V)
      if (strcmp(V(i).Name,'Parallel Computing Toolbox'))
          parallel = 1;
      end
   end
   if parallel
      matlabpool open 6 
      mfrols_par(pn, xi_output, 1e-5, pho, s, 0);
      matlabpool close
   else
       beta = mfrols(pn, xi_output, pho, s);
   end
%%
   err=err(1:M0)';
   l=l(1:M0)';
   ln = l;
   Dn=D(l)';
   for i = 1:subjects
    an(:,i) = mean(beta(:,(i-1)*divisions+1:i*divisions), 2);
   end     
end

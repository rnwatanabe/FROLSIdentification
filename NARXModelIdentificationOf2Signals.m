% This function performs the identification of a NARX model that represents the dynamic of the system with signal1 as 
% input and signal2 as output.
%
% written by: Renato Naville Watanabe 
%
%
% [Da, a, la, ERRs] = NARXModelIdentificationOf2Signals(signal1, signal2, degree, mu, my, delay, dataLength, ...
% divisions, pho)
%	
% Inputs:
%
%   signal1: matrix of floats, input signal. It can contain multiple trials of the same system. Each trial must be in one 
%   column of the signal1 matrix.
%
%   signal2: matrix of floats, output signal. It can contain multiple trials of the same system. Each trial must be in one 
%   column of the signal2 matrix. Each column of signal2 must be correspondent to the same column number of signal1.
%
%   degree: integer, maximal polynomial degree that you want the FROLS method to look for (it has been tested until the 
%   9th degree).
%
%   mu: integer, maximal lag of the input signal.
%
%   my: integer, maximal lag of the output signal.
%
%   delay: integer, lags you want to not consider in the input terms. It comes from a previous knowledge of 
%   your system.
%
%   dataLength: integer, number of steps of each column of the signal1 and 2 matrices to consider during the 
%   identification of the system. Normally a very high number do not leads to good results. 
%   400 to 600 should be fine.
%
%   divisions: integer: number of data parts (of dataLength length) to consider from each trial (each column) 
%   of the signals.
%
%   pho: float, stop criteria.
%
%
% Outputs:
%
%   Da: cell, contains the strings with the terms found during the system idetification. u is the input 
%   signal and y is the output signal.
%
%   a: vector of floats, coefficients of the chosen terms during the identification of the system.
%
%   l: vector of integers, indices of the chosen terms during the identification of the system.


function [Da, a, la, ERRs] = NARXModelIdentificationOf2Signals(signal1, signal2, degree, mu, my, delay, dataLength, ...
    divisions, pho)

flag = 0;

global l q g err A ESR M0; % The global variables are used due to the lack of pointers in Matlab

%%
trials = size(signal1, 2);
%%
numberOfCandidates = round(findPMatrixSize(mu - delay + 1, my, degree));

%%
% p matrix
k = 1;
for i = 1:trials
    for j = 1:divisions
        begin = randi([1 length(signal1) - dataLength - 1], 1);
        u(:,k) = signal1(begin+1:begin + dataLength, i);
        y(:,k) = signal2(begin+1:begin + dataLength, i);
        [p(:,:,k), D]= buildPMatrix(u(:,k), y(:,k), degree, mu, my, delay);
        output(:,k) = y(max(mu,my) + 1:end, k);
        k = k + 1;
    end
end
% identification of 1 to 2
q = []; err=[]; A=[]; g=[]; 
s = 1;
ESR = 1;
M = size(p, 3);
l = zeros(1, M);
%% parallel toolbox verification
V = ver;
parallel = 0;
for i = 1:length(V)
    if (strcmp(V(i).Name,'Parallel Computing Toolbox'))
        parallel = 1;
    end
end
if parallel
    matlabpool open 6 % this is the number of cores to use during the processing. You can change it.
    beta = mfrols_par(p, output, phoL, pho, s, flag);
    matlabpool close
else
    beta = mfrols(p, output, pho, s);
end
%%
err = err(1:M0)';
la = l(1:M0)';
Da = D(la)';
for i = 1:trials
    a(:,i) = mean(beta(:,(i-1)*divisions + 1:i*divisions), 2);
end

ERRs = sum(err);
end

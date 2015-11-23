%% This function performs the identification of a NARX model that represents the dynamic of the system with signal1 as 
%input and signal2 as output
% signal1 is the input signal. It can contain multiple trials of the same system. Each trial must be in one column of 
%the signal1 matrix.
% signal2 is the output signal. It can contain multiple trials of the same system. Each trial must be in one column of 
%the signal2 matrix. Each column of signal2 must be correspondent to the same column number of signal1
% degree is the maximal polynomial degree that you want the FROLS method to look for (it has been tested until the 
%9th degree)
% mu is the maximal lag of the input signal
% my is the maximal lag of the output signal
% delay is how much lags you want to not consider in the input terms. It comes from a previous knowledge of your system
% dataLength is the number of steps of each column of the signal1 and 2 matrices to consider during the identification 
%of the system. Normally a very high number do not leads to good results. 400 to 600 should be fine.
% divisions is the number of data parts (of dataLength length) to consider from each trial (each column) of the signals.
% phoL is the stop criteria, in the case of flag=1 (see the mfrols file), duing the first 45 steps
% pho is the stop criteria 
% Da is a vector in which each element is a string with a term found during the system idetification. u is the input 
%signal, y is the output signal
% a is a vector with the coefficients of the chosen terms during the identification of the system
% l is a vector with the indices of the chosen terms during the identification of the system


function [Da, a, la, ERRs] = NARXModelIdentificationOf2Signals(signal1, signal2, degree, mu, my, delay, dataLength, ...
    divisions, phoL, pho)

flag = 0;

global l q g err An ESR M0;

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
q = []; err=[]; An=[]; g=[]; 
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
    beta = mfrols(p, output, phoL, pho, s, flag);
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

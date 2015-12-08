% This function performs the identification of a NARMAX model that represents the dynamic of the system  
% with signal1 as input and signal2 as output. It is used after the identification of a NARX model 
% and of the residue of the NARX model. Only after this step, the coefficients of the model can be considered reliable.
%
% written by: Renato Naville Watanabe 
%
% [a, an, xin] = NARMAXCompleteIdentification(signal1, signal2, Da, Dn, dataLength, divisions,  ...
%   delta, degree, degree_n) 
%	
% Inputs:
%
%   signal1: matrix of floats, input signal. It can contain multiple trials of the same system. Each trial must be 
%   in one column of the signal1 matrix.
%
%   signal2: matrix of floats, output signal. It can contain multiple trials of the same system. Each trial must be
%   in one column of the signal2 matrix.
%
%   Da: cell, contains the strings with the terms found during the system idetification. u is the input 
%   signal and y is the output signal.
%
%   Dn: cell, contains the strings with the terms found during the residue idetification. u is the input 
%   signal, y is the output signal and e is the residue signal.
%
%   dataLength: integer, number of steps of each column of the signal1 and 2 matrices to consider during the
%   identification of the system. Normally a very high number do not leads to good results. 
%   400 to 600 should be fine.
%
%   divisions: integer, number of data parts (of dataLength length) to consider from each trial (each column) 
%   of the signals.
%
%   delta: float, stop criteria to the ELS algorithm.
%
%   degree: integer, maximal polynomial degree of the NARX model.
%
%   degree_n: integer, maximal polynomial degree of the NARX model of the residue. 
%
%
% Outputs:
%
%   a: vector of floats, coefficients of the NARX model.
%
%   an: vector of floats, coefficients of the NARX model of the residue.
%
%   xi: vector of floats, residue signal obtained form the last ELS iteration.

function [a, an, xin] = NARMAXCompleteIdentification(signal1, signal2, Da, Dn, dataLength, divisions,  ...
    delta, degree, degree_n)
    
    global t
    subjects = size(signal1, 2);
    %%
    %
    Dc =[Da;Dn];
    I = modelLags(Dc);
    maxLag = 0;
    for i = 1:length(I)
         Nt = length(I{i})/2;
         for j = 1:Nt
             if maxLag < I{i}(j*2)
                 maxLag = I{i}(j*2);
             end
         end
    end  
    Mp = length(Da);    
    
    
    
    %% complete identification for signals 1 to 2
    k = 1;
    for i = 1:subjects
        for j = 1:divisions
            begin = randi([1 length(signal1) - dataLength - 1], 1);
            u(:,k) = (signal1(begin+1:begin + dataLength));
            y(:,k) = (signal2(begin+1:begin + dataLength));
            pp(:,:,k) = buildPElsMatrix(u(:,k), y(:,k), 0, I, 0, Mp);
            k = k + 1;
        end
    end      
    
    M0 = length(I) - Mp;
    
    pn = zeros(dataLength - 2*maxLag, M0, divisions*subjects);
    xi = zeros(size(pp(maxLag + 2:end,:,:), 1), divisions*subjects);
    
   
    t = 0;
    beta=zeros(Mp, divisions*subjects);
    [p, beta, xin, yest] = els(pp(maxLag+2:end,:,:), pn(:,:,:), Mp, ...
    u(2*maxLag+2:end,:), y(2*maxLag+2:end,:), delta, degree, degree_n, ...
    maxLag, xi(maxLag+2:end,:), I, beta);
    for i = 1:subjects
       a(:,i) = mean(beta(1:Mp,(i-1)*divisions + 1:i*divisions), 2); 
       an(:,i) = mean(beta(Mp+1:end, (i-1)*divisions + 1:i*divisions), 2); 
    end
    
    %% identication process validation
%     V = ver;
%     for i = 1:length(V)
%         if (strcmp(V(i).Name,'Octave'))
%             pkg load signal;
%         end
%     end
%     xiValid = xin(end-round(0.9*size(xin,1)):end,1:divisions:end);
%     uValid = u(end-size(xiValid,1)+1:end, 1:divisions:end);
%     validation(uValid,xiValid, 2*maxLag);
%     
      
end

%% obtain a vector formed by integers corresponding to the ASCII code of u or y of the identified terms and the 
%correspondibg lags. It is used during the identification of the NARMAX model to read the vector of strings D.
% D is a vector of strings with the chosen terms
% I is a vector with the following format:
% ___________________
%| 117 or 121 or 101|  % 117 corresponds to the input signal u, 121  to output signal y and 101 to the residue signal e
%|      lag         |  % lag corresponds to the lag of the signal in the preceding cell
%   
%    this format of vector continues to represent a term of multiplied inputs, outputs and residue.
% Example:
% u(k-1)u(k-2)y(k-5)e(k-2) corresponds to>
%       _________
%      |   117   |
%      |    1    |
%  I = |   117   |
%      |    2    |
%      |   121   |
%      |    5    |
%      |   101   |
%      |    2    |
%      |_________|


function ind = modelLags(D)
    for j = 1:length(D)
       I{j} = sscanf(D{j}, '%c(k-%d)'); 
    end
    ind = I;
end

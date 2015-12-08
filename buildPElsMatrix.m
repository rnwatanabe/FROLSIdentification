% Function to build the P matrix for the  ELS identification process. 
%
% written by: Renato Naville Watanabe 
%
% p = buildPElsMatrix(u, y, e, I, noise, Mp)
%	
% Inputs:
%	
%   u: vector of floats, input signal.
%
%   y: vector of floats, output signal.
%
%   e: vector of floats, residue signal.
%
%   I: cell, obtained from the modelLags function.
% 	
%   noise: boolean, indicate if you have a residue signal. Normally you call it set to 0. The recursive
%   calls will call it set to 1.
%
%   Mp: integer, number of terms found in the identification process, without the residues.
%
%
% Outputs:
%
%   p: matrix of floats, matrix for the ELS identification process. 


function p = buildPElsMatrix(u, y, e, I, noise, Mp)
     if (noise == 1)
        Nl = length(I); 
        N = length(e);
        begin = length(u) - length(e);
     else
        Nl = Mp;
        N = length(u);
        begin = 0;
     end
     %%
     maxLag = 0;
     for i = 1:length(I)
         Nt = length(I{i})/2;
         for j = 1:Nt
             if maxLag < I{i}(j*2)
                 maxLag = I{i}(j*2);
             end
         end
     end  
     %%
     if (noise == 1)
         begin = length(u) - length(e) + maxLag;
     else
         begin = maxLag;
     end
     %%
     p = zeros(N-maxLag,Nl);
     for k = 1:N-maxLag
         for i = 1:Nl
             p(k,i) = 1;
             Nt = length(I{i})/2;
             for j = 1:Nt
                 if (I{i}((j-1)*2+1) == 117)
                     p(k,i) = p(k,i)*u(begin+k-I{i}(j*2));
                 else if (I{i}((j-1)*2+1) == 121)
                         p(k,i) = p(k,i)*y(begin+k-I{i}(j*2));
                     else if (I{i}((j-1)*2+1) == 101)
                             p(k,i) = p(k,i)*e(maxLag+k-I{i}(j*2));
                         end
                     end
                 end
             end
         end
     end
end

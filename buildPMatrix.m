% Function to build the P matrix for the FROLS identification process
%
% written by: Renato Naville Watanabe 
%
% [p, D] = buildPMatrix(u, y, degree, mu, my, delay)
%	
% Inputs:
%
%   u: vector of floats, input signal.
%
%   y: vector of floats, output signal.
%
%   degree: integer, maximal polynomial degree that you want the FROLS method to look for (it has been tested until the
%   9th degree).
%
%   mu: integer, the maximal lag of the input signal.
%	
%   my: integer, the maximal lag of the output signal.
%
%   delay: integer, how much lags you want to not consider in the input terms. It comes from a previous knowledge of your system
%
%
% Outputs:
%   
%   p: matrix of floats, the P matrix to be used in the identification process by the FROLS algorithm. 
%
%   D: cell, contains the strings with the candidate terms. Each element of D corresponds to a column of the P matrix.

function [p, D] = buildPMatrix(u, y, degree, mu, my, delay)
    N=length(u);
    p=zeros(N-max(mu,my), round(findPMatrixSize(mu - delay + 1, my, degree)));
    %% build p Matrix
    for k=1:N-max(mu, my)
        xb = [u(k + max(mu,my) - delay:-1:k + max(mu,my) - mu)'  y(k + max(mu,my) - 1:-1:k + max(mu,my) - my)'];
        j=1;
        for l=0:degree
            if (l==0)
                p(k, j)=1;
                m=1;
                len(l+1)=1; 
            else if (l==1)
                    p(k,j:j+(mu - delay + 1) + my - 1) = xb;
                    m=length(xb);
                    len(l+1)=m;
                else
                    j1=j;                    
                    if (l==2)
                        subFactor = 0;
                        subsubFactor = 0;
                    else
                        subFactor = len(l-2);
                        if (l==3)
                            subsubFactor = 0;
                        else
                            subsubFactor = len(l-3);
                        end
                    end
                    numberFactor = len(l);
                    subSum = 0;                    
                    for i=1:length(xb)
                       p(k, j1:j1 + numberFactor - 1) = ...
                            kron(xb(i), p(k,  j-numberFactor:j-1));
                        j1 = j1+numberFactor;
                        if (i >= 2)
                            subSum = subSum + subFactor - subsubFactor*(i-2);
                        end
                        numberFactor = numberFactor - len(l-1) + subSum;
                    end
                    len(l+1) = j1 - j;                    
                end
            end
            j = j + len(l+1);
        end        
    end
    
    
    %% Build D dictionary
    j=1;
    for l=0:degree
        if (l==0)
            D{j}='1';
            len(l+1)=1;
        else if (l==1)
                m = 1;
                for i=delay:mu
                    D{j+m-1} = ['u(k-' num2str(i) ')'];
                    Db{m} = D{j+m-1};
                    m = m + 1;
                end
                for i = 1:my
                    D{j+m-1} = ['y(k-' num2str(i) ')'];
                    Db{m} = D{j+m-1};
                    m = m + 1;
                end
                len(l+1) = length(Db);
            else
                j1 = j;                
                if (l==2)
                    subFactor = 0;
                    subsubFactor = 0;
                else
                    subFactor = len(l-2);
                    if (l==3)
                        subsubFactor = 0;
                    else
                        subsubFactor = len(l-3);
                    end
                end
                numberFactor = len(l);
                subSum = 0;
                
                for i=1:length(Db)
                    for q=j1:j1+numberFactor-1
                        D{q} = [Db{i} D{j-numberFactor+q-j1}];
                    end
                    j1=j1+numberFactor;
                    if (i>=2)
%                         subVector = 0;
%                         for n = 2:l-2
%                             subVector = subVector + (max((i-n)*(1+1*(n-1))/2, 0)*((-1)^(n - 1)))*len(l - (n + 1));
%                         end
%                         subSum = subSum + subFactor + subVector;
                        subSum = subSum + subFactor - subsubFactor*(i-2);
                    end
                    numberFactor = numberFactor - len(l-1) + subSum;
                end
                len(l+1)=j1-j;
            end
        end
        j=j+len(l+1);
    end
end

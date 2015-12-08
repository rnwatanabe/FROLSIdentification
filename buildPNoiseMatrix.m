% Function to build the P matrix for the FROLS identification process of the residue from the system identification 
% of the signals
%
% written by: Renato Naville Watanabe 
%
% [p, D] = buildPNoiseMatrix(u, y, e, degree, mu, my, me, delay)
%	
%
% Inputs:
%
%   u: vector of floats, input signal.
%
%   y: vector of floats, output signal.
%
%   e: vector of floats, residue signal.
%
%   degree: integer, maximal polynomial degree that you want the FROLS method to look for (it has been tested until the 9th 
%   degree).
%
%   mu: integer, the maximal lag of the input signal.
%
%   my: integer, the maximal lag of the output signal.
%
%   me: integer, the maximal lag of the residue signal.
%
%   delay: integer, how much lags you want to not consider in the input terms. It comes from a previous knowledge of your system.
%
%
% Outputs:
%
%   p: matrix of floats, the matrix used in the identification process of the residue of the system identification by the FROLS algorithm. 
%
%   D: cell, contains the strings with candidate terms. Each element of D corresponds to a column of the P matrix.

function [p, D] = buildPNoiseMatrix(u, y, e, degree, mu, my, me, delay)
    N=length(u);
    %p=zeros(N-max([mu my me]), round(findPMatrixSize((mu), my+me, degree)-findPMatrixSize((mu), my, degree)));
    %% build p Matrix
    for k=1:N-max([mu my me])
        xb = [u(k + max([mu my me]) - delay:-1:k + max([mu my me]) - mu)'  ...
            y(k + max([mu my me]) - 1:-1:k + max([mu my me]) - my)'...
            e(k + max([mu my me]) - 1:-1:k + max([mu my me]) - me)'];
        eb = e(k + max([mu my me]) - 1:-1:k + max([mu my me]) - me)';
        j=1;
        for l=1:degree
            if (l==1)
                p(k,j:j+me-1) = eb;
                m=length(eb);
                len(l)=m;
            else if (l==2)
                    j1=j;
                    for i=1:length(xb)
                        p(k, j1:j1+length(eb)-max(0, i - (mu -delay + 1) - my - 1)-1) = ...
                            kron(xb(i), eb(max(0, i - (mu -delay + 1) - my - 1)+1:end));
                        j1=j1+length(eb)-max(0, i - (mu -delay + 1) - my - 1);
                    end
                    len(l)=j1-j;
                else
                    j1=j;
                    
                    
                    if (l==3)
                        subFactor = 0;
                        subsubFactor = 0;
                    else
                        subFactor = len(l-3);
                        if (l==4)
                            subsubFactor = 0;
                        else
                            subsubFactor = len(l-4);
                        end
                    end
                    numberFactor = len(l-1);
                    subSum = 0;
                                        
                    for i=1:length(xb)
                        p(k, j1:j1 + numberFactor - 1) = ...
                            kron(xb(i), p(k,  j - numberFactor:j-1));
                        j1 = j1 + numberFactor;
                        if (i>=2)
                            subSum = subSum + subFactor - subsubFactor*(i-2);
                        end
                        numberFactor = numberFactor - len(l-2) + subSum;
                    end
                    len(l) = j1 - j;                   
                end
            end
            j=j+len(l);
        end
    end    
    
    %% Build D dictionary
    j=1;
    for l=1:degree
        if (l==1)
            for i=delay:mu+my+me
                if (i<=mu)
                    Db{i-delay + 1} = ['u(k-' num2str(i) ')'];
                else if (i<=mu+my)
                           Db{i - delay + 1} = ['y(k-' num2str(i-mu) ')'];
                     else
                           Db{i - delay + 1} = ['e(k-' num2str(i-mu-my) ')'];
                           Deb{i-mu-my} = ['e(k-' num2str(i-mu-my) ')'];
                           D{j+i-mu-my-1} = ['e(k-' num2str(i-mu-my) ')'];
                     end
                end
            end
            len(l) = length(Deb);
        else if (l==2)
                j1=j;
                for i=1:length(Db)
                    for q = j1:j1+length(Deb)-max(0, i - (mu - (delay - 1)) - my - 1)-1
                       D{q} = [Db{i} Deb{max(0, i - (mu - (delay - 1)) - my - 1)+q-j1+1}];
                    end
                    j1=j1+length(Deb)-max(0, i - (mu - (delay - 1)) - my - 1);
                end
                len(l)=j1-j;
            else
                j1=j;
                
                if (l==3)
                    subFactor = 0;
                    subsubFactor = 0;
                else
                    subFactor = len(l-3);
                    if (l==4)
                        subsubFactor = 0;
                    else
                        subsubFactor = len(l-4); 
                    end
                end
                numberFactor = len(l-1); 
                subSum = 0;                
                
                for i=1:length(Db)
                    for q=j1:j1+numberFactor-1
                        D{q} = [Db{i} D{j-numberFactor+q-j1}];
                    end
                    j1 = j1 + numberFactor;
                    if (i >= 2)
                        subSum = subSum + subFactor - subsubFactor*(i-2);
                    end
                    numberFactor = numberFactor - len(l-2) + subSum;
                end
                len(l) = j1 - j;
            end
        end
        j=j+len(l);
    end   
end

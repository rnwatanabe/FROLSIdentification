% Implements the MFROLS algorithm (see page 97 from Billings, SA (2013)).
%
% written by: Renato Naville Watanabe 
%
%
% beta = mfrols(p, y, pho, s)
%	
% Inputs:
%	
%   p: matrix of floats, is the matrix of candidate terms.
%
%   y: vector of floats, output signal.
%
%   pho: float, stop criteria.
%
%   s: integer, iteration step of the mfrols algorithm.
%
%
% Output:
%
%   beta: vector of floats, coefficients of the chosen terms.
%
%
% Globals:
%
%   l: vector of integers, indices of the chosen terms.
%
%   err: vector of floats, the error reduction ratio of each chosen term.
%
%   ESR: float, the sum of the individual error reduction ratios.
%
%   A: matrix of floats, auxiliary matrix in the orthogonalization process. 
%
%   q: matrix of floats, matrix with each column being the terms orthogonalized by the Gram-Schmidt process.
%
%   g: vector of floats, auxiliary vector in the orthogonalization process.
%
%   M0:	integer, number of chosen terms.


function beta = mfrols(p, y, pho, s)
    
    % The global variables are used due to the lack of pointers in Matlab
    global l;
    global err ESR;
    global A;
    global q g M0;
    beta = [];
    M = size(p,2);
    L = size(p,3);
    gs=zeros(L,M);
    ERR=zeros(L,M);
    qs=zeros(size(p));
    %%
    %%
    for j=1:L
        sigma = y(:,j)'*y(:,j);
        %qk(:,j,:) = squeeze(p(:,j,:));
        for m=1:M
            if (max(m*ones(size(l))==l)==0) 
                %% The Gram-Schmidt method was implemented in a modified way, as shown in Rice, JR(1966)
                 qs(:,m,j) = p(:,m,j);
                 for r=1:s-1
                     qs(:,m,j) = qs(:,m,j) - (squeeze(q(:,r,j))'*qs(:,m,j))/...
                         (squeeze(q(:,r,j))'*squeeze(q(:,r,j)))*squeeze(q(:,r,j));
                 end
                %%  
                gs(j,m) = (y(:,j)'*squeeze(qs(:,m,j)))/(squeeze(qs(:,m,j))'*squeeze(qs(:,m,j)));
                ERR(j,m) = (gs(j,m)^2)*(squeeze(qs(:,m,j))'*squeeze(qs(:,m,j)))/sigma;
            else
                ERR(j,m)=0;
            end
        end 
    end
    %% global variables assignment
    ERR_m = mean(ERR, 1);
    l(s) = find(ERR_m == max(ERR_m), 1);
    err(s) = ERR_m(l(s));
    for j=1:L
        for r = 1:s-1
            A(r, s, j) = (q(:,r,j)'*p(:,l(s),j))/(q(:,r,j)'*q(:,r,j));    
        end
        A(s, s, j) = 1;
        q(:, s,j) = qs(:,l(s),j);
        g(j,s) = gs(j,l(s));
    end    
    ESR = ESR - err(s);
    %D{l(s)}
    %% recursive call 
    if (err(s) >= pho && s < M)
       s = s + 1; 
       clear qs 
       clear gs
       beta = mfrols(p, y, pho, s);
    else
       M0 = s;
       s = s + 1;
       for j=1:L
            beta(:,j) = A(:,:,j)\g(j,:)';
       end       
    end   
end

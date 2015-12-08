% Implements the extended least squares algorithm (as shown in Isermann, R. and Muenchhoff, M. (2011), page 295)
%
% written by: Renato Naville Watanabe 
%
% [p, betan, xin, yest] = els(pp, pn, Mp, u, y, delta, degree, degreen, maxLag, xi, I, beta)
%	
%
% Inputs:
%
%   pp: matrix of floats, the matrix of the terms of the model.
%
%   pn: matrix of floats, the matrix of the terms of the model of the residue.
%
%   Mp: integer, the number of terms in the identified model, without the residue.
%
%   u: vector of floats, the input vector.
%
%   y: vector of floats, the output vector.
%
%   delta: float, stop criteria to the optimization of the coefficient values (is the  difference between the coefficients 
%   from this and the last step).
%
%   degree: integer maximal polynomial degree of the model.
%
%   degreen: ineteger, maximal polynomial degree of the residue model.
%
%   maxLag: integer, maximal Lag existent in the model.
%
%   xi: vector of floats, residue signal of the last step. In the first call you can simply put a vector of zeros of the same length of u.
%
%   I: cell, obtained from the modelLags function.
%
%   beta: vector of floats, coefficients vector of the last step of the ELS execution. In the first call, you can put the coefficients
%   vector originated from the FROLS identification or other method that you ave used.
%
%
% Outputs:
%
%   p: matrix of floats, is the matrix pp (in the case of t=0) or the concatenation of pp and pn (otherwise).
%
%   betan: vector of floats, coefficients vector found in this step of the ELS execution.
%
%   xin: vector of floats, residue signal of  this step.
%
%   yest: vector of floats, output signal estimated by the osaELS function.



function [p, betan, xin, yest] = els(pp, pn, Mp, u, y, delta, degree, degreen, maxLag, xi, I, beta)
    global t;
    if (t == 0)
        p=zeros(size(pp,1), size(pp,2), size(pp,3));
    else
        p=zeros(size(pp,1), size(pp,2)+size(pn,2), size(pp,3));
    end
    
    for j=1:size(pp,3)  
        if (t == 0)
                p(:,:,j) = [squeeze(pp(:,:,j))];
        else
                p(:,:,j) = [squeeze(pp(:,:,j)) squeeze(pn(:,:,j))];
        end
    end
    clear pn    
    M=size(p, 2);
    A=zeros(M, M, size(p,3));
    W=zeros(size(p,1), M, size(p, 3));
    for j=1:size(p,3)
        %% The Gram-Schmidt method was implemented in a modified way, as shown in Rice, JR(1966)
        Wk(:,:,j) = squeeze(p(:,:,j));
        for m=1:M
            W(:,m,j) = Wk(:,m,j);
            A(m,m,j) = 1; 
            for r=m+1:M
                Wk(:,r,j) = Wk(:,r,j) - ((Wk(:,r,j)'*W(:,m,j))/(W(:,m,j)'*W(:,m,j)))*W(:,m,j);
            end
            %%
            for r = 1:(m-1)
                A(r,m,j) = (squeeze(p(:,m,j))'*squeeze(W(:,r,j)))/(squeeze(W(:,r,j))'*squeeze(W(:,r,j)));
            end                       
            g(m,j) = (squeeze(W(:,m,j))'*y(:,j))/(squeeze(W(:,m,j))'*squeeze(W(:,m,j)));
        end       
        betan(:,j) = (A(:,:,j))\g(:,j); 
        if (t==0)
                [yest(:,j) xin(:,j)] = osaELS(u(:,j), y(:,j), xi(:,j), betan(:,j), Mp, I, 0);
        else
                [yest(:,j) xin(:,j)] = osaELS(u(:,j), y(:,j), xi(:,j), betan(:,j), Mp, I, 1);
        end
        p11 = buildPElsMatrix(u(1:end, j), y(1:end, j), xin(:,j), I, 1, Mp);
        pn(:,:,j) = p11(:,Mp+1:end);   
        clear p11
        difference(j) = sum(abs(betan(1:Mp,j) - beta(1:Mp,j))./abs(betan(1:Mp,j)));
    end       
    if (max(difference) > delta && t<3)
        clear xi;
        clear W Wk yest  xi
        t = t + 1;
        [p, betan, xin, yest] = els(pp(2*maxLag+1:end,:,:), pn, Mp,...
            u(2*maxLag+1:end,:), y(2*maxLag+1:end,:), ...
            delta, degree, degreen, maxLag, xin(maxLag+1:end,:),I, betan);
    end
    t=0;
end

function beta = ols(p,y)       
    M=size(p, 2);
    A=zeros(M,M,size(p,3));
    W=zeros(size(p,1), M,size(p, 3));
    for j=1:size(p,3)
         %% The Gram-Schmidt method was implemented in a modified way, as shown in Rice, JR(1966), for numerical stability purposes
        Wk(:,:,j) = squeeze(p(:,:,j));
        for m=1:M
            W(:,m,j) = Wk(:,m,j);
            A(m,m,j)=1; 
            for r=m+1:M
                Wk(:,r,j) = Wk(:,r,j) - ((Wk(:,r,j)'*W(:,m,j))/(W(:,m,j)'*W(:,m,j)))*W(:,m,j);
            end
            %%
            for r = 1:(m-1)
                A(r,m,j) = (squeeze(p(:,m,j))'*squeeze(W(:,r,j)))/(squeeze(W(:,r,j))'*squeeze(W(:,r,j)));
            end                       
            g(m,j) = (squeeze(W(:,m,j))'*y(:,j))/(squeeze(W(:,m,j))'*squeeze(W(:,m,j)));
        end       
        beta(:,j) = (A(:,:,j))\g(:,j);    
    end
end
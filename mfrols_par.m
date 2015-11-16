% Implements the MFROLS algorithm (see page 97 from Billings, SA (2013))
% p is the matrix of candidates
% y is the output vector
% pho  
function mfrols_par(p, y, phoLinear, phoNLinear, flag)
    
    global l;
    global err ESR;
    global An s;
    global q g beta M0 Dn D;
    M = size(p,2);
    L = size(p,3);
    gs=zeros(L,M);
    ERR=zeros(L,M);
    qs=zeros(size(p));
    s
    %%
    if (s<=45 && flag == 1)
            mBegin = 1;
            mEnd = 60;
            pho = phoLinear;
        else if (flag == 1)
                mBegin = 1;
                mEnd = M;
                pho = phoNLinear;
            else
                mBegin = 1;
                mEnd = M;
                pho = phoNLinear;
            end    
    end   
    pho
    %%
    for j=1:L
        sigma = y(:,j)'*y(:,j);
        %qk(:,j,:) = squeeze(p(:,j,:));
        parfor m=mBegin:mEnd
            if (max(m*ones(size(l))==l)==0) 
                %%  Gram-Schmidt procedure
                 qs(:,m,j) = p(:,m,j);
                 for r=1:s-1
                     qs(:,m,j) = qs(:,m,j) - (squeeze(q(:,r,j))'*qs(:,m,j))/(squeeze(q(:,r,j))'*squeeze(q(:,r,j)))*squeeze(q(:,r,j));
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
            An(r, s, j) = (q(:,r,j)'*p(:,l(s),j))/(q(:,r,j)'*q(:,r,j));    
        end
        An(s, s, j) = 1;
        q(:, s,j) = qs(:,l(s),j);
        g(j,s) = gs(j,l(s));
    end    
    ESR = ESR - err(s)
    %D{l(s)}
    %% recursive call 
   if (err(s) >= pho && s < min(M, M))
       s = s + 1; 
       clear qs 
       clear gs
       mfrols(p, y, phoLinear, phoNLinear, flag);
   else
       M0 = s;
       s = s + 1;
       for j=1:L
            beta(:,j) = An(:,:,j)\g(j,:)';
       end       
   end   
end
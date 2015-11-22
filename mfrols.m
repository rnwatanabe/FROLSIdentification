% Implements the MFROLS algorithm (see page 97 from Billings, SA (2013))
% p is the matrix of candidates
% y is the output vector
% phoLinear is the stop criteria, in the case of flag=1, duing the first 45 steps
% phoNLinear is the stop criteria
% s is the iteration step of the mfrols algorithm
% flag can be 0 or 1. It is important if you want to obtain GFRF from your identified model. It
%guarantees that at least one term of he identified model will be a linear one. Normally flag=0 is OK
function mfrols(p, y, phoLinear, phoNLinear, s, flag)
    
    global l;
    global err ESR;
    global An;
    global q g beta M0;
    M = size(p,2);
    L = size(p,3);
    gs=zeros(L,M);
    ERR=zeros(L,M);
    qs=zeros(size(p));
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
    %%
    for j=1:L
        sigma = y(:,j)'*y(:,j);
        %qk(:,j,:) = squeeze(p(:,j,:));
        for m=mBegin:mEnd
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
            An(r, s, j) = (q(:,r,j)'*p(:,l(s),j))/(q(:,r,j)'*q(:,r,j));    
        end
        An(s, s, j) = 1;
        q(:, s,j) = qs(:,l(s),j);
        g(j,s) = gs(j,l(s));
    end    
    ESR = ESR - err(s);
    %D{l(s)}
    %% recursive call 
   if (err(s) >= pho && s < min(M, 70))
       s = s + 1; 
       clear qs 
       clear gs
       mfrols(p, y, phoLinear, phoNLinear, s, flag);
   else
       M0 = s;
       s = s + 1;
       for j=1:L
            beta(:,j) = An(:,:,j)\g(j,:)';
       end       
   end   
end

%% Implements the algorithm to find the GFRFs of a NARX model. It is the
%	Equation (6.47) from Billings, 2013. It requires the Symbolic Matlab Toolbox.
%	
% written by: Renato Naville Watanabe 
%
% Hnn, Hn] = buildHn(order, C, fs, maxLag, noiseFlag)
%	
% Inputs:
%
%   order: integer, order of the GFRF you want to obtain. When you call it you should 
%   put as entry the maximal order of GFRF you want to obtain. As it is a recursive algorithm, 
%   it will give you as output all the GFRF with order lower and equal than the order number.
%
%   C: struct, obtained from the findCCoefficients function.
%
%   fs: float, is the sampling frequency of the data, in Hz.
%
%   maxLag: integer, is the maximal Lag of the model.
%
%   noiseFlag: boolean, is an indicator used for NonLinear Partial Directed Coherence. Normally set it to 0.
%
%
% Outputs:
%
%   Hnn are the intermediate functions for the GFRF computation.
%
%   Hn is a cell with the GFRFs.


function [Hnn, Hn] = buildHn(order, C, fs, maxLag, noiseFlag)

v2struct(C);

n = order;

fvector = [];
lvector = [];

for i=1:order
    eval(['syms f' num2str(i) ' real']);
    eval(['syms lag' num2str(i) ' real']);
    if (i == 1)
        fvector{i} = ['f' num2str(i)];
        lvector{i} = ['l' num2str(i)];
    else 
        fvector{i} = [fvector{i-1}, ',f' num2str(i)];
        lvector{i} = [lvector{i-1}, ',l' num2str(i)];
    end
end

%% compute the GFRFs for n = 1
if (order==1)
    
    eval(['syms denH(' fvector{order} ') numH(' fvector{order} ');'])
    if (noiseFlag == 0)
        eval(['numH(' fvector{order} ') = 0;']);
    else
        eval(['numH(' fvector{order} ') = 1;']);
    end
    eval(['denH(' fvector{order} ') = 0;']);
    
    for l1 = 1:maxLag
           if (exist('c_01', 'var'))
                if (length(c_01) >= l1)
                    eval(['numH(' fvector{order} ') = numH(' fvector{order} ') + c_01(' lvector{order} ...
                        ') * exp(-1j * l1 * 2 * pi * f1 / fs);']);
                end
            end
        if (exist('c_10', 'var'))
            if (length(c_10) >= l1)
                eval(['denH(' fvector{order} ') = denH(' fvector{order} ') + c_10(' lvector{order} ...
                    ') * exp(-1j * l1 * 2 * pi * f1 / fs);'])
            end
        end
    end
    
    denH(f1) = 1 - denH(f1);
    if (noiseFlag == 1)
        numH(f1) = 1;
    end
    H1(f1) = numH(f1) / denH(f1);
    
    
    syms H1_1(f1)
    
    H1_1(f1, lag1) = H1(f1) * exp(-1j*(2*pi*f1/fs)*lag1);
    
    Hn{1} = H1;
    Hnn{1,1} = H1_1;
else
    %% recursive call
    
    [Hnn ,Hn] = buildHn(order-1, C, fs, maxLag, noiseFlag); % recursive call
    
    %% Compute the Hn,p with n=order and p=2,..., n
    
    for p = 2:n
        for j = 1:p
            if (j == 1)
                lagsPvector = ['lag' num2str(j)];
            else
                lagsPvector = [lagsPvector, ',lag' num2str(j)];
            end
        end
        eval(['Hnn{n,p} = symfun(0*f1, [' fvector{n} ',' lagsPvector ']);'])
        for i = 1:(n-p+1)
            eval(['syms freqSum(' fvector{n} ')']);
            eval(['freqSum(' fvector{n} ') = 0;']);
            freqNivector = [];
            for j = 1:i
                eval(['freqSum(' fvector{n} ') = [freqSum + 2*pi*f' num2str(j) '/ fs];']);
            end
            for j = 1:p-1
                if (j == 1)
                    lagsPvector = ['lag' num2str(j)];
                else
                    lagsPvector = [lagsPvector, ',lag' num2str(j)];
                end
            end
            for j = i+1:n
                if (j == i+1)
                    freqNivector = ['f' num2str(j)];
                else
                    freqNivector = [freqNivector, ',f' num2str(j)];
                end
            end
            eval(['Hnn{n,p} = symfun(Hnn{n,p}(' fvector{n} ', ' lagsPvector ', lag' num2str(p) ...
                ') + Hn{i}(' fvector{i} ')*Hnn{n-i,p-1}(' freqNivector ',' lagsPvector ...
                ' )*exp(-1j*(freqSum)*(lag' num2str(p) ')), [' fvector{n} ',' lagsPvector ...
                ', lag' num2str(p) ']);']);
        end
    end
    
    %%
    eval(['syms inputComponent(' fvector{n} ')']); % Component of the GFRF related to the input signal
    eval(['syms mixedComponent(' fvector{n} ')']); % Component of the GFRF related to the terms with input and output 
                                                   %signals multiplied
    eval(['syms outputComponent(' fvector{n} ')']); % Component of the GFRF related to the output signal
    eval(['syms denH(' fvector{n} ')']); % Denominator of the GFRF
    eval(['syms numH(' fvector{n} ')']); % Numerator of the GFRF
    eval(['inputComponent(' fvector{n} ') = 0;']);
    eval(['mixedComponent(' fvector{n} ') = 0;']);
    eval(['outputComponent(' fvector{n} ') = 0;']);
    eval(['denH(' fvector{n} ') = 1;']);
    eval(['numH(' fvector{n} ') = 0;']);
    eval(['syms H' num2str(n) '_' num2str(1) '(' fvector{n} ')']);
        %% computation of the input component
        if (exist(['c_0' num2str(n)], 'var'))
            eval(['lagsPosition = find(c_0' num2str(n) ' ~= 0);']);
            eval(['[' lvector{n} '] = ind2sub(size(c_0' num2str(n) '), lagsPosition);']);
            eval(['syms freqVector(' fvector{n} ')']);            
            eval(['syms lagsVector']);           
            for k = 1:length(lagsPosition)
                eval(['freqVector(' fvector{n} ') = [];']);
                eval(['lagsVector = [];']);
                for j = 1:n
                    eval(['freqVector(' fvector{n} ') = [freqVector 2*pi*f' num2str(j) '/fs];']);
                    eval(['lagsVector = [lagsVector; l' num2str(j) '(' num2str(k) ')];']);
                end
                expFreqLag = exp(-1j * freqVector * lagsVector);
                eval(['inputComponent(' fvector{n} ') = inputComponent(' fvector{n} ...
                    ') + c_0' num2str(n) '(lagsPosition(k)) * expFreqLag;']);
            end
        end
        %% computation of the mixed component
        for q = 1:n-1
            for p = 1:n-q
                if (exist(['c_' num2str(p) '' num2str(q) ], 'var'))
                    eval(['lagsPosition = find(c_' num2str(p) '' num2str(q) ' ~= 0);']);
                    eval(['[' lvector{p+q} '] = ind2sub(size(c_' num2str(p) '' num2str(q) '), lagsPosition);']);
                    eval(['syms freqVector(' fvector{n} ')']);
                    
                    eval('syms lagsVector');                    
                    for k = 1:length(lagsPosition)
                        eval(['freqVector(' fvector{n} ') = [];']);
                        for j = n-q+1:n
                            eval(['freqVector(' fvector{n} ') = [freqVector 2*pi*f' num2str(j) '/fs];']);
                            %eval(['lagsVector = [lagsVector; l' num2str(j) '(' num2str(k) ')];']);
                        end
                        eval('lagsVector = [];');
                        for j = p+1:p+q
                            eval(['lagsVector = [lagsVector; l' num2str(j) '(' num2str(k) ')];']);
                        end
                        expFreqLag = exp(-1j * freqVector * lagsVector);
                        for j = 1:p
                            if (j == 1)
                                lPvector = ['l' num2str(j) '(k)'];
                            else
                                lPvector = [lPvector, ',l' num2str(j) '(k)'];
                            end
                        end
                        for j = 1:p+q
                            if (j == 1)
                                lNvector = ['l' num2str(j) '(k)'];
                            else
                                lNvector = [lNvector, ',l' num2str(j) '(k)'];
                            end
                        end
                        eval(['mixedComponent(' fvector{n} ') = mixedComponent(' fvector{n} ') + c_'  num2str(p) '' ...
                            num2str(q) '(' lNvector ') * expFreqLag * Hnn{n-q,p}(' fvector{n-q} ...
                            ',' lPvector ');'])
                    end
                end
            end
        end
        %% computation of the output component
        for p = 2:n
            if (exist(['c_' num2str(p) '0'], 'var'))
                eval(['lagsPosition = find(c_' num2str(p) '0 ~= 0);']);
                eval(['[' lvector{p} '] = ind2sub(size(c_' num2str(p) '0), lagsPosition);']);
                eval(['syms freqVector(' fvector{n} ')']);
                eval(['freqVector(' fvector{n} ') = [];']);
                eval(['syms lagsVector']);
                eval(['lagsVector = [];']);
                for k = 1:length(lagsPosition)
                    for j = 1:p
                        if (j == 1)
                            lPvector = ['l' num2str(j) '(k)'];
                        else
                            lPvector = [lPvector, ',l' num2str(j) '(k)'];
                        end
                    end
                    eval(['outputComponent(' fvector{n} ') = outputComponent(' fvector{n} ...
                        ') + c_' num2str(p) '0(' lPvector ') * Hnn{n,p}(' fvector{n} ',' lPvector ');']);
                end
            end
        end
        %% computation of the denominator of the GFRF
        if (exist('c_10', 'var'))
            lagsPosition = find(c_10 ~= 0);
            for k = 1:length(lagsPosition)
                eval(['syms freqSum(' fvector{n} ')']);
                eval(['freqSum(' fvector{n} ') = 0;']);
                for j = 1:n
                    eval(['freqSum(' fvector{n} ') = [freqSum + 2*pi*f' num2str(j) '/ fs];']);
                end
                denH = denH - c_10(lagsPosition(k)) * exp(-1j*freqSum*lagsPosition(k));
            end
        end
    %% Computation of Hn for n = order
    
    numH = inputComponent + mixedComponent + outputComponent;
    Hn{n} = numH / denH;
    
    %% Computation of Hn,1
    
    eval(['syms freqSum(' fvector{n} ')']);
    eval(['freqSum(' fvector{n} ') = 0;']);
    for j = 1:n
        eval(['freqSum(' fvector{n} ') = [freqSum + 2*pi*f' num2str(j) '/ fs];']);
    end
    eval(['Hnn{' num2str(n) ',1}(' fvector{n} ', lag1) = Hn{n}(' fvector{n} ')* exp(-1j*freqSum*lag1);'])    
end
end


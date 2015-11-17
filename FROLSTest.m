clear all
close all


%%
identifyModel = true;
identifyNoise = true;
identifyComplete = true;
computeGFRF = true; % if you do not have the Symbolic Toolbox,set this to false. The other parts of the system identification will work normally

%% data

% obtain a signal of the system y(k) = 0.3*y(k-1) + 2*x(k-1)*x(k-2)
Fs = 100;
x = randn(2000,1);
y = zeros(size(x));



for i = 3:length(y)
   y(i) = 0.3*y(i-1) + 2*x(i-1)*x(i-2); 
end

%% 
input = x(100:end);  %throw away the first 100 samples to avoid transient effects
output = y(100:end);  %throw away the first 100 samples to avoid transient effects
mu = 2;
my = 1;    
degree = 2;  
delay = 0;
dataLength = 500;
divisions = 1;
phoL = 1e-1;
pho = 1e-1;

%%
if identifyModel
    
    [Da, a, la, ERRs] = NARXModelIdentificationOf2Signals(input, output, degree, mu, my, delay, dataLength, divisions, phoL, pho);
    %%
    identModel.terms = Da;
    identModel.termIndices = la;
    identModel.coeff = a;
    identModel.degree = degree;
    identModel.Fs = Fs;
    identModel.ESR = 1-ERRs;
    %%    
    save(['testIdentifiedModel' num2str(Fs) '.mat'], 'identModel');
else
    load(['testIdentifiedModel' num2str(Fs) '.mat']);
    Da = identModel.terms;
    la = identModel.termIndices;
    a = identModel.coeff;
    degree = identModel.degree;
    Fs = identModel.Fs;
end

%%

if identifyNoise
    degree = identModel.degree;
    me = 2;  
    phoN = 1e-2;
    [Dn, an, ln] = NARXNoiseModelIdentification(input, output, degree, mu, my, me, delay, dataLength, divisions, phoN,  identModel.coeff, identModel.termIndices);
    %%
    identModel.noiseTerms = Dn;
    identModel.noiseTermIndices = ln;
    identModel.noiseCoeff = an;
    %%
    save(['testIdentifiedModel' num2str(Fs) '.mat'], 'identModel');
else
    load(['testIdentifiedModel' num2str(Fs) '.mat']);  
    Dn = identModel.noiseTerms;
    ln = identModel.noiseTermIndices;
    an = identModel.noiseCoeff;
end

%%

if identifyComplete
    delta = 1e-1;
    [a, an, xi] = NARMAXCompleteIdentification((input), output, identModel.terms, identModel.noiseTerms, dataLength, divisions,  delta, identModel.degree, identModel.degree);
    %%
    identModel.finalCoeff = a;
    identModel.finalNoiseCoeff = an;
    identModel.residue = xi;
    identModel.delta = delta;
    %%
    save(['testIdentifiedModel' num2str(Fs) '.mat'], 'identModel');
else
    load(['testIdentifiedModel' num2str(Fs) '.mat']);      
end

disp(identModel.terms)
disp(identModel.finalCoeff)


%%

if computeGFRF
    Hn = computeSignalsGFRF(identModel.terms, identModel.Fs, identModel.finalCoeff, identModel.degree)
    %%
    identModel.GFRF = Hn;    
    %%
    save(['testIdentifiedModel' num2str(Fs) '.mat'], 'identModel');
    disp('GFRF of order 1: ')
    disp(identModel.GFRF{1}{1})
    disp('GFRF of order 2: ')
    disp(identModel.GFRF{1}{2})
else
    load(['testIdentifiedModel' num2str(Fs) '.mat']);      
end


%% this script performs an example of all steps of the system identification available  at this repository

clear all
close all
clc


%% steps to perform
identifyModel = true;
identifyNoise = true;
identifyComplete = true;
computeGFRF = true; % if you do not have the Symbolic Toolbox,set this to false. The other parts of the system 
                    %identification will work normally
computeNOFRF = true; % if you do not have the Symbolic Toolbox,set this to false. The other parts of the system 
                    %identification will work normally

%% data

% obtain a signal of the system y(k) = -0.1*y(k-1) - 0.5*u(k-1)*y(k-1) + 0.1*u(k-2). You
% can change it as you wish, or use your own data collected elsewhere.
% The data must be in column format. It is also possible to use in the same
% identification process different data acquisitions from the same system.
% Each data acquisition must be in a different column and the columns from
% the input matrix must be correspondent to the columns from the output
% matrix

Fs = 100; % Sampling frequency of the data acquisition, in Hz. It is used only for the GFRFs computation

u = randn(2000,1);
y = 0.0*ones(size(u));

for k = 5:length(y)
   y(k) = -0.1*y(k-1) - 0.5*u(k-1)*y(k-1) + 0.1*u(k-2); 
end

%% 
input = (u(100:end));  % throw away the first 100 samples to avoid transient effects
output = (y(100:end));  % throw away the first 100 samples to avoid transient effects
mu = 2; % maximal lag for the input. In this case, we know that mu is 2 but normally we do not!
my = 1; % maximal lag for the output. In this case, we know that my is 1 but normally we do not!   
degree = 2; % maximal polynomial degree. In this case, we know that degree is 2 but normally we do not! 
delay = 1; % the number of samplings that takes to the input signal effect the output signal. In this case we know that 
%degree is 2 but normally we do not! 
dataLength = 500; % number of samplings to be used during the identification process. Normally a number between 400 and
% 600 is good. Do not use large numbers.
divisions = 4; % Number of parts of each data acquisition to be used in the identification process
pho = 1e-3; % a lower value will give you more identified terms. A higher value will give you less.
phoL = 1e-2; % a lower value will give you more identified terms. A higher value will give you less. This is only used 
%if you want to compute the GFRFs, to guarantee that at least one term will be linear. In this case, change the variable
%flag in %NARXModelIdentificationOf2Signals.m  file to 1



%%
if identifyModel    
    [Da, a, la, ERRs] = NARXModelIdentificationOf2Signals(input, output, degree, mu, my, delay, dataLength, divisions, ...
        phoL, pho);
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
    me = 2; % a good start guess for me is max(mu, my). In this case me=2. 
    phoN = 1e-2;
    [Dn, an, ln] = NARXNoiseModelIdentification(input, output, degree, mu, my, me, delay, dataLength, divisions, phoN,  ...
        identModel.coeff, identModel.termIndices);
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
    [a, an, xi] = NARMAXCompleteIdentification((input), output, identModel.terms, identModel.noiseTerms, dataLength, ...
        divisions,  delta, identModel.degree, identModel.degree);
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

disp('Identified Model')
disp(identModel.terms) 
disp('Coefficients')
disp(identModel.finalCoeff)


%%

if computeGFRF
    GFRFdegree = 3; % If your identified system has terms with inputs and outputs, the GFRF will be non-null for 
    %degrees higher than the maximal polynomial degree. In this case, a good number
    %is to add one to your maximal polynomial degree. If you have only
    %inputs or outputs terms,, the GFRFdegree will be the maximal
    %polynomial degree.
    Hn = computeSignalsGFRF(identModel.terms, identModel.Fs, identModel.finalCoeff, identModel.termIndices, GFRFdegree);
    %%
    identModel.GFRF = Hn{1};    
    %%
    save(['testIdentifiedModel' num2str(Fs) '.mat'], 'identModel');
    for j = 1:GFRFdegree
        disp(['GFRF of order' num2str(j) ': '])
        disp(identModel.GFRF{j})
    end
    ezsurf((abs(identModel.GFRF{2})), [-50 50]); title('GFRF of degree 2')
else
    load(['testIdentifiedModel' num2str(Fs) '.mat']);      
end


%%

if computeNOFRF
    % build the input signal you want to konow what the system output will
    % be. In this case is the sum of two sinusoids.
    t = 0:1/Fs:10000/Fs-1/Fs;
    u = cos(2*pi*8*t) + cos(2*pi*5*t);
    %NOFRF computation
    fres = 0.1; % the frequency resolution of the NOFRF
    fmin = 0; % lower frequency limit of the NOFRF
    fmax = 25; % upper frequency limit of the NOFRF

    [NOFRF, f] = computeSystemNOFRF(identModel.GFRF, u', Fs, fres, GFRFdegree, fmin, fmax); 
    % output prediction
    figure
    plot(f, (abs(NOFRF))); title('NOFRF for the input u')
    % true output FFT. In the case of you are using a real dataset, you can
    % not do this step. You will have to acquire in the real system an
    % output for this input signal.
    y = zeros(size(u));
    for k = 5:length(y)
        % system simulation for this input. This difference equation must
        % be the same you used for the identification
        y(k) =  -0.1*y(k-1) - 0.5*u(k-1)*y(k-1) + 0.1*u(k-2); 
    end
    Y = fft(y(1000:end)); Y = fftshift(Y)/length(Y);
    f4 = -Fs/2:Fs/length(Y):Fs/2-Fs/length(Y);
    [Sy, f] = pwelch((y(100:end)),[],[],[],Fs);
    figure
    plot(f4, 2*(abs(Y))); xlim([0 25]);
end




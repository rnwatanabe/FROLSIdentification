%% Runs the tests form Eq. 5.13 in Billings (2013).
%
%   written by: Renato Naville Watanabe 
%
%	validation(u, xi,maxLag)
%	
%   Inputs:
%
% 	u: matrix, each column is an input signal for each trial used in the identfication.
%
% 	xi: vector, is the residue obtained after the identification process.
%
% 	maxLag: integer, maximal lag to display in the plots. Usually it is good to plot until the maxLag of the model.


function validation(u, xi,maxLag)
    trials = size(u,2);
    
    for i = 1:trials
        xiu = xi(1:end-1, i).*u(1:end-1, i);
        [phi_xixi(:,i), lags, CB] = crosscorr(xi, xi, 0.1);  
        phi_uxi(:,i) = crosscorr(u, xi,0.1); 
        [phi_xixiu(:,i), lags1, CB1] = crosscorr(xi(2:end),xiu,0.1); 
        figure
        title(['Validation Tests - trial ', num2str(i)])
        subplot(3,1,1)
        plot(lags, phi_xixi(:,i), '-k', lags, CB(1)*ones(size(lags)), '--b', lags, CB(2)*ones(size(lags)), '--b')
        ylabel('\Phi_{\xi\xi}')
        xlim([-maxLag maxLag])
        subplot(3,1,2)        
        plot(lags, phi_uxi(:,i), '-k', lags, CB(1)*ones(size(lags)),  '--b', lags, CB(2)*ones(size(lags)), '--b')
        ylabel('\Phi_{u\xi}')
        xlim([-maxLag maxLag])
        subplot(3,1,3)
        plot(lags1, phi_xixiu(:,i), '-k', lags1, CB1(1)*ones(size(lags1)), '--b', lags1, CB1(2)*ones(size(lags1)), '--b')
        ylabel('\Phi_{\xi(\xi u)}')
        xlim([0 maxLag])
    end    

end

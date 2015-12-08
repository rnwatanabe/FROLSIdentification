% Function to remove a constant term from the identified model, in the case of the constant term ('1') was 
% identified. This is necessary for the computation of GFRFs.
%
% written by: Renato Naville Watanabe 
%
% [Da, a] = removeConstant(Da, a)
%	
% Inputs:
%
%   Da: cell, contains strings with the NARX model terms.
%
%   a: vector,  coefficients of the NARX model.
%
%   
% Outputs:
%
%   The Da and a vectors are the same of the input, except for the deletion of the constant term. 

function [Da, a] = removeConstant(Da, a)
    %%
    termsNumber = length(Da);
        
    %%
    removed = 0;
    i = 1;
    while (i <= termsNumber && removed == 0) 
        if strcmp(Da{i}, '1')
           if (termsNumber > i) 
                Da(i:end-1) = Da(i+1:end);
                a(i:end-1,:) = a(i+1:end,:);
           end
           a = a(1:end-1,:);
           Da = Da(1:end-1);
           removed = 1;
        end
        i = i + 1;
    end    
end

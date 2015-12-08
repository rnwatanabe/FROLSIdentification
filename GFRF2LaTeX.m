% Transforms the symbolic GFRFs to LaTeX format, for publishing purposes.
%
% written by: Renato Naville Watanabe 
%
% GFRF2LaTeX(GFRF, size, filename, numberOfDigits)
%	
%
% Inputs:
%   
%   GFRF: cell, contains all GFRFs.
%
%   size: string, the specified math font size in LaTeX. For example: 'scriptscript' for 
%   \scriptscriptstyle size.
%
%   filename: string, name of the file to store the LaTeX formatted GFRFs.
%
%   numberOfDigits: integer, number of digits to represent the float numbers.

function GFRF2LaTeX(GFRF, size, filename, numberOfDigits)
    %%
    file = fopen(filename, 'w');
    degree = length(GFRF);
    sizeString  = strcat(' \\',size,'style ');   
    
    D = digits;
    digits(numberOfDigits);
    outputString = '';
    %%
    outputString = strcat(outputString, '\\begin{align} \n');
    for i = 1:degree
        
        inputs = argnames(GFRF{i});
        outputString = strcat(outputString, sizeString, ' H_', num2str(i), '(');
        for j = 1:length(inputs)
            if j == length(inputs)
                outputString = strcat(outputString, strrep(char(inputs(j)), 'f', 'f_'));
            else
                outputString = strcat(outputString, strrep(char(inputs(j)), 'f','f_'), ',');
            end
        end
        outputString =  strcat(outputString,') =& ', sizeString);
        %% GFRF
        [num, den] = numden(GFRF{i});
        %% numerator
        numString = latex(vpa((num)));
        numString = strrep(numString, '\','\\');
        for j = 1:i
           numString = strrep(numString, strcat('\\mathrm{f',num2str(j),'}'), strcat('f_',num2str(j)));
        end
        numString = strrep(numString, '\\mathrm{i}','j');
        %% denominator
        denString = latex(vpa((den)));
        denString = strrep(denString, '\','\\');
        for j = 1:i
           denString = strrep(denString, strcat('\\mathrm{f',num2str(j),'}'), strcat('f_',num2str(j)));
        end
        denString = strrep(denString, '\\mathrm{i}','j');
        
        %% GFRF
        GFRFstring = strcat('\\frac{',numString,'}{',denString,'}');
        
        outputString = strcat(outputString, GFRFstring);
        %%
        if i == degree
            outputString = strcat(outputString, '\n');
        else
            outputString = strcat(outputString, '\\\\ \n');
        end
        
    end
    outputString = strcat(outputString, '\\end{align}');
    fprintf(file, outputString);
    digits(D);
    
end

%% Transforms the symbolic GFRFs to LaTeX format, for publishing purposes.
%
%
%	GFRF2LaTeX(GFRF, size, filename)
%	where:
%
%	GFRF is the cell with all the GFRFs.
%
%	size is a string with the specified math font size. For example: 'scriptscript' for 
%	\scriptscriptstyle size.
%
%	filename is a string with the name of the file to store the LaTeX formatted GFRFs.

function GFRF2LaTeX(GFRF, size, filename)
    %%
    file = fopen(filename, 'w');
    degree = length(GFRF);
    sizeString  = strcat(' \\',size,'style ');   
    
    
    %%
    fprintf(file, '\\begin{align} \n');
    for i = 1:degree
        inputs = argnames(GFRF{i});
        fprintf(file, strcat(sizeString, ' H_', num2str(i), '('));
        for j = 1:length(inputs)
            if j == length(inputs)
                fprintf(file, strrep(char(inputs(j)), 'f', 'f_'));
            else
                fprintf(file, strcat(strrep(char(inputs(j)), 'f','f_'), ','));
            end
        end
        fprintf(file, strcat(') =& ', sizeString));
        GFRFstring = latex(simplify(GFRF{i}));
        GFRFstring = strrep(GFRFstring, '\','\\');
        for j = 1:i
           GFRFstring = strrep(GFRFstring, strcat('\\mathrm{f',num2str(j),'}'), strcat('f_',num2str(j)));
        end
        GFRFstring = strrep(GFRFstring, '\\mathrm{i}','j');
        fprintf(file, GFRFstring);
        if i == degree
            fprintf(file, '\n');
        else
            fprintf(file, '\\\\ \n');
        end
    end
    fprintf(file, '\\end{align}');
    
    
end

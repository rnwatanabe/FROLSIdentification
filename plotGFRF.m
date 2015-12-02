%% Plots the all the GFRFs, one GFRF degree per plot. For degrees higher than 2, plots the number of specified slices of 
%   the GFRFs.
%
%   written by: Renato Naville Watanabe 
%
%
%   plotGFRF(GFRF, fmax, slices, figureWidth, figureHeight, gapHeight, gapWidth, marginTop,...
%                marginBottom, marginLeft, marginRight, units)  
%   
%   Inputs:
%
%   GFRF: cell, contains all GFRFs to be plotted.
%
%   fmax: float, maximal frequency to be plotted.
%
%   slices: integer, number of slices of the GFRFs with degree higher than two.
%
%   unit: string, length unit to be used. Possible units are 'pixels', 'normalized', 'inches', 
%   'centimeters', 'points' and 'characters'.
%
%   figureHeight: float, height of each plot, in the established unit.
%
%   figureWidth: float, width of each plot, in the established unit.
%
%   gapVertical: float, vertical gap between the plots, in the established unit.
%
%   gapHorizontal: float, horizontal gap between the plots, in the established unit.
%
%   marginTop: float, margin in the top of the figure, in the established unit.
%
%   marginBottom: float, margin in the bottom of the figure, in the established unit.
%
%   marginLeft: float, margin in the left side of the figure, in the established unit.
%
%   marginRight: float, margin in the right side of the figure, in the established unit.




function plotGFRF(GFRF, fmax, slices, unit, figureHeight, figureWidth, gapVertical, gapHorizontal, marginTop,...
                marginBottom, marginLeft, marginRight)
    maxDegree = length(GFRF);
    syms f1 f2
    for i = 1:maxDegree
        figure
        if i == 1
            ha = measuredPlot(1, 1, unit, figureHeight, figureWidth, gapVertical, gapHorizontal, marginTop, ...
                    marginBottom, marginLeft, marginRight);
            axes(ha(1));
            ezplot(matlabFunction((abs(GFRF{i}))), [-fmax fmax]); title('')
            xlabel('f (Hz)');
            ylabel('H_1')
            set(gca, 'Box','On', 'LineWidth', 2);
        else if i == 2  
                ha = measuredPlot(1, 1, unit, figureHeight, figureWidth, gapVertical, gapHorizontal, marginTop, ...
                    marginBottom, marginLeft, marginRight + 1.9);
                axes(ha(1));
                h = ezcontourf(matlabFunction(abs((GFRF{i}))), [-fmax fmax]); title('');
                %set(h, 'EdgeColor', 'none', 'FaceColor','interp')
                xlabel('f_1 (Hz)');
                ylabel('f_2 (Hz)');
                p = get(gca, 'Position');
                c1 = colorbar('location', 'East', 'Units','centimeters','Position',[p(1)+p(3)+1.3 p(2) 0.7 p(4)]);
                axes(ha(end))
                set(gca,'Position', p,'Box','On', 'LineWidth', 2);
            else
                numberOfRows = ceil(sqrt(slices));
                numberOfCols = ceil(sqrt(slices));                
                ha = measuredPlot(numberOfRows, numberOfCols, unit, figureHeight, figureWidth, gapVertical, gapHorizontal, marginTop, ...
                    marginBottom, marginLeft, marginRight + 1.9);
                fRes = nthroot(fmax * 2 / slices, i - 2);
                f = -fmax:fRes:fmax;
                for j = 0:length(ha)-1
                    axes(ha(j+1))
                    indices = dec2base(j, length(f), i-2);
                    fString = 'f1,f2';
                    titleString = '';
                    for k = 1:i-2
                        fString = strcat(fString, ',f(', num2str(base2dec(indices(k), length(f)) + 1), ')');
                        titleString = strcat(titleString, 'f_', num2str(k+2), '=', num2str(f(base2dec(indices(k), length(f)) + 1)), ',' );
                    end
                    titleString = titleString(1:end-1);
                    eval(['h = ezcontourf(matlabFunction(abs((GFRF{i}(' fString ')))), [-fmax fmax]);']); 
                    title(titleString, 'FontWeight', 'Bold');
                    if (mod(j+1,numberOfCols) == 1)
                        ylabel('f_2 (Hz)'); 
                    else
                        ylabel('');
                    end
                    if j+1 > (numberOfRows - 1) * numberOfCols
                        xlabel('f_1 (Hz)'); 
                    else
                        xlabel('')
                    end
                    p = get(gca, 'Position');
                    set(gca,'Position', p,'Box','On', 'LineWidth', 2);
                end
                c1 = colorbar('location', 'East', 'Units','centimeters','Position',[p(1)+p(3)+1.3 p(2) 0.7 2*p(4)+gapVertical]);
                axes(ha(end))
                set(gca,'Position', p,'Box','On', 'LineWidth', 2);
            end
        end
    end
end
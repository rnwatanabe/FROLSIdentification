% Plots the all the GFRFs, one GFRF degree per plot. For degrees higher than 2, plots the number of specified slices of 
% the GFRFs.
%
% written by: Renato Naville Watanabe 
%
%
%   plotGFRF(GFRF, fmax, slices, unit, figureHeight, figureWidth, gapVertical, gapHorizontal, marginTop,...
%   marginBottom, marginLeft, marginRight, freqAxisScaling, GFRFAxisScaling, fileName)
%   
% Inputs:
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
%
%   freqAxisScaling: string, scale to be used in the frequency axis.
%   Possible strings are: 'linear' and 'log'.
%
%   GFRFAxisScaling: string, scale to be used in the GFRF axis.
%   Possible strings are: 'linear', 'db' and 'log'.
%
%   fileName: string, name of the files to store the plots.       



function plotGFRF(GFRF, fmax, slices, unit, figureHeight, figureWidth, gapVertical, gapHorizontal, marginTop,...
                marginBottom, marginLeft, marginRight, freqAxisScaling, GFRFAxisScaling, fileName)
    
    %% scale functions
    function scaledF = scaleFreq(f)
       if strcmp(freqAxisScaling, 'log')
           scaledF = log10(f);
       else
           scaledF = f;
       end       
    end

    function scaledGFRF = scaleGFRF(Hn)
       if strcmp(GFRFAxisScaling, 'log')
           scaledGFRF = log10(Hn);
       else if strcmp(GFRFAxisScaling, 'db')
                scaledGFRF = db(Hn);
           else
                scaledGFRF = Hn;
           end           
       end       
    end
    %% frequency coloring
    f = linspace(0, fmax, 100);
    freq = [linspace(-fmax, 0, 100) linspace(0, fmax, 100)];
    map = hot(length(f)); map = [map(end:-1:2,:);map]; 
    f = [-f(end:-1:2) f];
    

    %% Octave verification
    V = ver;
    for i = 1:length(V)
        if (strcmp(V(i).Name,'Octave'))
            pkg load symbolic;
        end
    end
    
    %%
    numberOfGFRFs = length(GFRF);
    for i = 1:numberOfGFRFs
        if  logical(GFRF{i} ~= 0)
            Hfun = matlabFunction((abs(GFRF{i})));
            figure
            if nargin(Hfun) == 1
                ha = measuredPlot(1, 1, unit, figureHeight, figureWidth, gapVertical, gapHorizontal, marginTop, ...
                        marginBottom, marginLeft, marginRight);

                axes(ha(1));     
                plotColoredLine(scaleFreq(freq), scaleGFRF(Hfun(freq)), zeros(size(freq)), f, map, 'x', 2)
                ylimit = get(gca,'YLim');
                hold on
                set(gca, 'Box','Off', 'LineWidth', 2,'XTickLabelMode','auto', 'YTickLabelMode','auto');
                plotColoredLine(scaleFreq(freq), ylimit(1)*ones(size(freq)), zeros(size(freq)), scaleFreq(f), map, 'x', 10)                    
                xlabel('f (Hz)');
                ylabel('|H_1|');                
            else if nargin(Hfun) == 2                
                    ha = measuredPlot(1, 1, unit, figureHeight, figureWidth, gapVertical, gapHorizontal, marginTop, ...
                        marginBottom, marginLeft, marginRight + 1.9);
                    axes(ha(1));
                    [F1,F2] = meshgrid(freq/2,freq/2);
                    h = surf(scaleFreq(F1), scaleFreq(F2), scaleGFRF(Hfun(F1,F2)), F1+F2); title('');
                    set(h, 'EdgeColor', 'none', 'FaceColor','interp')
                    xlabel('f_1 (Hz)');
                    ylabel('f_2 (Hz)');
                    zlabel('|H_2|');
                    p = get(gca, 'Position');
                    axis([-fmax/2 fmax/2 -fmax/2 fmax/2]);
                    ylimit = get(gca,'YLim');
                    xlimit = get(gca,'XLim');
                    zlimit = get(gca,'ZLim');
                    set(ha(1), 'CameraPosition', [3 * xlimit(2) 3.3 * ylimit(1) 1.4 * zlimit(2)])
                    plotColoredLine(scaleFreq(freq/2), ylimit(1)*ones(size(freq)), zlimit(1)*ones(size(freq)), scaleFreq(f), map, 'x', 10)
                    plotColoredLine(xlimit(2)*ones(size(freq)), scaleFreq(freq/2), zlimit(1)*ones(size(freq)), scaleFreq(f), map, 'y', 10)
                    colormap(map)
                    c1 = colorbar('location', 'East', 'units','centimeters','Position',[p(1)+p(3)+1.3 p(2) 0.7 p(4)]);
                    axes(ha(end))
                    set(gca,'Position', p,'Box','Off', 'LineWidth', 2);                    
                else
                    numberOfRows = ceil(sqrt(slices));
                    numberOfCols = ceil(sqrt(slices));                
                    ha = measuredPlot(numberOfRows, numberOfCols, unit, figureHeight, figureWidth, gapVertical, gapHorizontal, marginTop, ...
                        marginBottom, marginLeft, marginRight + 1.9);
                    fRes = nthroot(fmax/nargin(Hfun) * 2 / slices, nargin(Hfun) - 2);
                    fslice = 0:fRes:fmax/nargin(Hfun); 
                    f0Index = length(fslice) - round(slices/2);
                    fslice = [-fslice(end:-1:2) fslice];
                    for j = 0:length(ha)-1
                        axes(ha(j+1))
                        indices = dec2base(j+f0Index, length(fslice), nargin(Hfun)-2);
                        fString = 'F1,F2';
                        colorMapString = 'F1+F2'; 
                        titleString = '{';
                        for k = 1:nargin(Hfun)-2
                            fString = strcat(fString, ',fslice(', num2str(base2dec(indices(k), length(fslice)) + 1), ')');
                            colorMapString = strcat(colorMapString, ' + fslice(', num2str(base2dec(indices(k), length(fslice)) + 1), ')');
                            fColorValueString = [num2str(interp1(f, map(:,1), fslice(base2dec(indices(k), length(fslice)) + 1))) ' ' ...
                                num2str(interp1(f, map(:,2), fslice(base2dec(indices(k), length(fslice)) + 1))) ' ' ...
                                num2str(interp1(f, map(:,3), fslice(base2dec(indices(k), length(fslice)) + 1)))];
                            titleString = strcat(titleString, '\color[rgb]{', fColorValueString ,'}f_', num2str(k+2), '=', ...
                                num2str(fslice(base2dec(indices(k), length(fslice)) + 1)), ',' );
                        end
                        titleString = titleString(1:end-1);
                        titleString = strcat(titleString,'}');
                        [F1, F2] = meshgrid(freq/nargin(Hfun),freq/nargin(Hfun));
                        eval(['h = surf(scaleFreq(F1), scaleFreq(F2), scaleGFRF(Hfun(' fString ')),' colorMapString ');']); 
                        set(h, 'EdgeColor', 'none', 'FaceColor','interp')
                        axis([-fmax/nargin(Hfun) fmax/nargin(Hfun) -fmax/nargin(Hfun) fmax/nargin(Hfun)]);
                        ylimit = get(gca,'YLim');
                        xlimit = get(gca,'XLim');
                        zlimit = get(gca,'ZLim');
                        set(ha(j+1), 'CameraPosition', [3 * xlimit(2) 3.3 * ylimit(1) 1.4 * zlimit(2)])
                        plotColoredLine(scaleFreq(freq/nargin(Hfun)), ylimit(1)*ones(size(freq)), zlimit(1)*ones(size(freq)), scaleFreq(f), map, 'x', 10)
                        plotColoredLine(xlimit(2)*ones(size(freq)), scaleFreq(freq/nargin(Hfun)), zlimit(1)*ones(size(freq)), scaleFreq(f), map, 'y', 10)
                        colormap(map)
                        title(titleString, 'FontWeight', 'Bold');
                        ylabel('f_2 (Hz)'); 
                        xlabel('f_1 (Hz)');
                        if (mod(j+1,numberOfCols) == 1)
                            zlabel(['|H_' num2str(nargin(Hfun)) '|']);
                        end
                        p = get(gca, 'Position');
                        set(gca,'Position', p,'Box','Off', 'LineWidth', 2);
                        caxis([-fmax fmax])
                    end
                    c1 = colorbar('location', 'East', 'units','centimeters','Position',[p(1)+p(3)+1.3 p(2) 0.7 numberOfRows*p(4) + (numberOfRows-1) * gapVertical]);
                    axes(ha(end))
                    set(gca,'Position', p,'Box','Off', 'LineWidth', 2);
                end
            end
            print([fileName num2str(nargin(Hfun))], '-depsc', '-r300','-cmyk')
        end
    end
end
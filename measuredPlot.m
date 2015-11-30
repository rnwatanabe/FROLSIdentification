%% Builds a set of subplots with the specified measures.
%
%
%   ha = measuredPlot(numberOfRows, numberOfCols, unit, height, width, gapVertical, gapHorizontal, marginTop, ...
%    marginBottom, marginLeft, marginRight)
%   where:
%
%   numberOfRows is the number of subplot rows that the figure will have.
%
%   numberOfCols is the number of subplot columns that the figure will have.
%
%   unit is a string with the length unit to be used. Possible units are 'pixels', 'normalized', 'inches', 
%   'centimeters', 'points' and 'characters'.
%
%   figureHeight is the height of each plot, in the established unit.
%
%   figureWidth is the width of each plot, in the established unit.
%
%   gapVertical is the vertical gap between the plots, in the established unit.
%
%   gapHorizontal is the horizontal gap between the plots, in the established unit.
%
%   marginTop is the margin in the top of the figure, in the established unit.
%
%   marginBottom is the margin in the bottom of the figure, in the established unit.
%
%   marginLeft is the margin in the left side of the figure, in the established unit.
%
%   marginRight is the margin in the right side of the figure, in the established unit.

function ha = measuredPlot(numberOfRows, numberOfCols, unit, height, width, gapVertical, gapHorizontal, marginTop, ...
    marginBottom, marginLeft, marginRight)

    % Calculation of axis width and height
    axesWidth = (width - (marginLeft + marginRight) - (numberOfCols - 1) * gapHorizontal) / numberOfCols;
    axesHeight = (height - (marginTop + marginBottom) - (numberOfRows - 1) * gapVertical) / numberOfRows;
    
    % Obtain screed dimensions to place figure in the centre
    set(0, 'units', unit);
    screensize = get(0, 'screensize');
    figureSize = [ screensize(3)/2 - width/2  screensize(4)/2 - height/2 width height];
    
    % Set bounding box equal to figure dimensions
    set(gcf, 'units', unit,'PaperPosition', figureSize, 'Position',...
        figureSize, 'Resize', 'off')
    
    % set each axes position
    ha = zeros(numberOfRows * numberOfCols, 1);
    
    py = height - marginTop - axesHeight;
    
    figNumber = 1;
    for i = 1:numberOfRows
        px = marginLeft(1);
            for j = 1:numberOfCols                
                ha(figNumber) = axes('Units', unit, 'Position',[px py axesWidth axesHeight], ...
                    'XtickLabel', '', 'YtickLabel', '');
                px = px + axesWidth + gapHorizontal;
                figNumber = figNumber + 1;
            end
        py = py - axesHeight - gapVertical;
    end   

end
% Builds a set of subplots with the specified measures.
%
% written by: Renato Naville Watanabe 
%
%
% ha = measuredPlot(numberOfRows, numberOfCols, unit, height, width, gapVertical, gapHorizontal, marginTop, ...
%   marginBottom, marginLeft, marginRight)
%   
%
% Inputs:
%
%   numberOfRows: integer, is the number of subplot rows that the figure will have.
%
%   numberOfCols: integer, is the number of subplot columns that the figure will have.
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
%
% Outputs:
%
%   ha: vector of floats, each number is the identifier of each axes built
%   by the function. To make an specific axes active use the function axes. For example, to
%   make the axes 2 active, use axes(ha(2)).



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
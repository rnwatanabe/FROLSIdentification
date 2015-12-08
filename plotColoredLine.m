%   Function to print a curve with colors mapped by a colormap
%
%   written by: Renato Naville Watanabe
%
%   plotColoredLine(pointsX, pointsY, pointsZ, mapValue, mapColor, mapAxes, LineWidth)
%   
% Inputs:
%
%   pointsX: vector of floats, X coordinates of the line.
%
%   pointsY: vector of floats, Y coordinates of the line.
%
%   pointsZ: vector of floats, Z coordinates of the line.
%   
%   mapValue: vector of floats, values to which the specified mapAxes
%   should be referenced.
%
%   mapColor: matrix of floats (n x 3), RGB matrix with the same number of
%   lines of the mapValue vector. It is the color map that the line will be
%   plotted.
%
%   mapAxes: char, axes to which the mapValue should reference. Can be 'x',
%   'y' or 'z'.
%
%   LineWidth, float, width of the line to be plotted


function plotColoredLine(pointsX, pointsY, pointsZ, mapValue, mapColor, mapAxes, LineWidth)
    
    if strcmp(mapAxes,'x')
       pointsMap = pointsX; 
    else if strcmp(mapAxes,'y')
       pointsMap = pointsY; 
        else
            pointsMap = pointsZ; 
        end
    end
    hold on
    for i = 1:length(pointsX)-1
        plot3(pointsX(i:i+1), pointsY(i:i+1), pointsZ(i:i+1), 'Color', [interp1(mapValue, mapColor(:,1), pointsMap(i)) ...
                                                                interp1(mapValue, mapColor(:,2), pointsMap(i)) ...
                                                                interp1(mapValue, mapColor(:,3), pointsMap(i))], ...
                                                                'LineWidth', LineWidth);
    end
end
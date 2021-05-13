function circ = drawCenterOfIllumination(image, minVal, maxVal)
	% DRAWCENTEROFILLUMINATION draws the center of the image's illumination pattern based on a treshold
	% range
	%
	% SYNTAX:
	%    circ = drawCenterOfIllumination(image, minVal, maxVal)
	%
	% OPTIONAL INPUTS:
	%    image - An NxM array or a full path to an image file
	%    minVal - Bottom threshold value
	%    maxVal - Upper threshold value
	%
	% OUTPUTS:
	%    circ - Structure with fields XYcenter ([x, y]) and Radius (r) of the fit circle
	%
	% EXAMPLE:
	%
	%
	% SEE ALSO:
	%    CIRCLE, CIRCLEFIT
	
	% Created on: September 27, 2019
	% By: Jeremiah Valenzuela
	
	if ~exist('image', 'var')
		image = imread(uigetfullfile('*.bmp;*.tif', 'Select an image file.'));
	else
		if strcmpi(image, '')
			image = imread(uigetfullfile('*.bmp;*.tif', 'Select an image file.'));
		elseif contains(class(image),{'char', 'string'})
			image = imread(image);
		end
	end
    
    if size(image, 3) == 3
        if isequal(image(:, :, 1), image(:, :, 2), image(:, :, 3))
            image = image(:,:,1);
        else
            image = rgb2gray(image);
        end
    end
    
	if exist('minVal', 'var')
		if ~exist('maxVal', 'var')
			error('Both minVal and maxVal values are required if one or the other is specified.')
		end
	else
		[minVal, maxVal] = selectThreshold(image);
		if isempty(minVal)
			circ = [];
			return
		end
	end
	
	mask = image > minVal & image < maxVal;
	[y, x] = find(mask);
	circ = circlefit(x, y);
    circ.XYoffset = [circ.XYcenter(1) - size(image, 2)/2 + 0.5, circ.XYcenter(2) - size(image, 1)/2 + 0.5];
    circ.ImageCenter = [size(image, 2)/2 + 0.5, size(image, 1)/2 + 0.5];
	figure;
	imshow(image);
	tightenaxes(gca, 'zeroedge');
	hold on
	circle(circ.XYcenter(1), circ.XYcenter(2), circ.Radius, 'red', 'LineWidth', 3);
	plot(circ.XYcenter(1), circ.XYcenter(2), 'r.', 'MarkerSize', 15);
    xline(circ.ImageCenter(1), '-.b')
    yline(circ.ImageCenter(2), '-.b')
	text(.01, .99, {...
        'X, Y Center (pixels)', ...
        ['[', num2str(circ.XYcenter(1), '%.1f'), ', ', num2str(circ.XYcenter(2), '%.1f'), ']'], ...
		'Radius (pixels)', ...
        num2str(circ.Radius, '%.2f'), ...
        'X, Y Center Offset (pixels)', ...
        ['[', num2str(circ.XYoffset(1), '%.1f'), ', ', num2str(circ.XYoffset(2), '%.1f'), ']'], ...
        'Dimensional Center (pixels)', ...
        ['[', num2str(circ.ImageCenter(1), '%.1f'), ', ', num2str(circ.ImageCenter(2), '%.1f'), ']'] ...
        }, 'Color', 'green', 'Units', 'normalized', 'VerticalAlignment', ...
		'top', 'FontWeight', 'bold', 'FontUnits', 'Normalized')
	
end

%% selectTreshhold
function [minVal, maxVal] = selectThreshold(image)
	% Adapted from readPoints
	%   Read manually-defined points from image
	%   [minVal, maxVal] = selectThreshold(image) displays the image in the current figure,
	%   then records the position of each click of button 1 of the mouse in the
	%   figure, and stops when another button is clicked. The image is filtered based on the clicks
	%   and the user is asked if the results are approved. The output is [minVal, maxVal] based on the
	%   values of the points clicked.
	%
	%   original function POINTS = READPOINTS(IMAGE, N) reads up to N points only.
	
	fig = figure;
 	
	while true
		fig.WindowButtonMotionFcn = @mousemove;
		warning('off', 'images:initSize:adjustingMag')
		imshow(image); % display image
		axe = gca;
		tightenaxes(axe, 'leavetop');
		hotspots = colormap(gray(256));
		hotspots(1:5, :) = zeros(5, 3) + [0, 1, 1];
		hotspots(end - 4:end, :) = zeros(5, 3) + [1, 0, 0];
		colormap(axe, hotspots)

		ttle = title(axe, ' ');
		
		k = 1;
		minVal = min(image, [], 'all');
		maxVal = max(image, [], 'all');
		hold on
		while true
			
			if k == 1
				ttle.String = 'Select pixel for bottom of threshold...';
				ttle.Color = 'red';
			elseif k == 2
				ttle.String = 'Select pixel for top of threshold...';
				ttle.Color = 'blue';
			end
			
			if k == 1
				while true
					waitforbuttonpress;
					rVal = round(axe.CurrentPoint(1,2));
					cVal = round(axe.CurrentPoint(1,1));
					if [rVal, cVal] >= [0, 0] & [rVal, cVal] < size(image)
						minVal = axe.Children(1).CData(rVal, cVal);
						break
					end
				end
			elseif k == 2
				while true
					waitforbuttonpress;
					rVal = round(axe.CurrentPoint(1,2));
					cVal = round(axe.CurrentPoint(1,1));
					if [rVal, cVal] >= [0, 0] & [rVal, cVal] < size(image) %#ok<*BDSCA,*AND2>
						maxVal = axe.Children(1).CData(rVal, cVal);
						fig.WindowButtonMotionFcn = [];
						break
					end
				end
			end
			
			filteredImage = image;
			filteredImage(filteredImage < minVal | filteredImage > maxVal) = 0;
			imshow(filteredImage, 'Parent', axe);
			
			if isequal(k, 2)
				ttle.String = 'Done!';
				ttle.Color = 'green';
				break
			end
			k = k + 1;
		end
		
		mask = image > minVal & image < maxVal;
	[y, x] = find(mask);
	circ = circlefit(x, y);
	circle(circ.XYcenter(1), circ.XYcenter(2), circ.Radius, 'red', 'LineWidth', 2);
		answer = questdlg('Happy with your selection?', '', 'Yes', 'No', 'Yes');
		
		switch answer
			case 'Yes'
				close(fig)
				break
			case 'No'
				% Continue
				hold off
			case ''
				close(fig)
				minVal = [];
				maxVal = [];
				break
		end
		
	end
end

%% funcMousemove
function mousemove(~, ~)
	axe = gca;
	currentRow = round(axe.CurrentPoint(1, 2));
	currentCol = round(axe.CurrentPoint(1, 1));
	
	if [currentRow, currentCol] >= [0, 0] & [currentRow, currentCol] <= size(axe.Children(1).CData)
		strDigits = digits(intmax(class(axe.Children(1).CData)), 'str');
		pxlValue = axe.Children(1).CData(currentRow, currentCol);
		axe.Title.String = regexprep(axe.Title.String, '\.\.\..*', ['... Pixel Value: ', sprintf(['%', strDigits, 'd'], pxlValue)]);
	else
		%Cursor is outside axis
		axe.Title.String = regexprep(axe.Title.String, '\.\.\..*', '...');
	end
end
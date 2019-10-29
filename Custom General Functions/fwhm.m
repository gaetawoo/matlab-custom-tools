function fullWidth = fwhm(x, y)
	% FWHM Computes the full-width half-max of a concave pulse function
	%
	% Syntax:
	%  fullWidth = fwhm(x, y)
	%
	% Inputs:
	%  x - Vector of x values of the pulse (domain)
	%  y - Vector of y values of the pulse (range)
	%
	% Outputs:
	%  fullWidth - Width of the pulse at 50% of the pulse peak in units of x

	% Created on: August 02, 2019
	% By: Jeremiah Valenzuela
	
	% Remove duplicates and normalize
	[y, uniqueIndicies] = unique(y, 'rows', 'stable');
	x = x(uniqueIndicies);
	y = y / max(y);
	
	% Get index of the peak data point of the pulse
	if y(1) < 0.5
		[~, centerindex] = max(y); % Pulse points up
	else
		[~, centerindex] = min(y); % Pulse points down
	end
	
	% Interpolate 50% points and compute result
	leftPosition = interp1(y(1:centerindex), x(1:centerindex), 0.5);
	rightPosition = interp1(y(centerindex:end), x(centerindex:end), 0.5);
	fullWidth = rightPosition - leftPosition;
end
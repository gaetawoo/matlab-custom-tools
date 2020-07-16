function outputMatrix = rotateXYaboutpoint(xColVector, yColVector, pivotPoint, angleDeg, CWorCCW)
  % From https://www.mathworks.com/matlabcentral/answers/2302-rotation-about-a-point
	% Positive input angle means CW clockwise rotation
  if ~exist('CWorCCW', 'var')
		if angleDeg > 0
			CWorCCW = 'CW';
		else
			CWorCCW = 'CCW';
		end
	else
		if ~strcmpi(CWorCCW, {'CW', 'CCW'})
			error('CWorCCW input argument must be ''CW'' or ''CCW''')
		end
	end
	
	if strcmpi(CWorCCW, 'CW')
		theta = abs(angleDeg);
	else
		theta = -abs(angleDeg);
	end
	
  D.x = xColVector;
  D.y = yColVector;
  P = pivotPoint;  % Rotation pivot point.
  r = [cosd(theta), -sind(theta); sind(theta), cosd(theta)];
  T = bsxfun(@(x,y) r*x, [D.x.' - P(1); D.y.' - P(2)], false(1,length(D.x)))';
  outputMatrix = [T(:, 1) + P(1), T(:, 2) + P(2)];
end
function outputMatrix = rotateXYaboutpoint(xColVector, yColVector, pivotPoint, angleDeg)
  % From https://www.mathworks.com/matlabcentral/answers/2302-rotation-about-a-point
  
  D.x = xColVector;
  D.y = yColVector;
  theta = angleDeg;  % Rotation angle.
  P = pivotPoint;  % Rotation pivot point.
  r = [cosd(theta), -sind(theta); sind(theta), cosd(theta)];
  T = bsxfun(@(x,y) r*x, [D.x.' - P(1); D.y.' - P(2)], false(1,length(D.x)))';
  outputMatrix = [T(:, 1) + P(1), T(:, 2) + P(2)];
end
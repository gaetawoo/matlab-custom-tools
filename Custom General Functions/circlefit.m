function circ = circlefit(x, y)
  %
  %   circ = circlefit(x,y)
  %
  %   fits a circle  in x,y plane in a more accurate
  %   (less prone to ill condition )
  %  procedure than circfit2 but using more memory
  %  x,y are column vector where (x(i),y(i)) is a measured point
  %
  %  result is center point (yc,xc) and radius R
  %  an optional output is the vector of coeficient a
  % describing the circle's equation
  %
  %   x^2+y^2+a(1)*x+a(2)*y+a(3)=0
  %
  %  By:  Izhak bucher 25/oct /1991,
  %  
  %  HINT: To get points to use as a fit from an image, threshold the image and then use find to
  %  return the rows and columns within the array of the remaining points.
  %  Example:
  %  mask = array > 30 & array < 40;
  %  [y, x] = find(mask);
	%
	% 	mask = img > 70 & img < 80;
	% 	[y, x] = find(mask);
	% 	figure;
	% 	imshow(img);
	% 	hold on
	% 	circ = circlefit(x, y);
	% 	circle(circ.XYcenter(1), circ.XYcenter(2), circ.Radius);
  
  x = x(:); y = y(:);
  a = [x, y, ones(size(x))] \ -(x.^2 + y.^2);
  circ.XYcenter = [-0.5 * a(1), -0.5 * a(2)];
  circ.Radius = sqrt((a(1)^2 + a(2)^2) / 4 - a(3));
end
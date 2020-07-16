function ellipse = ellipsefit(x, y)
	%
	%   ellipse = ellipsefit(x, y)
	%
	%   fits an ellipse  in x,y plane in a more accurate
	%   (less prone to ill condition )
	%  procedure than circfit2 but using more memory
	%  x,y are column vector where (x(i),y(i)) is a measured point
	%
	%  result is center point (yc,xc) and radius R
	%  an optional output is the vector of coeficient a
	% describing the circle's equation
	%
	%   p(1)*x^2 + p(2)*x*y + y^2 + p(3)*x + p(4)y + p(5) = 0
	%
	%  By:  Jeremiah Valenzuela April 24, 2020
	%
	% 	Theory: (from https://en.wikipedia.org/wiki/Ellipse)
	% 	Non-rotated Ellipse Equation : 1/a^2*(x - h)^2 + 1/b^2*(y - k)^2 = 1
	% 	Generalized Ellipse Equ : Ax^2 + Bxy + Cy^2 + Dx + Ey + F = 0
	%   C = 1 (so that y^2 can be the independant variable)
	% 	a = major axis = -sqrt(2(AE^2 + CD^2 - BDE + F(B^2 - 4AC))((A + C) + sqrt((A - C)^2 + B^2)))/(B^2 - 4AC)
	%   b = minor axis = -sqrt(2(AE^2 + CD^2 - BDE + F(B^2 - 4AC))((A + C) - sqrt((A - C)^2 + B^2)))/(B^2 - 4AC)
	%   h = xOrigin = (2CD - BE)/(B^2 - 4AC)
	%   k = yOrigin = (2AE - BD)/(B^2 - 4AC)
	%   theta = angle from positive horiz. axis to ellipse major axis
	%         = atan(1/B * (C - A - sqrt((A - C)^2 + B^2))) :: for B != 0
	%         = 0° :: for B = 0, A < C
	%         = 90° :: for B = 0, A > C
	%
	%   In this function:
	%   A = p(1), B = p(2), C = 1, D = p(3), E = p(4), F = p(5)
	%
	%  NOTE!!
	%  The more filled in the ellipse is, the worse the result for the minor axis is. For a completely
	%  filled in ellipse, the minor axis will report approximately RealMinorRadius/sqrt(3)
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
	% 	ellipse = ellipsefit(x, y);
	
	x = x(:); y = y(:);
	p = [x.^2, x.*y, x, y, ones(size(x))] \ -(y.^2);
	p = round(p, 14); % Assume very small numbers are 0
	A = p(1); B = p(2); C = 1; D = p(3); E = p(4); F = p(5);
	
	ellipse.MajorRadius = -sqrt(2 * (A * E^2 + C * D^2 - B * D * E + F * (B^2 - 4 * A * C)) * ((A + C) + sqrt((A - C)^2 + B^2))) / (B^2  - 4 * A * C);
	ellipse.MinorRadius = -sqrt(2 * (A * E^2 + C * D^2 - B * D * E + F * (B^2 - 4 * A * C)) * ((A + C) - sqrt((A - C)^2 + B^2))) / (B^2  - 4 * A * C);
	ellipse.XYcenter = [(2 * C * D) / (B^2 - 4 * A * C),...
		                  (2 * A * E) / (B^2 - 4 * A * C)];
	if B == 0
		if A <= C
			ellipse.ThetaDeg = 0;
		else
			ellipse.ThetaDeg = 90;
		end
	else
		ellipse.ThetaDeg = atan((1 / B) * (C - A - sqrt((A - C)^2 + B^2)));
	end
		
end
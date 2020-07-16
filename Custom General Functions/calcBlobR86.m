function R86 = calcBlobR86(inputImage, threshold)
	
	xy = regionprops(imerode(imdilate(inputImage > threshold, strel('square', 9)), strel('square', 9)), 'centroid');
	xy = xy.Centroid;
	
	
	% Create sub-pixel centroid-centered grid
	[X, Y] = meshgrid((1:size(inputImage, 2)) - 0.5, (1:size(inputImage, 1)) - 0.5);
	R = ((X - xy(1)).^2 + (Y - xy(2)).^2).^(1/2);
	
	
	% Sort and find total counts or eneregy
	data = [double(R(:)), double(inputImage(:))];
	data = sortrows(data, 1);
	data(:, 3) = cumsum(data(:, 2));
	E100 = data(end, 3);
	
	% Determine Encircled Energy at 1/e^2
	E86 = E100 * (1-(exp(-2)));
	
	
	k0 = find(data(:, 3) > E86*.20, 1);
	%   k1 = find(data(:, 3) > E86*.95, 1);
	k2 = find(data(:, 3) > E86*1.05, 1);
	%
	%   % Shortcut Way
	%   out = data(find(data(:, 3) <= E86,1,'last'), 1)
	%
	%   % Agatha's python way
	%   pp = polyfit(data(k1:k2, 3)/E86 - 1, data(k1:k2, 1), 1);
	%   out = pp(end)
	%
	%   % Linear Regression way
	%   coef = [data(k1:k2, 3)/E86 - 1, ones(size(data(k1:k2, 1)))] \ [data(k1:k2, 1)];
	%   out = coef(end)
	
	% Best fit polynomial way
	[p, fitProperties, S, mu] = polyfitsmart(data(k0:k2, 3), data(k0:k2, 1), 1); %#ok<ASGLU>
	R86 = polyval(p, E86, S, mu);
	
end
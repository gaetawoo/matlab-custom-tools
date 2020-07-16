function structCorners = findCornersOfGridList(xyList, yIncreasesGoing)
	% FINDCORNERSOFGRIDLIST assuming a square grid-like dataset, will find the 4 extreme corners of the
	% data, depending on coordinate system convention (y increasing going down or up)
	%
	% SYNTAX:
	%    structCorners = findCornersofGridList(xyList)
	%
	% INPUTS:
	%    xyList - square grid-like pairs of x,y coordinates
	%    yIncreasesGoing - 'up' or 'down'
	%
	% OUTPUTS:
	%    structCorners - corner locations stored in a structure
	%
	% EXAMPLE:
	%
	%
	% SEE ALSO:
	%
	
	% Created on: April 09, 2020
	% By: Jeremiah J. Valenzuela
	
	% Initalize variables
	k = 1;
	corners = zeros(4,2);
	distance = zeros(size(xyList, 1), 1);
	
	% Cycle through points as baseline
	for ii = 1:size(xyList, 1)
		% Cycle through points as comparitor
		for jj = 1:size(xyList, 1)
			% Calculate distance between each comparitor and baseline
			distance(jj) = norm(xyList(jj, :) - xyList(ii, :));
		end
		% Remove 0 distance
		distance(distance == 0) = [];
		% Sort distances closest to farthest
		sorted = sort(distance, 'ascend');
		% Establish distance to nearest neighbors
		meanNearest = mean(sorted([1 2]));
		% Remove distances beyond threshold of nearest neighbors
		sorted(sorted > meanNearest * 1.2) = [];
		% If only 2 neighbors, then it's a corner
		if numel(sorted) == 2
			corners(k, :) = xyList(ii, :);
			k = k + 1;
		end
	end
	
	sortedCorners = sortrows(corners, 2, 'ascend');
	vertMinHalf = sortedCorners(1:2, :);
	vertMaxHalf = sortedCorners(3:4, :);
	
	% If coordinate system has y increasing going up
	if strcmpi(yIncreasesGoing, 'up')
		structCorners.BottomLeft = vertMinHalf(vertMinHalf(:, 1) == min(vertMinHalf(:, 1)), :);
		structCorners.BottomRight = vertMinHalf(vertMinHalf(:, 1) == max(vertMinHalf(:, 1)), :);
		structCorners.TopLeft = vertMaxHalf(vertMaxHalf(:, 1) == min(vertMaxHalf(:, 1)), :);
		structCorners.TopRight = vertMaxHalf(vertMaxHalf(:, 1) == max(vertMaxHalf(:, 1)), :);
	else
		structCorners.BottomLeft = vertMaxHalf(vertMaxHalf(:, 1) == min(vertMaxHalf(:, 1)), :);
		structCorners.BottomRight = vertMaxHalf(vertMaxHalf(:, 1) == max(vertMaxHalf(:, 1)), :);
		structCorners.TopLeft = vertMinHalf(vertMinHalf(:, 1) == min(vertMinHalf(:, 1)), :);
		structCorners.TopRight = vertMinHalf(vertMinHalf(:, 1) == max(vertMinHalf(:, 1)), :);
	end
end
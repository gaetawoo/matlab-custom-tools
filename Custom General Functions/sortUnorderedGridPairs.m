function sortedList = sortUnorderedGridPairs(unorderedList, rowSortDirection)
	% SORTUNORDEREDGRIDPAIRS assuming points are nominally aligned to a grid, this function will sort
	% them by row and then by column
	%
	% SYNTAX:
	%    sortedList = sortUnorderedGridPairs(unorderedList)
	%
	% INPUTS:
	%    unorderedList - vertical Mx2 array of pair x,y points
	%    rowSortDirection - 'ascend' or 'descend': y increases or decreases
	%
	% OUTPUTS:
	%    sortedList - pair of x,y points sorted by y then by x within each group of y's
	%
	% EXAMPLE:
	%
	%
	% SEE ALSO:
	%
	
	% Created on: April 09, 2020
	% By: Jeremiah J. Valenzuela

	sortedByY = sortrows(unorderedList, 2, 'ascend');
	
	% Calculate number of columns and rows
	columns = find(diff(sortedByY(:, 2)) > max(diff(sortedByY(:, 2))) / 2, 1);
	rows = size(sortedByY, 1) / columns;
	
	if exist('rowSortDirection', 'var') && strcmpi(rowSortDirection, 'descend')
		sortedByY = sortrows(unorderedList, 2, 'descend');
	end
	
	% Sort columns row by row and append
	sortedList = [];
	for nRows = 1:rows
		sortedList = [sortedList; sortrows(sortedByY((nRows - 1) * columns + [1:columns], :), 1, 'ascend')]; %#ok<AGROW>
	end
end
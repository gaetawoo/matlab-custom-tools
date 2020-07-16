function array_out = arange(range_in, dimensions)
	% ARANGE returns array of specified dimensions and elements in row-major order
	%
	% SYNTAX:
	%    array_out = arange(range_in, dimensions)
	%
	% INPUTS:
	%    range_in - Can be single interger, in which case the result will be a range from 1 to the
	%               interger. Can be a vector, in which case the result will be a range of all the
	%               vector elements. Number of elements must match the product of all dimensions.
	%    dimensions - Must be a vector of length 2 or more with only positive intergers denoting the
	%                 size for each dimension (row, column, depth, 4, 5, etc...)
	%
	% OUTPUTS:
	%    array_out - Numerical array in row-major order (counting starts from row 1 and proceeds right
	%                through the columns, until continuing on to next row). MATLAB default is
	%                column-major (which counts at the first column going down through the rows, and
	%                then to the next column).
	%
	% EXAMPLE:
	%    array = arange(25, [5, 5])
	%
	%
	% NOTES:
	%    Inspired by numpy.arange
	%
	
	% Created on: August 09, 2019
	% By: Jeremiah Valenzuela
	
	if nargin ~= 2
		if numel(range_in) == 1
			dimensions = [1, range_in];
		else
			dimensions = [1, numel(range_in)];
		end
	end
	
	if numel(dimensions) == 1
		error('Dimensions must be a vector with 2 or more elements.')
	end
	
	if numel(range_in) == 1
		range_in = 1:range_in;
	end
	
	if numel(range_in) ~= prod(dimensions)
		error(['Number of elements in range does not match product of dimensions.\n',...
			'Range has %d elements. Dimensions call for %d elements.'], numel(range_in), prod(dimensions))
	end
	
	% Remove first 2 dimensions
	num_of_dimensions = 1:numel(dimensions);
	num_of_dimensions(1:2) = [];
	
	cell_dimensions = num2cell(dimensions([2 1 3:end]));
	
	array_out = permute(reshape(range_in, cell_dimensions{:}), [2, 1, num_of_dimensions]);
end
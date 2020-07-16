function indices = mid(data, opt_dimension)
  %%INDICES = MID(DATA, OPT_DIMENSION)
  %
  %  Returns midpoint index values. 
  %    -If dimension is specified, returns single-dimensional index(es) of the midpoint of that
  %    dimension. 
  %    -If dimension is not specified, returns array-wide index(es) of the midpoint of the entire
  %    multidimensional array.
  %    -If elements along a given dimension are even in number, then central two indices
  %    will be returned.
  %
  % By Jeremiah J. Valenzuela
  % June 15, 2019
  
  % Check if dimension argument has been passed in
  if exist('opt_dimension', 'var')
    dimsize = size(data, opt_dimension);
    if mod(dimsize, 2) % is odd
      indices = ceil(dimsize / 2);
    else % is even
      indices = [dimsize / 2;
                 dimsize / 2 + 1];
    end
    
  else
    % Initialize main variables
    nDimensions = size(size(data), 2); % Number of dimensions
    nIndices = 2^sum(abs(mod(size(data), 2) - 1), 'all'); % Compute total number of midpoints
    indices = zeros(nIndices, 1);
    midSubscripts = zeros(nIndices, nDimensions);
    nTwoElementVectors = 0;
    for iDim = 1:nDimensions
      tempSubscripts = mid(data, iDim); % Recursive call with dimensional argument
      if size(tempSubscripts, 1) > 1 % If 2 subscript column vector returned
        nTwoElementVectors = nTwoElementVectors + 1;
        % Arrange corresponding subscripts so every possible point combination is created
        midSubscripts(1:nIndices, iDim) = reshape(reshape(kron(tempSubscripts',ones(nIndices / 2, 1)), 2^(nTwoElementVectors - 1), [])', [], 1);
      else % If single subscript is returned
        midSubscripts(1:nIndices, iDim) = tempSubscripts;
      end
    end
    
    % Convert each row of subscripts into an index of the point relative to the full array
    for iPoint = 1:nIndices
      cellSubscripts = num2cell(midSubscripts(iPoint, :));
      indices(iPoint, 1) = sub2ind(size(data), cellSubscripts{:});
    end
  end
end
function [uniqueData, uniqueIndicies, duplicateData, duplicateIndicies] = uniquerows(data)
	%
	%
	%
	% See also: SETDIFF
  
  [uniqueData, uniqueIndicies] = unique(data, 'rows', 'stable');
  duplicateIndicies = setdiff(1:size(data, 1), uniqueIndicies)';
  duplicateData = data(duplicateIndicies, :);
  
end
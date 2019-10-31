function [uniqueData, uniqueIndicies, duplicateData, duplicateIndicies] = uniquerows(data)
	if iscell(data)
		[uniqueData, uniqueIndicies] = unique(data, 'stable');
	else
		[uniqueData, uniqueIndicies] = unique(data, 'rows', 'stable');
	end
	duplicateIndicies = setdiff(1:size(data, 1), uniqueIndicies)';
	duplicateData = data(duplicateIndicies, :);
	
end
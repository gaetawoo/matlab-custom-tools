function normalizedImage = normalizeimage(imageSingle, newMin, newMax)
	
	% Array must be size > 1
	if numel(imageSingle) < 2
		error('Number of elements in array must be 2 or more.');
	end
	
	% If array is not made of floats, then convert
  if ~strcmpi(class(imageSingle), 'single') && ~strcmpi(class(imageSingle), 'double')
    imageSingle = single(imageSingle);
  end
  
  imageSingle(isinf(imageSingle)) = NaN;
  x = (newMax - newMin) / (max(imageSingle, [], 'all', 'omitnan') - min(imageSingle, [], 'all', 'omitnan'));
  b = newMax - x * max(imageSingle, [], 'all', 'omitnan');
  
  normalizedImage = x .* imageSingle + b;
end
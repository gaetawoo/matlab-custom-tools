function normalizedImage = NormalizeImage(imageSingle, newMin, newMax)
if ~strcmpi(class(imageSingle), 'single') && ~strcmpi(class(imageSingle), 'double')
  imageSingle = single(imageSingle);
end
imageSingle(isinf(imageSingle)) = NaN;

x = (newMax - newMin) / (max(imageSingle(:), [], 'omitnan') - min(imageSingle(:), [], 'omitnan'));
b = newMax - x * max(imageSingle(:), [], 'omitnan');

normalizedImage = x .* imageSingle + b;
end
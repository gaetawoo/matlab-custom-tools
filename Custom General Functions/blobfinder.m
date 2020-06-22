function blobList = blobfinder(inputImage, thresholdDN, thresholdArea)
	% BLOBFINDER locate all viable blobs in an image and output as a list
	%
	% SYNTAX:
	%    blobList = blobfinder(inputImage, thresholdDN, thresholdArea)
	%
	% INPUTS:
	%    inputImage - M x N array of values
	%    (optional) 
	%    thresholdDN - pixel value limit below which to ignore
	%    thresholdArea - blob area limit below which to ignore
	%
	% OUTPUTS:
	%    blobList - list where each row is a blob with information
	%      [# blob, blob label, x centroid, y centroid, blob area, blob max DN, blob min DN, blob mean
	%      DN]
	%
	% EXAMPLE:
	%
	%
	% SEE ALSO:
	%
	
	% Created on: April 07, 2020
	% By: Jeremiah J. Valenzuela
	
	if ~exist('thresholdArea', 'var')
		thresholdArea = 0;
	end
	
	if ~exist('thresholdDN', 'var')
		bd = getBitDepth(inputImage);
		thresholdDN = 25 * 2^(bd.BitDepth - 8);
	end
		
	% Label and count contiguous regions above threshold
	[bwblobs, blobcounts] = bwlabeljj3(inputImage > thresholdDN);
	
	if isempty(blobcounts)
		blobList = [];
		return
	end
		
	% Sort blob labels by blob size, largest to smallest
	[sortedAreas, sortedLabels] = sort(sum(blobcounts(:) == (1:max(blobcounts))), 'descend');
	
	% Filter blobs that do not meet the area threshold
	sortedLabels(sortedAreas < thresholdArea) = [];
	sortedAreas(sortedAreas < thresholdArea) = [];
	
	% Determine how many unique areas (blobs) have been identified
	nBlobs = numel(sortedAreas);
	blobList = zeros(nBlobs, 8);
	
	% Loop through blobs
	for iBlob = 1:nBlobs
		rcFullCentroid = bwblobcentroidjj(bwblobs, sortedLabels(iBlob));
		blobList(iBlob, :) = [...
			iBlob,...
			sortedLabels(iBlob),...
			rcFullCentroid.Col,...
			rcFullCentroid.Row,...
			sortedAreas(iBlob),...
			max(double(inputImage(bwblobs == sortedLabels(iBlob)))),...
			min(double(inputImage(bwblobs == sortedLabels(iBlob)))),...
			mean(inputImage(bwblobs == sortedLabels(iBlob)))];
	end
end
function [snip, xyfullcentroid, boundary] = blobsnipper(inputImage, threshold, snippetSize)
  
  if ~exist('threshold', 'var')
    threshold = 10; % Counts
  end
  
  if ~exist('snippetSize', 'var')
    snippetSize = 32; % Pixels
  end
  
  if ~exist('inputImage', 'var')
    cprintf('*Red', 'Please input source image as first argument.')
    return
  end
  
  if ~isnumeric(inputImage)
    inputImage = imread(inputImage);
  end
    
  %% Get centroid of spot
	rpOut = regionprops(imerode(imdilate(inputImage > threshold, strel('square', 9)), strel('square', 9)), inputImage, {'WeightedCentroid', 'Area', 'MaxIntensity', 'MeanIntensity'});
	rpOut([rpOut.Area] < 9) = []; % Limit allowed blob sizes
	xyfullcentroid = rpOut([rpOut.MeanIntensity] == max([rpOut.MeanIntensity])).WeightedCentroid;
	rcfullcentroid.Col = xyfullcentroid(1);
	rcfullcentroid.Row = xyfullcentroid(2);
	
  % Alternate:
  % rcCentroid = bwblobcentroidjj(bwblobs, ...
  %  find(sum(blobcounts(:) == (1:max(blobcounts))) == max(sum(blobcounts(:) == (1:max(blobcounts))))));
  if isnanfields(rcfullcentroid) | isempty(xyfullcentroid) %#ok<OR2>
    cprintf('*Red', 'No blob found.\n\n')
    snip = [];
    return
	end
	
	rcfullcentroid.Col = round(rcfullcentroid.Col);
	rcfullcentroid.Row = round(rcfullcentroid.Row);

  %% Get final cumulative power
  % Check snipping region to make sure it is within the image bounds
  edgeLeft = rcfullcentroid.Col - round(snippetSize / 2);
  edgeRight = rcfullcentroid.Col + round(snippetSize / 2) - 1;
  edgeTop = rcfullcentroid.Row - round(snippetSize / 2);
  edgeBottom = rcfullcentroid.Row + round(snippetSize / 2) - 1;
  if edgeLeft < 1, edgeLeft = 1; end
  if edgeRight > size(inputImage, 2), edgeRight = size(inputImage, 2); end
  if edgeTop < 1, edgeTop = 1; end
  if edgeBottom > size(inputImage, 1), edgeBottom = size(inputImage, 1); end
  
  % Crop to snippet of spot
  snip = inputImage(edgeTop:edgeBottom, edgeLeft:edgeRight);
  boundary = [edgeTop, edgeBottom, edgeLeft, edgeRight];
  % Display snippet for verification of a good crop
  figure
	if strcmpi(class(snip), 'double')
		imshow(snip, [])
	else
		imshow(snip);
	end
  tightenaxes(gca, 'zeroedge')
end
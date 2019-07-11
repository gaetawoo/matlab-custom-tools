function [snip, xyfullcentroid] = blobsnipper(inputImage, snippetSize, threshold)
  
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
  % Label and count contiguous regions above threshold
  [bwblobs, blobcounts] = bwlabeljj3(inputImage > threshold);
  
  % Find largest contiguous region label
  [largestblobSize, largestblobID] = max(sum(blobcounts(:) == (1:max(blobcounts))));
  
  % Get centroid of region with largest contiguous region label
  rcfullcentroid = bwblobcentroidjj(bwblobs, largestblobID);
  xyfullcentroid = [rcfullcentroid.Col, rcfullcentroid.Row];
  % Alternate:
  % rcCentroid = bwblobcentroidjj(bwblobs, ...
  %  find(sum(blobcounts(:) == (1:max(blobcounts))) == max(sum(blobcounts(:) == (1:max(blobcounts))))));
  if isnanfields(rcfullcentroid) | largestblobSize < 10 %#ok<OR2>
    cprintf('*Red', 'No blob found.\n\n')
    snip = [];
    return
  end
  
  rcfullcentroid.Row = round(rcfullcentroid.Row);
  rcfullcentroid.Col = round(rcfullcentroid.Col);
  %% Get final cumulative power
  % Check snipping region to make sure it is within the image bounds
  edgeLeft = rcfullcentroid.Col - round(snippetSize / 2) + 1;
  edgeRight = rcfullcentroid.Col + round(snippetSize / 2);
  edgeTop = rcfullcentroid.Row - round(snippetSize / 2) + 1;
  edgeBottom = rcfullcentroid.Row + round(snippetSize / 2);
  if edgeLeft < 1, edgeLeft = 1; end
  if edgeRight > size(inputImage, 2), edgeRight = size(inputImage, 2); end
  if edgeTop < 1, edgeTop = 1; end
  if edgeBottom > size(inputImage, 1), edgeBottom = size(inputImage, 1); end
  
  % Crop to snippet of spot
  snip = inputImage(edgeTop:edgeBottom, edgeLeft:edgeRight);
  
  % Display snippet for verification of a good crop
  figure
  imshow(snip);
  disp({'Centroid as X,Y'})
  disp(xyfullcentroid)
  
end
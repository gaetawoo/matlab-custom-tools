[bigFname, fPath] = uigetfile('*AgathaGhostTest_St*.tif*', 'Select Large Image File(s)', ...
  'MultiSelect', 'on');

% Check if uigetfile was cancelled out
if ~iscell(bigFname) && ~ischar(bigFname)
  return
end

% Set to cell if string
if ~iscell(bigFname)
  bigFname = {bigFname};
end

bigFname = bigFname';

for nFiles = 1:size(bigFname, 1)
  main(fPath, bigFname(nFiles))
end

function main(fpath, fname)
  fullimage = imread([fpath, fname{1}]);
  threshold = 100;
  t = tic;
  t2 = tic;
  [bwblobs, blobcounts] = bwlabeljj3(fullimage > threshold);
  toc(t2)
  [~, largestblobID] = max(sum(blobcounts(:) == (1:max(blobcounts))));
  rcfullcentroid = bwblobcentroidjj(bwblobs, largestblobID);
  rcfullcentroid.Row = round(rcfullcentroid.Row);
  rcfullcentroid.Col = round(rcfullcentroid.Col);

  toc(t)
  disp(' ')
  blobsnippet = fullimage(rcfullcentroid.Row - 15:rcfullcentroid.Row + 16,...
    rcfullcentroid.Col - 15:rcfullcentroid.Col + 16);
  %imshow(blobsnippet,[])
  
  % Example of how to extract blob regions to evaluate them instead of using full image
  % [bwblobs, blobcounts] = bwlabeljj(fullimage > threshold);
  % [~, largestblobID] = max(sum(blobcounts(:) == (1:max(blobcounts))));
  % tic
  % largestblobindxs = find(bwblobs == largestblobID);
  % [logicalblob, rcblobregion] = bwextractblobjj(largestblobindxs, bwblobs);
  % rcblobcentroid = round(bwblobcentroidjj2(logicalblob));
  % rcblobcentroidInFullImage = bwtranslateblobcentroidtofullimagejj(rcblobregion(1, :), rcblobcentroid)
  % blobsnippet = fullimage(rcblobcentroidInFullImage.Row - 15:rcblobcentroidInFullImage.Row + 16,...
  %                         rcblobcentroidInFullImage.Col - 15:rcblobcentroidInFullImage.Col + 16);
end


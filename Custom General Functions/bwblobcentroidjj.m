function rcCoords = bwblobcentroidjj(region, blobFillValue)
  
  % Method 1 - Matrix Muplication - Slowest
  %   [c, r] = meshgrid(1:size(region, 2), 1:size(region, 1));
  %   weightedc = c .* region;
  %   weightedr = r .* region;
  %   rccoords = [sum(weightedr(:)) / sum(region(:)), sum(weightedc(:)) / sum(region(:))];
  
  % Method 2 - Looping - Faster
  %   Rs = 0;
  %   Cs = 0;
  %   area = 0;
  %   for r = 1:size(region, 1)
  %     for c = 1:size(region, 2)
  %       if region(r, c)
  %         Rs = Rs + r;
  %         Cs = Cs + c;
  %         area = area + 1;
  %       end
  %     end
  %   end
  %   Rs = Rs / area;
  %   Cs = Cs / area;
  %   rccoords = [Rs, Cs];
  
  % Method 3 - Direct Logical Indexing - Fastest
  if nargin == 1
    blobFillValue = 1;
  end
  [r, c] = find(region == blobFillValue);
  rcCoords.Row = mean(r);
  rcCoords.Col = mean(c);
end
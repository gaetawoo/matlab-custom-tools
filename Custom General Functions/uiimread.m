function [out, fullfilepath] = uiimread(title)
  if ~exist('title', 'var')
    title = 'Select Image File(s)';
  end
  [filenamesCell, filepath] = uigetfile('*.bmp;*.jpg;*.png;*.tif*', title, 'MultiSelect', 'on');
  
  % Check if uigetfile was cancelled out
  if ~iscell(filenamesCell) && ~ischar(filenamesCell)
    cprintf('*Red', 'No files selected\n')
    return
  end
  
  if ischar(filenamesCell)
    fullfilepath = string([filepath, filenamesCell]);
  else
    fullfilepath = string(cellfun(@(x) [filepath, x], filenamesCell, 'UniformOutput', false)');
  end
  
  % Set to cell if string
  if ~iscell(filenamesCell)
    filenamesCell = {filenamesCell};
  end
  
  filenamesCell = filenamesCell';
  
  hWaitbar = waitbar(0, ['0/', num2str(size(filenamesCell, 1)), ' Images Loaded. Loading: ', strrep(filenamesCell{1}, '_', '\_')]);
  out = imread([filepath, filenamesCell{1}]);
  
  if size(filenamesCell, 1) > 1
    out = cat(3, out, zeros([size(out), size(filenamesCell, 1) - 1]));
    for nFiles = 2:size(filenamesCell, 1)
      waitbar((nFiles - 1) / size(filenamesCell, 1), hWaitbar, [num2str(nFiles - 1), '/', num2str(size(filenamesCell, 1)), ' Images Loaded. Loading: ', strrep(filenamesCell{nFiles}, '_', '\_')]);
      out(:, :, nFiles) = imread([filepath, filenamesCell{nFiles}]);
    end
  end
  waitbar(1, hWaitbar, 'Completed!');
  close(hWaitbar)
  disp('Loaded Images:')
  disp(filenamesCell)
end






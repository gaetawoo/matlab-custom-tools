function [out, fullfilepath] = uiimread(title, suppressoutput)
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
  
  filenames = string(filenamesCell');
  
	out = imreadbulk(filenames, filepath);
	
	if ~exist('suppressoutput', 'var')
		disp('Loaded Images:')
		disp(filenames)
	end
end






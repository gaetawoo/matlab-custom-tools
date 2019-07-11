function fullfilepath = uigetfullfile(varargin)
%UIGETFULLFILE
% output is string array

  [filenames, filepath] = uigetfile(varargin{:});
  
  % Check if uigetfile was cancelled out
  if ~iscell(filenames) && ~ischar(filenames)
    error('No files selected')
  end
  
  if ischar(filenames)
    fullfilepath = string([filepath, filenames]);
  else
    fullfilepath = string(cellfun(@(x) [filepath, x], filenames, 'UniformOutput', false)');
  end
  
end
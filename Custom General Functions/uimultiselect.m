function [filenamesCell, filepathString] = uimultiselect(varargin)
  [filenames, filepathString] = uigetfile(varargin{:}, 'MultiSelect', 'on');
  
  % Check if uigetfile was cancelled out
  if ~iscell(filenames) && ~ischar(filenames)
    fprintf('No files selected\n')
    error('No files selected')
  end
  
  % Set to cell if string
  if ~iscell(filenames)
    filenames = {filenames};
  end
  
  filenamesCell = filenames';
end
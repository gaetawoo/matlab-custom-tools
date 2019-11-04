function [filenamesCell, filepathString] = uimultiselect(varargin)
  if isempty(varargin)
    [filenames, filepathString] = uigetfile('*.*', 'MultiSelect', 'on');
  else
    [filenames, filepathString] = uigetfile(varargin{:}, 'MultiSelect', 'on');
  end
    
  % Check if uigetfile was cancelled out
  if ~iscell(filenames) && ~ischar(filenames)
    filenames = 0;
    filepathString = 0;
  end
  
  % Set to cell if string
  if ~iscell(filenames)
    filenames = {filenames};
  end
  
  filenamesCell = filenames';
end
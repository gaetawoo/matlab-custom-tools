function fullfilepath = uigetfullfile(varargin)
	%UIGETFULLFILE
	% output is string array
	if isempty(varargin)
		[filenames, filepath] = uigetfile('*.*');
	else
		[filenames, filepath] = uigetfile(varargin{:});
	end
	
	% Check if uigetfile was cancelled out
	if ~iscell(filenames) && ~ischar(filenames)
		fullfilepath = 0;
	else
		if ischar(filenames)
			fullfilepath = string([filepath, filenames]);
		else
			fullfilepath = string(cellfun(@(x) [filepath, x], filenames, 'UniformOutput', false)');
		end
	end
end
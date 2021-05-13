function out = imreadbulk(filenames, filepath)
	% IMREADBULK stack images in bulk from a folder
	%
	% SYNTAX:
	%    out = imreadbulk(filenames, filepath)
	%
	% INPUTS:
	%    filenames - string (not char) vector
	%    filepath - single string
	%
	% OUTPUTS:
	%    out - 3D stacked image array
	%
	% EXAMPLE:
	%
	%
	% SEE ALSO:
	%    uiimread
	
	% Created on: June 12, 2020
	% By: Jeremiah Valenzuela
	
	% Convert filenames into a string object if it's a char
	if ~isstring(filenames)
		filenames = string(filenames);
	end
	
	% Load single argument input as single file with no waitbar dialog
	if nargin == 1
		out = imread(fullfile(filenames));
		if size(out, 3) > 2
			if isequal(out(:, :, 1), out(:, :, 2), out(:, :, 3))
				out = out(:, :, 1);
			end
		end
	end
	
	% Read in and process first file in dual arg. input with waitbar
	if nargin == 2
		hWaitbar = waitbar(0, join(['0/', num2str(numel(filenames)), ' Images Loaded. Loading: ', strrep(filenames(1), '_', '\_')], ""));
		out = imread(fullfile(filepath, filenames(1)));
		if size(out, 3) > 2
			if isequal(out(:, :, 1), out(:, :, 2), out(:, :, 3))
				out = out(:, :, 1);
			end
		end
		
		% If more filenames exist, read in and process
		if numel(filenames) > 1
			out(end, end, numel(filenames)) = 0;
			for nFiles = 2:numel(filenames)
				waitbar((nFiles - 1) / numel(filenames), hWaitbar, join([num2str(nFiles - 1), '/', num2str(numel(filenames)), ' Images Loaded. Loading: ', strrep(filenames(nFiles), '_', '\_')], ""));
				temp = imread(fullfile(filepath, filenames(nFiles)));
				if size(temp, 3) > 2
					if isequal(temp(:, :, 1), temp(:, :, 2), temp(:, :, 3))
						temp = temp(:, :, 1);
					end
				end
				out(:, :, nFiles) = temp;
			end
		end
		waitbar(1, hWaitbar, 'Completed!');
		close(hWaitbar)
	end
end
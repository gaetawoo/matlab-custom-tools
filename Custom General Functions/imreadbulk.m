function out = imreadbulk(filenames, path)
% IMREADBULK stack images in bulk from a folder
%
% SYNTAX:
%    out = imreadbulk(filenames, path)
%
% INPUTS:
%    filenames - string vector
%    path - single string
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

  hWaitbar = waitbar(0, join(['0/', num2str(numel(filenames)), ' Images Loaded. Loading: ', strrep(filenames(1), '_', '\_')], ""));
  out = imread(fullfile(path, filenames(1)));
	if size(out, 3) > 2
		if isequal(out(:, :, 1), out(:, :, 2), out(:, :, 3))
			out = out(:, :, 1);
		end
	end
  
	if numel(filenames) > 1
		out(end, end, numel(filenames)) = 0;
		for nFiles = 2:numel(filenames)
			waitbar((nFiles - 1) / numel(filenames), hWaitbar, join([num2str(nFiles - 1), '/', num2str(numel(filenames)), ' Images Loaded. Loading: ', strrep(filenames(nFiles), '_', '\_')], ""));
			temp = imread(fullfile(path, filenames(nFiles)));
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
function foldername = getParentFolderName(directory)
	%GETPARENTFOLDERNAME returns name of input folder from a path
	%
	% SUMMARY:
	%     GETPARENTFOLDERNAME(directory)
	%     This routine accepts a string of a path
	
	% Created by Jeremiah J. Valenzuela, Jenoptik Optical Systems
	% Created on May 13, 2020
	
	% Get full path name with no trailing folder seperator
	% https://de.mathworks.com/matlabcentral/answers/384972-how-do-i-find-out-the-full-path-for-a-directory
	s = what(directory);
	directory = s.path;
	
	% Wind-up one directory
	parentPath = fileparts(directory);
	parentPath = strrep(parentPath, '\', '\\'); % For regex
	foldername = strip(string(regexpi(directory, [parentPath, '(.*)'], 'tokens', 'once')), '\');
end
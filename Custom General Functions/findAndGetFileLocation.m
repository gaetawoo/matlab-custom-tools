function [filename, filepath] = findAndGetFileLocation(stringToBeFound, searchPath)
	%FINDANDGETFILELOCATION searches for a file containing the given string starting at the given search
	%     path, and searches iteratively backwards through the path until a single file is found,
	%     multiple files are found to choose from, or none are found through the drive's root folder.
	%
	% SUMMARY:
	%     FINDANDGETFILELOCATION(stringToBeFound, searchPath)
	%     This routine accepts a string or regular expression to search for and a starting search path. The routine will
	%     iteratively search through each parent folder until something or nothing is found.
	
	% Created by Jeremiah J. Valenzuela, Jenoptik Optical Systems
	% Created on November 8, 2018
	% Created with MATLAB ver. 9.5.0.944444 (R2018b) on Windows 10
	% Modified by Ralf Hambach, Jenoptik, Jena
	% Modified on September 27, 2019
	
	% Initialize default return values
	filename = '';
	filepath = '';
	
	% Get starting directory from user if not provided
	if nargin == 1
		searchPath = uigetdir(pwd, 'Select Folder to Begin Search');
		if ~searchPath % Dialog cancelled
			return
		end
	end

	% Get full path name with no trailing folder seperator
	% https://de.mathworks.com/matlabcentral/answers/384972-how-do-i-find-out-the-full-path-for-a-directory
	s = what(searchPath);
	searchPath = s.path;

	% Iteratively look through all parent directories
	while true
		filesInDir = dir(searchPath);
		filesInDir = filesInDir(~([filesInDir.isdir]));
		if ~isempty(filesInDir)
			% Files exist, check for matches
			logicalMatches = ~cellfun('isempty', regexpi({filesInDir.name}, stringToBeFound, 'once'));
			if any(logicalMatches)
				if sum(logicalMatches) == 1 % Found one match
					filename = filesInDir(logicalMatches).name;
					filepath = [filesInDir(logicalMatches).folder, filesep];
				elseif sum(logicalMatches) > 1 % Found multiple matches
					filteredResultsString = [filesInDir(1).folder, '\*', char(join({filesInDir(logicalMatches).name}, ';*'))];
					[filename, filepath] = uigetfile(filteredResultsString, 'Multiple results found. Choose one.');
					if ~filename % Dialog cancelled
						filename = '';
						filepath = '';
						return
					end
				end
				% Return with unique filename
				break
			end
		end

		% Wind-up one directory
		[parentDir] = fileparts(searchPath);
		if strcmp(parentDir, searchPath) % Reached root directory
			%cprintf('*[1, 0.5, 0]', 'Warning: Drive root folder reached. File containing "%s" not found.\n\n', stringToBeFound))
			break
		end
		searchPath = parentDir;
	end
end
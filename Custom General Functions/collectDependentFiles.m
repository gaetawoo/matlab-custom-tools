function collectDependentFiles(funcName, varargin)
	if ~ischar(funcName)
		warning('Enter main function name as a string.')
		return
	end
	
	% Collect all used functions
	[filelist, productstruct] = matlab.codetools.requiredFilesAndProducts(funcName, varargin{:});
	filelist = filelist';
	if numel(productstruct) > 1
		warning('Dependencies require the following toolbox(s):\n%s', sprintf('%s\n',productstruct(2:end).Name));
		answer = input('Do you want to continue with the file collection? Y/N [Y]:', 's');
		if isempty(answer)
			answer = 'Y';
		end
		if ~strcmpi(answer, 'y')
			fprintf('File collection cancelled.\n\n');
			return
		end
	end
	
	% Find any dependent packages (\+mypack\)
	packages = regexp(filelist, '.+\\\+[^\\]+\\', 'match');
	directorylist = unique([packages{:}]');
	filelist(contains(filelist, directorylist)) = [];
	
	if numel(filelist) > 0
		disp('***FILES***')
		disp(filelist)
	end
	if numel(directorylist) > 0
		disp('***DIRECTORIES***')
		disp(directorylist)
	end
	
	answer2 = input('Above are the files to be collected. Do you wish to proceed? Y/N [Y]:', 's');
	if isempty(answer2)
		answer2 = 'Y';
	end
	if ~strcmpi(answer2, 'y')
		return
	end
	
	% Make output directory
	outputDir = [fileparts(which(funcName)), '\', datestr(now, 'yyyymmdd-HHMMSS'), ' Collected Files\'];
	[~] = mkdir(outputDir);
	
	% Copy singular files
	if numel(filelist) > 0
		for iFile = 1:numel(filelist)
			copyfile(filelist{iFile}, outputDir)
		end
	end
	
	% Copy directories
	if numel(directorylist) > 0
		for iDir = 1:numel(directorylist)
			folderName = strip(directorylist{iDir}(regexp(directorylist{iDir}, '\\\+'):end), '\');
			[~] = mkdir([outputDir, folderName]);
			copyfile(directorylist{iDir}, [outputDir, folderName, '\']);
		end
	end
	
	fprintf('\n')
	hyperlink = sprintf('<a href="matlab:winopen(''%s'')">%s</a>', strrep(outputDir, '\', '\\'), outputDir);
	fprintf('Files collected in the following folder (Click to open):\n--> %s\n\n', hyperlink);
end
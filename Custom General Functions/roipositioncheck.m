function roipositioncheck(flagShowFOV, flagFlatfield, flagShowLabels)
	% ROIPOSITIONCHECK displays a selected image with a select ROI set overlaid and labeled. Can also
	% display Field-of-View is a Project Parameters file is available.
	%
	% SYNTAX:
	%     roipositioncheck(flagShowFOV, flagFlatfield, flagShowLabels)
	%
	% INPUTS:
	%    flagShowFOV - Whether or not to display the Field-of-View from the Project Parameters file
	%    flagFlatfield - Whether or not to flatfield the image for a more uniform background
	%	   flagShowLabels - Whether or not to show labels of regions
	%
	
	% Created on: November 9, 2018
	% By: Jeremiah Valenzuela
	
	% Select Image file and ROI file
	[targetFilename, targetPath] = uigetfile('*.bmp;*.tif', 'Select the image you want to use.');
	if ~targetFilename
		return
	end
	cd(targetPath);
	[~, ~, targetExtension] = fileparts([targetPath, targetFilename]);
	
	% Retrieve ROI file
	[roiFilename, roiPath] = findAndGetFileLocation('.*\.roi$', targetPath);
	
	% Check input arguments
	if nargin == 0
		flagShowFOV = 'off';
		flagFlatfield = 'off';
		flagShowLabels = 'on';
	end
	if nargin == 1
		flagFlatfield = 'on';
		flagShowLabels = 'on';
	end
	if nargin == 2
		flagShowLabels = 'on';
	end
	
	% To show FOV
	if strcmpi(flagShowFOV, 'on')
		% Load in project specific parameters
		[paramsFilename, paramsPath] = findAndGetFileLocation('Project Parameters.txt', targetPath);
		if isempty(paramsFilename)
			error('ERROR: Drive root folder reached. File containing "%s" not found.\n\n', 'Project Parameters.txt')
		end
		params = loadProjectParameters(paramsPath, paramsFilename);
	end
	
	% Change extension from .roi to .csv for reading in as a table
	copyfile([roiPath, roiFilename], [roiPath, roiFilename(1:end - 4), '.csv']);
	roiTable = readtable([roiPath, roiFilename(1:end - 4), '.csv']);
	delete([roiPath, roiFilename(1:end - 4), '.csv']);
	roiTable.Properties.VariableNames = {'Name', 'Orientation', 'Xstart', 'Ystart', 'Width', 'Height', 'Group'};
	
	% Load target image and check bit-depth and bit-resolution of target image
	targetImg = imread([targetPath, targetFilename]);
	targetImgBitStats = getBitDepth(targetImg);
	
	% To flatfield
	if strcmpi(flagFlatfield, 'on')
		if regexpi(targetFilename, 'red')
			colorName = 'Red';
		elseif regexpi(targetFilename, 'blue')
			colorName = 'Blue';
		else
			colorName = 'Green';
		end
		
		% Load in bright and dark field files for background flattening
		validExtensions = {'.tif', '.bmp'};
		for iExtensionTry = 1:numel(validExtensions)
			if iExtensionTry > 1
				% If extension from target image didn't work, try the other valid extensions
				targetExtension = cell2mat(setdiff(validExtensions, targetExtension));
			end
			% Try to find file with matching color first
			[brightfieldFilename, brightfieldPath] = findAndGetFileLocation(['(?=.*brightfield)(?=.*', colorName, ').*\', targetExtension, '$'], targetPath);
			if isempty(brightfieldFilename)
				[brightfieldFilename, brightfieldPath] = findAndGetFileLocation(['.*brightfield.*\', targetExtension, '$'], targetPath);
				
			end
			[darkfieldFilename, darkfieldPath] = findAndGetFileLocation(['(?=.*darkfield)(?=.*', colorName, ').*\', targetExtension, '$'], targetPath);
			if isempty(darkfieldFilename)
				[darkfieldFilename, darkfieldPath] = findAndGetFileLocation(['.*darkfield.*\', targetExtension, '$'], targetPath);
			end
			if ~isempty(brightfieldFilename) && ~isempty(darkfieldFilename)
				break
			elseif iExtensionTry == numel(validExtensions) && (isempty(brightfieldFilename) || isempty(darkfieldFilename))
				if isempty(brightfieldFilename)
					error('ERROR: Drive root folder reached. File containing "%s" not found.\n\n', 'brightfield')
				end
				if isempty(darkfieldFilename)
					error('ERROR: Drive root folder reached. File containing "%s" not found.\n\n', 'darkfield')
				end
			end
		end
		
		% Load background images
		brightfieldImg = imread([brightfieldPath, brightfieldFilename]);
		darkfieldImg = imread([darkfieldPath, darkfieldFilename]);
		
		% Check bit-depth and bit-resolution for brightfield image (assume darkfield is the same)
		brightfieldImgBitStats = getBitDepth(brightfieldImg);
		
		% Determine any bit-depth conversion parameters for target or brightfield images
		flagAdjustTargetImgBits = 'off';
		
		% If bit-depth stats are equal, do nothing
		if isequal(brightfieldImgBitStats, targetImgBitStats)
			% Do nothing
			% If brightfield is higher res, degrade it
		elseif  brightfieldImgBitStats.OriginalBitDepth > targetImgBitStats.OriginalBitDepth
			convertBitDepthArgs = {brightfieldImgBitStats.OriginalBitDepth, brightfieldImgBitStats.BitShift, targetImgBitStats.OriginalBitDepth, targetImgBitStats.BitShift, targetImgBitStats.DataClass};
			brightfieldImg = convertImgBitDepth(brightfieldImg, convertBitDepthArgs{:});
			darkfieldImg = convertImgBitDepth(darkfieldImg, convertBitDepthArgs{:});
			% If target is higher res, degrade it
		elseif brightfieldImgBitStats.OriginalBitDepth < targetImgBitStats.OriginalBitDepth
			flagAdjustTargetImgBits = 'on';
			convertBitDepthArgs = {targetImgBitStats.OriginalBitDepth, targetImgBitStats.BitShift, brightfieldImgBitStats.OriginalBitDepth, brightfieldImgBitStats.BitShift, brightfieldImgBitStats.DataClass};
			% If original bit-depths are equal, always convert brightfield to match target for speed
		elseif brightfieldImgBitStats.OriginalBitDepth == targetImgBitStats.OriginalBitDepth
			convertBitDepthArgs = {brightfieldImgBitStats.OriginalBitDepth, brightfieldImgBitStats.BitShift, targetImgBitStats.OriginalBitDepth, targetImgBitStats.BitShift, targetImgBitStats.DataClass};
			brightfieldImg = convertImgBitDepth(brightfieldImg, convertBitDepthArgs{:});
			darkfieldImg = convertImgBitDepth(darkfieldImg, convertBitDepthArgs{:});
		end
		
		% Perform actual flatfielding
		if exist('brightfieldImg', 'var') && exist('darkfieldImg', 'var')
			loThreshCount = 10;
			hiThreshCount = 20;
			% Convert bit-depth values if needed
			if contains(flagAdjustTargetImgBits, 'on', 'IgnoreCase', true)
				targetImg = convertImgBitDepth(targetImg, convertBitDepthArgs{:});
			end
			flatfieldSingle = single(targetImg - darkfieldImg) ./ single(brightfieldImg - darkfieldImg);
			flatfieldSingleFiltered = histogramthresholding(flatfieldSingle, 2^16, loThreshCount, hiThreshCount);
			targetImg = uint16(normalizeimage(flatfieldSingleFiltered, 0, 2^16 - 1));
		end
	end
	
	% If flatfielding didn't happen and image does not use full range of data type, the apply adjustment
	if ~strcmpi(flagFlatfield, 'on') && (targetImgBitStats.BitDepth ~= str2double(regexpi(targetImgBitStats.DataClass, '[0-9]+', 'match', 'once')))
		desiredBitShift = str2double(regexpi(targetImgBitStats.DataClass, '[0-9]+', 'match', 'once')) - targetImgBitStats.OriginalBitDepth;
		targetImg = convertImgBitDepth(targetImg, targetImgBitStats.OriginalBitDepth, targetImgBitStats.BitShift, targetImgBitStats.OriginalBitDepth, desiredBitShift, targetImgBitStats.DataClass);
	end
	
	% Display Image file
	warning('off', 'images:initSize:adjustingMag')
	figure('Name', [targetPath, targetFilename]);
	imshow(targetImg);
	hold on
	
	% Plot ROIs over image with labels
	for iRoiEntry = 1:height(roiTable)
		plot([roiTable.Xstart(iRoiEntry), roiTable.Xstart(iRoiEntry), ...
			roiTable.Xstart(iRoiEntry) + roiTable.Width(iRoiEntry), ...
			roiTable.Xstart(iRoiEntry) + roiTable.Width(iRoiEntry), ...
			roiTable.Xstart(iRoiEntry)], ...
			[roiTable.Ystart(iRoiEntry), ...
			roiTable.Ystart(iRoiEntry) + roiTable.Height(iRoiEntry), ...
			roiTable.Ystart(iRoiEntry) + roiTable.Height(iRoiEntry), ...
			roiTable.Ystart(iRoiEntry), roiTable.Ystart(iRoiEntry)], ...
			'LineWidth', 1.0, 'LineStyle', '-', 'Color', 'red')
		if strcmpi(flagShowLabels, 'on')
			xc = roiTable.Xstart(iRoiEntry) + roiTable.Width(iRoiEntry) / 2;
			yc = roiTable.Ystart(iRoiEntry) + roiTable.Height(iRoiEntry) / 2;
			text(xc + 4, yc + 6, roiTable.Name{iRoiEntry}, 'Color', 'black', 'FontSize', 27, 'FontName', 'Arial Bold', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
			text(xc, yc, roiTable.Name{iRoiEntry}, 'Color', 'green', 'FontSize', 27,  'FontName', 'Arial', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle');
		end
	end
	
	% Plot FFOV boundary
	if exist('params', 'var') && isfield(params, 'fullFovInPxls')
		if ~isfield(params, 'fullFovInPxlsOffset')
			params.fullFovInPxlsOffset = [0, 0];
		end
		
		switch numel(params.fullFovInPxls)
			case 1 % Value is diameter
				circle(size(targetImg, 2) / 2 + params.fullFovInPxlsOffset(1), ...
					size(targetImg, 1) / 2 + params.fullFovInPxlsOffset(2), ...
					params.fullFovInPxls / 2, 'LineWidth', 2, 'Color', 'red');
			case 2 % Value is width, height
				rectangle('Position', [ ...
					size(targetImg, 2) / 2 + params.fullFovInPxlsOffset(1) - params.fullFovInPxls(1) / 2, ...
					size(targetImg, 1) / 2 + params.fullFovInPxlsOffset(2) - params.fullFovInPxls(2) / 2, ...
					params.fullFovInPxls], 'LineWidth', 2, 'EdgeColor', 'red');
			otherwise
				cprintf([1, 0, 0], 'No FFOV value given in Project Parameter file.')
		end
		
	end
	
	hold off
	tightenaxes(gca, 'zeroedge')
end
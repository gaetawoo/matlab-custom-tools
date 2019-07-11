function roipositioncheck(flagShowFOV, flagFlatfield)
  % Select Image file and ROI file
  [targetFilename, targetPath] = uigetfile('*.bmp', 'Select the image you want to use.');
  cd(targetPath);
  [roiFilename, roiPath] = uigetfile([targetPath, '..\', '*.roi'], 'Select the ROI file you want to use.');
  
  if nargin == 0
    flagShowFOV = 'off';
    flagFlatfield = 'off';
  end
  
  if nargin == 1
    flagFlatfield = 'on';
  end
  
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
  
  if strcmpi(flagFlatfield, 'on')
    dataSetName = targetFilename(1:strfind(targetFilename, ' P') - 1);
    if contains(dataSetName, 'red')
      colorName = 'Red';
    elseif contains(dataSetName, 'blue')
      colorName = 'Blue';
    else
      colorName = 'Green';
    end
    
    % Load in bright and dark field files for background flattening
    [brightfieldFilename, brightfieldPath] = findAndGetFileLocation(['brightfield ', colorName], targetPath);
    if isempty(brightfieldFilename)
      [brightfieldFilename, brightfieldPath] = findAndGetFileLocation('brightfield', targetPath);
      if ~isempty(brightfieldFilename)
        brightfieldImg = imread([brightfieldPath, brightfieldFilename]);
      end
    else
      brightfieldImg = imread([brightfieldPath, brightfieldFilename]);
    end
    
    [darkfieldFilename, darkfieldPath] = findAndGetFileLocation('darkfield', targetPath);
    if ~isempty(darkfieldFilename)
      darkfieldImg = imread([darkfieldPath, darkfieldFilename]);
    end
  end
  
  
  % Display Image file
  warning('off', 'images:initSize:adjustingMag')
  figure;
  targetImg = imread([targetPath, targetFilename]);
  
  if exist('brightfieldImg', 'var') && exist('darkfieldImg', 'var')
    loThreshCount = 10;
    hiThreshCount = 20;
    flatfieldSingle = single(targetImg - darkfieldImg) ./ single(brightfieldImg - darkfieldImg);
    flatfieldSingleFiltered = histogramthresholding(flatfieldSingle, 2^16, loThreshCount, hiThreshCount);
    targetImg = uint16(normalizeimage(flatfieldSingleFiltered, 0, 2^16 - 1));
  end
  
  imshow(targetImg);
  set(gcf, 'Name', [targetPath, targetFilename])
  %caxis('auto');
  
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
    xc = roiTable.Xstart(iRoiEntry) + roiTable.Width(iRoiEntry) / 2;
    yc = roiTable.Ystart(iRoiEntry) + roiTable.Height(iRoiEntry) / 2;
    text(xc, yc, roiTable.Name{iRoiEntry}, 'Color', 'cyan', 'FontSize', 25)
  end
  
  % Plot FFOV boundary
  if exist('params', 'var') && isfield(params, 'fullFovInPxls')
    if ~isfield(params, 'fullFovInPxlsOffset')
      params.fullFovInPxlsOffset = [0, 0];
    end
    
    switch size(params.fullFovInPxls, 2)
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
  
end
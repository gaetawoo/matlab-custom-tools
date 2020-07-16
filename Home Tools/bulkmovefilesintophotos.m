h = waitbar(0);

tic;


files = dir('F:\My Pictures\Sony Home Video mp4 - Copy\DV*.mp4');
startingFilesSize = size(files, 1);

while ~isempty(files)
  % Parse date and time from file name. Example: DV.20060422-220005.Tape 21.mp4
  datetime = files(1).name(find(files(1).name == '.', 1)+1:max(find(files(1).name == '.', 2))-1);
  filesSubset = dir(['F:\My Pictures\Sony Home Video mp4 - Copy\DV.', datetime(1:6), '*.mp4']);
  % Set datetime string appropriately for each called command
  folderBeginning = datestr(datenum(datetime, 'yyyymmdd-HHMMSS'), 'yyyy - mm');
  
  
  waitbar((startingFilesSize - size(files, 1)) / startingFilesSize, h, ['Processing ', num2str(size(files, 1)), '/', num2str(startingFilesSize), '. Current: ', folderBeginning]);
  
  
  
  
  
  folder = dir(['F:\My Pictures\Photographs\', folderBeginning, '*\']);
  if isempty(folder)
    disp(['No folder found for ', folderBeginning])
    return
  endif
  
  disp(folder(1).folder)
  for ii = 1:size(filesSubset, 1)
    movefile([filesSubset(ii).folder, '\', filesSubset(ii).name], [folder(1).folder, '\', filesSubset(ii).name]);
  end
  files = dir('F:\My Pictures\Sony Home Video mp4 - Copy\DV*.mp4');
end

close(h)

disp('Processing Complete!')
toc
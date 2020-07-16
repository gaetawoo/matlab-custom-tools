
try
  [filenamesCell, filepath] = uimultiselect('*.*', 'Select File(s)');
catch
  return
end
nFiles = numel(filenamesCell);
for iFile = 1:nFiles
  MAINFUNCTION([filepath, filenamesCell(iFile)])
end

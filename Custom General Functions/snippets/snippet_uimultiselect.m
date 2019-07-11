
try
  [filenamesCell, filepath] = uimultiselect('*.*', 'Select File(s)');
catch
  return
end
for nFiles = 1:size(filenamesCell, 1)
  MAINFUNCTION([filepath, filenamesCell(nFiles)])
end

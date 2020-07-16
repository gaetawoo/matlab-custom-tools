function reporttohtml(directory, filename, TFmatCells, MTFmatCells, pngCells)
  filename = filename(strfind(filename, '_') + 1:strfind(filename, ' ') - 1);
  fid = fopen([directory, 'Report ', filename, '.html'], 'w');
  fprintf(fid, '%s', ['<html><head><title>Report for ', ...
    filename, '</title>']);
  fprintf(fid, '</head><body>');
  fprintf(fid, '%s', ['<b>Report for ', ...
    filename, '</b><br><br>']);
  fprintf(fid, 'Using the following versions:<br>');
  [~, osVer] = system('ver');
  fprintf(fid, '%s', ['&nbsp;&nbsp;OS: ', osVer(2:end - 1), '<br>']);
  fprintf(fid, '%s', ['&nbsp;&nbsp;Matlab: ', version, '<br>']);
  [~, currentMtfMapperVer] = system('mtf_mapper --version');
  currentMtfMapperVer = currentMtfMapperVer(strfind(currentMtfMapperVer, ':') + 2:end - 2);
  fprintf(fid, '%s', ['&nbsp;&nbsp;MTF Mapper: ', currentMtfMapperVer, '<br>']);
  fprintf(fid, '%s', ['&nbsp;&nbsp;Orbotech16000 software: ', getFFMTFVersion(), '<br><br>']);
  fprintf(fid, 'Through-Focus Processed MAT files:<br>');
  for ii = 1:size(TFmatCells, 1)
    fprintf(fid, '<a href="%s">%s</a><br><br>', TFmatCells{ii, 2}, TFmatCells{ii, 2});
  end
  
  fprintf(fid, '<br>Raw MTF Curve MAT files:<br>');
  for ii = 1:size(MTFmatCells, 1)
    fprintf(fid, '<a href="%s">%s</a><br><br>', MTFmatCells{ii, 2}, MTFmatCells{ii, 2});
  end
  
  fprintf(fid, '<br>Output Graphics:<br>');
  for ii = 1:size(pngCells, 1)
    fprintf(fid, '<img src="%s.png" width="75%%"><br><br>', pngCells{ii, 2});
  end
  fprintf(fid, '</body></html>');
  fclose(fid);
  
end

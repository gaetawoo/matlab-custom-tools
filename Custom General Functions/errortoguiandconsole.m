function errortoguiandconsole(ME)
	% Strip HTML from error report and format for display
	errReport = ME.getReport;
	errReport = string(regexprep(errReport, '(<a href=".*?">|</a>)', ''));
	errReport = split(errReport, newline);
	errReport = strip(errReport, 'right');
	errReport = strrep(errReport, native2unicode(9), " ");
	blanklineIdx = find(strcmpi(errReport, ME.message));
	if numel(errReport) > 1
		errReport = [errReport(1:blanklineIdx); ""; errReport(blanklineIdx + 1:end)];
	end
	
  if size(ME.stack, 1) == 0
    errorMessageBox = errordlg(errReport, 'ERROR!'); %#ok<*NASGU>
    rethrow(ME)
  else
    if isempty(ME.identifier)
      errorMessageBox = errordlg(errReport, 'ERROR!');
      
    else
      for nStack = 1:size(ME.stack, 1)
        stackText{nStack} = [{['File: ', ME.stack(nStack).file]}; {['Name: ', ME.stack(nStack).name]}; {['Line: ', num2str(ME.stack(nStack).line)]}; {''}];
      end
      nTextPos = 1;
      for nStack = 1:size(ME.stack, 1)
        for nItem = 1:4
          itemizedText(nTextPos, 1) = {stackText{nStack}(nItem)};
          nTextPos = nTextPos + 1;
        end
      end
      errorMessageBox = errordlg([errReport; {''}; [itemizedText{:}]'], 'ERROR!');
      rethrow(ME)
    end
  end
  movegui(errorMessageBox, 'center')
end
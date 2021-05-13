function renameFiles(search, replace, vararg)
	if ~exist('vararg', 'var')
		vararg = {};
	end
	files = dir(pwd);
	files = files(~cellfun(@isempty, (regexpi({files.name}', search))));
	for nFiles = 1:size(files, 1)
		oldName = files(nFiles).name;
		newName = regexprep(oldName, search, replace, vararg{:});
		movefile(oldName, newName);
	end
end
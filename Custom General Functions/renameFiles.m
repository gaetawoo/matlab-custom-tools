function renameFiles(searchstring, newstring)
files = dir(pwd);
files = files(~([files.isdir]) & contains({files.name}, searchstring));
for nFiles = 1:size(files, 1)
oldName = files(nFiles).name;
partialName = oldName(1:strfind(oldName, searchstring) - 1);
extName = oldName(strfind(oldName, searchstring)+ size(searchstring, 2):end);
newName = [partialName, newstring, extName];
movefile(oldName, newName);
end
end
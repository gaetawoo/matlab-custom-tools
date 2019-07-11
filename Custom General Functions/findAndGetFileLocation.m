function [filename, filepath] = findAndGetFileLocation(stringToBeFound, searchPath)
  %FINDANDGETFILELOCATION searches for a file containing the given string starting at the given search
  %     path, and searches recursively backwards through the path until a single file is found,
  %     multiple files are found to choose from, or none are found through the drive's root folder.
  %
  % SUMMARY:
  %     [filename, filepath] = FINDANDGETFILELOCATION(stringToBeFound, searchPath)
  %     This routine accepts a string to search for and a starting search path. The routine will
  %     recursively search through each parent folder until something or nothing is found.
  
  % Created by Jeremiah J. Valenzuela, Jenoptik Optical Systems
  % Created on November 8, 2018
  % Created with MATLAB ver. 9.5.0.944444 (R2018b) on Windows 10
  
  if nargin == 1
    searchPath = uigetdir(pwd, 'Select Folder to Begin Search');
    searchPath = [searchPath, '\'];
  end
  
  filesInDir = dir(searchPath);
  filesInDir = filesInDir(~([filesInDir.isdir]));
  
  if isempty(filesInDir)
    [filename, filepath] = findAndGetFileLocation(stringToBeFound, [searchPath, '..\']);
    return
    
  end
  
  if contains(filesInDir(1).folder(end - 1:end), ':\')
    %cprintf('*[1, 0.5, 0]', 'Warning: Drive root folder reached. File containing "%s" not found.\n\n', lower(stringToBeFound))
    filename = '';
    filepath = '';
    return
    
  end
  
  if sum(contains(lower({filesInDir.name}), lower(stringToBeFound))) > 0
    if sum(contains(lower({filesInDir.name}), lower(stringToBeFound))) == 1 % Found one match
      filename = filesInDir(contains(lower({filesInDir.name}), lower(stringToBeFound))).name;
      filepath = [filesInDir(contains(lower({filesInDir.name}), lower(stringToBeFound))).folder, '\'];
    else % Found multiple matches
      [filename, filepath] = uigetfile([searchPath, '*', stringToBeFound, '*.*'], 'Multiple results found. Choose one.');
    end
    %cprintf('[0, 0.5, 1]', 'Found %s', filepath)
    %cprintf('*[0. 0.5, 1]', '%s\n\n', filename)
    return
    
  else % Found no match
    [filename, filepath] = findAndGetFileLocation(stringToBeFound, [searchPath, '..\']);
    return
    
  end
  
end
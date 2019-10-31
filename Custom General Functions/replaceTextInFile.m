function [] = replaceTextInFile(InputFile, OutputFile, SearchPattern, ReplacePattern)
%%change data [e.g. initial conditions] in model file
% InputFile - string
% OutputFile - string
% SearchPattern - string
% ReplacePattern - string
% read whole model file data into cell array

% from: https://www.mathworks.com/matlabcentral/answers/62986-how-to-change-a-specific-line-in-a-text-file

fid = fopen(InputFile);
data = textscan(fid, '%s', 'Delimiter', '\n', 'CollectOutput', true, 'Whitespace', '');
fclose(fid);
% modify the cell array
% find the position where changes need to be applied and insert new data
for I = 1:length(data{1})
    tf = ~isempty(regexpi(data{1}{I}, SearchPattern)); % search for this string in the array
    if tf == 1
        data{1}{I} = regexprep(data{1}{I}, SearchPattern, ReplacePattern); % replace with this string
    end
end
% write the modified cell array into the text file
fid = fopen(OutputFile, 'w');
for I = 1:length(data{1})
    fprintf(fid, '%s\n', char(data{1}{I}));
end
fclose(fid);
function out = uidlmread()
[filename, path] = uigetfile('*.csv;*.txt', 'Select .CSV File');
if filename ~= 0
out = dlmread([path, filename]);
end
end
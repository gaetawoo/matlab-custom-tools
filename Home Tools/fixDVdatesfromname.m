files = uigetfullfile('*.*', 'Multiselect', 'on');

h = waitbar(0);

tic;

% Get current computer timezone
[~, tz] = system('tzutil /g');

% Set computer timezone to UTC so no transpositions happen when writing times to file properties
[~, ~] = system('tzutil /s "UTC"');

for ii = 1:size(files, 1)
	[path, name, ext] = fileparts(files(ii));
	waitbar(ii / size(files, 1), h, {['Processing ', num2str(ii), '/', num2str(size(files, 1))],  ['Current: ', char(strcat(name, ext))]});
	
	% Parse date and time from file name. Example: DV.20060422-220005.Tape 21.mp4
	%   datetime = name(find(name == '.', 1) + 1:max(find(name == '.', 2)) - 1); % For Char
	%   datetime = char(name.extractBetween("DV.", ".Tape")); % For String
	datetime = '19990904-200000';
	% Set datetime string appropriately for each called command
	dateExiftool = datestr(datenum(datetime, 'yyyymmdd-HHMMSS'), 'yyyy:mm:ddHH:MM:SS');
	dateNircmd = datestr(datenum(datetime, 'yyyymmdd-HHMMSS'), 'dd-mm-yyyy HH:MM:SS');
	
	% Change EXIF Date Created property
	[~, ~] = system(['exiftool "', char(files(ii)), '" -createdate=', dateExiftool, ' -overwrite_original']);
	%pause(1.0)
	% Change Creation Date and Modified Date property
	[~, ~] = system(['nircmd.exe setfiletime ', '"', char(files(ii)), '" "', dateNircmd, '" "', dateNircmd, '"']);
end

close(h)

% Set computer timezone back to previous timezone
[~, ~] = system(['tzutil /s "', tz, '"']);
disp('Processing Complete!')
toc
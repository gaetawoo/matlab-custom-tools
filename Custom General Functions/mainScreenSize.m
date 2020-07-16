function screensize = mainScreenSize()
% MAINSCREENSIZE returns 1x4 vector of the starting position and screensize of the main display
%
% SYNTAX:
%    screensize = mainScreenSize()
%
% INPUTS:
%    none
%
% OUTPUTS:
%    screensize - [left, bottom, width, height)
%
% EXAMPLE:
%    >> mainScreenSize()
%    ans =
%           1           1        2560        1440
%

% Created on: March 2018
% By: Jeremiah Valenzuela

screensize = get(groot, 'MonitorPositions');
screensize = screensize((find(screensize(:, 1) == 1 & screensize(:, 2) == 1)), :);
end
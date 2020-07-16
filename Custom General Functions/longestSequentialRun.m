function sequence = longestSequentialRun(vector)
% LONGESTSEQUENTIALRUN returns the longest run of sequential integers from input
%
% SYNTAX:
%    sequence = longestSequentialRun(vector)
%
% INPUTS:
%    vector - should be a sorted row vector of integers but could be column vector that will be
%             transposed
%
% OUTPUTS:
%    sequence - sorted row vector of only those integers which are part of the longest sequential run
%
% EXAMPLE:
%    >> longestSequentialRun([1,3,5,6,7,9,10,11,12,13])
%
% REFERENCE:
%    https://stackoverflow.com/a/11434204/3425022

% Created on: August 20, 2019
% By: Jeremiah Valenzuela

if size(vector) > 1
	error(['Size of input is [', strrep(num2str(size(vector)), ' ', ', '), ']. Input must be row- or column-vector only.'])
end

if size(vector, 1) > 1
	vector = vector';
end

groups = [0, cumsum(diff(vector) ~= 1)];
sequence = vector(groups == mode(groups));
end
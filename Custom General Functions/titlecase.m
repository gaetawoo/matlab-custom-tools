function S = titlecase(S, skipset)
%function S = titlecase(S) 
% Capitalize the first character in every word (excluding short words) in input
% string S, or in every word in every string in input cell array S.  The first word
% is always capitalized.
%
% Default set of words to skip is {'a', 'an', 'and', 'or', 'in', 'the'}
%
% https://www.mathworks.com/matlabcentral/fileexchange/43399-capitalize-strings-using-titlecase
%
% function S = titlecase(S,skipset)
% User-supplied cell array of words to skip 
if nargin < 2 
    skipset={'a', 'an', 'and', 'or', 'in', 'the'}; 
end
skipset = lower(skipset);
if iscell(S)
    S = cellfun(@(x) titlecase(x, skipset), S, 'uniformoutput', false);
else
    skip = 0;
    Sw = regexp(S, '[ \t]', 'split');
    skip(2 : length(Sw)) = ismember(lower(Sw(2:end)), skipset); %skip(1) is always 0
    Sw(~skip) = cellfun(@(x) [upper(x(1)) x(2:end)], Sw(~skip), 'uniformoutput', false);
    S = sprintf('%s ', Sw{:});
    S(end) = '';
end
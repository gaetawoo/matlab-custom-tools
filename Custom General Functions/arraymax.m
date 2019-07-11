function [max_val, ind_row, ind_col] = arraymax(array)
%%ARRAYMAX
% Accepts array as argument and outputs maximum value and coordinates
% ind_row should be used for Y values
% ind_col should be used for X values
% [max_val, ind_row, ind_col] = arraymax(array)

[max_val, ind] = max(array(:));
[ind_row, ind_col] = ind2sub(size(array), ind);
end
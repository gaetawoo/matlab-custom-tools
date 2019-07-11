function cell2clipboard(input)
%CELL2CLIPBOARD(input)
%
%   Copy cell array to clipboard with delimited formatting

  % Reference: https://stackoverflow.com/questions/26322273/copy-and-past-matlab-character-array-into-excel-w-o-quotes
  
  if iscell(input)
    % Convert all elements to char
    inputChar = cellfun(@num2str, input, 'UniformOutput', false);
    
    % Add tabs between columns and a newline in last column
    inputDlm = [strcat(inputChar(:, 1:end - 1), {sprintf('\t')}), ...
                strcat(inputChar(:, end), {newline})];
    
    % Remove final element's newline
    inputDlm{numel(inputDlm)} = strrep(inputDlm{numel(inputDlm)}, newline, sprintf(''));
    
    % Transpose cell because cell{:} outputs cells in top to bottom, left to right order
    inputDlmTransposed = inputDlm';
    
    % Combine elements into a single string
    inputString = sprintf('%s', inputDlmTransposed{:});
    
    % Copy to system clipboard
    clipboard('copy', inputString);
  else
    error('In cell2clipboard, input argument is not a cell.')
  end
end
function count = digits(value, opt_str)
  %%DIGITS(VALUE, OPT_STR) = COUNT
  %
  %   Takes a number and returns the number of integer digits. Optional string output with 2nd
  %   argument ('off' or any false equivalent will return number, everything else returns a string).
  %
  % Jeremiah J. Valenzuela
  % 2019-06-24
  
  count = numel(num2str(floor(value)));
  
  if exist('opt_str', 'var')
    if strcmpi(opt_str, 'off') || strcmpi(opt_str, 'false')
      return
    elseif ~opt_str
      return
    else
      count = num2str(count);
    end
  end
end
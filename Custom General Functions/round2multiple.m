function output = round2multiple(data, multiple)
  %ROUND2MULTIPLE  rounds towards nearest integer mupltiple
  %
  %   ROUND2MULTIPLE(X, N), for positive integers N, rounds X to nearest multiple
  %   of N. If N is zero, X does not change.
  %
  %   Examples
  %   --------
  %   % Round pi to the multiple of 2
  %   >> round2multiple(pi, 2)
  %        4
  %
  %   % Round 20 to the nearest multiple of 13
  %   >> round2multiple(20, 13)
  %        26
  %
  %  SEE ALSO FLOOR, CEIL, FPRINTF, ROUND.
  
  %   By Jeremiah Valenzuela
  %   2018
  
  if multiple == 0
    output = data;
  else
    output = round(data / multiple) * multiple;
  end
end
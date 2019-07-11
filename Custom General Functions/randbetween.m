function out = randbetween(v1, v2, n)
  %RANDBETWEEN  generates N random values between max and min values
  %
  %   RANDBETWEEN(v1, v2, n), for real values of v1 and v1, generates optional n
  %   number of random values between v1 and v1
  %
  %   Examples
  %   --------
  %   % Generate 4 random values between 3 and -1
  %   >> randbetween(3, -1, 4)
  %        0.81424
  %        0.86104
  %       -0.64085
  %        1.02694
  %
  %   % Generate 1 random value between 20 and 19.5
  %   >> randbetween(20, 19.5)
  %        19.538
  %
  
  %   By Jeremiah Valenzuela
  %   2019
  
  % Check for optional number of outputs
  if ~exist('n', 'var')
    n = 1;
  end
  
  out = zeros(n, 1);
  for ii = 1:n
    out(ii, 1) = rand * (2 * max([v1, v2]) - (max([v1, v2]) + min([v1, v2]))) + min([v1, v2]);
  end
end
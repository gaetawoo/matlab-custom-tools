function [p, fitProperties, S, mu] = polyfitsmart(x, y, maxFitOrderTry)
  if ~exist('maxFitOrderTry', 'var')
    maxFitOrderTry = 50;
  end
  
  fits = zeros(maxFitOrderTry, 2);
  
  [x, IA, ~] = unique(x, 'stable');
  y = y(IA);
  
  xHiRes = linspace(x(1), x(end), length(x) * 100)';
  yHiRes = interp1(x, y, xHiRes);
  
  
  warning('off', 'MATLAB:polyfit:RepeatedPoints');
  warning('off', 'MATLAB:polyfit:PolyNotUnique');
  warning('off', 'MATLAB:polyfit:RepeatedPointsOrRescale');
  
  for nTry = 1:maxFitOrderTry
    fits(nTry, 1) = nTry;
    
    if nargout < 3
      p = polyfit(x, y, nTry);
      Rsqr = 1 - sum((yHiRes - polyval(p, xHiRes)).^2) / sum((yHiRes - mean(yHiRes)).^2);
    elseif nargout < 4
      [p, S] = polyfit(x, y, nTry);
      Rsqr = 1 - sum((yHiRes - polyval(p, xHiRes, S)).^2) / sum((yHiRes - mean(yHiRes)).^2);
    elseif nargout == 4
      [p, S, mu] = polyfit(x, y, nTry);
      Rsqr = 1 - sum((yHiRes - polyval(p, xHiRes, S, mu)).^2) / sum((yHiRes - mean(yHiRes)).^2);
    end
    
    fits(nTry, 2) = Rsqr;
  end
  
  [maxRsqr, maxRsqrIdx] = max(fits(:, 2));
  
  if nargout < 3
    p = polyfit(x, y, fits(maxRsqrIdx, 1));
  elseif nargout < 4
    [p, S] = polyfit(x, y, fits(maxRsqrIdx, 1));
  elseif nargout == 4
    [p, S, mu] = polyfit(x, y, fits(maxRsqrIdx, 1));
  end
  
  if nargout > 1
    fitProperties.Rsqr = maxRsqr;
    fitProperties.FitOrder = fits(maxRsqrIdx, 1);
  end
end
function [rawMean, rawStDev, fitMean, fitStDev] = HistoGauss(y, nbins)
  figure;
  ax = gca;
  if exist('nbins', 'var')
    hist = histogram(ax, y(:), nbins);
  else
    hist = histogram(ax, y(:));
  end
  rawMean = mean(y(:), 'omitnan');
  rawStDev = std(y(:), 'omitnan');
  disp(['Point Count = ', num2str(size(y(:), 1))])
  disp(['Raw Data Mean = ', num2str(rawMean)])
  disp(['Raw Data StDev = ', num2str(rawStDev)])
  
  try
    cfit = fit(hist.BinEdges(1:end - 1)' + hist.BinWidth / 2, hist.Values', 'gauss1');
    hold on
    plot(cfit)
    hold off
    
    fitMean = cfit.b1;
    fitStDev = cfit.c1;
    disp(['Fit Data Mean = ', num2str(fitMean)])
    disp(['Fit Data StDev = ', num2str(fitStDev)])
  catch
    fitMean = NaN;
    fitStDev = NaN;
  end
  disp(' ')
  
  annotation(...
    'textbox', [.55, .68, 0 .15], ... % This dim doesn't make sense but it works
    'String', {['Point Count = ', num2str(size(y(:), 1))], ['Raw Data Mean = ', num2str(rawMean)], ...
              ['Raw Data StDev = ', num2str(rawStDev)], ['Fit Data Mean = ', num2str(fitMean)], ...
              ['Fit Data StDev = ', num2str(fitStDev)]}, ...
    'FitBoxToText', 'on');
  
end
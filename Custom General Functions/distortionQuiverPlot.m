function distortionQuiverPlot()
  [filename, filepath] = uigetfile('*.csv', 'Select the Distortion Data csv file to plot.');
  if filename == 0
    return
  end
  
  plotTitle = inputdlg('Enter title of the plot', 'Enter Plot Title');
  
  data = dlmread([filepath, filename]);
  
  data(:,3) = data(:,3) - data(:,1);
  data(:,4) = data(:,4) - data(:,2);
  maxDist = max(abs(data(:, 5)));
  
  maxX = max(abs(data(:, 1)));
  maxY = max(abs(data(:, 2)));
  arrowScale = 100;
  
  figure;
  qp = quiver(data(:, 1), data(:, 2), data(:, 3) * arrowScale, data(:, 4) * arrowScale, 'autoscale','off');
  axis([-maxX - 800, maxX + 800, -maxY - 800, maxY + 800])
  hold on
  
  quiver((maxX + 800) * 0.1, (maxY + 800) * 0.8, 5 * arrowScale, 0, 'AutoScale', 'off', 'Color', qp.Color);
  text((maxX + 800) * 0.1 - 450, (maxY + 800) * 0.8 + 180, 'Scale = 5 pixels')
  hold off
  
  title({plotTitle{1}, sprintf('Max distortion = %.3f%%', maxDist)})
  
end
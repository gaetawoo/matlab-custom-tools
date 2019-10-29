function distortionQuiverPlot()
	[filename, filepath] = uigetfile('*.csv', 'Select the Distortion Data csv file to plot.');
	if filename == 0
		return
	end
	plotTitle = inputdlg('Enter title of the plot', 'Enter Plot Title');
	
	data = dlmread([filepath, filename]);
	xVec = data(:,3) - data(:,5);
	yVec = data(:,4) - data(:,6);
	maxDist = max(abs(data(:, 7)));
	
	maxX = max(abs(data(:, 5)));
	maxY = max(abs(data(:, 6)));
	minX = min(abs(data(:, 5)));
	minY = min(abs(data(:, 6)));
	arrowScale = 100;
	
	if regexpi(filename, 'image')
		figure;
		qp = quiver(data(:, 5), data(:, 6), xVec * arrowScale, yVec * arrowScale, 'autoscale','off');
		set(gca, 'YDir', 'reverse')
		axis equal
		axis([0, maxX + minX, 0, maxY + minY])
		hold on
		plot(data(:,5), data(:, 6), '.k')
		plot(data(:,3), data(:,4), '.r')
		% Add scale arrow
		quiver((maxX + minX)/2, (minY / 2), 5 * arrowScale, 0, 'AutoScale', 'off', 'Color', qp.Color);
		text((maxX + minX) / 2, (minY / 2) + 180, 'Scale = 5 pixels')
		hold off
		
		title({plotTitle{1}, sprintf('Max distortion = %.3f%%', maxDist)})
	else
		figure;
		qp = quiver(data(:, 5), -data(:,6), xVec * arrowScale, -yVec * arrowScale, 'autoscale','off');
		axis equal
		axis([-maxX - 800, maxX + 800, -maxY - 800, maxY + 800])
		hold on
		plot(data(:,5),-data(:,6), '.k')
		plot(data(:,3),-data(:,4), '.r')
		% Add scale arrow
		quiver((maxX + 800) * 0.1, (maxY + 800) * 0.8, 5 * arrowScale, 0, 'AutoScale', 'off', 'Color', qp.Color);
		text((maxX + 800) * 0.1 - 450, (maxY + 800) * 0.8 + 180, 'Scale = 5 pixels')
		hold off
		
		title({plotTitle{1}, sprintf('Max distortion = %.3f%%', maxDist)})
	end
end
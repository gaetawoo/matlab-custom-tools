figs = findobj('type','figure');

% Get the maximum range of all open figures
range = zeros(numel(figs), 1);
for ii = 1:numel(figs)
	% Get axes object
	ax = findobj(figs(ii), 'Type', 'Axes');
	% Get Serial Number
	serialNum = string(regexpi(figs(ii).FileName, 'Optical Head (SN.*?)\\', 'tokens', 'once'));
	% Retitle axes with Serial Numbers
	ax.Title.String = join([serialNum, ax.Title.String], " - ");
	% Rename figure with Serial Number
	figs(ii).Name = join([serialNum, figs(ii).Name], " - ");
	
	% Get max data value
	maxCLim = max(ax.CLim);
	% If larger than a value, divide everything by 16 to go from 16 to 12 bits
	if maxCLim > 1E6
		ax.Children.CData = ax.Children.CData / 16;
	end

	% Get colorbar range
	range(ii) = diff(ax.CLim);
end

% Apply maximum range to all open figures, keeping middle value unchanged
for ii = 1:numel(figs)
	centerValue = mean(findobj(figs(ii), 'Type', 'Axes').CLim);
	ax = findobj(figs(ii), 'Type', 'Axes');
	ax.CLim = [centerValue + (mean(range) / 2) * [-1, 1]];
end

% Save all figures as figs and as PNGs in CURRENT WORKING DIRECTORY
for ii = 1:numel(figs)
	savefig(figs(ii), figs(ii).Name);
	saveas(figs(ii), figs(ii).Name + ".png");
end
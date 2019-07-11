function tightenaxes(currentAxes)
	
	
	% Ref: https://www.mathworks.com/matlabcentral/answers/352024-programmatically-performing-expand-axes-to-fill-figure
	InSet = get(currentAxes, 'TightInset');
	set(currentAxes, 'Position', [InSet(1:2), 1-InSet(1)-InSet(3), 1-InSet(2)-InSet(4)]);
end
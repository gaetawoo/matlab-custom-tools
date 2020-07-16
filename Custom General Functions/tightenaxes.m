function tightenaxes(currentAxes, method)
	if exist('method', 'var')
		if strcmpi(method, 'zeroedge')
			currentAxes.Position = [0, 0, 1, 1];
			figPos = currentAxes.Parent.Position;
			aspectRatio = currentAxes.PlotBoxAspectRatio;
			aspectRatio = aspectRatio(1) / aspectRatio(2);
			currentAxes.Parent.Position = [figPos(1), figPos(2) - (figPos(3) / aspectRatio - figPos(4)), figPos(3), figPos(3) / aspectRatio];
		elseif strcmpi(method, 'width')
			scaleForColorbar = 1;
			for ii = 1:numel(currentAxes.Parent.Children)
				if regexpi(class(currentAxes.Parent.Children(ii)), 'colorbar')
					scaleForColorbar = 0.87;
				end
			end
			InSet = currentAxes.TightInset;
			currentAxes.Position(1) = InSet(1);
			currentAxes.Position(3) = (1 - InSet(1) - InSet(3)) * scaleForColorbar;
		elseif strcmpi(method, 'height')
			InSet = currentAxes.TightInset;
			currentAxes.Position(2) = InSet(2);
			currentAxes.Position(4) = 1 - InSet(2) - InSet(4);
		elseif strcmpi(method, 'leavetop')
			axPos = currentAxes.Position;
			figPos = currentAxes.Parent.Position;
			currentAxes.Position = [0, 0, 1, axPos(4) * 1.05];
			currentAxes.Units = 'pixels';
			newAxPos = currentAxes.Position;
			currentAxes.Parent.Position = [figPos(1:2), newAxPos(4), figPos(4)];
			currentAxes.Units = 'normalized';
			currentAxes.Position = [0, 0, 1, axPos(4) * 1.05];
			
		end
	else
		% Ref: https://www.mathworks.com/matlabcentral/answers/352024-programmatically-performing-expand-axes-to-fill-figure
		scaleForColorbar = 1;
		for ii = 1:numel(currentAxes.Parent.Children)
			if regexpi(class(currentAxes.Parent.Children(ii)), 'colorbar')
				scaleForColorbar = 0.87;
			end
		end
		InSet = currentAxes.TightInset;
		currentAxes.Position = [InSet(1:2), (1 - InSet(1) - InSet(3)) * scaleForColorbar, 1 - InSet(2) - InSet(4)];
	end
end
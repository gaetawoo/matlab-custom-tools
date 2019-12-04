try %#ok
	% https://undocumentedmatlab.com/blog/reverting-axes-controls-in-figure-toolbar
	if ~verLessThan('matlab','9.5')
		set(groot,'defaultFigureCreateFcn',@(fig,~)addToolbarExplorationButtons(fig));
	end
	setenv('MTFDIR', 'C:\Users\jeremiah.valenzuela\Documents\Projects\Software\18125 Agatha\FFOVMTF');
	recycle('on')
end
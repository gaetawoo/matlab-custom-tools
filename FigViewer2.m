function FigViewer2(figure_to_open)
	if ~exist('figure_to_open', 'var')
		figure_to_open = uigetfullfile('*.fig', 'Select MATLAB Figure');
	end
	if isstring(figure_to_open)
		fprintf(1, 'Opening Figure: %s\n', figure_to_open)
		if contains(figure_to_open, '.fig')
			openfig(figure_to_open, 'new')
			set(gcf, 'Toolbar', 'figure')
			set(gcf, 'menuBar', 'figure')
			dcm_obj = datacursormode(gcf);
			dcm_obj.UpdateFcn = [];
		else
			m = msgbox('Not a valid Matlab Figure');
			waitfor(m)
		end
	end
end

function nope = isdeployed()
	nope = 0;
end
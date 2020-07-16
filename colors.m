formulary = {'cie_1931', '1931_full', 'cie_1964', '1964_full', 'judd', 'judd_vos', 'stiles_2', 'stiles_10'};

lambda = [360:950]';
figure;
hold on
for iColorFunc = 1:size(formulary, 2)
	rgb = reshape(spectrumRGB(lambda, formulary{iColorFunc}), [], 3, 1);
	scatter(lambda, ones(size(lambda)) * iColorFunc, 800, rgb, 'square', 'filled', 'UserData', [lambda, rgb, ones(size(lambda)) * iColorFunc])
	text(lambda(1), iColorFunc - 0.45, strrep(formulary{iColorFunc}, '_', '\_'))
end
set(datacursormode, 'UpdateFcn', @DataTipUpdateScatter2D, 'Enable', 'on')
ylim ([0, 9])
grid on
grid minor


function output_txt = DataTipUpdateScatter2D(~,event_obj)
% Display data cursor info in a data tip for Agatha scatter plots
% obj          Currently not used
% event_obj    Handle to event object
% output_txt   Data tip text, returned as a character vector or a cell array of character vectors

pos = event_obj.Position;
value = event_obj.Target.UserData(event_obj.Target.UserData(:, 1) == event_obj.Position(1), 2:4);

%********* Define the content of the data tip here *********%

% Display the x and y values:
output_txt = {['\lambda',formatValue2(event_obj.Position(1),event_obj)], ...
	['RGB',formatValue1(value,event_obj)]};
%***********************************************************%
end

%***********************************************************%

function formattedValue = formatValue1(value,event_obj)
% If you do not want TeX formatting in the data tip, uncomment the line below.
% event_obj.Interpreter = 'none';
if strcmpi(event_obj.Interpreter,'tex')
    valueFormat = ' \color[rgb]{0 0.5 1}\bf';
    removeValueFormat = '\color[rgb]{.15 .15 .15}\rm';
else
    valueFormat = ': ';
    removeValueFormat = '';
end
formattedValue = [valueFormat, '[', num2str(value(1)), ', ', num2str(value(2)), ', ', num2str(value(3)), ']', removeValueFormat];
end

function formattedValue = formatValue2(value,event_obj)
% If you do not want TeX formatting in the data tip, uncomment the line below.
% event_obj.Interpreter = 'none';
if strcmpi(event_obj.Interpreter,'tex')
    valueFormat = ' \color[rgb]{0 0.5 1}\bf';
    removeValueFormat = '\color[rgb]{.15 .15 .15}\rm';
else
    valueFormat = ': ';
    removeValueFormat = '';
end
formattedValue = [valueFormat, num2str(value), removeValueFormat];
end
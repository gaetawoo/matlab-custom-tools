function mainScreenSize = mainScreenSize()
mainScreenSize = get(groot, 'MonitorPositions');
mainScreenSize = mainScreenSize((find(mainScreenSize(:, 1) == 1 & mainScreenSize(:, 2) == 1)), :);
end
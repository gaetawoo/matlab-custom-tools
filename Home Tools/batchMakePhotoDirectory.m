for ii = 1:12
dt = sprintf('2020 %02d', ii);
dateout = datestr(datenum(dt, 'yyyy mm'), ['yyyy - ', num2str(ii, '%02d'), ' mmmm-'])
mkdir(dateout)
end
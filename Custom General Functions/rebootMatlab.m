function rebootMatlab
	answer = input('Do you want to reboot Matlab? [y/n]', 's');
	if strcmpi(answer, 'y')
		!matlab &
		exit
	end
end
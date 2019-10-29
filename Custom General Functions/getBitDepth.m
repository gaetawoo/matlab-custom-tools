function output = getBitDepth(imageArray)
	% GETBITDEPTH estimate bit-depth of input image array based on number of different values and
	% maximum value
	%
	% SYNTAX:
	%    output = getBitDepth(imageArray)
	%
	% INPUTS:
	%    imageArray - A 2D NxM array of integer values
	%
	% OUTPUTS:
	%    output - A struct with current bit-depth, amount of bit-shift, and original bit-depth
	%
 	% EXAMPLE:
	% 	>> getBitDepth(img)
	% 	ans =
	%   struct with fields:
	%
	%             BitDepth: 16
	%             BitShift: 4
	% 						OriginalBitDepth: 12
	%             DataClass: 'uint16'
	%
	
	% Created on: September 10, 2019
	% By: Jeremiah Valenzuela
	
	% Max sure imageArray is uint8 or uint16
	validateattributes(imageArray, {'uint8', 'uint16'}, {'2d', 'integer'}, 'getBitDepth', 'imageArray');
	
	% Constants
	MAX8BITS = 2^8 - 1;
	MAX10BITS = 2^10 - 1;
	MAX12BITS = 2^12 - 1;
	
	% Get max array value
	maxValue = max(imageArray, [], 'all');
	
	% Determine bit-depth
	if contains(class(imageArray), 'uint8')
		bitdepth = 8;
		dataclass = class(imageArray);
	else
		if maxValue > MAX12BITS
			bitdepth = 16;
		elseif maxValue > MAX10BITS
			bitdepth = 12;
		elseif maxValue > MAX8BITS
			bitdepth = 10;
		else
			bitdepth = 8;
		end
		dataclass = class(imageArray);
	end
	
	% Check size of consecutive value difference
	sortedUniqueValues = unique(imageArray);
	minDifference = min(diff(sortedUniqueValues));
	
	% Check if bit-shifted
	if minDifference > 1
		switch bitdepth
			case 16
				switch minDifference
					case 16
						originalBitDepth = 12;
						bitShift = 4;
					case 64
						originalBitDepth = 10;
						bitShift = 6;
					case 256
						originalBitDepth = 8;
						bitShift = 8;
				end
			case 12
				switch minDifference
					case 4
						originalBitDepth = 10;
						bitShift = 2;
					case 16
						originalBitDepth = 8;
						bitShift = 4;
				end
			case 10
				originalBitDepth = 8;
				bitShift = 2;
		end
	else
		originalBitDepth = bitdepth;
		bitShift = 0;
	end
	
	output = struct('BitDepth', bitdepth, 'BitShift', bitShift, 'OriginalBitDepth', originalBitDepth, 'DataClass', dataclass);
end
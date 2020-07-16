function [snip, boundary] = snipArray(inputImage, xy, edgeSize)
	edgeLeft = round(xy(1)) - round(edgeSize / 2);
	edgeRight = round(xy(1)) + round(edgeSize / 2) - 1;
	edgeTop = round(xy(2)) - round(edgeSize / 2);
	edgeBottom = round(xy(2)) + round(edgeSize / 2) - 1;
	if edgeLeft < 1, edgeLeft = 1; end
	if edgeRight > size(inputImage, 2), edgeRight = size(inputImage, 2); end
	if edgeTop < 1, edgeTop = 1; end
	if edgeBottom > size(inputImage, 1), edgeBottom = size(inputImage, 1); end
	
	% Crop to snippet of spot
	snip = inputImage(edgeTop:edgeBottom, edgeLeft:edgeRight);
	boundary = [edgeTop, edgeBottom, edgeLeft, edgeRight];
	
end